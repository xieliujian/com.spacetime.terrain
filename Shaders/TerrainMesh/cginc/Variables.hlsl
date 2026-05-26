#ifndef TERRAIN_TO_MESH_VARIABLES_CGINC
#define TERRAIN_TO_MESH_VARIABLES_CGINC

#if defined(_T2M_LAYER_COUNT_3) 
    #define NEED_PAINT_MAP_2
#elif defined(_T2M_LAYER_COUNT_4)
    #define NEED_PAINT_MAP_2
    #define NEED_PAINT_MAP_3
#elif defined(_T2M_LAYER_COUNT_5)
    #define NEED_SPLAT_MAP_1
    #define NEED_PAINT_MAP_2
    #define NEED_PAINT_MAP_3
    #define NEED_PAINT_MAP_4
#elif defined(_T2M_LAYER_COUNT_6)
    #define NEED_SPLAT_MAP_1
    #define NEED_PAINT_MAP_2
    #define NEED_PAINT_MAP_3
    #define NEED_PAINT_MAP_4
    #define NEED_PAINT_MAP_5
#elif defined(_T2M_LAYER_COUNT_7)
    #define NEED_SPLAT_MAP_1
    #define NEED_PAINT_MAP_2
    #define NEED_PAINT_MAP_3
    #define NEED_PAINT_MAP_4
    #define NEED_PAINT_MAP_5
    #define NEED_PAINT_MAP_6
#elif defined(_T2M_LAYER_COUNT_8)
    #define NEED_SPLAT_MAP_1
    #define NEED_PAINT_MAP_2
    #define NEED_PAINT_MAP_3
    #define NEED_PAINT_MAP_4
    #define NEED_PAINT_MAP_5
    #define NEED_PAINT_MAP_6
    #define NEED_PAINT_MAP_7
//#elif defined(_T2M_LAYER_COUNT_9)
//    #define NEED_SPLAT_MAP_1
//    //#define NEED_SPLAT_MAP_2
//    #define NEED_PAINT_MAP_2
//    #define NEED_PAINT_MAP_3
//    #define NEED_PAINT_MAP_4
//    #define NEED_PAINT_MAP_5
//    #define NEED_PAINT_MAP_6
//    #define NEED_PAINT_MAP_7
//    #define NEED_PAINT_MAP_8
//#elif defined(_T2M_LAYER_COUNT_10)
//    #define NEED_SPLAT_MAP_1
//    #define NEED_SPLAT_MAP_2
//    #define NEED_PAINT_MAP_2
//    #define NEED_PAINT_MAP_3
//    #define NEED_PAINT_MAP_4
//    #define NEED_PAINT_MAP_5
//    #define NEED_PAINT_MAP_6
//    #define NEED_PAINT_MAP_7
//    #define NEED_PAINT_MAP_8
//    #define NEED_PAINT_MAP_9
//#elif defined(_T2M_LAYER_COUNT_11)
//    #define NEED_SPLAT_MAP_1
//    #define NEED_SPLAT_MAP_2
//    #define NEED_PAINT_MAP_2
//    #define NEED_PAINT_MAP_3
//    #define NEED_PAINT_MAP_4
//    #define NEED_PAINT_MAP_5
//    #define NEED_PAINT_MAP_6
//    #define NEED_PAINT_MAP_7
//    #define NEED_PAINT_MAP_8
//    #define NEED_PAINT_MAP_9
//    #define NEED_PAINT_MAP_10
//#elif defined(_T2M_LAYER_COUNT_12)
//    #define NEED_SPLAT_MAP_1
//    #define NEED_SPLAT_MAP_2
//    #define NEED_PAINT_MAP_2
//    #define NEED_PAINT_MAP_3
//    #define NEED_PAINT_MAP_4
//    #define NEED_PAINT_MAP_5
//    #define NEED_PAINT_MAP_6
//    #define NEED_PAINT_MAP_7
//    #define NEED_PAINT_MAP_8
//    #define NEED_PAINT_MAP_9
//    #define NEED_PAINT_MAP_10
//    #define NEED_PAINT_MAP_11
//#elif defined(_T2M_LAYER_COUNT_13)
//    #define NEED_SPLAT_MAP_1
//    #define NEED_SPLAT_MAP_2
//    #define NEED_SPLAT_MAP_3
//    #define NEED_PAINT_MAP_2
//    #define NEED_PAINT_MAP_3
//    #define NEED_PAINT_MAP_4
//    #define NEED_PAINT_MAP_5
//    #define NEED_PAINT_MAP_6
//    #define NEED_PAINT_MAP_7
//    #define NEED_PAINT_MAP_8
//    #define NEED_PAINT_MAP_9
//    #define NEED_PAINT_MAP_10
//    #define NEED_PAINT_MAP_11
//    #define NEED_PAINT_MAP_12
//#elif defined(_T2M_LAYER_COUNT_14)
//    #define NEED_SPLAT_MAP_1
//    #define NEED_SPLAT_MAP_2
//    #define NEED_SPLAT_MAP_3
//    #define NEED_PAINT_MAP_2
//    #define NEED_PAINT_MAP_3
//    #define NEED_PAINT_MAP_4
//    #define NEED_PAINT_MAP_5
//    #define NEED_PAINT_MAP_6
//    #define NEED_PAINT_MAP_7
//    #define NEED_PAINT_MAP_8
//    #define NEED_PAINT_MAP_9
//    #define NEED_PAINT_MAP_10
//    #define NEED_PAINT_MAP_11
//    #define NEED_PAINT_MAP_12
//    #define NEED_PAINT_MAP_13
//#elif defined(_T2M_LAYER_COUNT_15)
//    #define NEED_SPLAT_MAP_1
//    #define NEED_SPLAT_MAP_2
//    #define NEED_SPLAT_MAP_3
//    #define NEED_PAINT_MAP_2
//    #define NEED_PAINT_MAP_3
//    #define NEED_PAINT_MAP_4
//    #define NEED_PAINT_MAP_5
//    #define NEED_PAINT_MAP_6
//    #define NEED_PAINT_MAP_7
//    #define NEED_PAINT_MAP_8
//    #define NEED_PAINT_MAP_9
//    #define NEED_PAINT_MAP_10
//    #define NEED_PAINT_MAP_11
//    #define NEED_PAINT_MAP_12
//    #define NEED_PAINT_MAP_13
//    #define NEED_PAINT_MAP_14
//#elif defined(_T2M_LAYER_COUNT_16)
//    #define NEED_SPLAT_MAP_1
//    #define NEED_SPLAT_MAP_2
//    #define NEED_SPLAT_MAP_3
//    #define NEED_PAINT_MAP_2
//    #define NEED_PAINT_MAP_3
//    #define NEED_PAINT_MAP_4
//    #define NEED_PAINT_MAP_5
//    #define NEED_PAINT_MAP_6
//    #define NEED_PAINT_MAP_7
//    #define NEED_PAINT_MAP_8
//    #define NEED_PAINT_MAP_9
//    #define NEED_PAINT_MAP_10
//    #define NEED_PAINT_MAP_11
//    #define NEED_PAINT_MAP_12
//    #define NEED_PAINT_MAP_13
//    #define NEED_PAINT_MAP_14
//    #define NEED_PAINT_MAP_15
#endif


//#if defined(_T2M_TEXTURE_SAMPLE_TYPE_ARRAY)    
//    #define T2M_DECLARE_LAYER(l)                half4 _T2M_Layer_##l##_MapsUsage; half2 _T2M_Layer_##l##_uvScaleOffset;   half4 _T2M_Layer_##l##_ColorTint; half4 _T2M_Layer_##l##_MetallicOcclusionSmoothness; int _T2M_Layer_##l##_SmoothnessFromDiffuseAlpha; 
//    #define T2M_DECALRE_NORMAL(l)               half _T2M_Layer_##l##_NormalScale;
//    #define T2M_DECALRE_MASK(l)                 half4 _T2M_Layer_##l##_MaskMapRemapMin; half4 _T2M_Layer_##l##_MaskMapRemapMax;
//#else
    #define T2M_DECLARE_LAYER(l)                TEXTURE2D(_T2M_Layer_##l##_Diffuse);  //half2 _T2M_Layer_##l##_uvScaleOffset;   half4 _T2M_Layer_##l##_ColorTint; half4 _T2M_Layer_##l##_MetallicOcclusionSmoothness; int _T2M_Layer_##l##_SmoothnessFromDiffuseAlpha;
    #define T2M_DECALRE_NORMAL(l)               TEXTURE2D(_T2M_Layer_##l##_NormalMap);  SAMPLER(sampler_T2M_Layer_##l##_NormalMap);//half _T2M_Layer_##l##_NormalScale;
    //#define T2M_DECALRE_MASK(l)                 TEXTURE2D(_T2M_Layer_##l##_Mask);      //half4 _T2M_Layer_##l##_MaskMapRemapMin; half4 _T2M_Layer_##l##_MaskMapRemapMax;
//#endif


//Layer Count/////////////////////////////////////////////////////////////////////////////


//Holes///////////////////////////////////////////////////////////////////////////////////
#if defined(_ALPHATEST_ON)
    TEXTURE2D(_T2M_HolesMap); SAMPLER(sampler_T2M_HolesMap);
#endif



#if defined(_T2M_TEXTURE_SAMPLE_TYPE_ARRAY)
     
    TEXTURE2D_ARRAY(_T2M_SplatMaps2DArray);     SAMPLER(sampler_T2M_SplatMaps2DArray);
    TEXTURE2D_ARRAY(_T2M_DiffuseMaps2DArray);   SAMPLER(sampler_T2M_DiffuseMaps2DArray);
    TEXTURE2D_ARRAY(_T2M_NormalMaps2DArray);    SAMPLER(sampler_T2M_NormalMaps2DArray);
    TEXTURE2D_ARRAY(_T2M_MaskMaps2DArray);      SAMPLER(sampler_T2M_MaskMaps2DArray);

	half4 _T2M_Layer_0_MapsUsage;
#else

    //Splatmaps///////////////////////////////////////////////////////////////////////////////
    TEXTURE2D(_T2M_SplatMap_0); SAMPLER(sampler_T2M_SplatMap_0);
    #if defined(NEED_SPLAT_MAP_1)
        TEXTURE2D(_T2M_SplatMap_1);
    #endif
    #if defined(NEED_SPLAT_MAP_2)
        TEXTURE2D(_T2M_SplatMap_2);
    #endif
    #if defined(NEED_SPLAT_MAP_3)
        TEXTURE2D(_T2M_SplatMap_3);
    #endif
    //Layers//////////////////////////////////////////////////////////////////////////////////
    TEXTURE2D(_T2M_Layer_0_Diffuse); SAMPLER(sampler_T2M_Layer_0_Diffuse);
    TEXTURE2D(_T2M_Layer_0_NormalMap); SAMPLER(sampler_T2M_Layer_0_NormalMap);
#endif
    //half2 _T2M_Layer_0_uvScaleOffset;
    //half4 _T2M_Layer_0_ColorTint;
    //half4 _T2M_Layer_0_MetallicOcclusionSmoothness;
    //int _T2M_Layer_0_SmoothnessFromDiffuseAlpha;

    //#if defined(_T2M_LAYER_0_NORMAL)
    //    T2M_DECALRE_NORMAL(0)
    //#endif
    //#if defined(_T2M_LAYER_0_MASK) 
    //    T2M_DECALRE_MASK(0)
    //#endif

    #if !defined(ONLY_NORMAL)
    T2M_DECLARE_LAYER(1)
    #endif

    
    #if defined(_T2M_LAYER_1_NORMAL) && !defined(ONLY_COLOR)
        T2M_DECALRE_NORMAL(1)
    #endif

    //#if defined(_T2M_LAYER_1_MASK) 
    //    T2M_DECALRE_MASK(1)
    //#endif

    T2M_DECLARE_LAYER(2)
    #if defined(_T2M_LAYER_2_NORMAL) && !defined(ONLY_COLOR)
        T2M_DECALRE_NORMAL(2)
    #endif
    //#if defined(_T2M_LAYER_2_MASK) 
    //    T2M_DECALRE_MASK(2)
    //#endif

    #ifdef NEED_PAINT_MAP_3
        #if !defined(ONLY_NORMAL)
        T2M_DECLARE_LAYER(3)
        #endif
        #if defined(_T2M_LAYER_3_NORMAL) && !defined(ONLY_COLOR)
            T2M_DECALRE_NORMAL(3)
        #endif
        //#if defined(_T2M_LAYER_3_MASK) 
        //    T2M_DECALRE_MASK(3)
        //#endif
    #endif


    #if defined(NEED_SPLAT_MAP_1)
        #ifdef NEED_PAINT_MAP_4
            #if !defined(ONLY_NORMAL)
            T2M_DECLARE_LAYER(4)
            #endif

            #if defined(_T2M_LAYER_4_NORMAL) && !defined(ONLY_COLOR)
                T2M_DECALRE_NORMAL(4)
            #endif
            //#if defined(_T2M_LAYER_4_MASK) 
            //    T2M_DECALRE_MASK(4)
            //#endif
        #endif

        #ifdef NEED_PAINT_MAP_5
            #if !defined(ONLY_NORMAL)
            T2M_DECLARE_LAYER(5)
            #endif
            #if defined(_T2M_LAYER_5_NORMAL) && !defined(ONLY_COLOR)
                T2M_DECALRE_NORMAL(5)
            #endif
            //#if defined(_T2M_LAYER_5_MASK) 
            //    T2M_DECALRE_MASK(5)
            //#endif
        #endif

        #ifdef NEED_PAINT_MAP_6
            #if !defined(ONLY_NORMAL)
            T2M_DECLARE_LAYER(6)
            #endif
            #if defined(_T2M_LAYER_6_NORMAL) && !defined(ONLY_COLOR)
                T2M_DECALRE_NORMAL(6)
            #endif
            //#if defined(_T2M_LAYER_6_MASK) 
            //    T2M_DECALRE_MASK(6)
            //#endif
        #endif

        #ifdef NEED_PAINT_MAP_7
            #if !defined(ONLY_NORMAL)
            T2M_DECLARE_LAYER(7)
            #endif
            #if defined(_T2M_LAYER_7_NORMAL) && !defined(ONLY_COLOR)
                T2M_DECALRE_NORMAL(7)
            #endif
            //#if defined(_T2M_LAYER_7_MASK) 
            //    T2M_DECALRE_MASK(7)
            //#endif
        #endif        
    #endif

    #if defined(NEED_SPLAT_MAP_2)
        #ifdef NEED_PAINT_MAP_8
            #if !defined(ONLY_NORMAL)
            T2M_DECLARE_LAYER(8)
            #endif
            #if defined(_T2M_LAYER_8_NORMAL) && !defined(ONLY_COLOR)
                T2M_DECALRE_NORMAL(8)
            #endif
            //#if defined(_T2M_LAYER_8_MASK) 
            //    T2M_DECALRE_MASK(8)
            //#endif
        #endif

        #ifdef NEED_PAINT_MAP_9
            #if !defined(ONLY_NORMAL)
            T2M_DECLARE_LAYER(9)
            #endif
            #if defined(_T2M_LAYER_9_NORMAL) && !defined(ONLY_COLOR)
                T2M_DECALRE_NORMAL(9)
            #endif
            //#if defined(_T2M_LAYER_9_MASK) 
            //    T2M_DECALRE_MASK(9)
            //#endif
        #endif

    #endif


    
CBUFFER_START(UnityPerMaterial)
    float _T2M_SplatMapOffsetX;
    float _T2M_SplatMapOffsetY;
    int _T2M_Layer_0_SmoothnessFromDiffuseAlpha;
    int _T2M_Layer_1_SmoothnessFromDiffuseAlpha;
    int _T2M_Layer_2_SmoothnessFromDiffuseAlpha;
    int _T2M_Layer_3_SmoothnessFromDiffuseAlpha;
    int _T2M_Layer_4_SmoothnessFromDiffuseAlpha;
    int _T2M_Layer_5_SmoothnessFromDiffuseAlpha;
    int _T2M_Layer_6_SmoothnessFromDiffuseAlpha;
    int _T2M_Layer_7_SmoothnessFromDiffuseAlpha;
    int _T2M_Layer_8_SmoothnessFromDiffuseAlpha;
    //int _T2M_Layer_9_SmoothnessFromDiffuseAlpha;
    //int _T2M_Layer_10_SmoothnessFromDiffuseAlpha;
    //int _T2M_Layer_11_SmoothnessFromDiffuseAlpha;
    //int _T2M_Layer_12_SmoothnessFromDiffuseAlpha;
    //int _T2M_Layer_13_SmoothnessFromDiffuseAlpha;
    //int _T2M_Layer_14_SmoothnessFromDiffuseAlpha;
    //int _T2M_Layer_15_SmoothnessFromDiffuseAlpha;
    
    half2 _T2M_Layer_0_uvScaleOffset;
    half2 _T2M_Layer_1_uvScaleOffset;
    half2 _T2M_Layer_2_uvScaleOffset;
    half2 _T2M_Layer_3_uvScaleOffset;
    half2 _T2M_Layer_4_uvScaleOffset;
    half2 _T2M_Layer_5_uvScaleOffset;
    half2 _T2M_Layer_6_uvScaleOffset;
    half2 _T2M_Layer_7_uvScaleOffset;
    half2 _T2M_Layer_8_uvScaleOffset;
    //half2 _T2M_Layer_9_uvScaleOffset;
    //half2 _T2M_Layer_10_uvScaleOffset;
    //half2 _T2M_Layer_11_uvScaleOffset;
    //half2 _T2M_Layer_12_uvScaleOffset;
    //half2 _T2M_Layer_13_uvScaleOffset;
    //half2 _T2M_Layer_14_uvScaleOffset;
    //half2 _T2M_Layer_15_uvScaleOffset;

    half4 _T2M_Layer_0_ColorTint;
    half4 _T2M_Layer_1_ColorTint;
    half4 _T2M_Layer_2_ColorTint;
    half4 _T2M_Layer_3_ColorTint;
    half4 _T2M_Layer_4_ColorTint;
    half4 _T2M_Layer_5_ColorTint;
    half4 _T2M_Layer_6_ColorTint;
    half4 _T2M_Layer_7_ColorTint;
    half4 _T2M_Layer_8_ColorTint;
    //half4 _T2M_Layer_9_ColorTint;
    //half4 _T2M_Layer_10_ColorTint;
    //half4 _T2M_Layer_11_ColorTint;
    //half4 _T2M_Layer_12_ColorTint;
    //half4 _T2M_Layer_13_ColorTint;
    //half4 _T2M_Layer_14_ColorTint;
    //half4 _T2M_Layer_15_ColorTint;

    half4 _T2M_Layer_0_MetallicOcclusionSmoothness;
    half4 _T2M_Layer_1_MetallicOcclusionSmoothness;
    half4 _T2M_Layer_2_MetallicOcclusionSmoothness;
    half4 _T2M_Layer_3_MetallicOcclusionSmoothness;
    half4 _T2M_Layer_4_MetallicOcclusionSmoothness;
    half4 _T2M_Layer_5_MetallicOcclusionSmoothness;
    half4 _T2M_Layer_6_MetallicOcclusionSmoothness;
    half4 _T2M_Layer_7_MetallicOcclusionSmoothness;
    half4 _T2M_Layer_8_MetallicOcclusionSmoothness;
    //half4 _T2M_Layer_9_MetallicOcclusionSmoothness;
    //half4 _T2M_Layer_10_MetallicOcclusionSmoothness;
    //half4 _T2M_Layer_11_MetallicOcclusionSmoothness;
    //half4 _T2M_Layer_12_MetallicOcclusionSmoothness;
    //half4 _T2M_Layer_13_MetallicOcclusionSmoothness;
    //half4 _T2M_Layer_14_MetallicOcclusionSmoothness;
    //half4 _T2M_Layer_15_MetallicOcclusionSmoothness;

    half _T2M_Layer_0_NormalScale;
    half _T2M_Layer_1_NormalScale;
    half _T2M_Layer_2_NormalScale;
    half _T2M_Layer_3_NormalScale;
    half _T2M_Layer_4_NormalScale;
    half _T2M_Layer_5_NormalScale;
    half _T2M_Layer_6_NormalScale;
    half _T2M_Layer_7_NormalScale;
    half _T2M_Layer_8_NormalScale;
    //half _T2M_Layer_9_NormalScale;
    //half _T2M_Layer_10_NormalScale;
    //half _T2M_Layer_11_NormalScale;
    //half _T2M_Layer_12_NormalScale;
    //half _T2M_Layer_13_NormalScale;
    //half _T2M_Layer_14_NormalScale;
    //half _T2M_Layer_15_NormalScale;


    //half4 _T2M_Layer_0_MaskMapRemapMin;
    //half4 _T2M_Layer_1_MaskMapRemapMin;
    //half4 _T2M_Layer_2_MaskMapRemapMin;
    //half4 _T2M_Layer_3_MaskMapRemapMin;
    //half4 _T2M_Layer_4_MaskMapRemapMin;
    //half4 _T2M_Layer_5_MaskMapRemapMin;
    //half4 _T2M_Layer_6_MaskMapRemapMin;
    //half4 _T2M_Layer_7_MaskMapRemapMin;
    //half4 _T2M_Layer_8_MaskMapRemapMin;
    //half4 _T2M_Layer_9_MaskMapRemapMin;
    //half4 _T2M_Layer_10_MaskMapRemapMin;
    //half4 _T2M_Layer_11_MaskMapRemapMin;
    //half4 _T2M_Layer_12_MaskMapRemapMin;
    //half4 _T2M_Layer_13_MaskMapRemapMin;
    //half4 _T2M_Layer_14_MaskMapRemapMin;
    //half4 _T2M_Layer_15_MaskMapRemapMin;

    //half4 _T2M_Layer_0_MaskMapRemapMax;
    //half4 _T2M_Layer_1_MaskMapRemapMax;
    //half4 _T2M_Layer_2_MaskMapRemapMax;
    //half4 _T2M_Layer_3_MaskMapRemapMax;
    //half4 _T2M_Layer_4_MaskMapRemapMax;
    //half4 _T2M_Layer_5_MaskMapRemapMax;
    //half4 _T2M_Layer_6_MaskMapRemapMax;
    //half4 _T2M_Layer_7_MaskMapRemapMax;
    //half4 _T2M_Layer_8_MaskMapRemapMax;
    //half4 _T2M_Layer_9_MaskMapRemapMax;
    //half4 _T2M_Layer_10_MaskMapRemapMax;
    //half4 _T2M_Layer_11_MaskMapRemapMax;
    //half4 _T2M_Layer_12_MaskMapRemapMax;
    //half4 _T2M_Layer_13_MaskMapRemapMax;
    //half4 _T2M_Layer_14_MaskMapRemapMax;
    //half4 _T2M_Layer_15_MaskMapRemapMax;

    int _T2M_Layer_Count;

    float4 _BakeScaleOffset;

    half _Layer0_Triplanar;
    half _Layer1_Triplanar;
    half _Layer2_Triplanar;
    half _Layer3_Triplanar;
    half _Layer4_Triplanar;
    half _Layer5_Triplanar;
    half _Layer6_Triplanar;
    half _Layer7_Triplanar;

    half _Layer0_TriplanarTileScale;
    half _Layer1_TriplanarTileScale;
    half _Layer2_TriplanarTileScale;
    half _Layer3_TriplanarTileScale;
    half _Layer4_TriplanarTileScale;
    half _Layer5_TriplanarTileScale;
    half _Layer6_TriplanarTileScale;
    half _Layer7_TriplanarTileScale;

    half _AtomColorRange0;
    half _AtomColorRange1;
    half _AtomColorRange2;
    half _AtomColorRange3;
    half _AtomColorRange4;
    half _AtomColorRange5;
    half _AtomColorRange6;
    half _AtomColorRange7;

    half _HeightTransition;
    half _EnableUV2ForTriplanar;

    //half _SnowLumIntensity;
    //half4 _SnowLumRemap;
    //half _SnowIntensity;
    //half _SnowProjYIntensity;
    //half4 _SnowProjYRemap;
    //half _SnowGlitterIntensity;

    #include "Buffer.hlsl"

CBUFFER_END


#include "../ext/Common.hlsl"
#endif
