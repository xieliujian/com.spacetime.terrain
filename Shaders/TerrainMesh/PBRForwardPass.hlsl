
#include "ext/CommonTonemapping.hlsl"
#include "TerrainShadowCommon.hlsl"
#include "ext/Common.hlsl"
#include "ext/AdditionalDirectionLightShadowCommon.hlsl"


#define LIGHTMAP_INDIRECTION_SAMPLER_NAME samplerunity_LightmapInd
SAMPLER(samplerunity_LightmapInd);

#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
#define SAMPLE_SHADOWMASK2(uv) SAMPLE_TEXTURE2D_LIGHTMAP(LIGHTMAP_INDIRECTION_NAME, LIGHTMAP_INDIRECTION_SAMPLER_NAME, uv SHADOWMASK_SAMPLE_EXTRA_ARGS);
#elif !defined (LIGHTMAP_ON)
#define SAMPLE_SHADOWMASK2(uv) unity_ProbesOcclusion;
#else
#define SAMPLE_SHADOWMASK2(uv) half4(1, 1, 1, 1);
#endif


#if USE_FORWARD_PLUS && defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING)
#define FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK if (_AdditionalLightsColor[lightIndex].a > 0.0h) continue;
#else
#define FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK
#endif

#if USE_FORWARD_PLUS
    #define LIGHT_LOOP_BEGIN(lightCount) { \
    uint lightIndex; \
    ClusterIterator _urp_internal_clusterIterator = ClusterInit(inputData.normalizedScreenSpaceUV, inputData.positionWS, 0); \
    [loop] while (ClusterNext(_urp_internal_clusterIterator, lightIndex)) { \
        lightIndex += URP_FP_DIRECTIONAL_LIGHTS_COUNT; \
        FORWARD_PLUS_SUBTRACTIVE_LIGHT_CHECK
    #define LIGHT_LOOP_END } }
#elif !_USE_WEBGL1_LIGHTS
    #define LIGHT_LOOP_BEGIN(lightCount) \
    for (uint lightIndex = 0u; lightIndex < lightCount; ++lightIndex) {

    #define LIGHT_LOOP_END }
#else
    // WebGL 1 doesn't support variable for loop conditions
    #define LIGHT_LOOP_BEGIN(lightCount) \
    for (int lightIndex = 0; lightIndex < _WEBGL1_MAX_LIGHTS; ++lightIndex) { \
        if (lightIndex >= (int)lightCount) break;

    #define LIGHT_LOOP_END }
#endif

void BuildInputData(Varyings input, SurfaceDescription surfaceDescription, out InputData inputData)
{
    inputData = (InputData)0;
    inputData.positionWS = input.positionWS;

    #ifdef _NORMALMAP
        #if _NORMAL_DROPOFF_TS
            // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
            float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
            float3 bitangent = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
            inputData.normalWS = TransformTangentToWorld(surfaceDescription.NormalTS, half3x3(input.tangentWS.xyz, bitangent, input.normalWS.xyz));
        #elif _NORMAL_DROPOFF_OS
            inputData.normalWS = TransformObjectToWorldNormal(surfaceDescription.NormalOS);
        #elif _NORMAL_DROPOFF_WS
            inputData.normalWS = surfaceDescription.NormalWS;
        #endif
    #else
        inputData.normalWS = input.normalWS;
    #endif
    inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
    inputData.viewDirectionWS = SafeNormalize(input.viewDirectionWS);

    #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
        inputData.shadowCoord = input.shadowCoord;
        #if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
        inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
        #endif
    #elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
        inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
    #else
        inputData.shadowCoord = half4(0, 0, 0, 0);
    #endif

    inputData.fogCoord = input.fogFactorAndVertexLight.x;
    inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
    inputData.bakedGI = SAMPLE_GI(input.lightmapUV, input.sh, inputData.normalWS);
    inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
    half4 shadowmask = SAMPLE_SHADOWMASK2(input.lightmapUV);
    //inputData.shadowMask = half4(shadowmask.a, 1, 1, 1);
    inputData.shadowMask = GetPrecomputedShadowMasks(half4(shadowmask.a, 1, 1, 1));
}

PackedVaryings vert(Attributes input)
{
    Varyings output = (Varyings)0;
    output = BuildVaryings(input);
    PackedVaryings packedOutput = (PackedVaryings)0;
    packedOutput = PackVaryings(output);
    return packedOutput;
}


half4 UniversalFragmentBlinnPhong_Terrain(InputData inputData, half3 diffuse, half4 specularGloss, half smoothness, half3 emission, half alpha)
{
    // To ensure backward compatibility we have to avoid using shadowMask input, as it is not present in older shaders
#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
    half4 shadowMask = inputData.shadowMask;
#elif !defined (LIGHTMAP_ON)
    half4 shadowMask = unity_ProbesOcclusion;
#else
    half4 shadowMask = half4(1, 1, 1, 1);
#endif

    Light mainLight = GetMainLight_Terrain(inputData.shadowCoord, inputData.positionWS, shadowMask);

#if defined(_SCREEN_SPACE_OCCLUSION)
    AmbientOcclusionFactor aoFactor = GetScreenSpaceAmbientOcclusion(inputData.normalizedScreenSpaceUV);
    mainLight.color *= aoFactor.directAmbientOcclusion;
    inputData.bakedGI *= aoFactor.indirectAmbientOcclusion;
#endif


    MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI);
//#if !defined (SHADER_API_MOBILE)
    #if !defined (SHADER_API_MOBILE)
    half cloudShadowAtten = GetCloudShadowAttenuation(inputData.positionWS, _MainLightShadowParams.x);
    mainLight.shadowAttenuation = min(cloudShadowAtten, mainLight.shadowAttenuation);
    #endif
//#endif
    
    half3 attenuatedLightColor = mainLight.color * (mainLight.distanceAttenuation * mainLight.shadowAttenuation);
    half3 diffuseColor = inputData.bakedGI + LightingLambert(attenuatedLightColor, mainLight.direction, inputData.normalWS);
    half3 specularColor = LightingSpecular(attenuatedLightColor, mainLight.direction, inputData.normalWS, inputData.viewDirectionWS, specularGloss, smoothness);



#ifdef _ADDITIONAL_LIGHTS_VERTEX
    diffuseColor += inputData.vertexLighting;
#endif

    half3 finalColor = diffuseColor * diffuse + emission;

#if defined(_SPECGLOSSMAP) || defined(_SPECULAR_COLOR)
    finalColor += specularColor;
#endif

    return half4(finalColor, alpha);
}

half3 LightingPhysicallyBased_Lit(BRDFData brdfData,
    half3 lightColor, half3 lightDirectionWS, half lightAttenuation,
    half3 normalWS, half3 viewDirectionWS)
{

//#region LR Modified
	// old code
    //half NdotL = saturate(dot(normalWS, lightDirectionWS));
    //half3 radiance = lightColor * (lightAttenuation * NdotL);

    half clamplightAttenuation = lightAttenuation;
    half NdotL = saturate(dot(normalWS, lightDirectionWS));
    clamplightAttenuation = clamp(clamplightAttenuation + _MainLightShaderParam.z, _MainLightShaderParam.x, 1);
    half3 radiance = lightColor * (clamplightAttenuation * NdotL); // +(1 - clamplightAttenuation * NdotL) * _MainLightShadowColor.rgb;
//#endregion    
    half3 brdf = brdfData.diffuse;
#ifndef _SPECULARHIGHLIGHTS_OFF
    //[branch]
    //if (!specularHighlightsOff)
    {
        brdf += brdfData.specular * DirectBRDFSpecular(brdfData, normalWS, lightDirectionWS, viewDirectionWS);

//#if defined(_CLEARCOAT) || defined(_CLEARCOATMAP) 
//        // Clear coat evaluates the specular a second timw and has some common terms with the base specular.
//        // We rely on the compiler to merge these and compute them only once.
//        half brdfCoat = kDielectricSpec.r * DirectBRDFSpecular(brdfDataClearCoat, normalWS, lightDirectionWS, viewDirectionWS);

//            // Mix clear coat and base layer using khronos glTF recommended formula
//            // https://github.com/KhronosGroup/glTF/blob/master/extensions/2.0/Khronos/KHR_materials_clearcoat/README.md
//            // Use NoV for direct too instead of LoH as an optimization (NoV is light invariant).
//            half NoV = saturate(dot(normalWS, viewDirectionWS));
//            // Use slightly simpler fresnelTerm (Pow4 vs Pow5) as a small optimization.
//            // It is matching fresnel used in the GI/Env, so should produce a consistent clear coat blend (env vs. direct)
//            half coatFresnel = kDielectricSpec.x + kDielectricSpec.a * Pow4(1.0 - NoV);

//        brdf = brdf * (1.0 - clearCoatMask * coatFresnel) + brdfCoat * clearCoatMask;
//#endif // _CLEARCOAT
    }
#endif // _SPECULARHIGHLIGHTS_OFF

    return brdf * radiance;
}
half3 LightingPhysicallyBased_Lit(BRDFData brdfData, /*BRDFData brdfDataClearCoat,*/Light light, half3 normalWS, half3 viewDirectionWS)
{
    return LightingPhysicallyBased_Lit(brdfData, /*brdfDataClearCoat,*/light.color, light.direction, light.distanceAttenuation * light.shadowAttenuation, normalWS, viewDirectionWS);
}
///////////////////////////////////////////////////////////////////////////////
//                      Fragment Functions                                   //
//       Used by ShaderGraph and others builtin renderers                    //
///////////////////////////////////////////////////////////////////////////////
half4 UniversalFragmentPBR_Terrain(InputData inputData, SurfaceData surfaceData)
{
#ifdef _SPECULARHIGHLIGHTS_OFF
    bool specularHighlightsOff = true;
#else
    bool specularHighlightsOff = false;
#endif

    BRDFData brdfData;
//#if TEST_PERF0
    [branch]if (Global_Enable > 0.5)
    {
        float viewIntensity = 0;
        float metallic = 0;
        
        
        surfaceData.albedo = CalcSnow(
            surfaceData.albedo,
            _SnowIntensity,
            _SnowLumIntensity,
            _SnowLumRemap,
            inputData.normalWS.y, _SnowProjYIntensity, _SnowProjYRemap,
            _SnowGlitterIntensity,
            inputData.positionWS, viewIntensity, 1.0f, metallic);
        

        //颜色覆盖
        [branch]
        if (Global_EnablePaintTinting > 0.5f)
        {
            half gray = Luminance(surfaceData.albedo);
            half lum = gray * 5;
            surfaceData.albedo = SceneCalcTintingColor(inputData.positionWS, surfaceData.albedo, gray, lum, 1);
        }        
    
        [branch]
        if (Global_EnableRain > 0.5f)        
        {           
            float4 atmoParams = CalcAtmo(inputData.positionWS);
            half projYMask = Remap(clamp(saturate(inputData.normalWS.y), 0, 1), _SnowProjYRemap.x, _SnowProjYRemap.y);
            half wetnessProjYMask = Remap(clamp(saturate(inputData.normalWS.y), 0, 1), _WetnessDropsProjRemap.x, _WetnessDropsProjRemap.y);
            float WetnessHeight = surfaceData.smoothness;
            float WetnessValue = atmoParams.y * _WetnessIntensity;
            float WaterMask = Remap(clamp(WetnessValue * _WetnessWaterIntensity - WetnessHeight, 0, 1), _WetnessBlendRemap.x, _WetnessBlendRemap.y);
    
        //雨 wetness
            surfaceData.smoothness += WetnessValue * Global_WetnessMtlModify.x;
            surfaceData.specular.r += WetnessValue * Global_WetnessMtlModify.y;
    
            half3 WetColor0 = lerp(surfaceData.albedo, _WetnessWaterColor.rgb * surfaceData.albedo, WaterMask);
            half3 WetColor1 = lerp(WetColor0, WetColor0 * WetColor0, Global_WetnessMtlModify.z);
            half3 WetColor2 = lerp(surfaceData.albedo, WetColor1, WetnessValue);
            surfaceData.albedo = WetColor2.rgb;
        //return half4(surfaceData.albedo,1);
        //计算雨点
            half4 wetnessTex = CalcWetnessDrops(inputData.positionWS, Global_WetnessMtlModify.w);
            half4 rain_RingsNormal = half4(wetnessTex.xy, 2, -1);
            half4 rain_DropsNormal = half4(wetnessTex.zw, 2, -1);
            half distMinus = 1 - saturate(distance(_WorldSpaceCameraPos, inputData.positionWS) / _WetnessDropsFade);
            half2 WetnessNormal = lerp((rain_RingsNormal * 2 - 1), ( rain_DropsNormal * 2 - 1), 
            1 - WaterMask) * _WetnessDropsIntensity * _WetnessDropsNormal * WetnessValue * wetnessProjYMask * distMinus;
          
            inputData.normalWS += half3(WetnessNormal.x, 0, WetnessNormal.y);
            inputData.normalWS = normalize(inputData.normalWS);
        //计算雨点结束
        }
    }
    //#endif
    
    // NOTE: can modify alpha
    InitializeBRDFData(surfaceData.albedo, 
        surfaceData.metallic, surfaceData.specular, surfaceData.smoothness, surfaceData.alpha, brdfData);

    BRDFData brdfDataClearCoat = (BRDFData) 0;
#if defined(_CLEARCOAT) || defined(_CLEARCOATMAP)
    // base brdfData is modified here, rely on the compiler to eliminate dead computation by InitializeBRDFData()
    InitializeBRDFDataClearCoat(surfaceData.clearCoatMask, surfaceData.clearCoatSmoothness, brdfData, brdfDataClearCoat);
#endif

    // To ensure backward compatibility we have to avoid using shadowMask input, as it is not present in older shaders
#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
    half4 shadowMask = inputData.shadowMask;
#elif !defined (LIGHTMAP_ON)
    half4 shadowMask = unity_ProbesOcclusion;
#else
    half4 shadowMask = half4(1, 1, 1, 1);
#endif

    Light mainLight = GetMainLight_Terrain(inputData.shadowCoord, inputData.positionWS, shadowMask);

#if defined(_SCREEN_SPACE_OCCLUSION)
        AmbientOcclusionFactor aoFactor = GetScreenSpaceAmbientOcclusion(inputData.normalizedScreenSpaceUV);
        mainLight.color *= aoFactor.directAmbientOcclusion;
        surfaceData.occlusion = min(surfaceData.occlusion, aoFactor.indirectAmbientOcclusion);
#endif

#if USE_FORWARD_PLUS
    half charShadowOverlay = 0.0f;
    [branch] if(URP_FP_DIRECTIONAL_LIGHTS_COUNT)
    {
        Light charShadowLight = LRGetAdditionalLight(0, inputData.positionWS, shadowMask);
        charShadowOverlay = saturate(1 - charShadowLight.shadowAttenuation) * step(mainLight.shadowAttenuation, 0.5f);
        mainLight.shadowAttenuation = min(mainLight.shadowAttenuation, charShadowLight.shadowAttenuation);
    }
#endif
    
    MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI);
    half3 color = GlobalIllumination(brdfData, brdfDataClearCoat, surfaceData.clearCoatMask,
                                     inputData.bakedGI, surfaceData.occlusion,
                                     inputData.normalWS, inputData.viewDirectionWS);
   
//#if !defined (SHADER_API_MOBILE)
    #if !defined (SHADER_API_MOBILE)

    half cloudShadowAtten = GetCloudShadowAttenuation(inputData.positionWS, _MainLightShadowParams.x);
    mainLight.shadowAttenuation = min(cloudShadowAtten, mainLight.shadowAttenuation);
    #endif
//#endif

    color += LightingPhysicallyBased_Lit(brdfData,
                                     mainLight,
                                     inputData.normalWS, inputData.viewDirectionWS);

        
#if USE_FORWARD_PLUS
    color *= lerp(1, _CharShadowOverlayStrength, charShadowOverlay);
#endif

    //     
    #if  defined(_ADDITIONAL_LIGHTS) //&& defined(TEST_PERF1)
    #if USE_FORWARD_PLUS && defined(URP_FP_POINTLIGHT_COUNT)
	[branch] if( URP_FP_POINTLIGHT_COUNT > 0.5f )
	#endif
    {
         uint meshRenderingLayers = GetMeshRenderingLayer();
         uint pixelLightCount = GetAdditionalLightsCount();
        //正常灯光循环
            LIGHT_LOOP_BEGIN(pixelLightCount)
            Light light = GetAdditionalLight(lightIndex, inputData.positionWS, shadowMask);
            if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
            {
        //#ifdef _UE5PBR
        //    color += LightingPhysicallyBased_UE5(brdfData, light, inputData.normalWS, surfaceData.tangentWS, inputData.viewDirectionWS, surfaceData);
        //#else
                color += LightingPhysicallyBased_Lit(brdfData,
                                                light,
                                                inputData.normalWS, inputData.viewDirectionWS);
                //color = float3(1,0,0);
        //#endif
            }
            LIGHT_LOOP_END
        //正常灯光循环 结束
    }
       
    #endif
    //#endif

#ifdef _ADDITIONAL_LIGHTS_VERTEX
    color += inputData.vertexLighting * brdfData.diffuse;
#endif
#ifdef _ONLY_SM 
    //这里一定要用到color.rgb 要不然Shader会报错
    half3 color1 = color.rgb;
    half var = 0.001f;
    color.rgb *= var;
    if(color.r < 10.0f )
    {
        color.rgb *= 0.0f;
    }
    return half4(shadowMask.rrr+color.rrr,shadowMask.r);
#endif
    //color += surfaceData.emission;

    return half4(color, surfaceData.alpha);
}

half4 UniversalFragmentPBR_Terrain(Varyings unpacked, SurfaceDescriptionInputs surfaceDescriptionInputs)
{
    SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(unpacked, surfaceDescriptionInputs);

    #if _AlphaClip
    half alpha = surfaceDescription.Alpha;
    clip(alpha - surfaceDescription.AlphaClipThreshold);
    #elif _SURFACE_TYPE_TRANSPARENT
    half alpha = surfaceDescription.Alpha;
    #else
    half alpha = 1;
    #endif

    InputData inputData;
    BuildInputData(unpacked, surfaceDescription, inputData);

    #ifdef _SPECULAR_SETUP
    half3 specular = surfaceDescription.Specular;
    half metallic = 1;
    #else
    half3 specular = 0;
    half metallic = surfaceDescription.Metallic;
    #endif

    SurfaceData surface         = (SurfaceData)0;
    surface.albedo              = surfaceDescription.BaseColor;
    surface.metallic            = saturate(metallic);
    surface.specular            = specular;
    surface.smoothness          = saturate(surfaceDescription.Smoothness),
    surface.occlusion           = surfaceDescription.Occlusion,
    surface.emission            = surfaceDescription.Emission,
    surface.alpha               = saturate(alpha);
    surface.clearCoatMask       = 0.0f;
    surface.clearCoatSmoothness = 1.0f;
        

    #ifdef _CLEARCOAT
    surface.clearCoatMask       = saturate(surfaceDescription.CoatMask);
    surface.clearCoatSmoothness = saturate(surfaceDescription.CoatSmoothness);
    #endif

    return UniversalFragmentPBR_Terrain(inputData, surface);
}


half4 UniversalFragmentBlinnPhong_SceneLit(InputData inputData, half3 diffuse, half metallic, half smoothness, half3 emission, half alpha)
{
    // To ensure backward compatibility we have to avoid using shadowMask input, as it is not present in older shaders
#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
    half4 shadowMask = inputData.shadowMask;
#elif !defined (LIGHTMAP_ON)
    half4 shadowMask = unity_ProbesOcclusion;
#else
    half4 shadowMask = half4(1, 1, 1, 1);
#endif

    half oneMinusReflectivity = OneMinusReflectivityMetallic(metallic);
    half3 brdfDiffuse = diffuse * oneMinusReflectivity;
    half3 brdfSpecular = diffuse * metallic;

    Light mainLight = GetMainLight_Terrain(inputData.shadowCoord, inputData.positionWS, shadowMask);

    #if defined(_SCREEN_SPACE_OCCLUSION)
        AmbientOcclusionFactor aoFactor = GetScreenSpaceAmbientOcclusion(inputData.normalizedScreenSpaceUV);
        mainLight.color *= aoFactor.directAmbientOcclusion;
        inputData.bakedGI *= aoFactor.indirectAmbientOcclusion;
    #endif
        
#if USE_FORWARD_PLUS
    half charShadowOverlay = 0.0f;
    [branch] if(URP_FP_DIRECTIONAL_LIGHTS_COUNT)
    {
        Light charShadowLight = LRGetAdditionalLight(0, inputData.positionWS, shadowMask);
        charShadowOverlay = saturate(1 - charShadowLight.shadowAttenuation) * step(mainLight.shadowAttenuation, 0.5f);
        mainLight.shadowAttenuation = min(mainLight.shadowAttenuation, charShadowLight.shadowAttenuation);
    }
#endif

    MixRealtimeAndBakedGI(mainLight, inputData.normalWS, inputData.bakedGI);
//#if defined(RENDER_LEVEL_1)
    #if !defined(_USEVERTEXAO) //&& !defined (SHADER_API_MOBILE)
    #if !defined (SHADER_API_MOBILE)
    half cloudShadowAtten = GetCloudShadowAttenuation(inputData.positionWS, _MainLightShadowParams.x);
    mainLight.shadowAttenuation = min(cloudShadowAtten, mainLight.shadowAttenuation);
    #endif
    #endif
//#endif!defined(_USE_BLINNPHONG)

    half3 attenuatedLightColor = mainLight.color * (mainLight.distanceAttenuation * mainLight.shadowAttenuation + 0.1) + 0.01;
    half3 diffuseColor = inputData.bakedGI + LightingLambert(attenuatedLightColor, mainLight.direction, inputData.normalWS);
    
#if USE_FORWARD_PLUS
    diffuseColor *= lerp(1, _CharShadowOverlayStrength, charShadowOverlay);
#endif

    half3 specularColor = attenuatedLightColor * brdfSpecular;


#if  defined(_ADDITIONAL_LIGHTS) //&& defined(TEST_PERF1)
    #if USE_FORWARD_PLUS && defined(URP_FP_POINTLIGHT_COUNT)
	[branch] if( URP_FP_POINTLIGHT_COUNT > 0.5f )
	#endif
    {
    //    uint pixelLightCount = GetAdditionalLightsCount();
    //for (uint lightIndex = 0u; lightIndex < pixelLightCount; ++lightIndex)
    //{
    //    Light light = GetAdditionalLight(lightIndex, inputData.positionWS, shadowMask);
    //    #if defined(_SCREEN_SPACE_OCCLUSION)
    //        light.color *= aoFactor.directAmbientOcclusion;
    //    #endif
    //    half3 attenuatedLightColor = light.color * (light.distanceAttenuation * light.shadowAttenuation);
    //    diffuseColor += LightingLambert(attenuatedLightColor, light.direction, inputData.normalWS);
    //    //specularColor += LightingSpecular(attenuatedLightColor, light.direction, inputData.normalWS, inputData.viewDirectionWS, specularGloss, smoothness);
    //}
    }

#endif

#ifdef _ADDITIONAL_LIGHTS_VERTEX
    diffuseColor += inputData.vertexLighting;
#endif

    half3 finalColor = (diffuseColor * brdfDiffuse + specularColor + emission);

//#if defined(_SPECGLOSSMAP) || defined(_SPECULAR_COLOR)
    //finalColor += specularColor;
//#endif
    //finalColor = specularColor;
    return half4(finalColor, alpha);
}

half4 UniversalFragmentBlinnPhong_SceneLit(Varyings unpacked, SurfaceDescriptionInputs surfaceDescriptionInputs)
{
    SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(unpacked, surfaceDescriptionInputs);

    #if _AlphaClip
    half alpha = surfaceDescription.Alpha;
    clip(alpha - surfaceDescription.AlphaClipThreshold);
    #elif _SURFACE_TYPE_TRANSPARENT
    half alpha = surfaceDescription.Alpha;
    #else
    half alpha = 1;
    #endif

    InputData inputData;
    BuildInputData(unpacked, surfaceDescription, inputData);

    return UniversalFragmentBlinnPhong_SceneLit(inputData, surfaceDescription.BaseColor, surfaceDescription.Metallic, surfaceDescription.Smoothness, 0, 1);
}

half4 frag(PackedVaryings packedInput) : SV_TARGET
{
#if defined(_SOLIDCOLORTEST)
    return half4(0,0,1,1);
#endif

    Varyings unpacked = UnpackVaryings(packedInput);
    UNITY_SETUP_INSTANCE_ID(unpacked);
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(unpacked);

    SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(unpacked);


    
    half4 color = half4(0,0,0,1);
    #if ONLY_COLOR || ONLY_NORMAL
        SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(unpacked, surfaceDescriptionInputs);
        #if ONLY_COLOR    
            color = half4(surfaceDescription.BaseColor,surfaceDescription.Smoothness);
        #else
            color = half4(surfaceDescription.NormalTS.xyz,1.0f);
        #endif
    #else
        color = UniversalFragmentPBR_Terrain(unpacked, surfaceDescriptionInputs); 
        color.rgb = TonemppingColor(color.rgb);
    #endif
    
    return color;
}

half4 frag_BLINN(PackedVaryings packedInput) : SV_TARGET
{
#if defined(_SOLIDCOLORTEST)
    return half4(1,0,0,1);
#endif

    Varyings unpacked = UnpackVaryings(packedInput);
    UNITY_SETUP_INSTANCE_ID(unpacked);
    UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(unpacked);

    SurfaceDescriptionInputs surfaceDescriptionInputs = BuildSurfaceDescriptionInputs(unpacked);

    half4 color = half4(0,0,0,1);
    #if ONLY_COLOR || ONLY_NORMAL
        SurfaceDescription surfaceDescription = SurfaceDescriptionFunction(unpacked, surfaceDescriptionInputs);
        #if ONLY_COLOR    
            color = half4(surfaceDescription.BaseColor,surfaceDescription.Smoothness);
        #else
            color = half4(surfaceDescription.NormalTS.xyz,1.0f);
        #endif
        
    #else
        color = UniversalFragmentBlinnPhong_SceneLit(unpacked, surfaceDescriptionInputs); 
        color.rgb = TonemppingColor(color.rgb);
        
    #endif
    
    return color;
}
