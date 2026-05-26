#ifndef TERRAIN_SHADOW_COMMON_INCLUDE
#define TERRAIN_SHADOW_COMMON_INCLUDE

#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
#include "ext/GlobalCommon.hlsl"

half MainLightShadow_Terrain(float4 shadowCoord, float3 positionWS, half4 shadowMask, half4 occlusionProbeChannels)
{
    half realtimeShadow = MainLightRealtimeShadow(shadowCoord);

#ifdef CALCULATE_BAKED_SHADOWS
    half bakedShadow = BakedShadow(shadowMask, occlusionProbeChannels);
#else
    half bakedShadow = 1.0h;
#endif

    // LR Modified 测试代码
#if defined(_USEVERTEXAO) || defined(IMPOSTOR_DRAW) || defined(LOW_SHADER)
    return bakedShadow;
#endif
    // LR Modified
    
#ifdef MAIN_LIGHT_CALCULATE_SHADOWS
    half shadowFade = GetShadowFade(positionWS);
#else
    half shadowFade = 1.0h;
#endif

#if defined(_MAIN_LIGHT_SHADOWS_CASCADE) && defined(CALCULATE_BAKED_SHADOWS)
    // shadowCoord.w represents shadow cascade index
    // in case we are out of shadow cascade we need to set shadow fade to 1.0 for correct blending
    // it is needed when realtime shadows gets cut to early during fade and causes disconnect between baked shadow
    shadowFade = shadowCoord.w == 4 ? 1.0h : shadowFade;
#endif

    return MixRealtimeAndBakedShadowsCustom(realtimeShadow, bakedShadow, shadowFade);
}

Light GetMainLight_Terrain()
{
    Light light = (Light)0;
    light.direction = _MainLightPosition.xyz;
#if USE_FORWARD_PLUS
#if defined(LIGHTMAP_ON) && defined(LIGHTMAP_SHADOW_MIXING)
    light.distanceAttenuation = _MainLightColor.a;
#else
    light.distanceAttenuation = 1.0;
#endif
#else
    light.distanceAttenuation = unity_LightData.z; // unity_LightData.z is 1 when not culled by the culling mask, otherwise 0.
#endif

    //light.distanceAttenuation = unity_LightData.z; // unity_LightData.z is 1 when not culled by the culling mask, otherwise 0.
    light.shadowAttenuation = 1.0;
    light.color = _MainLightColor.rgb;
    light.layerMask = _MainLightLayerMask;

    return light;
}

Light GetMainLight_Terrain(float4 shadowCoord, float3 positionWS, half4 shadowMask)
{
    Light light = GetMainLight_Terrain();
    light.shadowAttenuation = MainLightShadow_Terrain(shadowCoord, positionWS, shadowMask, _MainLightOcclusionProbes);
    return light;
}


#endif // TERRAIN_SHADOW_COMMON