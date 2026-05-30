using System.Collections.Generic;
using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;
#if HAS_UNITY_TERRAIN_TOOLS
using UnityEngine.TerrainTools;
#endif

namespace ST.Terrain
{
    public static class TerrainMaterialExport
    {
        public static void GenerateMaterial(TerrainExportData data)
        {
            var (sceneDir, sceneName) = TerrainExportUtility.GetCurrentSceneParts();
            string matFolder = string.Format("{0}{1}/{2}/mat/", sceneDir, sceneName,
                TerrainExportPath.PREFAB_EXPORT_FOLDER_NAME);
            string texFolder = TerrainExportPath.GetTerrainOutputPath() + "/texture";

            bool hasTerainLayers = data.terrain.terrainData.terrainLayers != null &&
                                   data.terrain.terrainData.terrainLayers.Length > 0;

            #region Splatmap Material
            if (hasTerainLayers)
            {
                Material splatMat = TerrainBridge.exportSplatmapMaterial(data.terrain);
                Shader   splatShader = Shader.Find("SpaceTime/Scene/TerrainMesh/Splatmap");
                if (splatMat != null)
                {
                    splatMat.shader = splatShader;
                    CopyWeatherParams(data.terrain.materialTemplate, splatMat);
                }

                if (splatMat != null)
                {
                    splatMat.SetTexture("_BaseMap", LoadTexture(TerrainExportUtility.AbsPath2AssetsPath(data.baseTexPath)));
                    splatMat.SetTexture("_BumpMap", LoadTexture(TerrainExportUtility.AbsPath2AssetsPath(data.normalTexPath)));
                }

                data.enableTriplanar = false;
#if HAS_UNITY_TERRAIN_TOOLS
                var atd = data.terrain.GetComponent<AdditionalTerrainData>();
                if (atd != null && splatMat != null)
                {
                    for (int i = 0; i < 8; i++)
                    {
                        bool hasLayer = splatMat.HasTexture("_T2M_Layer_" + i + "_Diffuse") &&
                                        splatMat.GetTexture("_T2M_Layer_" + i + "_Diffuse") != null;
                        if (hasLayer)
                        {
                            if (atd.LayerTriplanar[i]) data.enableTriplanar = true;
                            splatMat.SetFloat("_Layer" + i + "_Triplanar",          atd.LayerTriplanar[i] ? 1f : 0f);
                            splatMat.SetFloat("_Layer" + i + "_TriplanarTileScale", atd.LayerTriplanarTileScale[i]);
                            splatMat.SetFloat("_AtomColorRange" + i,                atd.AtomColorRanges[i]);
                        }
                        else
                        {
                            splatMat.SetFloat("_Layer" + i + "_Triplanar", 0f);
                        }
                    }
                }
#endif

                if (splatMat != null)
                {
                    for (int i = 0; i < 2; i++)
                    {
                        string splatPath = TerrainExportUtility.AbsPath2AssetsPath(
                            string.Format("{0}/{1}-Splatmap-{2}.tga", texFolder, data.splatTexPath, i));
                        splatMat.SetTexture("_T2M_SplatMap_" + i, LoadTexture(splatPath));
                    }

                    if (data.terrain.materialTemplate != null)
                    {
                        if (data.terrain.materialTemplate.IsKeywordEnabled("_TERRAIN_BLEND_HEIGHT"))
                            splatMat.EnableKeyword(new LocalKeyword(splatMat.shader, "_TERRAIN_BLEND_HEIGHT"));
                        splatMat.SetFloat("_HeightTransition",
                            data.terrain.materialTemplate.GetFloat("_HeightTransition"));
                    }

                    for (int i = 0; i < data.terrain.terrainData.terrainLayers.Length; i++)
                    {
                        TerrainLayer layer = data.terrain.terrainData.terrainLayers[i];
                        float hasAlpha = (layer != null && TerrainExportUtility.TextureHasAlpha(layer.diffuseTexture)) ? 1f : 0f;
                        splatMat.SetFloat(string.Format("_T2M_Layer_{0}_SmoothnessFromDiffuseAlpha", i), hasAlpha);
                    }

                    splatMat.SetFloat("_QueueOffset", 4);
                    splatMat.renderQueue = 2199;
                    splatMat.SetFloat("_T2M_SplatMapOffsetX", data.offsetX);
                    splatMat.SetFloat("_T2M_SplatMapOffsetY", data.offsetY);

                    NormaliseLayerCountKeywords(splatMat);

                    for (int i = 0; i < 8; i++)
                    {
                        string prop = string.Format("_T2M_Layer_{0}_uvScaleOffset", i);
                        Vector4 v = splatMat.GetVector(prop);
                        splatMat.SetVector(prop, new Vector4(
                            Mathf.FloorToInt(v.x), Mathf.FloorToInt(v.y),
                            Mathf.CeilToInt(v.z),  Mathf.CeilToInt(v.w)));
                    }

                    string splatMatPath = string.Format("{0}{1}-Splatmap.mat", matFolder, data.terrain.name);
                    AssetDatabase.CreateAsset(splatMat, splatMatPath);
                    data.splatMat = splatMatPath;
                }
            }
            #endregion

            BuildBaseMapMaterial(data, matFolder);
        }

        static void BuildBaseMapMaterial(TerrainExportData data, string matFolder)
        {
            Material baseMat = new Material(Shader.Find("SpaceTime/Scene/SceneObjLit"));
            baseMat.shaderKeywords = new string[0];
            baseMat.SetFloat("_Smoothness", 0f);

            baseMat.SetTexture("_BaseMap", LoadTexture(TerrainExportUtility.AbsPath2AssetsPath(data.baseTexPath)));
            baseMat.SetFloat("_UseNormal", 1f);
            baseMat.SetTexture("_BumpMap", LoadTexture(TerrainExportUtility.AbsPath2AssetsPath(data.normalTexPath)));
            baseMat.SetFloat("_ReceiveRealShadows", 0f);
            baseMat.SetFloat("_QueueOffset",        4f);
            baseMat.renderQueue = 2200;
            baseMat.SetFloat("_OcclusionStrength",  1f);
            baseMat.SetFloat("_SpecularHighlights", 1f);

            string baseMatPath = string.Format("{0}{1}-Basemap.mat", matFolder, data.terrain.name);
            AssetDatabase.CreateAsset(baseMat, baseMatPath);
            data.baseMat = baseMatPath;
        }

        static void CopyWeatherParams(Material src, Material dst)
        {
            if (src == null || dst == null) return;
            void CopyFloat(string n)  { if (src.HasFloat(n))  dst.SetFloat(n,  src.GetFloat(n)); }
            void CopyVec(string n)    { if (src.HasVector(n)) dst.SetVector(n, src.GetVector(n)); }

            CopyFloat("_SnowIntensity");     CopyFloat("_SnowLumIntensity");
            CopyVec("_SnowLumRemap");        CopyFloat("_SnowProjYIntensity");
            CopyVec("_SnowProjYRemap");      CopyFloat("_SnowGlitterIntensity");
            CopyFloat("_SnowUseAtmoGlobals");
            CopyFloat("_WetnessIntensity");  CopyVec("_WetnessWaterColor");
            CopyVec("_WetnessBlendRemap");   CopyFloat("_WetnessWaterIntensity");
            CopyFloat("_WetnessDropsIntensity"); CopyFloat("_WetnessDropsNormal");
            CopyFloat("_WetnessDropsFade");  CopyVec("_WetnessDropsProjRemap");
            CopyFloat("_WetnessUseAtmoGlobals");
            CopyFloat("_TintingIntensity");  CopyFloat("_TintingGray");
            CopyVec("_TintingColor");        CopyFloat("_TintingLumIntensity");
            CopyVec("_TintingLumRemap");     CopyVec("_TintingBlendRemap");
        }

        static void NormaliseLayerCountKeywords(Material mat)
        {
            bool has3 = mat.IsKeywordEnabled("_T2M_LAYER_COUNT_3");
            bool has567 = mat.IsKeywordEnabled("_T2M_LAYER_COUNT_5") ||
                          mat.IsKeywordEnabled("_T2M_LAYER_COUNT_6") ||
                          mat.IsKeywordEnabled("_T2M_LAYER_COUNT_7");

            if (has3)
            {
                mat.DisableKeyword("_T2M_LAYER_COUNT_3");
                mat.EnableKeyword("_T2M_LAYER_COUNT_4");
            }
            if (has567)
            {
                mat.DisableKeyword("_T2M_LAYER_COUNT_5");
                mat.DisableKeyword("_T2M_LAYER_COUNT_6");
                mat.DisableKeyword("_T2M_LAYER_COUNT_7");
                mat.EnableKeyword("_T2M_LAYER_COUNT_8");
            }
        }

        static Texture2D LoadTexture(string assetPath)
        {
            Texture2D tex = AssetDatabase.LoadAssetAtPath<Texture2D>(assetPath);
            if (tex == null)
            {
                AssetDatabase.ImportAsset(assetPath);
                tex = AssetDatabase.LoadAssetAtPath<Texture2D>(assetPath);
            }
            return tex;
        }
    }
}
