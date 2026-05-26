#ifndef _GLOBAL_COMMON_H_
#define _GLOBAL_COMMON_H_

float _OnlyRoleRealShadowMode;
float _ForceUseBakedShadow;

// .
half MixRealtimeAndBakedShadowsCustom_OnlyRoleRealShadowMode(half realtimeShadow, half bakedShadow, half shadowFade)
{    
    realtimeShadow = min(realtimeShadow, bakedShadow);
    
#if defined(LIGHTMAP_SHADOW_MIXING)
    return min(lerp(realtimeShadow, 1, shadowFade), bakedShadow);
#else
    return lerp(realtimeShadow, bakedShadow, shadowFade);
#endif
}

// .
half MixRealtimeAndBakedShadowsCustom_NormalMode(half realtimeShadow, half bakedShadow, half shadowFade)
{
    realtimeShadow = lerp(realtimeShadow, min(realtimeShadow, bakedShadow), step(0.5, _ForceUseBakedShadow));

#if defined(LIGHTMAP_SHADOW_MIXING)
    return min(lerp(realtimeShadow, 1, shadowFade), bakedShadow);
#else
    return lerp(realtimeShadow, bakedShadow, shadowFade);
#endif
}

// .
half MixRealtimeAndBakedShadowsCustom(half realtimeShadow, half bakedShadow, half shadowFade)
{
    float shadow = 1.0;
    
    if (_OnlyRoleRealShadowMode > 0.5)
    {
        shadow = MixRealtimeAndBakedShadowsCustom_OnlyRoleRealShadowMode(realtimeShadow, bakedShadow, shadowFade);
    }
    else
    {
        shadow = MixRealtimeAndBakedShadowsCustom_NormalMode(realtimeShadow, bakedShadow, shadowFade);
    }
    
    return shadow;
}

#endif