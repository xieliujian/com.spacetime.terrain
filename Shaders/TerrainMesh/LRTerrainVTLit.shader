Shader "LingRen/Scene/TerrainMesh/TerrainVTLit" 
{
	Properties{
		_BaseMap("_BaseMap", 2D) = "grey" {}
		_Normal("Normal", 2D) = "grey" {}
		_EnableNormal("_EnableNormal", Float) = 1

		_SnowIntensity("Snow Intensity", Range(0.0, 1)) = 0.7
        _SnowLumIntensity("Snow Lum Intensity", Range(0.0, 1)) = 0.7
        _SnowLumRemap("Snow Lum Remap)", Vector) = (0.1,0.8,0,0)       
        _SnowProjYIntensity("Snow ProjY Intensity", Range(0.0, 1)) = 1
        _SnowProjYRemap("Snow ProjY Remap)", Vector) = (0.5,1,0,0)       

        _SnowGlitterIntensity("Snow Glitter Intensity", Range(0.0, 1)) = 0.7
        _SnowUseAtmoGlobals("_SnowUseAtmoGlobals", Float) = 1

        _WetnessIntensity("_WetnessIntensity", Range(0.0, 1)) = 1
        //_WetnessSmoothness("_WetnessSmoothness", Range(0.0, 1)) = 0.2
        //_WetnessContrast("_WetnessContrast", Range(0.0, 1)) = 0.25
        _WetnessWaterIntensity("Wetness Water Intensity", Range(0.0, 1)) = 0.0
        [HDR]_WetnessWaterColor("WetnessWaterColor", Color) = (0.54,0.70,0.61,1)
        _WetnessBlendRemap("BlendRemap", Vector) = (0.1,0.2,0,0)

        _WetnessDropsIntensity("Wetness Drops Intensity", Range(0.0, 1)) = 1
        _WetnessDropsNormal("DropsNormal", Range(0.0, 8)) = 4
//        _WetnessDropsTilling("DropsTilling", Range(0.0, 8)) = 0.25
        _WetnessDropsFade("DropsFade", Range(1.0, 40)) = 20
        _WetnessDropsProjRemap("DropsProjRemap", Vector) = (0.4,1,0,0)
        _WetnessUseAtmoGlobals("接受全局控制", Float) = 1
		_WetnessBlendSlope("混合倾斜度(类似Terrain处理)", Float) = 0


        _TintingIntensity("染色强度", Range(0.0, 1)) = 0.7
        _TintingGray("灰度", Range(0.0, 1)) = 0.7
        [HDR] _TintingColor("颜色", Color) = (1,1,1,1)
        _TintingLumIntensity("亮度Mask强度", Range(0.0, 1)) = 0.7
        _TintingLumRemap("        亮度Mask强度", Vector) = (0.1,0.8,0,0)       
        _TintingBlendRemap("        最终混合Remap", Vector) = (0.1,0.2,0,0)  

		_UseUnpackNormal("_UseUnpackNormal", float) = 0
		_NormalClose("_NormalClose", float) = 0


		[HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
		//_BaseMap("_Diffuse_ST", Vector) = (1, 1, 1, 1)
	} 


	SubShader
	{
		Tags { "Queue" = "Geometry" "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "IgnoreProjector" = "False"}

		//LOD 300

		Pass
		{
			Name "ForwardLit"
			Tags { "LightMode" = "UniversalForward" }

			HLSLPROGRAM

			// Required to compile gles 2.0 with standard srp library
			#pragma prefer_hlslcc gles
			#pragma exclude_renderers metal

			#pragma target 4.5

			#pragma vertex vert
			#pragma fragment frag			

			//#define LR_SHADER_RUNTIME 1
			
			// #pragma multi_compile _ TEST_PERF0
			// #pragma multi_compile _ TEST_PERF1
			// #pragma multi_compile _ TEST_PERF2

		#define _MAIN_LIGHT_SHADOWS 1        
        #if !defined (SHADER_API_MOBILE)
            #define LIGHT_SHADOW_NEW 1
            #define _MAIN_LIGHT_SHADOWS_CASCADE 1
        #else
			#if SHADER_API_GLES || SHADER_API_GLES3
                #define _SHADOWS_SOFT_LOW 1
            #else
                #define _SHADOWS_SOFT_MEDIUM 1
            #endif
        #endif
			
			#if SHADER_API_GLES || SHADER_API_GLES3
				#define GLOBAL_LOWMODE 1
			#endif

	#if defined(LR_SHADER_RUNTIME)
			#define DIRLIGHTMAP_COMBINED 1
			#define LIGHTMAP_ON 1
				//#define LIGHTMAP_SHADOW_MIXING 1
		   // #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#define SHADOWS_SHADOWMASK 1
			//#define RENDER_LEVEL_1 1
			//#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#define _ADDITIONAL_LIGHTS 1
			#define _SHADOWS_SOFT 1

			//#pragma multi_compile _ _SHADOWS_SOFT
			//#pragma multi_compile_fragment _ VT_RUNTIME

			//#pragma multi_compile _ _ADDITIONAL_LIGHTS
			#define _FORWARD_PLUS 1
        #if !defined (SHADER_API_MOBILE)
            #define _ADDITIONAL_LIGHT_SHADOWS 1
            #define ADDITIONAL_LIGHT_CALCULATE_SHADOWS 1
        #endif    
	#else
		   // #define RENDER_LEVEL_1 1
			//#pragma multi_compile_fragment _ VT_RUNTIME
			#pragma shader_feature _ONLY_COLOR
			#pragma shader_feature _ONLY_GI
			#pragma shader_feature _ONLY_SM

			#pragma multi_compile _ DIRLIGHTMAP_COMBINED
			#pragma multi_compile _ LIGHTMAP_ON
			#pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
			#pragma multi_compile _ SHADOWS_SHADOWMASK

			//#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
			#pragma multi_compile _ _ADDITIONAL_LIGHTS
			#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
			#pragma multi_compile_fragment _ _SHADOWS_SOFT
			#pragma multi_compile _ _FORWARD_PLUS
	#endif
			
			//#pragma multi_compile _ USE_NORMAL_UNPACK
            //#pragma multi_compile _ _RENDER_PASS_ENABLED
        //#pragma multi_compile _ _SOLIDCOLORTEST
            
			//#pragma multi_compile _ _RENDER_PASS_ENABLED

			//#pragma multi_compile _ VT_NORMALMAP
			
			//#pragma multi_compile _ _USE_BLINNPHONG
			// #pragma multi_compile _ TEST_PERF0
			// #pragma multi_compile _ TEST_PERF1
//			#pragma multi_compile _ TEST_PERF2
			//#pragma multi_compile _ _SHADOWS_SOFT
			#define _SHADOWS_SOFT 1
			//#define _NORMALMAP 1
			//#pragma shader_feature _NORMALMAP_CLOSE
			#define _NORMALMAP 1
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			//#include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"

			CBUFFER_START(UnityPerMaterial)
			float4 _BaseMap_ST;
			float _EnableNormal;
			float _UseUnpackNormal;
			float _NormalClose;
			// half _SnowLumIntensity;
			// half4 _SnowLumRemap;
			// half _SnowIntensity;
			// half _SnowProjYIntensity;
			// half4 _SnowProjYRemap;
			// half _SnowGlitterIntensity;
			#include "ext/Buffer.hlsl"
			CBUFFER_END
			//SAMPLER(sampler_LinearClamp);


			#include "TerrainShadowCommon.hlsl"
			#include "ext/CommonTonemapping.hlsl"
			#include "ext/CloudShadowCommon.hlsl"
			
			#include "ext/Common.hlsl"
			#include "ext/AdditionalDirectionLightShadowCommon.hlsl"
			

			//TEXTURE2D(_BaseMap);     SAMPLER(sampler_BaseMap);
			TEXTURE2D(_Normal);     SAMPLER(sampler_Normal);
			

			struct Attributes
			{
				float4 positionOS : POSITION;
				float3 normalOS : NORMAL;
				float4 texcoord0 : TEXCOORD0;
				float4 texcoord1 : TEXCOORD1;
			};

			struct Varyings
			{
				float4 uvMainAndLM              : TEXCOORD0; // xy: control, zw: lightmap

#if defined(_NORMALMAP)
				float4 normal                   : TEXCOORD1;    // xyz: normal, w: viewDir.x
				float4 tangent                  : TEXCOORD2;    // xyz: tangent, w: viewDir.y
				float4 bitangent                : TEXCOORD3;    // xyz: bitangent, w: viewDir.z
#else
				float3 normal                   : TEXCOORD1;
				float3 positionWS               : TEXCOORD2;
				half3 vertexSH                  : TEXCOORD3; // SH
#endif

				half4 fogFactorAndVertexLight   : TEXCOORD4; // x: fogFactor, yzw: vertex light
#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				float4 shadowCoord              : TEXCOORD6;
#endif
				float4 UVTest                   : TEXCOORD7;
				float4 clipPos                  : SV_POSITION;
			};
			Varyings vert(Attributes v)
			{
				Varyings o = (Varyings)0;
				
				VertexPositionInputs Attributes = GetVertexPositionInputs(v.positionOS.xyz);

				o.uvMainAndLM.xy =  TRANSFORM_TEX(v.texcoord0, _BaseMap);
				o.uvMainAndLM.zw = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
				o.UVTest = _BaseMap_ST;
#if defined(_NORMALMAP)
				float4 vertexTangent = float4(cross(float3(0, 0, 1), v.normalOS), 1.0);
				VertexNormalInputs normalInput = GetVertexNormalInputs(v.normalOS, vertexTangent);
				o.normal = half4(normalInput.normalWS, Attributes.positionWS.x);
				o.tangent = half4(normalInput.tangentWS, Attributes.positionWS.y);
				o.bitangent = half4(normalInput.bitangentWS, Attributes.positionWS.z);
#else
				o.normal = TransformObjectToWorldNormal(v.normalOS);
				o.positionWS = Attributes.positionWS;
				o.vertexSH = SampleSH(o.normal);
#endif
				o.fogFactorAndVertexLight.x = ComputeFogFactor(Attributes.positionCS.z);
				o.fogFactorAndVertexLight.yzw = VertexLighting(Attributes.positionWS, o.normal.xyz);
				o.clipPos = Attributes.positionCS;

#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				o.shadowCoord = GetShadowCoord(Attributes);
#endif
				return o;
			}

#if defined(SHADOWS_SHADOWMASK) && defined(LIGHTMAP_ON)
	#define SAMPLE_SHADOWMASK2(uv) SAMPLE_TEXTURE2D_LIGHTMAP(LIGHTMAP_INDIRECTION_NAME, LIGHTMAP_SAMPLER_NAME, uv SHADOWMASK_SAMPLE_EXTRA_ARGS);
#elif !defined (LIGHTMAP_ON)
	#define SAMPLE_SHADOWMASK2(uv) unity_ProbesOcclusion;
#else
	#define SAMPLE_SHADOWMASK2(uv) half4(1, 1, 1, 1);
#endif
			void InitializeInputData(Varyings IN, half3 normalTS, out InputData input)
			{
				input = (InputData)0;

				half3 SH = half3(0, 0, 0);

#if defined(_NORMALMAP)
				input.positionWS = float3(IN.normal.w, IN.tangent.w, IN.bitangent.w);
				input.normalWS = lerp(TransformTangentToWorld(normalTS, half3x3(-IN.tangent.xyz, IN.bitangent.xyz, IN.normal.xyz)), IN.normal, _NormalClose);

				SH = SampleSH(input.normalWS.xyz);
#else
				input.positionWS = IN.positionWS;
				input.normalWS = IN.normal;
				SH = IN.vertexSH;
#endif
				input.normalWS = SafeNormalize(input.normalWS);
				input.viewDirectionWS = SafeNormalize(GetCameraPositionWS() - input.positionWS);

#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
				input.shadowCoord = IN.shadowCoord;
				#if defined(MAIN_LIGHT_CALCULATE_SHADOWS)
				input.shadowCoord = TransformWorldToShadowCoord(input.positionWS);
				#endif
#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
				input.shadowCoord = TransformWorldToShadowCoord(input.positionWS);
#else
				input.shadowCoord = float4(0, 0, 0, 0);
#endif

				input.fogCoord = IN.fogFactorAndVertexLight.x;
				input.vertexLighting = IN.fogFactorAndVertexLight.yzw;
				
				//NOTE SAMPLE_GI 会调用SampleSHPixel函数，这个函数有问题，手机上使用的是EVALUATE_SH_MIXED宏
				//pc使用的是EVALUATE_SH_VERTEX
				//#if defined(LIGHTMAP_ON)
				input.bakedGI = SAMPLE_GI(IN.uvMainAndLM.zw, SH, input.normalWS);
				//#else
				//input.bakedGI = SH;
				//#endif
				input.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(IN.clipPos);
				half4 shadowmask = SAMPLE_SHADOWMASK2(IN.uvMainAndLM.zw);
				input.shadowMask = GetPrecomputedShadowMasks(half4(shadowmask.a, 1, 1, 1));
			}
			
			half3 LightingPhysicallyBased_Lit(BRDFData brdfData,
				half3 lightColor, half3 lightDirectionWS, half lightAttenuation,
				half3 normalWS, half3 viewDirectionWS)
			{

				half clamplightAttenuation = lightAttenuation;
				half NdotL = saturate(dot(normalWS, lightDirectionWS));
				clamplightAttenuation = clamp(clamplightAttenuation + _MainLightShaderParam.z, _MainLightShaderParam.x, 1);
				half3 radiance = lightColor * (clamplightAttenuation * NdotL); 
				half3 brdf = brdfData.diffuse;
			#ifndef _SPECULARHIGHLIGHTS_OFF
				{
					brdf += brdfData.specular * DirectBRDFSpecular(brdfData, normalWS, lightDirectionWS, viewDirectionWS);

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
			half4 UniversalFragmentPBR_VTTerrain(InputData inputData, SurfaceData surfaceData)
			{
			#ifdef _SPECULARHIGHLIGHTS_OFF
				bool specularHighlightsOff = true;
			#else
				bool specularHighlightsOff = false;
			#endif
				//return half4(1,1,1,1);
				BRDFData brdfData;

				UNITY_BRANCH 
				if (Global_Enable > 0.5)
				{
					float viewIntensity = 0;
					float metallic = 0;       
					
					half4 depthRGB = SAMPLE_TEXTURE2D(Global_RainSnowMask, sampler_LinearRepeat, (inputData.positionWS.xz + 512) / 1024.0f);
					half depthHeight = depthRGB.r * 255.0f * 255.0f + depthRGB.g * 255.0f;
					half OcclusionCulling1 = (1 - (Remap(depthHeight - (inputData.positionWS.y + 1.5), 0, 4) / 4.0f));
					half4 OcclusionCullingAndMask = half4((depthHeight - (inputData.positionWS.y + 1.5)),
							lerp(1, depthRGB.b, _WetnessBlendSlope), 0, 0);

					UNITY_BRANCH
					if (Global_EnableSnow)
					{
						//1.高度图
						Light mainLight = GetMainLight();
						// half dir = dot(inputData.normalWS, mainLight.direction);
						// if (dir > 0.0)
						// {
						// 	half3 bitangent = cross(inputData.normalWS.xyz, inputData.tangentWS.xyz) * inputData.tangentWS.w;
						// 	half3 viewDir = SafeNormalize(inputData.viewDirectionWS);
            
						// 	viewIntensity = pow(max(0, dot(reflect(-mainLight.direction, inputData.normalWS), viewDir)), Global_SnowShininess);
						// }

						surfaceData.albedo = CalcSnow(
							surfaceData.albedo,
							_SnowIntensity,
							_SnowLumIntensity,
							_SnowLumRemap,
							inputData.normalWS.y, _SnowProjYIntensity, _SnowProjYRemap,
							_SnowGlitterIntensity,
							inputData.positionWS, viewIntensity, 1.0f, metallic);    
					}
	
					    

					//颜色覆盖
					UNITY_BRANCH
					if (Global_EnablePaintTinting)
					{
						half gray = Luminance(surfaceData.albedo);
						half lum = gray * 5;
						surfaceData.albedo = SceneCalcTintingColor(inputData.positionWS, surfaceData.albedo, gray, lum, 1);
					}        

					UNITY_BRANCH
					if (Global_EnableRain)        
					{           
						#if SHADER_API_GLES || SHADER_API_GLES3
							half4 atmoParams = float4(0, 1, /*Global_AtmoParams.z*/0, 0);    
						#else
							half4 atmoParams = CalcAtmo(inputData.positionWS);
						#endif

						//half3 waveNormal = CalcWaveNormal(inputData.normalWS, inputData.tangentWS, inputData.positionWS);			

						half projYMask = Remap(clamp(saturate(inputData.normalWS.y), 0, 1), _SnowProjYRemap.x, _SnowProjYRemap.y);
						half wetnessProjYMask = Remap(clamp(saturate(inputData.normalWS.y), 0, 1), _WetnessDropsProjRemap.x, _WetnessDropsProjRemap.y);
						float WetnessHeight = surfaceData.smoothness;
						float WetnessValue = atmoParams.y * _WetnessIntensity;

						
						half4 temp_cast_10 = ((depthRGB.a + (-1.2 + (Global_SpreadDetailMap - 0.0) * (0.7 - -1.2) / (1.0 - 0.0)))).xxxx;
						half4 temp_output_35_0_g871 = CalculateContrast((Global_ContrastDetailMap + 1.0), temp_cast_10);
						half4 clampResult38_g871 = clamp(temp_output_35_0_g871, half4(0, 0, 0, 0), half4(1, 1, 1, 0));
						half Mask = (OcclusionCullingAndMask.g * clampResult38_g871.r) * (1 - saturate(OcclusionCullingAndMask.r));

						half WaterMask = Remap(clamp(WetnessValue * _WetnessWaterIntensity - WetnessHeight, 0, 1), _WetnessBlendRemap.x, _WetnessBlendRemap.y) * Mask.r; //积水 只有Mask区域积水
    
						//雨 wetness
						surfaceData.smoothness = lerp(surfaceData.smoothness, Global_WetnessMtlModify.x, WaterMask); // 反射增强
						surfaceData.specular.r = lerp(surfaceData.specular.r, Global_WetnessMtlModify.y, WaterMask); // 反射增强
    
						half3 WetColor0 = lerp(surfaceData.albedo, _WetnessWaterColor.rgb * surfaceData.albedo, WaterMask);
						half3 WetColor1 = lerp(WetColor0, WetColor0 * WetColor0, Global_WetnessMtlModify.z);
						half3 WetColor2 = lerp(surfaceData.albedo, WetColor1, WetnessValue);
						surfaceData.albedo = WetColor2.rgb;
						//计算雨点
						#if SHADER_API_GLES || SHADER_API_GLES3 //GLOBALE_TEXTURESIM
						#else
						half4 wetnessTex = CalcWetnessDrops(inputData.positionWS, Global_WetnessMtlModify.w);
						half4 rain_RingsNormal = half4(wetnessTex.xy, 2, -1);
						half4 rain_DropsNormal = half4(wetnessTex.zw, 2, -1);
						half distMinus = 1 - saturate(distance(_WorldSpaceCameraPos, inputData.positionWS) / _WetnessDropsFade);
						half2 WetnessNormal = lerp((rain_RingsNormal * 2 - 1), ( rain_DropsNormal * 2 - 1), 
						1 - WaterMask) * _WetnessDropsIntensity * _WetnessDropsNormal * WetnessValue * wetnessProjYMask * distMinus;
          
						inputData.normalWS = lerp(inputData.normalWS, half3(WetnessNormal.x, 0, WetnessNormal.y), WaterMask);
						inputData.normalWS = normalize(inputData.normalWS);
						#endif
					//计算雨点结束
					}
				}

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

				#if  defined(_ADDITIONAL_LIGHTS)
					#if USE_FORWARD_PLUS
					UNITY_BRANCH
					if( URP_FP_POINTLIGHT_COUNT )
					#endif
					{
						uint meshRenderingLayers = GetMeshRenderingLayer();
						uint pixelLightCount = GetAdditionalLightsCount();
					// //正常灯光循环
						LIGHT_LOOP_BEGIN(pixelLightCount)
						Light light = GetAdditionalLight(lightIndex, inputData.positionWS, shadowMask);
						if (IsMatchingLightLayer(light.layerMask, meshRenderingLayers))
						{
							color += LightingPhysicallyBased_Lit(brdfData,
															light,
															inputData.normalWS, inputData.viewDirectionWS);
						}
						LIGHT_LOOP_END
					}			
					
				#endif

				return half4(color, surfaceData.alpha);
			}

			half4 UniversalFragmentPBR_VTTerrain(InputData inputData, half3 albedo, half metallic, half3 specular,
				half smoothness, half occlusion, half3 emission, half alpha)
			{
				SurfaceData s;
				s.albedo              = albedo;
				s.metallic            = metallic;
				s.specular            = specular;
				s.smoothness          = smoothness;
				s.occlusion           = occlusion;
				s.emission            = emission;
				s.alpha               = alpha;
				s.clearCoatMask       = 0.0;
				s.clearCoatSmoothness = 1.0;
				return UniversalFragmentPBR_VTTerrain(inputData, s);
			}

			// Used in Standard Terrain shader
			half4 frag(Varyings IN) : SV_TARGET
			{
			// #if defined(_SOLIDCOLORTEST)
			// 	return half4(0,0,1,1);
			// #endif

				//return half4(IN.UVTest.yyy, 1.0h);
				half4 mixedDiffuse = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uvMainAndLM.xy);
				half4 mixedNormal = SAMPLE_TEXTURE2D(_Normal, sampler_Normal, IN.uvMainAndLM.xy);
				if(_UseUnpackNormal > 0.5)
				{
					#if BUMP_SCALE_NOT_SUPPORTED
						mixedNormal.rgb = UnpackNormal(mixedNormal.rgb);
					#else
						mixedNormal.rgb = UnpackNormalScale(mixedNormal, 1);
					#endif
				}

				half3 normalTS = half3(0,0,1);
				normalTS.xyz = lerp(normalTS, mixedNormal.xyz, 1);// * 2 - 1;
				//normalTS.z = sqrt(1 - normalTS.x * normalTS.x - normalTS.y * normalTS.y);
				half3 albedo = mixedDiffuse.rgb;

				half smoothness = 0;//mixedDiffuse.a;
				half metallic = 0;
				half occlusion = 1;
				half alpha = 1.0;

				InputData inputData;
				InitializeInputData(IN, normalTS, inputData);

				half4 color = UniversalFragmentPBR_VTTerrain(inputData, albedo, metallic, /* specular */ 
					half3(0.0h, 0.0h, 0.0h), smoothness, occlusion, /* emission */ half3(0, 0, 0), alpha);

				color.rgb = MixFog(color.rgb, inputData.fogCoord);
				color.rgb = TonemppingColor(color.rgb);

				return half4(color.rgb, 1.0h);				
			}

			ENDHLSL
		}

		Pass
        {
            Name "DepthOnly"
            Tags{"LightMode" = "DepthOnly"}

            ZWrite On
            ColorMask 0

            HLSLPROGRAM
            #pragma exclude_renderers glcore metal
            #pragma target 4.5

            #pragma vertex DepthOnlyVertex
            #pragma fragment DepthOnlyFragment
			
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            // -------------------------------------
            // Material Keywords
            //#pragma shader_feature_local_fragment _ALPHATEST_ON

            //--------------------------------------
            // GPU Instancing
            //#pragma multi_compile_instancing
            //#pragma multi_compile _ DOTS_INSTANCING_ON

			CBUFFER_START(UnityPerMaterial)
			float4 _BaseMap_ST;
			float _EnableNormal;
			
			#include "ext/Buffer.hlsl"
			CBUFFER_END

            struct Attributes
			{
				float4 position     : POSITION;
				float2 texcoord     : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct Varyings
			{
				float2 uv           : TEXCOORD0;
				float4 positionCS   : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			Varyings DepthOnlyVertex(Attributes input)
			{
				Varyings output = (Varyings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);
				output.positionCS = TransformObjectToHClip(input.position.xyz);
				return output;
			}

			half4 DepthOnlyFragment(Varyings input) : SV_TARGET
			{
				return 0;
			}

            ENDHLSL
        }

		Pass
		{
			Name "PreDepthOnly"
			Tags{"LightMode" = "PreDepthOnly"}

			ZWrite On
			ColorMask 0

			HLSLPROGRAM
			#pragma exclude_renderers glcore metal
			#pragma target 4.5

			#pragma vertex DepthOnlyVertex
			#pragma fragment DepthOnlyFragment

			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

			// -------------------------------------
			// Material Keywords
			//#pragma shader_feature_local_fragment _ALPHATEST_ON

			//--------------------------------------
			// GPU Instancing
			//#pragma multi_compile_instancing
			//#pragma multi_compile _ DOTS_INSTANCING_ON

			CBUFFER_START(UnityPerMaterial)
			float4 _BaseMap_ST;
			float _EnableNormal;
			#include "ext/Buffer.hlsl"
			CBUFFER_END

			struct Attributes
			{
				float4 position     : POSITION;
				float2 texcoord     : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct Varyings
			{
				float2 uv           : TEXCOORD0;
				float4 positionCS   : SV_POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			Varyings DepthOnlyVertex(Attributes input)
			{
				Varyings output = (Varyings)0;
				UNITY_SETUP_INSTANCE_ID(input);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

				output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);
				output.positionCS = TransformObjectToHClip(input.position.xyz);
				return output;
			}

			half4 DepthOnlyFragment(Varyings input) : SV_TARGET
			{
				return 0;
			}

			ENDHLSL
		}
	}

	Fallback "Hidden/Universal Render Pipeline/FallbackError"
}