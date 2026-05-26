#ifndef CLOUDSHADOW_COMMON
#define CLOUDSHADOW_COMMON

TEXTURE2D_X(_CloudShadowTex);
SAMPLER(sampler_CloudShadowTex);

uniform half _EnableCloudShadow;
uniform half _CloudIntensity;
uniform half _CloudScale;
uniform half _CloudSpeedX;
uniform half _CloudSpeedY;
uniform half _CloudThrehold;
uniform half _CloudSmooth;

half GetCloudShadowAttenuation(float3 wpos, half shadowStrength)
{
    return 1;
    //if(_EnableCloudShadow > 0.5)
    //{
    //    float2 cloud_uv = (wpos.xz + _Time.y * float2(_CloudSpeedX, _CloudSpeedY)) * _CloudScale;

    //    half cloud = SAMPLE_TEXTURE2D(_CloudShadowTex, sampler_CloudShadowTex, cloud_uv).r;

    //    half useShadow = step(0, cloud) * step(length(wpos - _WorldSpaceCameraPos), 1000);

    //    half darkMask = smoothstep(_CloudThrehold - _CloudSmooth, _CloudThrehold + _CloudSmooth, 1 - cloud);

    //    half attenuation = LerpWhiteTo(darkMask, useShadow * _CloudIntensity);
        
    //    return LerpWhiteTo(attenuation, shadowStrength);
    //}
    //else
    //{
    //    return 1.0f;
    //}
}

#endif
