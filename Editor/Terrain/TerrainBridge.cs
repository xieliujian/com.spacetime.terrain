using System;
using UnityEngine;

namespace ST.Terrain
{
    /// <summary>
    /// 地形导出桥接器，通过委托注入外部依赖（如 Amazing Assets TTM 插件）。
    /// 调用方在 Editor 启动时注册各委托，导出管线通过此类访问。
    /// </summary>
    public static class TerrainBridge
    {
        /// <summary>将 Terrain 导出为 Mesh（由 TTM 插件实现）</summary>
        public static Func<UnityEngine.Terrain, int, int, Mesh> exportMesh;

        /// <summary>将 Terrain 导出 Splatmap 纹理数组</summary>
        public static Func<UnityEngine.Terrain, bool, Texture2D[]> exportSplatmapTextures;

        /// <summary>将 Terrain 导出 Base 纹理（[0]=Diffuse, [1]=Normal）</summary>
        public static Func<UnityEngine.Terrain, int, Texture2D[]> exportBaseTexture;

        /// <summary>将 Terrain 导出 Splatmap Material</summary>
        public static Func<UnityEngine.Terrain, Material> exportSplatmapMaterial;

        /// <summary>获取当前场景路径分量 (sceneDir, sceneName)</summary>
        public static Func<(string sceneDir, string sceneName)> getSceneParts;

        /// <summary>是否需要为 LOD0 附加 MeshCollider</summary>
        public static bool needTerrainCollider = false;

        /// <summary>
        /// 可选：地形缓存查询接口，用于增量导出（跳过未修改地形）。
        /// 为 null 时每次都重新导出。
        /// </summary>
        public static ITerrainCacheQuery terrainCacheQuery;
    }

    /// <summary>
    /// 地形缓存查询接口，允许外部控制是否重新生成某块地形的运行时数据。
    /// </summary>
    public interface ITerrainCacheQuery
    {
        void Init();
        bool IsNeedReCreateTerrainRuntimeData(UnityEngine.Terrain terrain);
    }
}
