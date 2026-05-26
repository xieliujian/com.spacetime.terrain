#ifndef SCENEOBJ_COMMON
#define SCENEOBJ_COMMON

#define USE_GLOBALTEXARRY 1

//#define GLOBALE_NOTTEXTURE 1

//#define GLOBALE_TEXTURESIM 1

#include "CommonTonemapping.hlsl"
#include "CloudShadowCommon.hlsl"
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
float Remap(float x, float low, float high)
{
    return saturate((x - low) / (high - low));
}

#define TRANSFORM_TANGENT_TO_WORLD_CUSTOM(normalTS, tangentToWorld) mul(normalTS, tangentToWorld)

//  Additional textures
//TEXTURE2D(_LuxURPWindRT);SAMPLER(sampler_LuxURPWindRT);

//  Global Inputs
//float4 _LuxURPWindDirSize;
//float4 _LuxURPWindStrengthMultipliers;
//float4 _LuxURPSinTime;
half _LowShaderDistance = 128;

uniform half _EnableLuxWind = 0.0f;
uniform half _EnableWind = 0.0f;
uniform half _EnableTreeRim = 1.0f;
uniform half _EnableTerrainBlend = 1.0f;
/////  Displacement
TEXTURE2D(_Lux_DisplacementRT); SAMPLER(sampler_Lux_DisplacementRT);
float4 _Lux_DisplacementPosition;

float4 Global_RenderBaseCoords;
float4 Global_RenderBasePositionR;
float4 Global_RenderNearCoords;
float4 Global_RenderNearPositionR;
float Global_RenderBaseFadeValue;
float Global_RenderNearFadeValue;
float4 Global_PushParams;

float GTestVar;

uniform bool Global_Enable;
uniform bool Global_EnableSnow;
uniform bool Global_EnableRain;
uniform bool Global_EnablePaintTinting;
uniform bool Global_EnableGlowEmissive;
uniform bool Global_EnablePush;
float Global_FormSizeFade;


float4 Global_SnowColor;

float4 Global_SnowGlitterColor;
float4 Global_SnowGlitterScale;


float Global_SnowShininess;


float4 Global_WetnessMtlModify; //x = smoothness y = specular z = contrast w = DropsTilling
//_WetnessSmoothness;
//half _WetnessSpecular;
//half _WetnessContrast;

//half Global_WetnessDropsTilling;

float Global_ContrastDetailMap;
float Global_SpreadDetailMap;


TEXTURE2D(Global_DropsRainOrSnow);
TEXTURE2D(Global_RainSnowMask);
//TEXTURE2D(Global_RainMask);
TEXTURE2D(Global_WaveNormalMap);
TEXTURE2D(Global_MotionTex);

#if USE_GLOBALTEXARRY
TEXTURE2D_ARRAY(Global_RTArray);
#else
TEXTURE2D_ARRAY(Global_PushBaseTex);
TEXTURE2D_ARRAY(Global_FormNearTex);
TEXTURE2D_ARRAY(Global_PaintBaseTex);
TEXTURE2D_ARRAY(Global_PaintNearTex);
TEXTURE2D_ARRAY(Global_AtmoBaseTex);
TEXTURE2D_ARRAY(Global_AtmoNearTex);
#endif





float4 Global_GlowParams;
uniform float Global_PushActive;
uniform float Global_GlowActive;
uniform float Global_PaintActive;
uniform float Global_AtmoActive;
uniform float Global_FormActive;




half4 Global_PaintParams;
half4 Global_AtmoParams = half4(0, 0, 0, 0);
half4 Global_FormParams;



struct SceneObjInputData
{
    float3 positionWS;
    half3 normalWS;
    half3 viewDirectionWS;
    float4 shadowCoord;
    half fogCoord;
    half3 vertexLighting;
    half3 bakedGI;
    half3 bakedBackFaceGI;
    float2 normalizedScreenSpaceUV;
    half4 shadowMask;
    half4 tangentWS;
    half4 OcclusionCullingAndMask;
};

float4 Global_MotionParams;
float4 Global_MainPlayerPosition;

half  _UseCustomTreeLight = 0;
half3  _CustomTreeMainLight_Dir = half3(1,0,0);
half3  _CustomTreeMainLight_SwitchDir = half3(1, 0, 0);

half4 SamplePlanar2D(float3 worldPosition, float4 coords, TEXTURE2D_PARAM( tex, Sampler_tex) )
{
    half2 UV = worldPosition.xz * coords.xy + coords.zw;
    half4 var = SAMPLE_TEXTURE2D(tex, Sampler_tex, UV);
    return var;
}


half4 CalcWetnessDrops(float3 worldPos, float dropTilling )
{
    half4 wetnessVar = SamplePlanar2D(worldPos, half4(dropTilling, dropTilling, 0, 0), TEXTURE2D_ARGS(Global_DropsRainOrSnow, sampler_LinearRepeat));
        
    return wetnessVar;
}


float4 CalcForm(float3 vertex)
{
    float push_layer_value = 0;
    float2 baseUV = ((Global_RenderBaseCoords).zw + ((Global_RenderBaseCoords).xy * (vertex).xz));
    float2 nearUV = ((Global_RenderNearCoords).zw + ((Global_RenderNearCoords).xy * (vertex).xz));
			
    float distance_threshold = 1.0f;
    float NearFadeValue = (Global_RenderNearFadeValue - distance_threshold);
    float distanceFade = saturate(((saturate((distance(vertex.xyz, (Global_RenderNearPositionR).xyz) / (Global_RenderNearPositionR).w)) - distance_threshold) / NearFadeValue));
    
    #if GLOBALE_NOTTEXTURE
    float4 lerpResult = Global_PushParams;
    #else
    #if USE_GLOBALTEXARRY
    float4 lerpResult = lerp(
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_RTArray, sampler_LinearClamp, baseUV, 4, 0.0),
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_RTArray, sampler_LinearClamp, nearUV, 5, 0.0), distanceFade);
    #else
    float4 lerpResult = lerp(
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_PushBaseTex, sampler_LinearClamp, baseUV, push_layer_value, 0.0),
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_PushNearTex, sampler_LinearClamp, nearUV, push_layer_value, 0.0), distanceFade);
    #endif
    #endif
    float4 form = lerp(Global_PushParams, lerpResult, Global_PushActive);
    //push.xy = push.xy * 2 - 1;
    return form;
}


float4 CalcPaintTinting(float3 vertex)
{
    float push_layer_value = 0;
    float2 baseUV = ((Global_RenderBaseCoords).zw + ((Global_RenderBaseCoords).xy * (vertex).xz));
    float2 nearUV = ((Global_RenderNearCoords).zw + ((Global_RenderNearCoords).xy * (vertex).xz));
			
    float distance_threshold = 1.0f;
    float NearFadeValue = (Global_RenderNearFadeValue - distance_threshold);
    float distanceFade = saturate(((saturate((distance(vertex.xyz, (Global_RenderNearPositionR).xyz) / (Global_RenderNearPositionR).w)) - distance_threshold) / NearFadeValue));
        
    #if USE_GLOBALTEXARRY
    float4 lerpResult = lerp(
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_RTArray, sampler_LinearClamp, baseUV, 2, 0.0),
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_RTArray, sampler_LinearClamp, nearUV, 3, 0.0), distanceFade);
    #else
    float4 lerpResult = lerp(
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_PaintBaseTex, sampler_LinearClamp, baseUV, push_layer_value, 0.0),
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_PaintNearTex, sampler_LinearClamp, nearUV, push_layer_value, 0.0), distanceFade);
    #endif

    float4 push = lerp(Global_PaintParams, lerpResult, Global_PaintActive);
    return push;
}

float4 CalcGlobalPush(float3 vertex)
{
    if (Global_EnablePush < 0.5f)
    {
        return Global_PushParams * 2 - 1;
    }
    float push_layer_value = 0;
    float2 baseUV = ((Global_RenderBaseCoords).zw + ((Global_RenderBaseCoords).xy * (vertex).xz));
    float2 nearUV = ((Global_RenderNearCoords).zw + ((Global_RenderNearCoords).xy * (vertex).xz));
			
    float distance_threshold = 1.0f;
    float NearFadeValue = (Global_RenderNearFadeValue - distance_threshold);
    float distanceFade = saturate(((saturate((distance(vertex.xyz, (Global_RenderNearPositionR).xyz) / (Global_RenderNearPositionR).w)) - distance_threshold) / NearFadeValue));
    

    #if USE_GLOBALTEXARRY    
    float4 lerpResult = lerp(
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_RTArray, sampler_LinearClamp, baseUV, 4, 0.0),
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_RTArray, sampler_LinearClamp, nearUV, 5, 0.0), distanceFade);
    #else
    float4 lerpResult = lerp(
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_PushBaseTex, sampler_LinearClamp, baseUV, push_layer_value, 0.0),
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_PushNearTex, sampler_LinearClamp, nearUV, push_layer_value, 0.0), distanceFade);
    #endif

    float4 push = lerp(Global_PushParams, lerpResult, Global_PushActive);
    push.xy = push.xy * 2 - 1;
    return push;
}

//干燥r 雨湿润g 雪b
float4 CalcAtmo(float3 vertex)
{
    //float4 atmo = Global_AtmoParams;
   // if (Global_AtmoActive > 0.5f)
    {
        float push_layer_value = 0;
        float2 baseUV = ((Global_RenderBaseCoords).zw + ((Global_RenderBaseCoords).xy * (vertex).xz));
        float2 nearUV = ((Global_RenderNearCoords).zw + ((Global_RenderNearCoords).xy * (vertex).xz));
        
        float distance_threshold = 1.0f;
        float NearFadeValue = (Global_RenderNearFadeValue - distance_threshold);
        float distanceFade = saturate(((saturate((distance(vertex.xyz, (Global_RenderNearPositionR).xyz) / (Global_RenderNearPositionR).w)) - distance_threshold) / NearFadeValue));
        
#if USE_GLOBALTEXARRY
        float4 lerpResult = lerp(
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_RTArray, sampler_LinearClamp, baseUV, 0, 0.0),
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_RTArray, sampler_LinearClamp, nearUV, 1, 0.0), distanceFade);
#else
        float4 lerpResult = lerp(
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_AtmoBaseTex, sampler_LinearClamp, baseUV, push_layer_value, 0.0),
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_AtmoNearTex, sampler_LinearClamp, nearUV, push_layer_value, 0.0), distanceFade);

#endif
        float4 atmo = max(Global_AtmoParams, lerpResult); 
        atmo = lerp(Global_AtmoParams, atmo, Global_AtmoActive);
        return atmo;
    }
    //return Global_AtmoParams;
}


float4 CalcGlowMask(float3 vertex)
{
    float push_layer_value = 0;
    float2 baseUV = ((Global_RenderBaseCoords).zw + ((Global_RenderBaseCoords).xy * (vertex).xz));
    float2 nearUV = ((Global_RenderNearCoords).zw + ((Global_RenderNearCoords).xy * (vertex).xz));
			
    float distance_threshold = 1.0f;
    float NearFadeValue = (Global_RenderNearFadeValue - distance_threshold);
    float distanceFade = saturate(((saturate((distance(vertex.xyz, (Global_RenderNearPositionR).xyz) / (Global_RenderNearPositionR).w)) - distance_threshold) / NearFadeValue));
#if GLOBALE_NOTTEXTURE
    float4 lerpResult = Global_GlowParams;
#else
    #if USE_GLOBALTEXARRY
    float4 lerpResult = lerp(
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_RTArray, sampler_LinearClamp, baseUV, 0, 0.0),
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_RTArray, sampler_LinearClamp, nearUV, 1, 0.0), distanceFade);
    #else
    float4 lerpResult = lerp(
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_AtmoBaseTex, sampler_LinearClamp, baseUV, push_layer_value, 0.0),
					SAMPLE_TEXTURE2D_ARRAY_LOD(Global_AtmoNearTex, sampler_LinearClamp, nearUV, push_layer_value, 0.0), distanceFade);

    #endif
#endif
    float4 glow = lerp(Global_GlowParams, lerpResult, Global_GlowActive);    
    return glow;
}
half4 ComputeFlowMap(float2 Coords, float2 Direction, float time)
{
    float2 uv0 = Coords + Direction * frac(time);
    float2 uv1 = Coords + Direction * frac(time + 0.5f);
    float weight = abs(frac(time) - 0.5) / 0.5f;
	
    //frac(time + 0.5f) frac(time);
	
    half4 wind = SAMPLE_TEXTURE2D_LOD(Global_MotionTex, sampler_LinearRepeat, uv0, 0.0f);
    half4 wind2 = SAMPLE_TEXTURE2D_LOD(Global_MotionTex, sampler_LinearRepeat, uv1, 0.0f);
	
    return lerp(wind, wind2, weight);

}
// out xy = Dir.xy Z = Noise
float3 ComputeMotionNoiseFlow(float3 PositionWO, float MotionValue, float MotionNoise, float MotionSpeed, float MotionTilling)
{
    float4 MotionParams = Global_MotionParams;
    float2 globalWindDir = MotionParams.xy;
    float globalWindIntensity = MotionParams.z;
	
    float2 Noise_Coord = -1 * PositionWO.xz * (MotionTilling + 0.2f) * 0.005f;
    float Noise_Speed = _TimeParameters.x * MotionSpeed * 0.02f;
	
    float4 Noise_Params = ComputeFlowMap(Noise_Coord, globalWindDir * 2 - 1, Noise_Speed);
	
    //float3 NoiseWind = float3(lerp(float2(0.5, 0.5), lerp(globalWindDir, Noise_Params.xy, MotionNoise), globalWindIntensity * MotionValue), Noise_Params.y);
    float3 NoiseWind = float3(lerp(float2(0.5, 0.5), lerp(globalWindDir, Noise_Params.xy, MotionNoise), globalWindIntensity * MotionValue), Noise_Params.y);
    
	//这里欠缺全局Blend风效果，后期补全
    //float3 BlendWind = lerp(NoiseWind, GlobalWind.rgb, GlobalWind.a);
    
    return NoiseWind;
    //half4 wind = SAMPLE_TEXTURE2D(_LuxURPWindRT, sampler_LuxURPWindRT, Noise_Coord + Noise_Speed.xx);
}

// -------------------------- 安全归一化核心函数 --------------------------
/// <summary>
/// 安全归一化向量，避免零向量产生 NaN
/// </summary>
/// <param name="vec">待归一化的向量</param>
/// <param name="defaultVec">向量为零时返回的默认单位向量</param>
/// <returns>有效单位向量或默认向量</returns>
float3 safeNormalize(float3 vec, float3 defaultVec = float3(1, 0, 0))
{
    // 计算模长平方（性能优于 length(vec)，无需开方）
    float magSq = dot(vec, vec);
    // 阈值 1e-6：兼容浮点精度误差，避免误判
    return magSq > 1e-6 ? (vec / sqrt(magSq)) : defaultVec;
    // 等价于：magSq > 1e-6 ? normalize(vec) : defaultVec;
}

//xy dir z = push.w
float3 CalcMotion(float3 BasePosition, float4x4 worldToObject, float baseMask, float touchStrength)
{
   
    float4 push = CalcGlobalPush(BasePosition.xyz);
    float2 localPush = push.rg;		
    float bend_Influence = push.w;
    float3 wind = ComputeMotionNoiseFlow(BasePosition.xyz, _MotionIntensityValue, _MotionNoiseValue, _MotionSpeedValue, _MotionTillingValue);
    wind.xy = wind.xy * 2 - 1;
        
    float bseNoise = abs(wind.z);
		//从风 Lerp 到 Push 
    float mask = (baseMask * _MotionBaseIntensityValue * lerp(bseNoise * 2 - 1, bseNoise, length(wind.xy)));
    
    float2 dir2D = lerp(wind.xy * mask, localPush.xy * touchStrength * baseMask, bend_Influence);
    //float2 dir2D = wind.xy * mask;//
    //lerp(wind.xy * mask, localPush.xy * touchStrength * baseMask, 0);
    float3 dir = float3(dir2D.x, 0, dir2D.y);
        //dir = float3(0, 0, 0);        
        
    // 防止无效值 
    float3 rotX = safeNormalize(worldToObject[0].xyz); // 世界空间中物体局部x轴的纯旋转方向
    float3 rotY = safeNormalize(worldToObject[1].xyz); // 世界空间中物体局部y轴的纯旋转方向
    float3 rotZ = safeNormalize(worldToObject[2].xyz); // 世界空间中物体局部z轴的纯旋转方向
    float4x4 objectToWorld_Rotation_4x4 = float4x4(
        rotX.x, rotX.y, rotX.z, 0.0, // 第1行：纯旋转 + 平移=0
        rotY.x, rotY.y, rotY.z, 0.0, // 第2行：纯旋转 + 平移=0
        rotZ.x, rotZ.y, rotZ.z, 0.0, // 第3行：纯旋转 + 平移=0
        0.0, 0.0, 0.0, 1.0 // 第4行：固定值
    );
    float2 Base_Direction = (mul(objectToWorld_Rotation_4x4, float4(dir, 0.0))).xz;
    
    //float3 ase_parentObjectScale = (1.0 / float3(length(worldToObject[0].xyz), length(worldToObject[1].xyz), length(worldToObject[2].xyz))); 
    //float2 Base_Direction = ((mul(worldToObject, float4(dir, 0.0)).xyz * ase_parentObjectScale)).xz;
    
    //mask = _MotionBaseIntensityValue;
    //Base_Direction *= mask;
    
    return float3(Base_Direction.xy, push.w);
}

#ifdef _USEVERTEXAO
half3 CalcTreeLeafColor(float3 ObjectSpacePosition, half3 albedo, half3 vextexColor)
{
    half3 aoOffset = vextexColor + _AO;
    half3 newAO = _AO_color.rgb;

    half posHeight = ObjectSpacePosition.y;

    //half bottomRangle = clamp(posHeight * _Btoom_Range + _Btoom_range_move, 0, 1);
    half bottomRangle = saturate(posHeight * _Btoom_Range + _Btoom_range_move);
    half3 bmColor = lerp(_Color_bottom.rgb, _Color_middle.rgb, bottomRangle);

    //half topRangle = clamp(posHeight * _Top_range + _Top_range_move, 0, 1);   
    half topRangle = saturate(posHeight * _Top_range + _Top_range_move);
    half3 colortbm = lerp(_Color_top.rgb, bmColor.rgb, 1 - topRangle);

    half3 color2 = lerp(newAO, colortbm, aoOffset);
    half3 outColor = albedo * color2;
    return outColor;
}
#endif   

uniform half _EnableReflection = 1.0f;
uniform half _EnableFog;

half Dither32(half2 Pos, half frameIndexMod4)
{
    uint3 k0 = uint3(13, 5, 15);
    //float Ret = dot( float3(Pos.xy, frameIndexMod4 + 0.5f), k0 / 32.0f);
    //half Ret = dot(half3(Pos.xy, 0.5f), k0 / 32.0f);
    half Ret = dot(half3(Pos.xy, 0.5f), k0 * 0.03125);
    return frac(Ret);
}

float4 CalculateContrast(float contrastValue, float4 colorTarget)
{
    float t = 0.5 * (1.0 - contrastValue);
    return mul(float4x4(contrastValue, 0, 0, t, 0, contrastValue, 0, t, 0, 0, contrastValue, t, 0, 0, 0, 1), colorTarget);
}

real ComputeCustomFogFactor(float z)
{
	float clipZ_01 = UNITY_Z_0_FAR_FROM_CLIPSPACE(z);

	// factor = (end-z)/(end-start) = z * (-1/(end-start)) + (end/(end-start))
	float fogFactor = saturate(clipZ_01 * unity_FogParams.z + unity_FogParams.w);
	return real(fogFactor);
}

real ComputeCustomFogIntensity(real fogFactor)
{
	real fogIntensity = fogFactor;
	return fogIntensity;
}

half3 MixCustomFogColor(real3 fragColor, real3 fogColor, real fogFactor)
{
	real fogIntensity = ComputeCustomFogIntensity(fogFactor);
	fragColor = lerp(fogColor, fragColor, fogIntensity);
	return fragColor;
}

half3 MixCustomFog(real3 fragColor, real fogFactor)
{
	return MixCustomFogColor(fragColor, unity_FogColor.rgb, fogFactor);
}



uniform half _EnabelChecker;
uniform half _EnabelStoreBlend;
uniform half _EnabelLight;
uniform half _EnableOverDraw;

uniform half _EnableMetallicSpecGlossMap = 1;
uniform half _EnableNormalMap = 1;
uniform half _EnableSpecularHighLights = 1;
uniform half _EnableEnvReflections = 1;
uniform half _DisableTerrainNormal = 0;

uniform half _EnabelBlinnPhong = 0; 
uniform half _UseWaterRender = 0;
uniform half _UseReflection = 0;

uniform float Global_GrassTouchStrength = 1.0f;

sampler2D _Checker;

uniform half _EnableAdditionalLights = 0;
uniform half _EnableAdditionalLightsVertex = 0;
uniform half _EnableAdditionalLightShadows = 0;

uniform float4 _MainLightPosition_I;
uniform half4 _MainLightColor_I;

//风
TEXTURE2D(_LuxURPWindRT); SAMPLER(sampler_LuxURPWindRT);

//  Global Inputs
float4 _LuxURPWindDirSize;
float4 _LuxURPWindStrengthMultipliers;
float4 _LuxURPSinTime;
float2 _LuxURPGust;
float _LuxURPBendFrequency;


//MAIN_LIGHT_SHADOWS_CASCADE

half3 SceneCalcTintingColor(float3 vertex, half3 albedo, half grayScale, half lum, half projY = 1.0f)
{
    half4 paintColor = CalcPaintTinting(vertex);
    
    half Tinting_GlobalValue = paintColor.w; //Global_PaintParams.w;
    half3 Tinting_GlobalColor = paintColor.rgb * Global_PaintParams.rgb * _TintingColor.rgb;
    half3 color0 = lerp(albedo, grayScale.rrr, Tinting_GlobalValue * _TintingGray);
    half LumMask = Remap(lum, _TintingLumRemap.x, _TintingLumRemap.y) * _TintingLumIntensity;
    
    half finalMask = Remap(Tinting_GlobalValue * _TintingIntensity * projY * LumMask, _TintingBlendRemap.x, _TintingBlendRemap.y);
      
    float spaceDoubleValue = 4.6; //    
    half3 Final_Albedo = lerp(albedo, Tinting_GlobalColor * spaceDoubleValue * color0, finalMask);
    return Final_Albedo; // * Tinting_GlobalColor * spaceDoubleValue;
}


half3 CalcSnow(half3 albedo, float snowIntensity,
    half snowLumIntensity, half4 snowLumRemap,
    half normalY, half snowProjYIntensity, half4 snowProjYRemap,
    half snowGlitterIntensity,
    float3 posWS,
    float viewIntensity,
    float OcclusionCulling,
    inout float metallic
    )
{
    //计算雪 开始
    //_EnableSnow
    UNITY_BRANCH
    if (Global_EnableSnow)
    {
        #if defined(GLOBAL_LOWMODE)
        half4 atmoParams = half4(0, 0, /*Global_AtmoParams.z*/1, 0);    
        #else
        half4 atmoParams = CalcAtmo(posWS);
        #endif
        
        half gray = Luminance(albedo);
        half lum = gray * 5;        
        
        half overlay_mask = Remap(lum, snowLumRemap.x, snowLumRemap.y) * snowLumIntensity;
        
        half projYMask = Remap(clamp(saturate(normalY), 0, 1), snowProjYRemap.x, snowProjYRemap.y);
        half overlay_projY = lerp(1, projYMask, snowProjYIntensity);
        half snowMask = atmoParams.z * overlay_mask * overlay_projY * OcclusionCulling;        
        
        half4 snowColor = Global_SnowColor.rgba;
       
        #if GLOBAL_LOWMODE
        albedo = lerp(albedo, snowColor.rgb, snowMask * snowIntensity);        
        #else
        half4 baseSnowColor = SAMPLE_TEXTURE2D(Global_DropsRainOrSnow, sampler_LinearRepeat, posWS.xz * Global_SnowGlitterScale.y).rgba;
        snowColor *= lerp(1, saturate(pow(baseSnowColor + Global_SnowGlitterScale.z * 0.225, 2)), Global_SnowGlitterScale.z);
        half GlitterMask = SAMPLE_TEXTURE2D(Global_DropsRainOrSnow, sampler_LinearRepeat, posWS.xz * Global_SnowGlitterScale.x).a;
        
        albedo = lerp(albedo, snowColor.rgb, snowMask * snowIntensity);
        albedo += snowMask * Global_SnowGlitterColor.rgb * snowGlitterIntensity
            * GlitterMask * viewIntensity;
        #endif
        
        metallic = lerp(metallic, 0.01f, snowMask * snowIntensity);
    }
    //计算雪 结束
    return albedo;
}


// 计算细节法线
half3 CalcWaveNormal(float3 normalWS, float4 tangentWS, float3 positionWS)
{
#if LOW_TEXSAMPLE
    return normalWS;
#endif
    
    float2 detailUv = float2(positionWS.x / 1024, positionWS.z / 1024) * 128.0f;

    float4 _DetailWaveMap_ST = float4(1, 1, 0, 0);
    float _NormalWaveIntensity1 = 0.35;
    float _TranslationSpeed1 = 1.2f;
    float _RotationAngle1 = 0;
    float _TilingWave1 = 3;
    
    float cos54_g889 = cos(radians(_RotationAngle1));
    float sin54_g889 = sin(radians(_RotationAngle1));
    
    
    float2 temp_cast_12 = (_TranslationSpeed1).xx;

    //////////////
    float2 panner = float2((_TimeParameters.x * 0.05f) * temp_cast_12);
    //panner86_g889.x = 0;
    
    half3 FlowWave = half3(0, 0, 1);
    half3 FlowWaveNormal0 = UnpackNormalScale(SAMPLE_TEXTURE2D(Global_WaveNormalMap, sampler_LinearRepeat, positionWS.xz / float2(2, 2) + float2(0.5, 0) + float2(0, panner.x * 1.0f)), _NormalWaveIntensity1).xyz;
    half3 FlowWaveNormal1 = UnpackNormalScale(SAMPLE_TEXTURE2D(Global_WaveNormalMap, sampler_LinearRepeat, positionWS.xz / float2(2, 2) - float2(0, panner.x * 1.0f)), _NormalWaveIntensity1).
    xyz;
    half3 FlowWaveNormal2 = UnpackNormalScale(SAMPLE_TEXTURE2D(Global_WaveNormalMap, sampler_LinearRepeat, positionWS.zx / float2(2, 2) + float2(0.5, 0) + float2(0, panner.x * 1.0f)), _NormalWaveIntensity1).xyz;
    half3 FlowWaveNormal3 = UnpackNormalScale(SAMPLE_TEXTURE2D(Global_WaveNormalMap, sampler_LinearRepeat, positionWS.zx / float2(2, 2) - float2(0, panner.x * 1.0f)), _NormalWaveIntensity1).xyz;

    
    half3 FlowWaveNormal4 = UnpackNormalScale(SAMPLE_TEXTURE2D(Global_WaveNormalMap, sampler_LinearRepeat, positionWS.xy / float2(4, 8) + float2(0, panner.x * 2)), _NormalWaveIntensity1).xyz;
    half3 FlowWaveNormal5 = UnpackNormalScale(SAMPLE_TEXTURE2D(Global_WaveNormalMap, sampler_LinearRepeat, positionWS.zy / float2(4, 8) + float2(0, panner.x * 2)), _NormalWaveIntensity1).xyz;
    
    half3 FlowWaveNormal6 = UnpackNormalScale(SAMPLE_TEXTURE2D(Global_WaveNormalMap, sampler_LinearRepeat, positionWS.xy / float2(2, 4) + float2(0, panner.x * 2)), _NormalWaveIntensity1).xyz;

    half3 FlowWaveNormal7 = UnpackNormalScale(SAMPLE_TEXTURE2D(Global_WaveNormalMap, sampler_LinearRepeat, positionWS.zy / float2(2, 4) + float2(0, panner.x * 2)), _NormalWaveIntensity1).xyz;

    
    half isVertical = (normalWS.y * normalWS.y) < 0.90f;
    half fIntensity = isVertical;
    
    half3 waveNormal = FlowWaveNormal0 + FlowWaveNormal3 + FlowWaveNormal2 + FlowWaveNormal1;
    
    FlowWave = (FlowWaveNormal4 + FlowWaveNormal6) * abs(normalWS.z) + (FlowWaveNormal5 + FlowWaveNormal7) * abs(normalWS.x);
    FlowWave = normalize(FlowWave) * fIntensity;
    
    FlowWave = FlowWave + (1 - fIntensity) * waveNormal;
    FlowWave = normalize(FlowWave);
        
    half3 NormalPuddles459 = FlowWave;
    half3 detailNormalWS = half3(0, 0, 1);
    {
        half sgn = tangentWS.w; // should be either +1 or -1
        half3 bitangent = sgn * cross(normalWS.xyz, tangentWS.xyz);
        detailNormalWS = TransformTangentToWorld(NormalPuddles459, half3x3(tangentWS.xyz, bitangent.xyz, normalWS.xyz));
    }

    return detailNormalWS;
}


void ProcessGlobal(float3 positionWS, float emissionMod, 
    float metallic, half3 mainLightDir,
    float4 tangentWS, float3 viewDirectionWS,
    inout half3 GlowColor,
    inout half3 albedo, 
    inout float3 normalWS, 
    inout float smoothness, 
    inout float3 specular
)
{
    GlowColor = half3(0, 0, 0);
    UNITY_BRANCH
    if (Global_Enable)
    {
        half4 depthRGB = SAMPLE_TEXTURE2D(Global_RainSnowMask, sampler_LinearRepeat, (positionWS.xz + 512) / 1024.0f);
        half depthHeight = depthRGB.r * 255.0f * 255.0f + depthRGB.g * 255.0f;

        half OcclusionCulling1 = (1 - (Remap(depthHeight - (positionWS.y + 1.5), 0, 4) / 4.0f));
        half4 OcclusionCullingAndMask = half4((depthHeight - (positionWS.y + 1.5)),
                lerp(1, depthRGB.b, _WetnessBlendSlope), 0, 0);
        
        UNITY_BRANCH
        if (Global_EnableSnow)
        {
            half viewIntensity = 0;
            //1.高度图
            half dir = dot(normalWS, mainLightDir);
            if (dir > 0.0)
            {
                half3 bitangent = cross(normalWS.xyz, tangentWS.xyz) * tangentWS.w;
                half3 viewDir = SafeNormalize(viewDirectionWS);
            
                viewIntensity = pow(max(0, dot(reflect(-mainLightDir, normalWS), viewDir)), Global_SnowShininess);
            }
           
            albedo = CalcSnow(
                albedo,
                _SnowIntensity,
                _SnowLumIntensity,
                _SnowLumRemap,
                normalWS.y, _SnowProjYIntensity, _SnowProjYRemap,
                _SnowGlitterIntensity,
                positionWS, viewIntensity, OcclusionCulling1,
                metallic);
        }
    
#if GLOBAL_LOWMODE
#else
        UNITY_BRANCH
        if (Global_EnableGlowEmissive)
        {
            half emissiveMask = lerp(1, emissionMod, _EmissiveMask_GS) * _EmissiveIntensity_GS;
            half3 emissionColor = emissiveMask * _EmissiveColor_GS.rgb;
            GlowColor += emissionColor * CalcGlowMask(positionWS).r;
        }
#endif
    
        UNITY_BRANCH
        if (Global_EnablePaintTinting)
        {
            half gray = Luminance(albedo);
            half lum = gray * 5;
            
            albedo = SceneCalcTintingColor(positionWS, albedo, gray, lum, 1);
        }
        
        UNITY_BRANCH
        if (Global_EnableRain)
        {
#if GLOBAL_LOWMODE
            half4 atmoParams = float4(0, 1, /*Global_AtmoParams.z*/0, 0);    
#else
            half4 atmoParams = CalcAtmo(positionWS);
#endif            
            half3 waveNormal = CalcWaveNormal(normalWS, tangentWS, positionWS);        
            half wetnessProjYMask = Remap(clamp(saturate(normalWS.y), 0, 1), _WetnessDropsProjRemap.x, _WetnessDropsProjRemap.y);
            half4 temp_cast_10 = ((depthRGB.a + (-1.2 + (Global_SpreadDetailMap - 0.0) * (0.7 - -1.2) / (1.0 - 0.0)))).xxxx;
            half4 temp_output_35_0_g871 = CalculateContrast((Global_ContrastDetailMap + 1.0), temp_cast_10);
            half4 clampResult38_g871 = clamp(temp_output_35_0_g871, half4(0, 0, 0, 0), half4(1, 1, 1, 0));        
            
            half Mask = (OcclusionCullingAndMask.g * clampResult38_g871.r) * (1 - saturate(OcclusionCullingAndMask.r));        
            half WetnessHeight = saturate(smoothness);
            half WetnessValue = atmoParams.y * _WetnessIntensity; //湿度，应该是全部地表都湿
            half WaterMask = Remap(clamp(WetnessValue * _WetnessWaterIntensity - WetnessHeight, 0, 1), _WetnessBlendRemap.x, _WetnessBlendRemap.y) * Mask.r; //积水 只有Mask区域积水
        
            //雨 wetness
            smoothness = lerp(smoothness, Global_WetnessMtlModify.x, WaterMask); // 反射增强
            specular.r = lerp(specular.r, Global_WetnessMtlModify.y, WaterMask); // 反射增强

            half3 WetColor0 = lerp(albedo, _WetnessWaterColor.rgb * albedo, WaterMask);
            half3 WetColor1 = lerp(WetColor0, WetColor0 * WetColor0, Global_WetnessMtlModify.z);
            half3 WetColor2 = lerp(albedo, WetColor1, WetnessValue); //颜色变暗 
            albedo = WetColor2.rgb;
    
#if GLOBAL_LOWMODE //GLOBALE_TEXTURESIM
#else
            half4 wetnessTex = CalcWetnessDrops(positionWS, Global_WetnessMtlModify.w);
            half4 rain_RingsNormal = half4(wetnessTex.xy, 2, -1);
            half4 rain_DropsNormal = half4(wetnessTex.zw, 2, -1);
            half distMinus = 1 - saturate(distance(_WorldSpaceCameraPos, positionWS) / _WetnessDropsFade);
            half2 WetnessNormal = lerp((rain_RingsNormal * 2 - 1), (rain_DropsNormal * 2 - 1) * 0.5f, 1 - WaterMask).rg
                        * _WetnessDropsIntensity * _WetnessDropsNormal * WetnessValue * wetnessProjYMask * distMinus;
    
            normalWS = lerp(normalWS, waveNormal + half3(WetnessNormal.x, 0, WetnessNormal.y), WaterMask);
            normalWS = normalize(normalWS);
#endif       
        }
    }
} 



float4 _MainLightShaderParam;
half4 GetPrecomputedShadowMasks(float4 shadowMask)
{
    half4 InvUniformPenumbraSizes = _MainLightShaderParam.w;
    half4 DistanceFieldBias = -.5f * InvUniformPenumbraSizes + .5f;
    half4 ShadowFactors = saturate(shadowMask * InvUniformPenumbraSizes + DistanceFieldBias);
    return ShadowFactors * ShadowFactors;
}

#endif
