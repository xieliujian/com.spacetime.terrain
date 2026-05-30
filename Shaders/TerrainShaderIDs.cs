using UnityEngine;

namespace ST.Terrain
{
    /// <summary>
    /// 地形 Mesh Shader 属�?ID 缓存，避免运行时反复调用 Shader.PropertyToID�?
    /// 参�?URP ShaderPropertyId 模式（com.unity.render-pipelines.universal）�?
    /// </summary>
    public static class TerrainShaderIDs
    {
        // ─── Fallback / Base 贴图 ────────────────────────────────────────────
        public static readonly int BaseMap    = Shader.PropertyToID("_BaseMap");
        public static readonly int BumpMap    = Shader.PropertyToID("_BumpMap");

        // ─── Splatmap ────────────────────────────────────────────────────────
        public static readonly int SplatMap0  = Shader.PropertyToID("_T2M_SplatMap_0");
        public static readonly int SplatMap1  = Shader.PropertyToID("_T2M_SplatMap_1");
        public static readonly int SplatMap2  = Shader.PropertyToID("_T2M_SplatMap_2");
        public static readonly int SplatMap3  = Shader.PropertyToID("_T2M_SplatMap_3");

        public static readonly int SplatMapOffsetX = Shader.PropertyToID("_T2M_SplatMapOffsetX");
        public static readonly int SplatMapOffsetY = Shader.PropertyToID("_T2M_SplatMapOffsetY");

        // ─── Layer Count Keywords ────────────────────────────────────────────
        public const string KEYWORD_LAYER_COUNT_4 = "_T2M_LAYER_COUNT_4";
        public const string KEYWORD_LAYER_COUNT_8 = "_T2M_LAYER_COUNT_8";

        // ─── Height Blend ────────────────────────────────────────────────────
        public static readonly int HeightTransition  = Shader.PropertyToID("_HeightTransition");
        public const string KEYWORD_TERRAIN_BLEND_HEIGHT = "_TERRAIN_BLEND_HEIGHT";

        // ─── Weather: Snow ───────────────────────────────────────────────────
        public static readonly int SnowIntensity        = Shader.PropertyToID("_SnowIntensity");
        public static readonly int SnowLumIntensity     = Shader.PropertyToID("_SnowLumIntensity");
        public static readonly int SnowLumRemap         = Shader.PropertyToID("_SnowLumRemap");
        public static readonly int SnowProjYIntensity   = Shader.PropertyToID("_SnowProjYIntensity");
        public static readonly int SnowProjYRemap       = Shader.PropertyToID("_SnowProjYRemap");
        public static readonly int SnowGlitterIntensity = Shader.PropertyToID("_SnowGlitterIntensity");
        public static readonly int SnowUseAtmoGlobals   = Shader.PropertyToID("_SnowUseAtmoGlobals");

        // ─── Weather: Wetness ────────────────────────────────────────────────
        public static readonly int WetnessIntensity       = Shader.PropertyToID("_WetnessIntensity");
        public static readonly int WetnessWaterColor      = Shader.PropertyToID("_WetnessWaterColor");
        public static readonly int WetnessBlendRemap      = Shader.PropertyToID("_WetnessBlendRemap");
        public static readonly int WetnessWaterIntensity  = Shader.PropertyToID("_WetnessWaterIntensity");
        public static readonly int WetnessDropsIntensity  = Shader.PropertyToID("_WetnessDropsIntensity");
        public static readonly int WetnessDropsNormal     = Shader.PropertyToID("_WetnessDropsNormal");
        public static readonly int WetnessDropsFade       = Shader.PropertyToID("_WetnessDropsFade");
        public static readonly int WetnessDropsProjRemap  = Shader.PropertyToID("_WetnessDropsProjRemap");
        public static readonly int WetnessUseAtmoGlobals  = Shader.PropertyToID("_WetnessUseAtmoGlobals");

        // ─── Weather: Tinting ────────────────────────────────────────────────
        public static readonly int TintingIntensity    = Shader.PropertyToID("_TintingIntensity");
        public static readonly int TintingGray         = Shader.PropertyToID("_TintingGray");
        public static readonly int TintingColor        = Shader.PropertyToID("_TintingColor");
        public static readonly int TintingLumIntensity = Shader.PropertyToID("_TintingLumIntensity");
        public static readonly int TintingLumRemap     = Shader.PropertyToID("_TintingLumRemap");
        public static readonly int TintingBlendRemap   = Shader.PropertyToID("_TintingBlendRemap");

        // ─── Render Queue / Misc ─────────────────────────────────────────────
        public static readonly int QueueOffset = Shader.PropertyToID("_QueueOffset");

        // ─── Layer Triplanar ─────────────────────────────────────────────────
        /// <summary>格式�?"_Layer{i}_Triplanar" 属性名并缓�?PropertyToID�?/summary>
        public static int LayerTriplanar(int layerIndex)
            => Shader.PropertyToID("_Layer" + layerIndex + "_Triplanar");

        public static int LayerTriplanarTileScale(int layerIndex)
            => Shader.PropertyToID("_Layer" + layerIndex + "_TriplanarTileScale");

        public static int AtomColorRange(int layerIndex)
            => Shader.PropertyToID("_AtomColorRange" + layerIndex);

        // ─── Shader Names ────────────────────────────────────────────────────
        public const string SHADER_SPLATMAP        = "SpaceTime/Scene/TerrainMesh/Splatmap";
        public const string SHADER_SPLATMAP_UNWRAP = "SpaceTime/Scene/TerrainMesh/SplatmapUnwrap";
        public const string SHADER_VT_LIT          = "SpaceTime/Scene/TerrainMesh/VTLit";
        public const string SHADER_SCENE_BASE_LIT  = "SpaceTime/Scene/SceneObjBaseLit";
    }
}
