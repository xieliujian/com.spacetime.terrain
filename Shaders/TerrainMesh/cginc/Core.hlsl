#ifndef TERRAIN_TO_MESH_CORE_CGINC
#define TERRAIN_TO_MESH_CORE_CGINC



#include "Variables.hlsl"


half4 TerrainToMeshRemap(half4 value, half4 outMin, half4 outMax)
{ 
    return outMin + value * (outMax - outMin);
} 

//Unity_NormalStrength_half
half3 TerrainToMeshNormalStrength(half3 In, half Strength)
{
	return half3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
}

#if defined(_T2M_TEXTURE_SAMPLE_TYPE_ARRAY)	
	#define T2M_UNPACK_SPLATMAP(uv,index)            SAMPLE_TEXTURE2D_ARRAY(_T2M_SplatMaps2DArray, sampler_T2M_SplatMaps2DArray, uv, index);
	#define T2M_UNPACK_PAINTMAP(uv,index,sum,splat,positionWS,normalWS)	 float4 paintColor##index = (_T2M_Layer_##index##_MapsUsage.x > 0.5 ? SAMPLE_TEXTURE2D_ARRAY(_T2M_DiffuseMaps2DArray, sampler_T2M_DiffuseMaps2DArray, uv * _T2M_Layer_##index##_uvScaleOffset, paintMapUsageIndex) : float4(1, 1, 1, 1));  paintMapUsageIndex += _T2M_Layer_##index##_MapsUsage.x > 0.5 ? 1 : 0;  sum += paintColor##index * _T2M_Layer_##index##_ColorTint * splat;

	#define T2M_UNPACK_NORMAL_MAP(index,uv,sum,splat) sum += TerrainToMeshNormalStrength(UnpackNormal(SAMPLE_TEXTURE2D_ARRAY(_T2M_NormalMaps2DArray, sampler_T2M_NormalMaps2DArray, uv * _T2M_Layer_##index##_uvScaleOffset, normalMapUsageIndex)), _T2M_Layer_##index##_NormalScale) * splat;	normalMapUsageIndex += 1;
	#define T2M_UNPACK_MASK(index,uv,sum,splat)       sum += TerrainToMeshRemap(SAMPLE_TEXTURE2D_ARRAY(_T2M_MaskMaps2DArray, sampler_T2M_MaskMaps2DArray, uv * _T2M_Layer_##index##_uvScaleOffset, maskMapUsageIndex), _T2M_Layer_##index##_MaskMapRemapMin, _T2M_Layer_##index##_MaskMapRemapMax) * splat; maskMapUsageIndex += 1;
#else

#if defined(ONLY_NORMAL)	
	#define T2M_UNPACK_PAINTMAP(uv,index,sum,splat,positionWS,normalWS)  float4 paintColor##index = float4(0,0,0,0);
#else
	//#define T2M_UNPACK_PAINTMAP(uv,index,sum,splat,positionWS,normalWS)	 half4 paintColor##index = SAMPLE_TEXTURE2D(_T2M_Layer_##index##_Diffuse, sampler_T2M_Layer_0_Diffuse, uv * _T2M_Layer_##index##_uvScaleOffset);	sum += paintColor##index * _T2M_Layer_##index##_ColorTint * splat;	
	#define T2M_UNPACK_PAINTMAP(uv,index,textureValue,splat,positionWS,normalWS)	 T2M_Paintmap(textureValue, _T2M_Layer_##index##_Diffuse, sampler_T2M_Layer_0_Diffuse, uv, _T2M_Layer_##index##_uvScaleOffset, positionWS, normalWS, _Layer##index##_Triplanar, _Layer##index##_TriplanarTileScale);	float4 paintColor##index = textureValue;
#endif

	#define T2M_UNPACK_SPLATMAP(uv,index)            SAMPLE_TEXTURE2D(_T2M_SplatMap_##index, sampler_T2M_SplatMap_0, uv);

#if defined(ONLY_COLOR)
	#define T2M_UNPACK_NORMAL_MAP(index,uv,sum,splat) sum += 0;
	#else
	//#define T2M_UNPACK_NORMAL_MAP(index,uv,sum,splat) sum += TerrainToMeshNormalStrength(UnpackNormal(SAMPLE_TEXTURE2D(_T2M_Layer_##index##_NormalMap, sampler_T2M_Layer_##index##_NormalMap, uv * _T2M_Layer_##index##_uvScaleOffset)), _T2M_Layer_##index##_NormalScale) * splat;

	#define T2M_UNPACK_NORMAL_MAP(index,uv,sum,splat,positionWS,normalWS) half4 normalValue##index = half4(0,0,0,0); T2M_Paintmap(normalValue##index, _T2M_Layer_##index##_NormalMap, sampler_LinearRepeat, uv, _T2M_Layer_##index##_uvScaleOffset, positionWS, normalWS, _Layer##index##_Triplanar, _Layer##index##_TriplanarTileScale);  sum += TerrainToMeshNormalStrength(UnpackNormal(normalValue##index), _T2M_Layer_##index##_NormalScale) * splat;

#endif

	//#define T2M_UNPACK_MASK(index,uv,sum,splat)       sum += TerrainToMeshRemap(SAMPLE_TEXTURE2D(_T2M_Layer_##index##_Mask, sampler_T2M_Layer_0_Diffuse, uv * _T2M_Layer_##index##_uvScaleOffset), _T2M_Layer_##index##_MaskMapRemapMin, _T2M_Layer_##index##_MaskMapRemapMax) * splat;


#endif

//#define T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(index,sum,splat)   sum += half4(_T2M_Layer_##index##_MetallicOcclusionSmoothness.rgb, lerp(_T2M_Layer_##index##_MetallicOcclusionSmoothness.a, paintColor##index.a, _T2M_Layer_##index##_SmoothnessFromDiffuseAlpha)) * splat;
#define T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(index,sum,splat)   sum += half4(_T2M_Layer_##index##_MetallicOcclusionSmoothness.rgb, _T2M_Layer_##index##_MetallicOcclusionSmoothness.a) * splat;


void T2M_Paintmap(inout half4 finalColor, TEXTURE2D(sourceTexture), SAMPLER(sampler_sourceTexture), float2 uv, float2 uvScale, float3 position, float3 normal, float enableTriplanar, float tileScale)
{
	float triplanarMapping = enableTriplanar;
	float3 weight = float3(1.0f, 1.0f, 1.0f);

	float2 uv_xy = position.xy;
	float2 uv_zy = position.yz;
	float2 uv_xz = position.xz;
	
	if(triplanarMapping < 0.5)
	{
		uv_xy = uv * uvScale;
	}
	else
	{
        tileScale *= 8;
		tileScale = rcp(tileScale);

		uv_xy = uv_xy * tileScale;
		uv_zy = uv_zy * tileScale;
		uv_xz = uv_xz * tileScale;

		float _BlendOffset = 0.35f;
		float _BlendExponent = 10.0f;
		
		weight = abs(normal);
		weight = saturate(weight - _BlendOffset);
		weight = pow(weight, _BlendExponent);
		weight = weight / max(0.001f,(weight.x + weight.y + weight.z));

		uv_zy.x = lerp(uv_zy.x, -uv_zy.x, step(normal.x, 0));
		uv_xz.x = lerp(uv_xz.x, -uv_xz.x, step(normal.y, 0));
		uv_xy.x = lerp(uv_xy.x, -uv_xy.x, step(0, normal.z));
	}

    finalColor = SAMPLE_TEXTURE2D(sourceTexture, sampler_sourceTexture, uv_xy) * saturate(weight.z);

	if(triplanarMapping > 0.5)
	{
		float4 color_zy = SAMPLE_TEXTURE2D(sourceTexture, sampler_sourceTexture, uv_zy) * saturate(weight.x);
		float4 color_xz = SAMPLE_TEXTURE2D(sourceTexture, sampler_sourceTexture, uv_xz) * saturate(weight.y);
		finalColor += color_zy + color_xz;
	}
}


half TerrainToMeshCalculateClipValue(half2 uv)
{
	#if defined(_ALPHATEST_ON)
		half4 holesmap = SAMPLE_TEXTURE2D(_T2M_HolesMap, sampler_T2M_HolesMap, uv);
		return holesmap.r;
	#else 		
		return 1;
	#endif
}

//void TerrainToMeshCalculateLayersBlend_VTBase(float2 uv, out half3 albedoValue, out half alphaValue, out half3 normalValue, out half metallicValue, out half smoothnessValue, out half occlusionValue)
//{
//	half4 paintColorSum = 0;
	
//	albedoValue = paintColorSum.rgb;
//	alphaValue = paintColorSum.a;

//	half3 emptyNormal = half3(0, 0, 1);
//	normalValue = half3(0, 0, 1);

//}

#ifdef _TERRAIN_BLEND_HEIGHT
void HeightBasedSplatModify(inout float4 splatControl0, inout float4 splatControl1, in half4 heightValue0[4], in half4 heightValue1[4])
{
    // heights are in mask blue channel, we multiply by the splat Control weights to get combined height
    float4 splatHeight0 = float4(heightValue0[0].a, heightValue0[1].a, heightValue0[2].a, heightValue0[3].a) * splatControl0.rgba;
    float maxHeight0 = max(splatHeight0.r, max(splatHeight0.g, max(splatHeight0.b, splatHeight0.a)));

	float4 splatHeight1 = float4(heightValue1[0].a, heightValue1[1].a, heightValue1[2].a, heightValue1[3].a) * splatControl1.rgba;
    float maxHeight1 = max(splatHeight1.r, max(splatHeight1.g, max(splatHeight1.b, splatHeight1.a)));

	float maxHeight = max(maxHeight0, maxHeight1);

    // Ensure that the transition height is not zero.
    float transition = max(_HeightTransition * 0.01f, /*0.0005f*/0.0005f);

    // This sets the highest splat to "transition", and everything else to a lower value relative to that, clamping to zero
    // Then we clamp this to zero and normalize everything
    float4 weightedHeights0 = splatHeight0 + transition - maxHeight.xxxx;
	float4 weightedHeights1 = splatHeight1 + transition - maxHeight.xxxx;
    weightedHeights0 = max(0, weightedHeights0);
    weightedHeights1 = max(0, weightedHeights1);

    // We need to add an epsilon here for active layers (hence the blendMask again)
    // so that at least a layer shows up if everything's too low.
    weightedHeights0 = (weightedHeights0 + /*1e-4*/0.0001f) * splatControl0;
    weightedHeights1 = (weightedHeights1 + /*1e-4*/0.0001f) * splatControl1;

    // Normalize (and clamp to epsilon to keep from dividing by zero)
    float sumHeight = max(dot(weightedHeights0, half4(1, 1, 1, 1)) + dot(weightedHeights1, half4(1, 1, 1, 1)), /*1e-4*/0.00001f);
    //float sumHeight = max(dot(weightedHeights0, float4(1, 1, 1, 1)), /*1e-4*/0.00001f) + max(dot(weightedHeights1, float4(1, 1, 1, 1)), /*1e-4*/0.00001f);
    splatControl0 = weightedHeights0 / sumHeight.xxxx;
    splatControl1 = weightedHeights1 / sumHeight.xxxx;
}
#endif

void TerrainToMeshCalculateLayersBlend(float3 positionWS, float3 normalWS, float2 uv, out half3 albedoValue, out half alphaValue, out half3 normalValue, out half metallicValue, out half smoothnessValue, out half occlusionValue)
{
	//Splatmaps//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#ifdef KYEWORD_ENABLE_BIG_TEXTURE
	float2 newUV = float2(_T2M_SplatMapOffsetX + uv.x * 0.5, _T2M_SplatMapOffsetY + uv.y * 0.5);
#else
    float2 newUV = uv; //_T2M_SplatMapOffsetX
#endif

    #if ONLY_COLOR || ONLY_NORMAL
		newUV = float2(_T2M_SplatMapOffsetX, _T2M_SplatMapOffsetY)+ float2(uv.x * 0.5,  uv.y * 0.5)*_BakeScaleOffset.xy + _BakeScaleOffset.zw*0.5f;
		uv.xy = uv.xy*_BakeScaleOffset.xy + _BakeScaleOffset.zw;
    #endif

	float4 splatmap0 = T2M_UNPACK_SPLATMAP(newUV, 0);

	#if defined(NEED_SPLAT_MAP_1)
		float4 splatmap1 = T2M_UNPACK_SPLATMAP(newUV, 1);
	#else
		float4 splatmap1 = half4(0, 0, 0, 0);
    #endif

	#if defined(NEED_SPLAT_MAP_2)
		half4 splatmap2 = T2M_UNPACK_SPLATMAP(newUV, 2);
    #endif

	#if defined(NEED_SPLAT_MAP_3)
		half4 splatmap3 = T2M_UNPACK_SPLATMAP(newUV, 3);
	#endif
		                       

	//Paint Textures////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	half4 paintColorSum = 0;
	
	#if defined(_T2M_TEXTURE_SAMPLE_TYPE_ARRAY)
		int paintMapUsageIndex = 0;
	#endif

	half4 defualtColor = half4(0,0,0,1);
	half4 diffAlbedo0[4] = { defualtColor, defualtColor, defualtColor, defualtColor};
	half4 diffAlbedo1[4] = { defualtColor, defualtColor, defualtColor, defualtColor};
	
	T2M_UNPACK_PAINTMAP(uv, 0, diffAlbedo0[0], splatmap0.r, positionWS, normalWS);
    T2M_UNPACK_PAINTMAP(uv, 1, diffAlbedo0[1], splatmap0.g, positionWS, normalWS);

	#if defined(NEED_PAINT_MAP_2)
		T2M_UNPACK_PAINTMAP(uv, 2, diffAlbedo0[2], splatmap0.b, positionWS, normalWS);
	#endif

	#if defined(NEED_PAINT_MAP_3)
		T2M_UNPACK_PAINTMAP(uv, 3, diffAlbedo0[3], splatmap0.a, positionWS, normalWS);
	#endif

	#if defined(NEED_SPLAT_MAP_1)
		#if defined(NEED_PAINT_MAP_4)
			T2M_UNPACK_PAINTMAP(uv, 4, diffAlbedo1[0], splatmap1.r, positionWS, normalWS);
		#endif

		#if defined(NEED_PAINT_MAP_5)
			T2M_UNPACK_PAINTMAP(uv, 5, diffAlbedo1[1], splatmap1.g, positionWS, normalWS);
		#endif

		#if defined(NEED_PAINT_MAP_6)
			T2M_UNPACK_PAINTMAP(uv, 6, diffAlbedo1[2], splatmap1.b, positionWS, normalWS);
		#endif

		#if defined(NEED_PAINT_MAP_7)
			T2M_UNPACK_PAINTMAP(uv, 7, diffAlbedo1[3], splatmap1.a, positionWS, normalWS);
		#endif
	#endif

#ifdef _TERRAIN_BLEND_HEIGHT
    HeightBasedSplatModify(splatmap0, splatmap1, diffAlbedo0, diffAlbedo1);
#endif
	
    paintColorSum = 0.0h;

    paintColorSum += diffAlbedo0[0] * half4(_T2M_Layer_0_ColorTint.rgb * splatmap0.rrr, 1.0h);
	paintColorSum += diffAlbedo0[1] * half4(_T2M_Layer_1_ColorTint.rgb * splatmap0.ggg, 1.0h);
    paintColorSum += diffAlbedo0[2] * half4(_T2M_Layer_2_ColorTint.rgb * splatmap0.bbb, 1.0h);
    paintColorSum += diffAlbedo0[3] * half4(_T2M_Layer_3_ColorTint.rgb * splatmap0.aaa, 1.0h);
	
	paintColorSum += diffAlbedo1[0] * half4(_T2M_Layer_4_ColorTint.rgb * splatmap1.rrr, 1.0h);
    paintColorSum += diffAlbedo1[1] * half4(_T2M_Layer_5_ColorTint.rgb * splatmap1.ggg, 1.0h);
    paintColorSum += diffAlbedo1[2] * half4(_T2M_Layer_6_ColorTint.rgb * splatmap1.bbb, 1.0h);
    paintColorSum += diffAlbedo1[3] * half4(_T2M_Layer_7_ColorTint.rgb * splatmap1.aaa, 1.0h);

	albedoValue = paintColorSum.rgb;

	alphaValue = 1.0f;

	//Normal//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	#ifdef TERRAIN_TO_MESH_NEED_NORMAL //&& defined(RENDER_LEVEL_1)

	//if (_DisableTerrainNormal < 0.5)
	{
			half3 emptyNormal = half3(0, 0, 1);
			normalValue = 0;

	#if defined(_T2M_TEXTURE_SAMPLE_TYPE_ARRAY)
			int normalMapUsageIndex = 0;
	#endif


	#if defined(_T2M_LAYER_0_NORMAL)
			T2M_UNPACK_NORMAL_MAP(0, uv, normalValue, splatmap0.r, positionWS, normalWS);
	#else 
			normalValue += splatmap0.r * emptyNormal;
	#endif

	#if defined(_T2M_LAYER_1_NORMAL)
			T2M_UNPACK_NORMAL_MAP(1, uv, normalValue, splatmap0.g, positionWS, normalWS);
	#else 
			normalValue += splatmap0.g * emptyNormal;
	#endif

	#ifdef NEED_PAINT_MAP_2
	#if defined(_T2M_LAYER_2_NORMAL)
			T2M_UNPACK_NORMAL_MAP(2, uv, normalValue, splatmap0.b, positionWS, normalWS);
	#else 
			normalValue += splatmap0.b * emptyNormal;
	#endif
	#endif

	#ifdef NEED_PAINT_MAP_3
	#if defined(_T2M_LAYER_3_NORMAL)
			T2M_UNPACK_NORMAL_MAP(3, uv, normalValue, splatmap0.a, positionWS, normalWS);
	#else 
			normalValue += splatmap0.a * emptyNormal;
	#endif
	#endif

	#if defined(NEED_SPLAT_MAP_1)
	#ifdef NEED_PAINT_MAP_4
	#if defined(_T2M_LAYER_4_NORMAL)
			T2M_UNPACK_NORMAL_MAP(4, uv, normalValue, splatmap1.r, positionWS, normalWS);
	#else 
			normalValue += splatmap1.r * emptyNormal;
	#endif
	#endif

	#ifdef NEED_PAINT_MAP_5
	#if defined(_T2M_LAYER_5_NORMAL)
			T2M_UNPACK_NORMAL_MAP(5, uv, normalValue, splatmap1.g, positionWS, normalWS);
	#else 
			normalValue += splatmap1.g * emptyNormal;
	#endif
	#endif

	#ifdef NEED_PAINT_MAP_6
	#if defined(_T2M_LAYER_6_NORMAL)
			T2M_UNPACK_NORMAL_MAP(6, uv, normalValue, splatmap1.b, positionWS, normalWS);
	#else 
			normalValue += splatmap1.b * emptyNormal;
	#endif
	#endif

	#ifdef NEED_PAINT_MAP_7
	#if defined(_T2M_LAYER_7_NORMAL)
			T2M_UNPACK_NORMAL_MAP(7, uv, normalValue, splatmap1.a, positionWS, normalWS);
	#else 
			normalValue += splatmap1.a * emptyNormal;
	#endif
	#endif
	#endif

/*
	#if defined(NEED_SPLAT_MAP_2)
	#ifdef NEED_PAINT_MAP_8
	//#if defined(_T2M_LAYER_8_NORMAL)
	//		T2M_UNPACK_NORMAL_MAP(8, uv, normalValue, splatmap2.r);
	//#else 
	//		normalValue += splatmap2.r * emptyNormal;
	//#endif
	#endif

	#ifdef NEED_PAINT_MAP_9
	#if defined(_T2M_LAYER_9_NORMAL)
			T2M_UNPACK_NORMAL_MAP(9, uv, normalValue, splatmap2.g);
	#else 
			normalValue += splatmap2.g * emptyNormal;
	#endif
	#endif

	#ifdef NEED_PAINT_MAP_10
	#if defined(_T2M_LAYER_10_NORMAL)
			T2M_UNPACK_NORMAL_MAP(10, uv, normalValue, splatmap2.b);
	#else 
			normalValue += splatmap2.b * emptyNormal;
	#endif
	#endif

	#ifdef NEED_PAINT_MAP_11
	#if defined(_T2M_LAYER_11_NORMAL)
			T2M_UNPACK_NORMAL_MAP(11, uv, normalValue, splatmap2.a);
	#else 
			normalValue += splatmap2.a * emptyNormal;
	#endif
	#endif
	#endif

	#if defined(NEED_SPLAT_MAP_3)
	#ifdef NEED_PAINT_MAP_12
	#if defined(_T2M_LAYER_12_NORMAL)
			T2M_UNPACK_NORMAL_MAP(12, uv, normalValue, splatmap3.r);
	#else 
			normalValue += splatmap3.r * emptyNormal;
	#endif
	#endif

	#ifdef NEED_PAINT_MAP_13
	#if defined(_T2M_LAYER_13_NORMAL)
			T2M_UNPACK_NORMAL_MAP(13, uv, normalValue, splatmap3.g);
	#else 
			normalValue += splatmap3.g * emptyNormal;
	#endif
	#endif

	#ifdef NEED_PAINT_MAP_14
	#if defined(_T2M_LAYER_14_NORMAL)
			T2M_UNPACK_NORMAL_MAP(14, uv, normalValue, splatmap3.b);
	#else 
			normalValue += splatmap3.b * emptyNormal;
	#endif
	#endif

	#ifdef NEED_PAINT_MAP_15
	#if defined(_T2M_LAYER_15_NORMAL)
			T2M_UNPACK_NORMAL_MAP(15, uv, normalValue, splatmap3.a);
	#else 
			normalValue += splatmap3.a * emptyNormal;
	#endif
	#endif
	#endif

	*/
	}
	//else
	//{
	//	normalValue = half3(0, 0, 1);
	//}

	#else

		normalValue = half3(0, 0, 1);

	#endif

	//Metallic, Occlusion, Smoothness////////////////////////////////////////////////////////////////////////////////////////////////////////
	#ifdef TERRAIN_TO_MESH_NEED_METALLIC_SMOOTHNESS_OCCLUSION

		half4 metallicSmoothnessOcclusion = 0;

		#if defined(_T2M_TEXTURE_SAMPLE_TYPE_ARRAY)
			int maskMapUsageIndex = 0;
		#endif


/*		#if defined(_T2M_LAYER_0_MASK)
			T2M_UNPACK_MASK(0, uv, metallicSmoothnessOcclusion, splatmap0.r);
		#else		*/	
			T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(0, metallicSmoothnessOcclusion, splatmap0.r);
		//#endif

		//#if defined(_T2M_LAYER_1_MASK)
		//	T2M_UNPACK_MASK(1, uv, metallicSmoothnessOcclusion, splatmap0.g);
		//#else
			T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(1, metallicSmoothnessOcclusion, splatmap0.g);
		//#endif

		#if defined(NEED_PAINT_MAP_2)
			//#if defined(_T2M_LAYER_2_MASK)
			//	T2M_UNPACK_MASK(2, uv, metallicSmoothnessOcclusion, splatmap0.b);
			//#else
				T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(2, metallicSmoothnessOcclusion, splatmap0.b);
			//#endif
		#endif

		#if defined(NEED_PAINT_MAP_3)
			//#if defined(_T2M_LAYER_3_MASK)
			//	T2M_UNPACK_MASK(3, uv, metallicSmoothnessOcclusion, splatmap0.a);
			//#else
				T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(3, metallicSmoothnessOcclusion, splatmap0.a);
			//#endif
		#endif


		#if defined(NEED_SPLAT_MAP_1)
			#if defined(NEED_PAINT_MAP_4)
				//#if defined(_T2M_LAYER_4_MASK)
				//	T2M_UNPACK_MASK(4, uv, metallicSmoothnessOcclusion, splatmap1.r);
				//#else
					T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(4, metallicSmoothnessOcclusion, splatmap1.r);
				//#endif
			#endif

			#if defined(NEED_PAINT_MAP_5)
				//#if defined(_T2M_LAYER_5_MASK)
				//	T2M_UNPACK_MASK(5, uv, metallicSmoothnessOcclusion, splatmap1.g);
				//#else
					T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(5, metallicSmoothnessOcclusion, splatmap1.g);
				//#endif
			#endif

			#if defined(NEED_PAINT_MAP_6)
				//#if defined(_T2M_LAYER_6_MASK)
				//	T2M_UNPACK_MASK(6, uv, metallicSmoothnessOcclusion, splatmap1.b);
				//#else
					T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(6, metallicSmoothnessOcclusion, splatmap1.b);
				//#endif
			#endif

			#if defined(NEED_PAINT_MAP_7)
				//#if defined(_T2M_LAYER_7_MASK)
				//	T2M_UNPACK_MASK(7, uv, metallicSmoothnessOcclusion, splatmap1.a);
				//#else
					T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(7, metallicSmoothnessOcclusion, splatmap1.a);
				//#endif
			#endif
		#endif

		#if defined(NEED_SPLAT_MAP_2)
			#if defined(NEED_PAINT_MAP_8)
				//#if defined(_T2M_LAYER_8_MASK)
				//	T2M_UNPACK_MASK(8, uv, metallicSmoothnessOcclusion, splatmap2.r);
				//#else
					T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(8, metallicSmoothnessOcclusion, splatmap2.r);
				//#endif
			#endif

			#if defined(NEED_PAINT_MAP_9)
				//#if defined(_T2M_LAYER_9_MASK)
				//	T2M_UNPACK_MASK(9, uv, metallicSmoothnessOcclusion, splatmap2.g);
				//#else
					T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(9, metallicSmoothnessOcclusion, splatmap2.g);
				//#endif
			#endif

			#if defined(NEED_PAINT_MAP_10)
				//#if defined(_T2M_LAYER_10_MASK)
				//	T2M_UNPACK_MASK(10, uv, metallicSmoothnessOcclusion, splatmap2.b);
				//#else
					T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(10, metallicSmoothnessOcclusion, splatmap2.b);
				//#endif
			#endif

			#if defined(NEED_PAINT_MAP_11)
				//#if defined(_T2M_LAYER_11_MASK)
				//	T2M_UNPACK_MASK(11, uv, metallicSmoothnessOcclusion, splatmap2.a);
				//#else
					T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(11, metallicSmoothnessOcclusion, splatmap2.a);
			//	#endif
			#endif
		#endif

		#if defined(NEED_SPLAT_MAP_3)
			#if defined(NEED_PAINT_MAP_12)
				//#if defined(_T2M_LAYER_12_MASK)
				//	T2M_UNPACK_MASK(12, uv, metallicSmoothnessOcclusion, splatmap3.r);
				//#else
					T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(12, metallicSmoothnessOcclusion, splatmap3.r);
				//#endif
			#endif

			#if defined(NEED_PAINT_MAP_13)
				//#if defined(_T2M_LAYER_13_MASK)
				//	T2M_UNPACK_MASK(13, uv, metallicSmoothnessOcclusion, splatmap3.g);
				//#else
					T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(13, metallicSmoothnessOcclusion, splatmap3.g);
				//#endif
			#endif

			#if defined(NEED_PAINT_MAP_14)
				//#if defined(_T2M_LAYER_14_MASK)
				//	T2M_UNPACK_MASK(14, uv, metallicSmoothnessOcclusion, splatmap3.b);
				//#else
					T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(14, metallicSmoothnessOcclusion, splatmap3.b);
				//#endif
			#endif

			#if defined(NEED_PAINT_MAP_15)
				//#if defined(_T2M_LAYER_15_MASK)
				//	T2M_UNPACK_MASK(15, uv, metallicSmoothnessOcclusion, splatmap3.a);
				//#else
					T2M_UNPACK_METALLIC_OCCLUSION_SMOOTHNESS(15, metallicSmoothnessOcclusion, splatmap3.a);
				//#endif
			#endif
		#endif


		//metallicSmoothnessOcclusion.r = 0.1f;//pow(metallicSmoothnessOcclusion.r,2.4f);
		metallicSmoothnessOcclusion = saturate(metallicSmoothnessOcclusion);

		metallicValue  = pow(metallicSmoothnessOcclusion.r,2.4f);
		smoothnessValue = metallicSmoothnessOcclusion.a;
		occlusionValue = metallicSmoothnessOcclusion.g;

	#else

		metallicValue = 0;
		smoothnessValue = 0;
		occlusionValue = 1;

	#endif
}

#endif
 