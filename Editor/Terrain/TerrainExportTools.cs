using System.Collections.Generic;
using System.IO;
using UnityEditor;
using UnityEngine;
#if HAS_UNITY_TERRAIN_TOOLS
using UnityEngine.TerrainTools;
#endif

namespace ST.Terrain
{
    public class RuntimeTerrainPrefabInfo
    {
        public GameObject prefabGo;
        public Vector3 pos;
        public string path;
        public int x = 0;
        public int y = 0;
    }

    public class TerrainExportData
    {
        public UnityEngine.Terrain terrain;
        public string baseTexPath;
        public string normalTexPath;
        public string splatTexPath;

        public string meshLOD0Path;
        public string meshLOD1Path;
        public string meshLOD2Path;
        public string meshLODVTPath;
        public string meshLODVT1Path;

        public string baseMat;
        public string splatMat;
        public string baseTriMat;

        public float offsetX;
        public float offsetY;
        public bool enableTriplanar = false;

        public List<string> GetAllPath()
        {
            return new List<string>
            {
                meshLOD0Path, meshLOD1Path, meshLOD2Path,
                meshLODVTPath, meshLODVT1Path,
                baseMat, splatMat, baseTriMat
            };
        }
    }

    public static class TerrainExportPath
    {
        public const string PREFAB_EXPORT_FOLDER_NAME = "RuntimeTerrainData";

        public static string GetTerrainOutputPath()
        {
            var (sceneDir, sceneName) = TerrainExportUtility.GetCurrentSceneParts();
            string projectRoot = Application.dataPath.Substring(0, Application.dataPath.Length - 7);
            return string.Format("{0}/{1}{2}/{3}", projectRoot, sceneDir, sceneName, PREFAB_EXPORT_FOLDER_NAME);
        }

        public static void InitTempDir(string parentFolder)
        {
            string src = parentFolder.Replace(PREFAB_EXPORT_FOLDER_NAME, "");
            TerrainExportUtility.EnsureDirectory(src, PREFAB_EXPORT_FOLDER_NAME, true);
            TerrainExportUtility.EnsureDirectory(parentFolder, "texture");
            TerrainExportUtility.EnsureDirectory(parentFolder, "asset");
            TerrainExportUtility.EnsureDirectory(parentFolder, "mat");
            TerrainExportUtility.EnsureDirectory(parentFolder, "prefab");
        }
    }

    public static class TerrainExportTools
    {
        const int COUNT_IN_WIDTH  = 2;
        const int COUNT_IN_LENGTH = 2;

        public const int SECTOR_DEFAULT_WIDTH  = 128;
        public const int SECTOR_DEFAULT_LENGTH = 128;

        public static readonly List<string> s_ModifyRuntimeTerrain = new List<string>();

        public const string TERRAIN_MESH_ROOT_NAME = "TerrainMeshExportRootNode";

        public static GameObject GlobalTempNode
        {
            get
            {
                GameObject go = GameObject.Find(TERRAIN_MESH_ROOT_NAME);
                if (go == null)
                    go = new GameObject(TERRAIN_MESH_ROOT_NAME);
                return go;
            }
        }

        static readonly List<TerrainExportData> m_NeedProcessTerrain = new List<TerrainExportData>();

        // ─── Pipeline Steps ───────────────────────────────────────────────

        public static void PreProcess()
        {
            s_ModifyRuntimeTerrain.Clear();
            m_NeedProcessTerrain.Clear();

            string runTerrainFolder = string.Format("{0}/", TerrainExportPath.GetTerrainOutputPath());
            string assetFolder = TerrainExportUtility.AbsPath2AssetsPath(runTerrainFolder);

            if (AssetDatabase.IsValidFolder(assetFolder))
            {
                AssetDatabase.DeleteAsset(assetFolder);
                AssetDatabase.Refresh();
            }

            TerrainExportPath.InitTempDir(runTerrainFolder);
            AssetDatabase.Refresh();
        }

        public static void CollectProcessTerrain()
        {
            TerrainBridge.terrainCacheQuery?.Init();

            foreach (UnityEngine.Terrain terrain in Object.FindObjectsOfType<UnityEngine.Terrain>())
            {
                if (!CanExport(terrain.gameObject)) continue;
                if (IsRuntimePrefabCached(terrain))  continue;

                TerrainTextureExport.GenerateSplatTexture(terrain);
                m_NeedProcessTerrain.AddRange(SplitQuadTerrain(terrain));
            }
        }

        public static void GenerateMesh()
        {
            foreach (var data in m_NeedProcessTerrain)
                TerrainMeshExport.GenerateMesh(data);
        }

        public static void GenerateBaseTexture()
        {
            foreach (var data in m_NeedProcessTerrain)
                TerrainTextureExport.GenerateBaseTexture(data);
        }

        public static void GenerateMaterial()
        {
            foreach (var data in m_NeedProcessTerrain)
                TerrainMaterialExport.GenerateMaterial(data);
        }

        public static void ReRefreshRes()
        {
            foreach (var data in m_NeedProcessTerrain)
                RefreshRes(data);
        }

        public static void GeneratePrefab()
        {
            foreach (var data in m_NeedProcessTerrain)
                TerrainPrefabExport.GeneratePrefab(data);
        }

        public static void Clear()
        {
            SetMeshesNonReadable();
        }

        // ─── Public Helpers ───────────────────────────────────────────────

        public static void SetMeshesNonReadable()
        {
            string assetFolder = string.Format("{0}/asset/", TerrainExportPath.GetTerrainOutputPath());
            if (!Directory.Exists(assetFolder)) return;

            foreach (string absPath in Directory.GetFiles(assetFolder, "*.asset"))
            {
                string str = File.ReadAllText(absPath);
                str = str.Replace("m_IsReadable: 1", "m_IsReadable: 0");
                File.WriteAllText(absPath, str);
            }
        }

        public static bool IsRuntimeTerrainPrefabExist(UnityEngine.Terrain terrain,
            int sectorWidthCount, int sectorHeightCount, int sectorLengthCount,
            int sectorWidth, int sectorHeight, int sectorLength,
            string sceneDir, string sceneName,
            List<RuntimeTerrainPrefabInfo> prefabInfoList)
        {
            string dir = GetRuntimeTerrainPrefabDir(sceneDir, sceneName);

            for (int j = 0; j < sectorLengthCount; j++)
            {
                for (int i = 0; i < sectorWidthCount; i++)
                {
                    for (int h = 0; h < sectorHeightCount; h++)
                    {
                        string name = GetRuntimeTerrainName(terrain, i, j);
                        string path = dir + name + ".prefab";

                        GameObject go = AssetDatabase.LoadAssetAtPath(path, typeof(GameObject)) as GameObject;
                        if (go == null) continue;

                        MeshRenderer render = go.GetComponentInChildren<MeshRenderer>();
                        if (render == null) continue;

                        Material material = render.sharedMaterial;
                        if (material == null) continue;

                        if (material.GetTexture("_T2M_SplatMap_0") == null) continue;

                        Vector3 pos = GetPrefabPos(i, sectorWidth, h, sectorHeight, j, sectorLength, terrain);
                        prefabInfoList.Add(new RuntimeTerrainPrefabInfo
                        {
                            prefabGo = go,
                            pos      = pos,
                            path     = path,
                            x        = i,
                            y        = j
                        });
                    }
                }
            }

            return prefabInfoList.Count == sectorWidthCount * sectorHeightCount * sectorLengthCount;
        }

        public static GameObject InstanceRuntimeTerrainPrefab(UnityEngine.Terrain terrain,
            List<RuntimeTerrainPrefabInfo> runTerPrefabInfoList,
            GameObject existRootGo = null)
        {
            GameObject rootGo = existRootGo ?? new GameObject(terrain.name);
            rootGo.transform.eulerAngles = Vector3.zero;
            rootGo.transform.localScale  = Vector3.one;

            foreach (var prefabInfo in runTerPrefabInfoList)
            {
                if (prefabInfo == null) continue;

                GameObject instGo = PrefabUtility.InstantiatePrefab(prefabInfo.prefabGo) as GameObject;
                if (instGo == null) continue;

                instGo.transform.SetParent(rootGo.transform);
                instGo.transform.position = prefabInfo.pos;

                foreach (LightMapStorageHelper helper in instGo.GetComponentsInChildren<LightMapStorageHelper>())
                {
                    helper.MyLightMapData.MyLightMapIndex = terrain.lightmapIndex;

                    float sx = 0.5f * terrain.lightmapScaleOffset.x;
                    float sz = 0.5f * terrain.lightmapScaleOffset.y;
                    helper.MyLightMapData.MyLightMapOffset = new Vector4(
                        sx, sz,
                        sx * prefabInfo.x + terrain.lightmapScaleOffset.z,
                        sz * prefabInfo.y + terrain.lightmapScaleOffset.w);

                    MeshRenderer mr = helper.GetComponent<MeshRenderer>();
                    if (mr != null)
                    {
                        mr.lightmapIndex       = terrain.lightmapIndex;
                        mr.lightmapScaleOffset = helper.MyLightMapData.MyLightMapOffset;
                    }
                }
            }

            return rootGo;
        }

        public static string GetRuntimeTerrainPrefabDir(string sceneDir, string sceneName)
        {
            return string.Format("{0}{1}/{2}/prefab/", sceneDir, sceneName,
                TerrainExportPath.PREFAB_EXPORT_FOLDER_NAME);
        }

        public static string GetRuntimeTerrainName(UnityEngine.Terrain terrain, int widthIndex, int lengthIndex)
        {
            return terrain != null
                ? string.Format("{0}{1}_{2}", terrain.name, widthIndex, lengthIndex)
                : string.Empty;
        }

        // ─── Private Helpers ──────────────────────────────────────────────

        static bool CanExport(GameObject go) => go != null && go.activeInHierarchy;

        static bool IsRuntimePrefabCached(UnityEngine.Terrain terrain)
        {
            if (TerrainBridge.terrainCacheQuery == null) return false;
            if (TerrainBridge.terrainCacheQuery.IsNeedReCreateTerrainRuntimeData(terrain)) return false;

            Vector3 size          = terrain.terrainData.size;
            int sectorWidth       = (int)size.x / COUNT_IN_WIDTH;
            int sectorLength      = (int)size.z / COUNT_IN_LENGTH;
            int sectorHeight      = (int)size.y;
            int sectorWidthCount  = (int)size.x / SECTOR_DEFAULT_WIDTH;
            int sectorLengthCount = (int)size.z / SECTOR_DEFAULT_LENGTH;

            var (sceneDir, sceneName) = TerrainExportUtility.GetCurrentSceneParts();
            var list = new List<RuntimeTerrainPrefabInfo>();
            return IsRuntimeTerrainPrefabExist(terrain,
                sectorWidthCount, 1, sectorLengthCount,
                sectorWidth, sectorHeight, sectorLength,
                sceneDir, sceneName, list);
        }

        static List<TerrainExportData> SplitQuadTerrain(UnityEngine.Terrain terrain)
        {
            EditorUtility.DisplayProgressBar("切分Terrain", "Preparing", 0);
            var outTerrains = new List<TerrainExportData>();

            Vector3 terrainSize = terrain.terrainData.size;
            int hmRes     = terrain.terrainData.heightmapResolution;
            int hmWidth   = hmRes / COUNT_IN_WIDTH;
            int hmLength  = hmRes / COUNT_IN_LENGTH;
            int secWidth  = (int)terrainSize.x / COUNT_IN_WIDTH;
            int secLength = (int)terrainSize.z / COUNT_IN_LENGTH;
            int alphaW    = terrain.terrainData.alphamapWidth  / COUNT_IN_WIDTH;
            int alphaL    = terrain.terrainData.alphamapHeight / COUNT_IN_LENGTH;

            int total = COUNT_IN_WIDTH * COUNT_IN_LENGTH;
            int prog  = 0;

            for (int wi = 0; wi < COUNT_IN_WIDTH; wi++)
            {
                for (int li = 0; li < COUNT_IN_LENGTH; li++)
                {
                    string newName = GetRuntimeTerrainName(terrain, wi, li);
                    s_ModifyRuntimeTerrain.Add(newName);
                    EditorUtility.DisplayProgressBar("切分Terrain",
                        "Creating sector " + newName, prog++ / (float)total);

                    GameObject newGo         = new GameObject(newName);
                    newGo.layer              = terrain.gameObject.layer;
                    UnityEngine.Terrain newT = newGo.AddComponent<UnityEngine.Terrain>();

                    var outputData = new TerrainExportData
                    {
                        splatTexPath = terrain.name,
                        terrain      = newT,
                        offsetX      = (float)wi / COUNT_IN_WIDTH,
                        offsetY      = (float)li / COUNT_IN_LENGTH
                    };
                    outTerrains.Add(outputData);

                    LightMapStorageHelper lmHelper = newGo.AddComponent<LightMapStorageHelper>();
                    lmHelper.MyLightMapData = new MyLMStruct
                    {
                        MyLightMapIndex = terrain.lightmapIndex
                    };
                    newT.lightmapIndex = terrain.lightmapIndex;

                    float sx = (secWidth  / terrainSize.x) * terrain.lightmapScaleOffset.x;
                    float sz = (secLength / terrainSize.z) * terrain.lightmapScaleOffset.y;
                    newT.lightmapScaleOffset = new Vector4(
                        sx, sz,
                        sx * wi + terrain.lightmapScaleOffset.z,
                        sz * li + terrain.lightmapScaleOffset.w);

                    newT.materialTemplate = terrain.materialTemplate;
                    newT.allowAutoConnect = true;
                    newT.terrainData      = new TerrainData();

                    int hbX = wi * hmWidth;
                    int hbY = li * hmLength;
                    int hwX = hmWidth  + (COUNT_IN_WIDTH  > 1 ? 1 : 0);
                    int hwY = hmLength + (COUNT_IN_LENGTH > 1 ? 1 : 0);

                    newT.terrainData.heightmapResolution = hmRes / COUNT_IN_WIDTH;
                    newT.terrainData.size = new Vector3(secWidth, terrainSize.y, secLength);
                    newT.terrainData.SetHeights(0, 0,
                        terrain.terrainData.GetHeights(hbX, hbY, hwX, hwY));

                    newT.terrainData.terrainLayers      = terrain.terrainData.terrainLayers;
                    newT.basemapDistance                = 150;
                    newT.heightmapPixelError            = 10;
                    newT.terrainData.baseMapResolution  = terrain.terrainData.baseMapResolution  / COUNT_IN_WIDTH;
                    newT.terrainData.alphamapResolution = terrain.terrainData.alphamapResolution / COUNT_IN_WIDTH;
                    newT.terrainData.SetAlphamaps(0, 0,
                        terrain.terrainData.GetAlphamaps(alphaW * wi, alphaL * li, alphaW, alphaL));

                    newT.drawTreesAndFoliage = false;
                    newT.Flush();
                    newT.enabled = true;

#if HAS_UNITY_TERRAIN_TOOLS
                    var atd = terrain.gameObject.GetComponent<AdditionalTerrainData>();
                    if (atd != null)
                        CopyComponent(atd, newGo);
#endif

                    UnityEngine.TerrainCollider tc = terrain.GetComponent<UnityEngine.TerrainCollider>();
                    if (tc != null)
                    {
                        UnityEngine.TerrainCollider nc = newGo.AddComponent<UnityEngine.TerrainCollider>();
                        nc.sharedMaterial = tc.sharedMaterial;
                        nc.terrainData    = newT.terrainData;
                    }

                    newT.transform.position = GetPrefabPos(wi, secWidth, 0, (int)terrainSize.y,
                        li, secLength, terrain);
                    newT.transform.parent = GlobalTempNode.transform;
                }
            }

            EditorUtility.ClearProgressBar();
            return outTerrains;
        }

        static Vector3 GetPrefabPos(int wi, int sw, int hi, int sh, int li, int sl,
            UnityEngine.Terrain terrain)
        {
            return new Vector3(wi * sw, hi * sh, li * sl) + terrain.transform.position;
        }

        static void RefreshRes(TerrainExportData data)
        {
            foreach (string path in data.GetAllPath())
            {
                if (!string.IsNullOrEmpty(path))
                    AssetDatabase.ImportAsset(path);
            }
        }

        static void ClearAssetFiles(string folder)
        {
            string[] files = Directory.GetFiles(folder, "*.asset");
            var assetPaths = new List<string>();
            foreach (string f in files)
                assetPaths.Add(TerrainExportUtility.AbsPath2AssetsPath(f));

            AssetDatabase.DeleteAssets(assetPaths.ToArray(), new List<string>());
        }

        static void CopyComponent<T>(T src, GameObject dst) where T : Component
        {
            T copy = dst.AddComponent<T>();
            foreach (var field in typeof(T).GetFields(
                System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance))
            {
                field.SetValue(copy, field.GetValue(src));
            }
        }
    }
}
