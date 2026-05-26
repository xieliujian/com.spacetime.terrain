#ifndef SCENEOBJ_COMMONTONNEMAPING
#define SCENEOBJ_COMMONTONNEMAPING

uniform half _EnableLocalToneMap = 0.0f;
uniform half _UEExposure;
uniform half _UESaturation;
uniform half _UEContrast;
uniform half _UEToneMapWight;

// Converts color to luminance (grayscale)
half UE_Luminance(half3 rgb)
{
    return dot(rgb, half3(0.2126729, 0.7151522, 0.0721750));
}

// Reference: https://github.com/EpicGames/UnrealEngine/blob/release/Engine/Shaders/Private/PostProcessCombineLUTs.usf
half3 UE_ColorCorrect(half3 color, half saturation, half contrast, half exposture, half luma)
{
    
    color = max(0, lerp(luma, color, saturation));
    //1.0/0.18f = 5.555555f;
    color = pow(color * 5.5556f/*(1.0f / 0.18f)*/, contrast) * 0.18f;
    color = color * pow(2.0f, exposture);
    return color;
}

// ACES tone mapping curve fit to go from HDR to LDR
// Reference: https://knarkowicz.wordpress.com/2016/01/06/aces-filmic-tone-mapping-curve/
half3 UE_ACESFilm(half3 x, half luma)
{
    luma = clamp(luma, 1, 100.0f);
    half a = 2.51f;
    half b = 0.03f;
    half c = 2.43f;
    half d = 0.59f;
    half e = 0.14f;
    
    half3 rgb = x;
    
    half3 newColor = clamp((x * (a * x + b)) / (x * (c * x + d) + e), 0, 1) * luma; //
    
    return newColor;
    //return (newColor / x) * newColor;
    //(x * (a * x + b)) / (x * (c * x + d) + e) * luma; //,
    //0.0f, 1.0f);
}

half3 TonemppingColor(half3 color, half mod = 1.0f )
{
    //新項目關閉Tonemapping
    return color;
//#if defined(_CHECK_TONEMAP)
    //if (_EnableLocalToneMap < 0.5f)
    //{
    //    return color;
    //}
//#endif
   // half luma = UE_Luminance(color);
   // half3 newColor = UE_ColorCorrect(color, _UESaturation, _UEContrast, _UEExposure, luma);
   //// half luma2 = UE_Luminance(color);
   // newColor = UE_ACESFilm(newColor, luma);
    
   // return lerp(color, newColor, _EnableLocalToneMap*mod*_UEToneMapWight);
}

// Decodes HDR textures
// handles dLDR, RGBM formats
inline half3 DecodeHDR_Skybox(half4 data, half4 decodeInstructions)
{
	// Take into account texture alpha if decodeInstructions.w is true(the alpha value affects the RGB channels)
	half alpha = abs(decodeInstructions.w * (data.a - 1.0) + 1.0);

	// If Linear mode is not supported we can skip exponent part
#if defined(UNITY_COLORSPACE_GAMMA)
	return (decodeInstructions.x * alpha) * data.rgb;
#else
#   if defined(UNITY_USE_NATIVE_HDR)
	return decodeInstructions.x * data.rgb; // Multiplier for future HDRI relative to absolute conversion.
#   else
	return (decodeInstructions.x * pow(alpha, decodeInstructions.y)) * data.rgb;
#   endif
#endif
}

float4 GetColorSpaceDouble()
{
#ifdef UNITY_COLORSPACE_GAMMA
	return float4(2.0, 2.0, 2.0, 2.0);
#else // Linear values
	return float4(4.59479380, 4.59479380, 4.59479380, 2.0);
#endif
}

#endif
