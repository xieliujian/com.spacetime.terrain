#ifndef ADDITIONALDIRECTIONALLIGHT_COMMON_INCLUDED
#define ADDITIONALDIRECTIONALLIGHT_COMMON_INCLUDED

half _CharShadowOverlayStrength;
half _MainLightShadowCascadeEnable;

half LRAdditionalLightRealtimeShadow(int lightIndex, float3 positionWS, half3 lightDirection)
{
    #if defined(ADDITIONAL_LIGHT_CALCULATE_SHADOWS)
    ShadowSamplingData shadowSamplingData = GetAdditionalLightShadowSamplingData(lightIndex);

    half4 shadowParams = GetAdditionalLightShadowParams(lightIndex);

    int shadowSliceIndex = shadowParams.w;
    if (shadowSliceIndex < 0)
        return 1.0;

    half isPointLight = shadowParams.z;
    half isDirectionLight = step(shadowParams.z, -0.5);

    UNITY_BRANCH
    if(isDirectionLight)
    {
#if LIGHT_SHADOW_NEW || _MAIN_LIGHT_SHADOWS_CASCADE
        shadowSliceIndex += (int)lerp(0.0h, (half)ComputeCascadeIndex(positionWS), _MainLightShadowCascadeEnable);
#else
        shadowSliceIndex += 0;
#endif
    }
    else if (isPointLight)
    {
        // This is a point light, we have to find out which shadow slice to sample from
        float cubemapFaceId = CubeMapFaceID(-lightDirection);
        shadowSliceIndex += cubemapFaceId;
    }

    #if USE_STRUCTURED_BUFFER_FOR_LIGHT_DATA
        float4 shadowCoord = mul(_AdditionalLightsWorldToShadow_SSBO[shadowSliceIndex], float4(positionWS, 1.0));
    #else
        float4 shadowCoord = mul(_AdditionalLightsWorldToShadow[shadowSliceIndex], float4(positionWS, 1.0));
    #endif

    return SampleShadowmap(TEXTURE2D_ARGS(_AdditionalLightsShadowmapTexture, sampler_AdditionalLightsShadowmapTexture), shadowCoord, shadowSamplingData, shadowParams, true);
        #else
        return half(1.0);
    #endif
}

half LRAdditionalLightShadow(int lightIndex, float3 positionWS, half3 lightDirection, half4 shadowMask, half4 occlusionProbeChannels)
{
#if !defined(ADDITIONAL_LIGHT_CALCULATE_SHADOWS)
    return 1.0h;
#endif
    
    half realtimeShadow = LRAdditionalLightRealtimeShadow(lightIndex, positionWS, lightDirection);

    #ifdef CALCULATE_BAKED_SHADOWS
    half bakedShadow = BakedShadow(shadowMask, occlusionProbeChannels);
    #else
    half bakedShadow = 1.0h;
    #endif

#ifdef ADDITIONAL_LIGHT_CALCULATE_SHADOWS
    half shadowFade = GetAdditionalLightShadowFade(positionWS);
#else
    half shadowFade = half(1.0);
#endif

    return MixRealtimeAndBakedShadows(realtimeShadow, bakedShadow, shadowFade);
}

Light LRGetAdditionalLight(uint i, float3 positionWS, half4 shadowMask)
{
#if USE_FORWARD_PLUS
    int lightIndex = i;
#else
    int lightIndex = GetPerObjectLightIndex(i);
#endif
    Light light = GetAdditionalPerObjectLight(lightIndex, positionWS);

//#if USE_STRUCTURED_BUFFER_FOR_LIGHT_DATA
//    half4 occlusionProbeChannels = _AdditionalLightsBuffer[lightIndex].occlusionProbeChannels;
//#else
//    half4 occlusionProbeChannels = _AdditionalLightsOcclusionProbes[lightIndex];
//#endif
    half4 occlusionProbeChannels = half4(0, 0, 0, 0);
    light.shadowAttenuation = LRAdditionalLightShadow(lightIndex, positionWS, light.direction, shadowMask, occlusionProbeChannels);

    return light;
}

#endif