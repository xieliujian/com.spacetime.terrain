Shader "SpaceTime/Scene/TerrainMesh/Splatmap"
{
    Properties
    {
        //[HideInInspector][CurvedWorldBendSettings] _CurvedWorldBendSettings("0|1|1", Vector) = (0, 0, 0, 0)
        //Terrain To Mesh Properties/////////////////////////////////////////////////////////////////////////////////////////////////////////
        [HideInInspector] [TerrainToMeshLayerCounter] _T2M_Layer_Count ("Layer Count", float) = 0		

        [Space]
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_SplatMap_0 ("Splat Map #0 (RGBA)", 2D) = "black" {}
        [HideInInspector] _BakeScaleOffset("_BakeScaleOffset", Vector) = (1, 1, 0, 0)

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
        _WetnessUseAtmoGlobals("����ȫ�ֿ���", Float) = 1

        _TintingIntensity("Ⱦɫǿ��", Range(0.0, 1)) = 0.7
        _TintingGray("�Ҷ�", Range(0.0, 1)) = 0.7
        [HDR] _TintingColor("��ɫ", Color) = (1,1,1,1)
        _TintingLumIntensity("����Maskǿ��", Range(0.0, 1)) = 0.7
        _TintingLumRemap("        ����Maskǿ��", Vector) = (0.1,0.8,0,0)       
        _TintingBlendRemap("        ���ջ��Remap", Vector) = (0.1,0.2,0,0)  

        [HideInInspector] _T2M_SplatMapOffsetX("MyOffsetX", float) = 0
        [HideInInspector] _T2M_SplatMapOffsetY("MyOffsetY", float) = 0
        [HideInInspector] _Enable_BigTexture_Feature("Enable Big Texture", Float) = 0.0
        [HideInInspector] _T2M_Layer_0_ColorTint ("Color Tint", Color) = (1, 1, 1, 1)
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_0_Diffuse ("Paint Map 1 (R)", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_0_NormalScale("Strength", float) = 1
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_0_NormalMap("Bump", 2D) = "bump" {}
        [HideInInspector] [NoScaleOffset] _T2M_Layer_0_Mask ("Mask", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_0_uvScaleOffset("UV Scale", Vector) = (1, 1, 0, 0)
        [HideInInspector] _T2M_Layer_0_MapsUsage("Maps Usage", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_0_MetallicOcclusionSmoothness("Metallic (R), Occlusion (G), Smoothness(A)", Vector) = (0, 1, 0, 0)
        [HideInInspector] _T2M_Layer_0_SmoothnessFromDiffuseAlpha("", float) = 0
        [HideInInspector] _T2M_Layer_0_MaskMapRemapMin("Maskmap Remap Min", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_0_MaskMapRemapMax("Maskmap Remap Max", Vector) = (1, 1, 1, 1)

        [HideInInspector] _T2M_Layer_1_ColorTint ("Color Tint", Color) = (1, 1, 1, 1)
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_1_Diffuse ("Paint Map 1 (R)", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_1_NormalScale("Strength", float) = 1
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_1_NormalMap("Bump", 2D) = "bump" {}
        [HideInInspector] [NoScaleOffset] _T2M_Layer_1_Mask ("Mask", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_1_uvScaleOffset("UV Scale", Vector) = (1, 1, 0, 0)
        [HideInInspector] _T2M_Layer_1_MapsUsage("Maps Usage", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_1_MetallicOcclusionSmoothness("Metallic (R), Occlusion (G), Smoothness(A)", Vector) = (0, 1, 0, 0)
        [HideInInspector] _T2M_Layer_1_SmoothnessFromDiffuseAlpha("", float) = 0
        [HideInInspector] _T2M_Layer_1_MaskMapRemapMin("Maskmap Remap Min", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_1_MaskMapRemapMax("Maskmap Remap Max", Vector) = (1, 1, 1, 1)

        [HideInInspector] _T2M_Layer_2_ColorTint ("Color Tint", Color) = (1, 1, 1, 1)
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_2_Diffuse ("Paint Map 2 (G)", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_2_NormalScale("Strength", float) = 1
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_2_NormalMap("Bump", 2D) = "bump" {}
        [HideInInspector] [NoScaleOffset] _T2M_Layer_2_Mask ("Mask", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_2_uvScaleOffset("UV Scale", Vector) = (1, 1, 0, 0)
        [HideInInspector] _T2M_Layer_2_MapsUsage("Maps Usage", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_2_MetallicOcclusionSmoothness("Metallic (R), Occlusion (G), Smoothness(A)", Vector) = (0, 1, 0, 0)
        [HideInInspector] _T2M_Layer_2_SmoothnessFromDiffuseAlpha("", float) = 0
        [HideInInspector] _T2M_Layer_2_MaskMapRemapMin("Maskmap Remap Min", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_2_MaskMapRemapMax("Maskmap Remap Max", Vector) = (1, 1, 1, 1)

        [HideInInspector] _T2M_Layer_3_ColorTint ("Color Tint", Color) = (1, 1, 1, 1)
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_3_Diffuse ("Paint Map 3 (B)", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_3_NormalScale("Strength", float) = 1
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_3_NormalMap("Bump", 2D) = "bump" {}
        [HideInInspector] [NoScaleOffset] _T2M_Layer_3_Mask ("Mask", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_3_uvScaleOffset("UV Scale", Vector) = (1, 1, 0, 0)
        [HideInInspector] _T2M_Layer_3_MapsUsage("Maps Usage", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_3_MetallicOcclusionSmoothness("Metallic (R), Occlusion (G), Smoothness(A)", Vector) = (0, 1, 0, 0)
        [HideInInspector] _T2M_Layer_3_SmoothnessFromDiffuseAlpha("", float) = 0
        [HideInInspector] _T2M_Layer_3_MaskMapRemapMin("Maskmap Remap Min", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_3_MaskMapRemapMax("Maskmap Remap Max", Vector) = (1, 1, 1, 1)


        /*[HideInInspector]*/ [NoScaleOffset] _T2M_SplatMap_1 ("Splat Map #1 (RGBA)", 2D) = "black" {}

        [HideInInspector] _T2M_Layer_4_ColorTint ("Color Tint", Color) = (1, 1, 1, 1)
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_4_Diffuse ("Paint Map 4 (A)", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_4_NormalScale("Strength", float) = 1
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_4_NormalMap("Bump", 2D) = "bump" {}
        [HideInInspector] [NoScaleOffset] _T2M_Layer_4_Mask ("Mask", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_4_uvScaleOffset("UV Scale", Vector) = (1, 1, 0, 0)
        [HideInInspector] _T2M_Layer_4_MapsUsage("Maps Usage", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_4_MetallicOcclusionSmoothness("Metallic (R), Occlusion (G), Smoothness(A)", Vector) = (0, 1, 0, 0)
        [HideInInspector] _T2M_Layer_4_SmoothnessFromDiffuseAlpha("", float) = 0
        [HideInInspector] _T2M_Layer_4_MaskMapRemapMin("Maskmap Remap Min", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_4_MaskMapRemapMax("Maskmap Remap Max", Vector) = (1, 1, 1, 1)

        [HideInInspector] _T2M_Layer_5_ColorTint ("Color Tint", Color) = (1, 1, 1, 1)
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_5_Diffuse ("Paint Map 5 (R)", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_5_NormalScale("Strength", float) = 1
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_5_NormalMap("Bump", 2D) = "bump" {}
        [HideInInspector] [NoScaleOffset] _T2M_Layer_5_Mask ("Mask", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_5_uvScaleOffset("UV Scale", Vector) = (1, 1, 0, 0)
        [HideInInspector] _T2M_Layer_5_MapsUsage("Maps Usage", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_5_MetallicOcclusionSmoothness("Metallic (R), Occlusion (G), Smoothness(A)", Vector) = (0, 1, 0, 0)
        [HideInInspector] _T2M_Layer_5_SmoothnessFromDiffuseAlpha("", float) = 0
        [HideInInspector] _T2M_Layer_5_MaskMapRemapMin("Maskmap Remap Min", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_5_MaskMapRemapMax("Maskmap Remap Max", Vector) = (1, 1, 1, 1)

        [HideInInspector] _T2M_Layer_6_ColorTint ("Color Tint", Color) = (1, 1, 1, 1)
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_6_Diffuse ("Paint Map 6 (G)", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_6_NormalScale("Strength", float) = 1
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_6_NormalMap("Bump", 2D) = "bump" {}
        [HideInInspector] [NoScaleOffset] _T2M_Layer_6_Mask ("Mask", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_6_uvScaleOffset("UV Scale", Vector) = (1, 1, 0, 0)
        [HideInInspector] _T2M_Layer_6_MapsUsage("Maps Usage", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_6_MetallicOcclusionSmoothness("Metallic (R), Occlusion (G), Smoothness(A)", Vector) = (0, 1, 0, 0)
        [HideInInspector] _T2M_Layer_6_SmoothnessFromDiffuseAlpha("", float) = 0
        [HideInInspector] _T2M_Layer_6_MaskMapRemapMin("Maskmap Remap Min", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_6_MaskMapRemapMax("Maskmap Remap Max", Vector) = (1, 1, 1, 1)

        [HideInInspector] _T2M_Layer_7_ColorTint ("Color Tint", Color) = (1, 1, 1, 1)
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_7_Diffuse ("Paint Map 7 (B)", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_7_NormalScale("Strength", float) = 1
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_7_NormalMap("Bump", 2D) = "bump" {}
        [HideInInspector] [NoScaleOffset] _T2M_Layer_7_Mask ("Mask", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_7_uvScaleOffset("UV Scale", Vector) = (1, 1, 0, 0)
        [HideInInspector] _T2M_Layer_7_MapsUsage("Maps Usage", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_7_MetallicOcclusionSmoothness("Metallic (R), Occlusion (G), Smoothness(A)", Vector) = (0, 1, 0, 0)
        [HideInInspector] _T2M_Layer_7_SmoothnessFromDiffuseAlpha("", float) = 0
        [HideInInspector] _T2M_Layer_7_MaskMapRemapMin("Maskmap Remap Min", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_7_MaskMapRemapMax("Maskmap Remap Max", Vector) = (1, 1, 1, 1)

        /*[HideInInspector]*/ [NoScaleOffset] _T2M_SplatMap_2 ("Splat Map #2 (RGBA)", 2D) = "black" {}
        /*[HideInInspector]*/[NoScaleOffset] _T2M_SplatMap_3("Splat Map #3 (RGBA)", 2D) = "black" {}

        [HideInInspector] _T2M_Layer_8_ColorTint ("Color Tint", Color) = (1, 1, 1, 1)
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_8_Diffuse ("Paint Map 8 (A)", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_8_NormalScale("Strength", float) = 1
        /*[HideInInspector]*/ [NoScaleOffset] _T2M_Layer_8_NormalMap("Bump", 2D) = "bump" {}
        [HideInInspector] [NoScaleOffset] _T2M_Layer_8_Mask ("Mask", 2D) = "white" {}
        [HideInInspector] _T2M_Layer_8_uvScaleOffset("UV Scale", Vector) = (1, 1, 0, 0)
        [HideInInspector] _T2M_Layer_8_MapsUsage("Maps Usage", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_8_MetallicOcclusionSmoothness("Metallic (R), Occlusion (G), Smoothness(A)", Vector) = (0, 1, 0, 0)
        [HideInInspector] _T2M_Layer_8_SmoothnessFromDiffuseAlpha("", float) = 0
        [HideInInspector] _T2M_Layer_8_MaskMapRemapMin("Maskmap Remap Min", Vector) = (0, 0, 0, 0)
        [HideInInspector] _T2M_Layer_8_MaskMapRemapMax("Maskmap Remap Max", Vector) = (1, 1, 1, 1)
			
        //Texture 2D Array
        [HideInInspector] [NoScaleOffset] _T2M_SplatMaps2DArray("SplatMaps 2D Array", 2DArray) = "black" {}
        [HideInInspector] [NoScaleOffset] _T2M_DiffuseMaps2DArray("DiffuseMaps 2D Array", 2DArray) = "white" {}
        [HideInInspector] [NoScaleOffset] _T2M_NormalMaps2DArray("NormalMaps 2D Array", 2DArray) = "bump" {}
        [HideInInspector] [NoScaleOffset] _T2M_MaskMaps2DArray("MaskMaps 2D Array", 2DArray) = "white" {}	 		 
		 
        //Holesmap
        [HideInInspector] [NoScaleOffset] _T2M_HolesMap ("Holes Map", 2D) = "white" {}

        //Fallback use only
        [HideInInspector] _Color("Color", Color) = (1, 1, 1, 1)								//Not used
        [HideInInspector] [NoScaleOffset] _BaseMap("Fallback Diffuse", 2D) = "white" {}		
        [HideInInspector] [NoScaleOffset] _BumpMap("Fallback Normal", 2D) = "bump" {}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}

        _Checker("Checker", 2D) = "white" {}

        [HideInInspector] _Layer0_Triplanar("Layer1 Triplanar", float) = 0.0
        [HideInInspector] _Layer1_Triplanar("Layer1 Triplanar", float) = 0.0
        [HideInInspector] _Layer2_Triplanar("Layer2 Triplanar", float) = 0.0
        [HideInInspector] _Layer3_Triplanar("Layer3 Triplanar", float) = 0.0
        [HideInInspector] _Layer4_Triplanar("Layer4 Triplanar", float) = 0.0
        [HideInInspector] _Layer5_Triplanar("Layer5 Triplanar", float) = 0.0
        [HideInInspector] _Layer6_Triplanar("Layer6 Triplanar", float) = 0.0
        [HideInInspector] _Layer7_Triplanar("Layer7 Triplanar", float) = 0.0

        [HideInInspector] _Layer0_TriplanarTileScale("Layer0 Triplanar TileScale", float) = 0.0
        [HideInInspector] _Layer1_TriplanarTileScale("Layer1 Triplanar TileScale", float) = 0.0
        [HideInInspector] _Layer2_TriplanarTileScale("Layer2 Triplanar TileScale", float) = 0.0
        [HideInInspector] _Layer3_TriplanarTileScale("Layer3 Triplanar TileScale", float) = 0.0
        [HideInInspector] _Layer4_TriplanarTileScale("Layer4 Triplanar TileScale", float) = 0.0
        [HideInInspector] _Layer5_TriplanarTileScale("Layer5 Triplanar TileScale", float) = 0.0
        [HideInInspector] _Layer6_TriplanarTileScale("Layer6 Triplanar TileScale", float) = 0.0
        [HideInInspector] _Layer7_TriplanarTileScale("Layer7 Triplanar TileScale", float) = 0.0

        [HideInInspector] _AtomColorRange0("_AtomColorRange0", float) = 1.0
        [HideInInspector] _AtomColorRange1("_AtomColorRange1", float) = 1.0
        [HideInInspector] _AtomColorRange2("_AtomColorRange2", float) = 1.0
        [HideInInspector] _AtomColorRange3("_AtomColorRange3", float) = 1.0
        [HideInInspector] _AtomColorRange4("_AtomColorRange4", float) = 1.0
        [HideInInspector] _AtomColorRange5("_AtomColorRange5", float) = 1.0
        [HideInInspector] _AtomColorRange6("_AtomColorRange6", float) = 1.0
        [HideInInspector] _AtomColorRange7("_AtomColorRange7", float) = 1.0

        _HeightTransition("Height Transition", Range(0.0005, 1.0)) = 0.0005

        [HideInInspector] _EnableUV2ForTriplanar("Enable UV2 For Triplanar", Float) = 0
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="Geometry"
        }

        //LOD 300

        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

            // Render State
            Cull Back
            Blend One Zero
            ZTest LEqual
            ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
        //big texture toggle 
        #define KYEWORD_ENABLE_BIG_TEXTURE 1

        #pragma vertex vert
        #pragma fragment frag
        
        //#define LR_SHADER_RUNTIME 1
        //#define LR_SHADER_HARMONY 1

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

        
#if defined(LR_SHADER_RUNTIME)
        #define DIRLIGHTMAP_COMBINED 1
        #define LIGHTMAP_ON 1
       // #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #define SHADOWS_SHADOWMASK 1
        //#define RENDER_LEVEL_1 1
        //#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        //#pragma multi_compile _ _ADDITIONAL_LIGHTS
        #define _SHADOWS_SOFT 1

        #pragma multi_compile_fragment _ VT_RUNTIME
        #define _FORWARD_PLUS 1
        #define _ADDITIONAL_LIGHTS 1
        #if !defined (SHADER_API_MOBILE)
            #define _ADDITIONAL_LIGHT_SHADOWS 1
            #define ADDITIONAL_LIGHT_CALCULATE_SHADOWS 1
        #endif    
#else
       // #define RENDER_LEVEL_1 1
        #pragma multi_compile_fragment _ VT_RUNTIME
        #pragma shader_feature _ONLY_COLOR
        #pragma shader_feature _ONLY_GI
        #pragma shader_feature _ONLY_SM

        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK

        //#pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHTS
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _SHADOWS_SOFT
        #pragma multi_compile _ _FORWARD_PLUS
#endif
    
            //#pragma multi_compile _ _RENDER_PASS_ENABLED
        //#pragma multi_compile _ _SOLIDCOLORTEST
            
            //#pragma multi_compile _ _GLOBAL_ENABLE
            #pragma shader_feature _TERRAIN_BLEND_HEIGHT
            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_FORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */
            #define  _LIGHTMAPON_ENVIRONMENTCOLOR_OFF 1
            #define _ENVIRONMENTREFLECTIONS_OFF 1
             #define _SPECULARHIGHLIGHTS_OFF 1
            // Includes
            
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
            {
                float3 positionOS : POSITION;
                half3 normalOS : NORMAL;
                half4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                float4 uv2 : TEXCOORD2;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                half3 normalWS;
                half4 tangentWS;
                float4 texCoord0;
                half3 viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                float2 lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                half3 sh;
                #endif
                half4 fogFactorAndVertexLight;
                half4 shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            struct SurfaceDescriptionInputs
            {
                half3 TangentSpaceNormal;
                float4 uv0;
            };
            struct VertexDescriptionInputs
            {
                half3 ObjectSpaceNormal;
                half3 ObjectSpaceTangent;
                half3 ObjectSpacePosition;
            };
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                float3 interp0 : TEXCOORD0;
                half3 interp1 : TEXCOORD1;
                half4 interp2 : TEXCOORD2;
                float4 interp3 : TEXCOORD3;
                half3 interp4 : TEXCOORD4;
                #if defined(LIGHTMAP_ON)
                float2 interp5 : TEXCOORD5;
                #endif
                #if !defined(LIGHTMAP_ON)
                half3 interp6 : TEXCOORD6;
                #endif
                half4 interp7 : TEXCOORD7;
                float4 interp8 : TEXCOORD8;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            PackedVaryings PackVaryings (Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp0.xyz =  input.positionWS;
                output.interp1.xyz =  input.normalWS;
                output.interp2.xyzw =  input.tangentWS;
                output.interp3.xyzw =  input.texCoord0;
                output.interp4.xyz =  input.viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                output.interp5.xy =  input.lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.interp6.xyz =  input.sh;
                #endif
                output.interp7.xyzw =  input.fogFactorAndVertexLight;
                output.interp8.xyzw =  input.shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            Varyings UnpackVaryings (PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp0.xyz;
                output.normalWS = input.interp1.xyz;
                output.tangentWS = input.interp2.xyzw;
                output.texCoord0 = input.interp3.xyzw;
                output.viewDirectionWS = input.interp4.xyz;
                #if defined(LIGHTMAP_ON)
                output.lightmapUV = input.interp5.xy;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.sh = input.interp6.xyz;
                #endif
                output.fogFactorAndVertexLight = input.interp7.xyzw;
                output.shadowCoord = input.interp8.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // --------------------------------------------------
            // Graph
            #pragma shader_feature_local_fragment _ _T2M_LAYER_COUNT_4 _T2M_LAYER_COUNT_8

            #if !defined(LR_SHADER_HARMONY)
            #pragma shader_feature_local_fragment _T2M_LAYER_0_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_1_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_2_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_3_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_4_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_5_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_6_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_7_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_8_NORMAL
            #endif


            #define TERRAIN_TO_MESH_NEED_NORMAL
            #define TERRAIN_TO_MESH_NEED_METALLIC_SMOOTHNESS_OCCLUSION

            #include "Splatmap.cginc"

                // Graph Vertex
            struct VertexDescription
            {
                float3 Position;
                float3 Normal;
                float3 Tangent;
            };

            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float3 _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0;
                half3 _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4;
                SHG_TerrainToMeshCurvedWorld_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, (half4(IN.ObjectSpaceTangent, 1.0)), _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0, _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4);
                description.Position = _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0;
                description.Normal = _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4;
                description.Tangent = IN.ObjectSpaceTangent;
                return description;
            }

            // Graph Pixel
            struct SurfaceDescription
            {
                half3 BaseColor;
                half3 NormalTS;
                half3 Emission;
                half Metallic;
                half Smoothness;
                half Occlusion;
            };

            SurfaceDescription SurfaceDescriptionFunction(Varyings unpacked, SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                half4 _UV_d56c6fdf7ac2828fa944da2372119006_Out_0 = IN.uv0;
                half3 _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_albedo_1;
                half _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_alpha_2;
                half3 _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_normal_3;
                half _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_metallic_4;
                half _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_smoothness_5;
                half _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_occlusion_6;
                SHG_TerrainToMeshCalculateLayersBlend_float(unpacked.positionWS, unpacked.normalWS, _UV_d56c6fdf7ac2828fa944da2372119006_Out_0, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_albedo_1, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_alpha_2, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_normal_3, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_metallic_4, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_smoothness_5, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_occlusion_6);
                surface.BaseColor = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_albedo_1;
                surface.NormalTS = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_normal_3;
                surface.Emission = half3(0, 0, 0);
                surface.Metallic = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_metallic_4;
                surface.Smoothness = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_smoothness_5;
                surface.Occlusion = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_occlusion_6;
                return surface;
            }

            SurfaceDescription BaseSurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;

                surface.BaseColor = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv0.xy).rgb;
                surface.NormalTS = half3(0, 0, 1);
                surface.Emission = half3(0, 0, 0);
                surface.Metallic = 0;
                surface.Smoothness = 0;
                surface.Occlusion = 1;
                
                return surface;
            }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                output.ObjectSpaceNormal =           input.normalOS;
                output.ObjectSpaceTangent =          input.tangentOS.xyz;
                output.ObjectSpacePosition =         input.positionOS;

                return output;
            }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                output.TangentSpaceNormal =          half3(0.0f, 0.0f, 1.0f);

                output.uv0 =                         input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                return output;
            }

                // --------------------------------------------------
                // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            #include "SplatmapVaryings.hlsl"
            #include "PBRForwardPass.hlsl"
            //#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
            ENDHLSL
        }
        Pass
        {
            Name "CustomRenderPass0" //Color Pass
            Tags
            {
                "LightMode" = "CustomRenderPass0"
            }

            // Render State
            Cull Back
            Blend One Zero
            ZTest LEqual
            ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
            //big texture toggle 
            #define KYEWORD_ENABLE_BIG_TEXTURE 1
            #pragma shader_feature _TERRAIN_BLEND_HEIGHT

            #pragma exclude_renderers metal

            #pragma vertex vert
            #pragma fragment frag


            #define ONLY_COLOR 1
//            #define ONLY_NORMAL 1

            // Defines
            #define _NORMALMAP 0
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_FORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
            {
                float3 positionOS : POSITION;
                half3 normalOS : NORMAL;
                half4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                half3 normalWS;
                half4 tangentWS;
                float4 texCoord0;
                half3 viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                float2 lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                half3 sh;
                #endif
                half4 fogFactorAndVertexLight;
                half4 shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            struct SurfaceDescriptionInputs
            {
                half3 TangentSpaceNormal;
                float4 uv0;
            };
            struct VertexDescriptionInputs
            {
                half3 ObjectSpaceNormal;
                half3 ObjectSpaceTangent;
                half3 ObjectSpacePosition;
            };
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                float3 interp0 : TEXCOORD0;
                half3 interp1 : TEXCOORD1;
                half4 interp2 : TEXCOORD2;
                float4 interp3 : TEXCOORD3;
                half3 interp4 : TEXCOORD4;
                #if defined(LIGHTMAP_ON)
                float2 interp5 : TEXCOORD5;
                #endif
                #if !defined(LIGHTMAP_ON)
                half3 interp6 : TEXCOORD6;
                #endif
                half4 interp7 : TEXCOORD7;
                float4 interp8 : TEXCOORD8;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            PackedVaryings PackVaryings (Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp0.xyz =  input.positionWS;
                output.interp1.xyz =  input.normalWS;
                output.interp2.xyzw =  input.tangentWS;
                output.interp3.xyzw =  input.texCoord0;
                output.interp4.xyz =  input.viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                output.interp5.xy =  input.lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.interp6.xyz =  input.sh;
                #endif
                output.interp7.xyzw =  input.fogFactorAndVertexLight;
                output.interp8.xyzw =  input.shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            Varyings UnpackVaryings (PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp0.xyz;
                output.normalWS = input.interp1.xyz;
                output.tangentWS = input.interp2.xyzw;
                output.texCoord0 = input.interp3.xyzw;
                output.viewDirectionWS = input.interp4.xyz;
                #if defined(LIGHTMAP_ON)
                output.lightmapUV = input.interp5.xy;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.sh = input.interp6.xyz;
                #endif
                output.fogFactorAndVertexLight = input.interp7.xyzw;
                output.shadowCoord = input.interp8.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }


            // --------------------------------------------------
            // Graph
            #pragma shader_feature_local_fragment _ _T2M_LAYER_COUNT_4 _T2M_LAYER_COUNT_8

            //#if !defined(LR_SHADER_HARMONY)
            //#pragma shader_feature_local_fragment _T2M_LAYER_0_NORMAL
            //#pragma shader_feature_local_fragment _T2M_LAYER_1_NORMAL
            //#pragma shader_feature_local_fragment _T2M_LAYER_2_NORMAL
            //#pragma shader_feature_local_fragment _T2M_LAYER_3_NORMAL
            //#pragma shader_feature_local_fragment _T2M_LAYER_4_NORMAL
            //#pragma shader_feature_local_fragment _T2M_LAYER_5_NORMAL
            //#pragma shader_feature_local_fragment _T2M_LAYER_6_NORMAL
            //#pragma shader_feature_local_fragment _T2M_LAYER_7_NORMAL
            //#pragma shader_feature_local_fragment _T2M_LAYER_8_NORMAL
            //#endif

            #define TERRAIN_TO_MESH_NEED_NORMAL
            #define TERRAIN_TO_MESH_NEED_METALLIC_SMOOTHNESS_OCCLUSION

            #include "Splatmap.cginc"

                // Graph Vertex
            struct VertexDescription
            {
                float3 Position;
                float3 Normal;
                float3 Tangent;
            };

            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float3 _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0;
                half3 _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4;
                SHG_TerrainToMeshCurvedWorld_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, (half4(IN.ObjectSpaceTangent, 1.0)), _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0, _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4);
                description.Position = _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0;
                description.Normal = _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4;
                description.Tangent = IN.ObjectSpaceTangent;
                return description;
            }

            // Graph Pixel
            struct SurfaceDescription
            {
                half3 BaseColor;
                half3 NormalTS;
                half3 Emission;
                half Metallic;
                half Smoothness;
                half Occlusion;
            };

            SurfaceDescription SurfaceDescriptionFunction(Varyings unpacked, SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                half4 _UV_d56c6fdf7ac2828fa944da2372119006_Out_0 = IN.uv0;
                half3 _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_albedo_1;
                half _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_alpha_2;
                half3 _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_normal_3;
                half _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_metallic_4;
                half _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_smoothness_5;
                half _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_occlusion_6;
                SHG_TerrainToMeshCalculateLayersBlend_float(unpacked.positionWS, unpacked.normalWS, _UV_d56c6fdf7ac2828fa944da2372119006_Out_0, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_albedo_1, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_alpha_2, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_normal_3, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_metallic_4, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_smoothness_5, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_occlusion_6);
                surface.BaseColor = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_albedo_1;
                surface.NormalTS = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_normal_3;
                surface.Emission = half3(0, 0, 0);
                surface.Metallic = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_metallic_4;
                surface.Smoothness = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_smoothness_5;
                surface.Occlusion = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_occlusion_6;
                return surface;
            }

            SurfaceDescription BaseSurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;

                surface.BaseColor = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv0.xy).rgb;
                surface.NormalTS = half3(0, 0, 1);
                surface.Emission = half3(0, 0, 0);
                surface.Metallic = 0;
                surface.Smoothness = 0;
                surface.Occlusion = 1;
                
                return surface;
            }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                output.ObjectSpaceNormal =           input.normalOS;
                output.ObjectSpaceTangent =          input.tangentOS.xyz;
                output.ObjectSpacePosition =         input.positionOS;

                return output;
            }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                output.TangentSpaceNormal =          half3(0.0f, 0.0f, 1.0f);

                output.uv0 =                         input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                return output;
            }

                // --------------------------------------------------
                // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            #include "SplatmapVaryings.hlsl"
            #include "PBRForwardPass.hlsl"
            //#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
            ENDHLSL
        }
        
        Pass
        {
            Name "CustomRenderPass1"//OnlyNormalPass
            Tags
            {
                "LightMode" = "CustomRenderPass1"
            }

            // Render State
            Cull Back
            Blend One Zero
            ZTest LEqual
            ZWrite On

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
            //big texture toggle 
            #define KYEWORD_ENABLE_BIG_TEXTURE 1
            #pragma shader_feature _TERRAIN_BLEND_HEIGHT

            

            #pragma exclude_renderers metal

            #pragma vertex vert
            #pragma fragment frag


            //#define ONLY_COLOR 1
            #define ONLY_NORMAL 1

            // Defines
            #define _NORMALMAP 0
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define ATTRIBUTES_NEED_TEXCOORD1
            #define VARYINGS_NEED_POSITION_WS
            #define VARYINGS_NEED_NORMAL_WS
            #define VARYINGS_NEED_TANGENT_WS
            #define VARYINGS_NEED_TEXCOORD0
            #define VARYINGS_NEED_VIEWDIRECTION_WS
            #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_FORWARD
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
            {
                float3 positionOS : POSITION;
                half3 normalOS : NORMAL;
                half4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                float4 uv1 : TEXCOORD1;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 positionWS;
                half3 normalWS;
                half4 tangentWS;
                float4 texCoord0;
                half3 viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                float2 lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                half3 sh;
                #endif
                half4 fogFactorAndVertexLight;
                half4 shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            struct SurfaceDescriptionInputs
            {
                half3 TangentSpaceNormal;
                float4 uv0;
            };
            struct VertexDescriptionInputs
            {
                half3 ObjectSpaceNormal;
                half3 ObjectSpaceTangent;
                half3 ObjectSpacePosition;
            };
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                float3 interp0 : TEXCOORD0;
                half3 interp1 : TEXCOORD1;
                half4 interp2 : TEXCOORD2;
                float4 interp3 : TEXCOORD3;
                half3 interp4 : TEXCOORD4;
                #if defined(LIGHTMAP_ON)
                float2 interp5 : TEXCOORD5;
                #endif
                #if !defined(LIGHTMAP_ON)
                half3 interp6 : TEXCOORD6;
                #endif
                half4 interp7 : TEXCOORD7;
                float4 interp8 : TEXCOORD8;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            PackedVaryings PackVaryings (Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                output.interp0.xyz =  input.positionWS;
                output.interp1.xyz =  input.normalWS;
                output.interp2.xyzw =  input.tangentWS;
                output.interp3.xyzw =  input.texCoord0;
                output.interp4.xyz =  input.viewDirectionWS;
                #if defined(LIGHTMAP_ON)
                output.interp5.xy =  input.lightmapUV;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.interp6.xyz =  input.sh;
                #endif
                output.interp7.xyzw =  input.fogFactorAndVertexLight;
                output.interp8.xyzw =  input.shadowCoord;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            Varyings UnpackVaryings (PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                output.positionWS = input.interp0.xyz;
                output.normalWS = input.interp1.xyz;
                output.tangentWS = input.interp2.xyzw;
                output.texCoord0 = input.interp3.xyzw;
                output.viewDirectionWS = input.interp4.xyz;
                #if defined(LIGHTMAP_ON)
                output.lightmapUV = input.interp5.xy;
                #endif
                #if !defined(LIGHTMAP_ON)
                output.sh = input.interp6.xyz;
                #endif
                output.fogFactorAndVertexLight = input.interp7.xyzw;
                output.shadowCoord = input.interp8.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // --------------------------------------------------
            // Graph

            #pragma shader_feature_local_fragment _ _T2M_LAYER_COUNT_4 _T2M_LAYER_COUNT_8

            //#if !defined(LR_SHADER_HARMONY)
            #pragma shader_feature_local_fragment _T2M_LAYER_0_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_1_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_2_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_3_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_4_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_5_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_6_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_7_NORMAL
            #pragma shader_feature_local_fragment _T2M_LAYER_8_NORMAL
            //#endif

            #define TERRAIN_TO_MESH_NEED_NORMAL
            #define TERRAIN_TO_MESH_NEED_METALLIC_SMOOTHNESS_OCCLUSION

            #include "Splatmap.cginc"

                // Graph Vertex
            struct VertexDescription
            {
                float3 Position;
                float3 Normal;
                float3 Tangent;
            };

            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float3 _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0;
                half3 _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4;
                SHG_TerrainToMeshCurvedWorld_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, (half4(IN.ObjectSpaceTangent, 1.0)), _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0, _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4);
                description.Position = _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0;
                description.Normal = _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4;
                description.Tangent = IN.ObjectSpaceTangent;
                return description;
            }

            // Graph Pixel
            struct SurfaceDescription
            {
                half3 BaseColor;
                half3 NormalTS;
                half3 Emission;
                half Metallic;
                half Smoothness;
                half Occlusion;
            };

            SurfaceDescription SurfaceDescriptionFunction(Varyings unpacked, SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                half4 _UV_d56c6fdf7ac2828fa944da2372119006_Out_0 = IN.uv0;
                half3 _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_albedo_1;
                half _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_alpha_2;
                half3 _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_normal_3;
                half _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_metallic_4;
                half _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_smoothness_5;
                half _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_occlusion_6;
                SHG_TerrainToMeshCalculateLayersBlend_float(unpacked.positionWS, unpacked.normalWS, _UV_d56c6fdf7ac2828fa944da2372119006_Out_0, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_albedo_1, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_alpha_2, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_normal_3, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_metallic_4, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_smoothness_5, _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_occlusion_6);
                surface.BaseColor = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_albedo_1;
                surface.NormalTS = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_normal_3;
                surface.Emission = half3(0, 0, 0);
                surface.Metallic = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_metallic_4;
                surface.Smoothness = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_smoothness_5;
                surface.Occlusion = _SHGTerrainToMeshCalculateLayersBlendCustomFunction_24112ec2b2aa8c829e8ab4bb7ea28f60_occlusion_6;
                return surface;
            }

            SurfaceDescription BaseSurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;

                surface.BaseColor = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, IN.uv0.xy).rgb;
                surface.NormalTS = half3(0, 0, 1);
                surface.Emission = half3(0, 0, 0);
                surface.Metallic = 0;
                surface.Smoothness = 0;
                surface.Occlusion = 1;
                
                return surface;
            }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                output.ObjectSpaceNormal =           input.normalOS;
                output.ObjectSpaceTangent =          input.tangentOS.xyz;
                output.ObjectSpacePosition =         input.positionOS;

                return output;
            }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
                output.TangentSpaceNormal =          half3(0.0f, 0.0f, 1.0f);

                output.uv0 =                         input.texCoord0;
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                return output;
            }

                // --------------------------------------------------
                // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            #include "SplatmapVaryings.hlsl"
            #include "PBRForwardPass.hlsl"
            //#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
            ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }

            // Render State
            Cull Back
            Blend One Zero
            ZTest LEqual
            ZWrite On
            ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
            //#pragma exclude_renderers gles gles3 glcore
            //#pragma multi_compile_instancing
            //#pragma multi_compile _ DOTS_INSTANCING_ON
            #pragma vertex vert
            #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_SHADOWCASTER
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
            {
                float3 positionOS : POSITION;
                half3 normalOS : NORMAL;
                half4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };
            struct SurfaceDescriptionInputs
            {
				float4 uv0;
            };
            struct VertexDescriptionInputs
            {
                half3 ObjectSpaceNormal;
                half3 ObjectSpaceTangent;
                half3 ObjectSpacePosition;
            };
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            PackedVaryings PackVaryings (Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            Varyings UnpackVaryings (PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // --------------------------------------------------
            // Graph
            #define TERRAIN_TO_MESH_NEED_NORMAL
            #define TERRAIN_TO_MESH_NEED_METALLIC_SMOOTHNESS_OCCLUSION

            #include "Splatmap.cginc"

            // Graph Vertex
            struct VertexDescription
            {
                float3 Position;
                half3 Normal;
                half3 Tangent;
            };

            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                half3 _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0;
                half3 _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4;
                SHG_TerrainToMeshCurvedWorld_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, (float4(IN.ObjectSpaceTangent, 1.0)), _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0, _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4);
                description.Position = _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0;
                description.Normal = _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4;
                description.Tangent = IN.ObjectSpaceTangent;
                return description;
            }

            // Graph Pixel
            struct SurfaceDescription
            {
            };

            SurfaceDescription SurfaceDescriptionFunction(Varyings unpacked, SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                return surface;
            }
            
            SurfaceDescription BaseSurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                return surface;
            }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                output.ObjectSpaceNormal =           input.normalOS;
                output.ObjectSpaceTangent =          input.tangentOS.xyz;
                output.ObjectSpacePosition =         input.positionOS;

                return output;
            }
            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
                #else
                #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
                #endif
                #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

                return output;
            }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            #include "SplatmapVaryings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"

            ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }

            // Render State
            Cull Back
            Blend One Zero
            ZTest LEqual
            ZWrite On
            ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass
            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
            #pragma exclude_renderers glcore
            //#pragma multi_compile_instancing
            //#pragma multi_compile _ DOTS_INSTANCING_ON
            #pragma vertex vert
            #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
            {
                float3 positionOS : POSITION;
                half3 normalOS : NORMAL;
                half4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            struct SurfaceDescriptionInputs
            {
				float4 uv0;
            };

            struct VertexDescriptionInputs
            {
                half3 ObjectSpaceNormal;
                half3 ObjectSpaceTangent;
                half3 ObjectSpacePosition;
            };
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            PackedVaryings PackVaryings (Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            Varyings UnpackVaryings (PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // --------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        #define TERRAIN_TO_MESH_NEED_NORMAL
        #define TERRAIN_TO_MESH_NEED_METALLIC_SMOOTHNESS_OCCLUSION


        #include "Splatmap.cginc"

            // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            half3 Normal;
            half3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float3 _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0;
            half3 _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4;
            SHG_TerrainToMeshCurvedWorld_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, (half4(IN.ObjectSpaceTangent, 1.0)), _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0, _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4);
            description.Position = _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0;
            description.Normal = _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
        };

        SurfaceDescription SurfaceDescriptionFunction(Varyings unpacked, SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }

        SurfaceDescription BaseSurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            #include "SplatmapVaryings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }

        Pass
        {
            Name "PreDepthOnly"
            Tags
            {
                "LightMode" = "PreDepthOnly"
            }

            // Render State
            Cull Back
            Blend One Zero
            ZTest LEqual
            ZWrite On
            ColorMask 0

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass
            HLSLPROGRAM

            // Pragmas
            #pragma target 4.5
            #pragma exclude_renderers glcore metal
            //#pragma multi_compile_instancing
            //#pragma multi_compile _ DOTS_INSTANCING_ON
            #pragma vertex vert
            #pragma fragment frag

            // DotsInstancingOptions: <None>
            // HybridV1InjectedBuiltinProperties: <None>

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _NORMALMAP 1
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX
            /* WARNING: $splice Could not find named fragment 'PassInstancing' */
            #define SHADERPASS SHADERPASS_DEPTHONLY
            /* WARNING: $splice Could not find named fragment 'DotsInstancingVars' */

            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"

            // --------------------------------------------------
            // Structs and Packing

            struct Attributes
            {
                float3 positionOS : POSITION;
                half3 normalOS : NORMAL;
                half4 tangentOS : TANGENT;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            struct SurfaceDescriptionInputs
            {
				float4 uv0;
            };

            struct VertexDescriptionInputs
            {
                half3 ObjectSpaceNormal;
                half3 ObjectSpaceTangent;
                half3 ObjectSpacePosition;
            };
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            PackedVaryings PackVaryings (Varyings input)
            {
                PackedVaryings output;
                output.positionCS = input.positionCS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }
            Varyings UnpackVaryings (PackedVaryings input)
            {
                Varyings output;
                output.positionCS = input.positionCS;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // --------------------------------------------------
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


        #define TERRAIN_TO_MESH_NEED_NORMAL
        #define TERRAIN_TO_MESH_NEED_METALLIC_SMOOTHNESS_OCCLUSION


        #include "Splatmap.cginc"

            // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            half3 Normal;
            half3 Tangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float3 _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0;
            half3 _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4;
            SHG_TerrainToMeshCurvedWorld_float(IN.ObjectSpacePosition, IN.ObjectSpaceNormal, (half4(IN.ObjectSpaceTangent, 1.0)), _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0, _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4);
            description.Position = _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_vertex_0;
            description.Normal = _SHGTerrainToMeshCurvedWorldCustomFunction_1d12c500e42ebf8b903bf40b7a0a5e2c_normal_4;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }

            // Graph Pixel
            struct SurfaceDescription
        {
        };

        SurfaceDescription SurfaceDescriptionFunction(Varyings unpacked, SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }

        SurfaceDescription BaseSurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            return surface;
        }

            // --------------------------------------------------
            // Build Graph Inputs

        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal =           input.normalOS;
            output.ObjectSpaceTangent =          input.tangentOS.xyz;
            output.ObjectSpacePosition =         input.positionOS;

            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);

            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
            #else
            #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
            #endif
            #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN

            return output;
        }

            // --------------------------------------------------
            // Main

            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
            #include "SplatmapVaryings.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"

            ENDHLSL
        }


    }
    

    
    //CustomEditor "AmazingAssets.TerrainToMeshEditor.SplatmapShaderGUI"
    //FallBack "LingRen/Shader/Scene/TerrainMesh/Fallback/Splatmap"
}
