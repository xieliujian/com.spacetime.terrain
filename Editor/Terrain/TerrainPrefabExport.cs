using UnityEditor;
using UnityEngine;
using UnityEngine.Rendering;

namespace ST.Terrain
{
    public static class TerrainPrefabExport
    {
        public static void GeneratePrefab(TerrainExportData data)
        {
            string runFolder   = TerrainExportPath.GetTerrainOutputPath();
            string prefabFolder = TerrainExportUtility.AbsPath2AssetsPath(runFolder + "/prefab/");

            bool needCollider = TerrainBridge.needTerrainCollider;

            GameObject group = new GameObject(data.terrain.name);

            CreateLodObject(data, "_LOD0",  group, prefabFolder, needCollider);
            CreateLodObject(data, "_LOD1",  group, prefabFolder, needCollider);
            CreateLodObject(data, "_LOD2",  group, prefabFolder, needCollider);
            CreateLodObject(data, "_LODVT", group, prefabFolder, needCollider);
            CreateLodObject(data, "_LODVT1",group, prefabFolder, needCollider);

            PrefabUtility.SaveAsPrefabAsset(group, prefabFolder + group.name + ".prefab");
            Object.DestroyImmediate(group);
        }

        static void CreateLodObject(TerrainExportData data, string suffix,
            GameObject group, string prefabFolder, bool needCollider)
        {
            string name = data.terrain.name + suffix;
            GameObject go = new GameObject(name);
            go.layer = 8;

            LightMapStorageHelper lmHelper = go.AddComponent<LightMapStorageHelper>();
            lmHelper.MyLightMapData = new MyLMStruct
            {
                MyLightMapIndex = data.terrain.lightmapIndex
            };
            float sx = 0.5f * data.terrain.lightmapScaleOffset.x;
            float sz = 0.5f * data.terrain.lightmapScaleOffset.y;
            lmHelper.MyLightMapData.MyLightMapOffset = new Vector4(
                sx, sz,
                sx * data.offsetX * 2 + data.terrain.lightmapScaleOffset.z,
                sz * data.offsetY * 2 + data.terrain.lightmapScaleOffset.w);

            MeshRenderer mr = go.AddComponent<MeshRenderer>();
            MeshFilter   mf = go.AddComponent<MeshFilter>();
            mr.shadowCastingMode = ShadowCastingMode.Off;

            Material splatMat = Load<Material>(data.splatMat);
            Material baseMat  = Load<Material>(data.baseMat);
            Material lodHighMat = splatMat != null ? splatMat : baseMat;

            switch (suffix)
            {
                case "_LOD0":
                    mf.sharedMesh     = Load<Mesh>(data.meshLOD0Path);
                    mr.sharedMaterial = lodHighMat;
                    if (needCollider) AddCollider(go, mf.sharedMesh);
                    break;
                case "_LOD1":
                    mf.sharedMesh     = Load<Mesh>(data.meshLOD1Path);
                    mr.sharedMaterial = baseMat;
                    break;
                case "_LOD2":
                    mf.sharedMesh     = Load<Mesh>(data.meshLOD2Path);
                    mr.sharedMaterial = baseMat;
                    break;
                case "_LODVT":
                    mf.sharedMesh = Load<Mesh>(data.meshLODVTPath);
                    AssignMultiMaterial(mr, mf, lodHighMat);
                    if (needCollider) AddCollider(go, mf.sharedMesh);
                    break;
                case "_LODVT1":
                    mf.sharedMesh = Load<Mesh>(data.meshLODVT1Path);
                    AssignMultiMaterial(mr, mf, lodHighMat);
                    if (needCollider) AddCollider(go, mf.sharedMesh);
                    break;
            }

            string lodPrefabPath = prefabFolder + name + ".prefab";
            PrefabUtility.SaveAsPrefabAsset(go, lodPrefabPath);
            Object.DestroyImmediate(go);

            GameObject lodAsset  = Load<GameObject>(lodPrefabPath);
            GameObject lodInst   = PrefabUtility.InstantiatePrefab(lodAsset) as GameObject;
            lodInst.transform.SetParent(group.transform);
        }

        static void AssignMultiMaterial(MeshRenderer mr, MeshFilter mf, Material mat)
        {
            mr.sharedMaterial = mat;
            if (mf.sharedMesh == null) return;
            var mats = new Material[mf.sharedMesh.subMeshCount];
            for (int i = 0; i < mats.Length; i++) mats[i] = mat;
            mr.sharedMaterials = mats;
        }

        static void AddCollider(GameObject go, Mesh mesh)
        {
            if (mesh == null) return;
            MeshCollider col = go.AddComponent<MeshCollider>();
            col.sharedMesh = mesh;
        }

        static T Load<T>(string path) where T : Object
            => AssetDatabase.LoadAssetAtPath<T>(path);
    }
}
