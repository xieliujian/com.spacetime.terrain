#ifndef VACUUM_SHADERS_T2M_DEFERRED_CGINC
#define VACUUM_SHADERS_T2M_DEFERRED_CGINC


#define TERRAIN_TO_MESH_RP_UNIVERSAL


#include "cginc/Core.hlsl"

TEXTURE2D(_BaseMap); SAMPLER(sampler_BaseMap);
#if defined(TERRAIN_TO_MESH_FALLBACK)
    TEXTURE2D(_BumpMap);
#endif



//Curved World//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void SHG_TerrainToMeshCurvedWorld_float(float3 inVertex, half3 inNormal, half4 inTangent, out float3 outVertex, out half3 outNormal)
{
    float4 vertex = float4(inVertex, 1);
    half3 normal = inNormal;
    half4 tangent =  inTangent;

    //Curved World
    #if defined(CURVEDWORLD_IS_INSTALLED) && !defined(CURVEDWORLD_DISABLED_ON)
        #ifdef CURVEDWORLD_NORMAL_TRANSFORMATION_ON            
            CURVEDWORLD_TRANSFORM_VERTEX_AND_NORMAL(vertex, normal, tangent)
        #else
            CURVEDWORLD_TRANSFORM_VERTEX(vertex)
        #endif
    #endif


    outVertex = vertex.xyz;
    outNormal = normal.xyz;
}

void SHG_TerrainToMeshCurvedWorld_half(float3 inVertex, half3 inNormal, half4 inTangent, out float3 outVertex, out half3 outNormal)
{
    SHG_TerrainToMeshCurvedWorld_float(inVertex, inNormal, inTangent, outVertex, outNormal);
}


//Holes//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void SHG_TerrainToMeshCalculateClipValue_float(float4 uv, out half clipValue)
{
     clipValue = TerrainToMeshCalculateClipValue(uv.xy);	
}

void SHG_TerrainToMeshCalculateClipValue_half(float4 uv, out half clipValue)
{
     SHG_TerrainToMeshCalculateClipValue_float(uv, clipValue);	
} 

half4 UseWaterRender(SurfaceDescriptionInputs IN)
{
	half4 baseColor = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv0.xy);
	return baseColor;
}

//Layers//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
void SHG_TerrainToMeshCalculateLayersBlend_float(float3 positionWS, float3 normalWS, float4 uv, out half3 albedoValue, out half alphaValue, out half3 normalValue, out half metallicValue, out half smoothnessValue, out half occlusionValue)
{

    #if defined(TERRAIN_TO_MESH_FALLBACK) || defined(VT_RUNTIME)
        uv.xy = lerp(uv.xy, uv.zw, _EnableUV2ForTriplanar);
        half4 baseColor = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, uv.xy);
        albedoValue = baseColor.rgb;
        alphaValue = baseColor.a;
        //Unpack normal
        //half4 bumpMap = SAMPLE_TEXTURE2D(_BumpMap, sampler_BaseMap, uv.xy);
        //normalValue.rgb = UnpackNormal(bumpMap);
        //
        normalValue = float3(0, 0, 1);
        metallicValue = 0;
        smoothnessValue = 0;
        occlusionValue = 1;

    #elif defined(SHADERPASS_SHADOWCASTER) || defined(SHADERPASS_DEPTHONLY)
        albedoValue = 0;
        alphaValue = 1;
        normalValue = float3(0, 0, 1);
        metallicValue = 0;
        smoothnessValue = 0;
        occlusionValue = 0;
    #else
        TerrainToMeshCalculateLayersBlend(positionWS, normalWS, uv.xy, albedoValue, alphaValue, normalValue, metallicValue, smoothnessValue, occlusionValue);	
    #endif
}

void SHG_TerrainToMeshCalculateLayersBlend_half(float4 uv, inout half3 albedoValue, inout half alphaValue, inout half3 normalValue, inout half metallicValue, inout half smoothnessValue, out half occlusionValue)
{
    SHG_TerrainToMeshCalculateLayersBlend_float(float3(0,0,0), float3(0,0,0), uv, albedoValue, alphaValue, normalValue, metallicValue, smoothnessValue, occlusionValue);	
}

 
#endif   