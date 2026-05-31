using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace ST.Terrain
{
    /// <summary>
    /// 地形 Mesh 法线缝合工具：将相邻地形块边界处的法线平均，消除接缝。
    /// </summary>
    public static class TerrainMeshReCalcNormal
    {
        /// <summary>
        /// 遍历场景中所有已导出的地形块，对相邻块的 LOD0/1/2 边界法线做融合。
        /// 在 SceneOtherExportWork.CalcNormal 步调用。
        /// </summary>
        public static void FuseSectorNormalInfo()
        {
            var allDetailTerrain = new List<GameObject>();

            foreach (GameObject go in Object.FindObjectsOfType<GameObject>())
            {
                if (go.name.StartsWith("Terrain") && go.transform.childCount > 2)
                {
                    allDetailTerrain.Add(go);
                }
            }

            EditorUtility.DisplayProgressBar("FuseSectorNormalInfo", "正在融合法线", 0);
            int count = 0;

            foreach (GameObject item in allDetailTerrain)
            {
                if (!TerrainExportTools.s_ModifyRuntimeTerrain.Contains(item.name))
                    continue;

                List<EdgeRelation> relations = FindNeighbours(item, allDetailTerrain);
                EditorUtility.DisplayProgressBar("FuseSectorNormalInfo",
                    "地块 " + count, (float)count / allDetailTerrain.Count);

                foreach (EdgeRelation rel in relations)
                {
                    MergeNormalForLod(item, rel.m_NeighbourObject, "LOD0");
                    MergeNormalForLod(item, rel.m_NeighbourObject, "LOD1");
                    MergeNormalForLod(item, rel.m_NeighbourObject, "LOD2");
                }
                count++;
            }

            EditorUtility.ClearProgressBar();
        }

        // ─── Private ──────────────────────────────────────────────────────

        static List<EdgeRelation> FindNeighbours(GameObject self, List<GameObject> all)
        {
            var result = new List<EdgeRelation>();
            Vector3 p = self.transform.position;
            TryAddNeighbour(all, new Vector3(p.x,   0, p.z + 128), EdgeDirection.Up,     result);
            TryAddNeighbour(all, new Vector3(p.x,   0, p.z - 128), EdgeDirection.Bottom, result);
            TryAddNeighbour(all, new Vector3(p.x - 128, 0, p.z),   EdgeDirection.Left,   result);
            TryAddNeighbour(all, new Vector3(p.x + 128, 0, p.z),   EdgeDirection.Right,  result);
            return result;
        }

        static void TryAddNeighbour(List<GameObject> all, Vector3 target,
            EdgeDirection dir, List<EdgeRelation> result)
        {
            foreach (GameObject go in all)
            {
                if (go.transform.position.x == target.x &&
                    go.transform.position.z == target.z)
                {
                    result.Add(new EdgeRelation
                    {
                        m_NeighbourDirection = dir,
                        m_NeighbourObject    = go
                    });
                    return;
                }
            }
        }

        static void MergeNormalForLod(GameObject a, GameObject b, string lodTag)
        {
            GameObject goA = FindChildByName(a, lodTag);
            GameObject goB = FindChildByName(b, lodTag);
            if (goA == null || goB == null) return;

            MeshFilter mfA = goA.GetComponent<MeshFilter>();
            MeshFilter mfB = goB.GetComponent<MeshFilter>();
            if (mfA == null || mfB == null) return;

            Mesh mA = mfA.sharedMesh;
            Mesh mB = mfB.sharedMesh;
            if (mA == null || mB == null) return;

            // 获取 mesh 的 asset 路径
            string pathA = AssetDatabase.GetAssetPath(mA);
            string pathB = AssetDatabase.GetAssetPath(mB);
            if (string.IsNullOrEmpty(pathA) || string.IsNullOrEmpty(pathB)) return;

            // 临时启用 Read/Write
            bool wasReadableA = SetMeshReadable(pathA, true);
            bool wasReadableB = SetMeshReadable(pathB, true);

            try
            {
                // 重新加载 mesh 以应用 Read/Write 设置
                AssetDatabase.ImportAsset(pathA);
                AssetDatabase.ImportAsset(pathB);

                mA = mfA.sharedMesh;
                mB = mfB.sharedMesh;

                Vector3[] vA = mA.vertices, nA = mA.normals;
                Vector3[] vB = mB.vertices, nB = mB.normals;
                Vector3 posA = goA.transform.position;
                Vector3 posB = goB.transform.position;

                bool modified = false;

                for (int i = 0; i < nA.Length; i++)
                {
                    if ((int)vA[i].x % 128 != 0 && (int)vA[i].z % 128 != 0) continue;
                    Vector2 wa = new Vector2(posA.x + vA[i].x, posA.z + vA[i].z);

                    for (int j = 0; j < nB.Length; j++)
                    {
                        Vector2 wb = new Vector2(posB.x + vB[j].x, posB.z + vB[j].z);
                        if (System.Math.Abs(wa.x - wb.x) < 0.1f &&
                            System.Math.Abs(wa.y - wb.y) < 0.1f)
                        {
                            nA[i] = nB[j] = (nA[i] + nB[j]) / 2f;
                            modified = true;
                            break;
                        }
                    }
                }

                if (modified)
                {
                    mA.normals = nA;
                    mB.normals = nB;
                }
            }
            finally
            {
                // 恢复原始 Read/Write 设置
                if (!wasReadableA) SetMeshReadable(pathA, false);
                if (!wasReadableB) SetMeshReadable(pathB, false);

                // 重新导入以应用设置
                if (!wasReadableA) AssetDatabase.ImportAsset(pathA);
                if (!wasReadableB) AssetDatabase.ImportAsset(pathB);
            }
        }

        /// <summary>
        /// 设置 Mesh 的 Read/Write 属性。
        /// </summary>
        /// <returns>返回修改前的 Read/Write 状态</returns>
        static bool SetMeshReadable(string assetPath, bool readable)
        {
            ModelImporter importer = AssetImporter.GetAtPath(assetPath) as ModelImporter;
            if (importer == null) return false;

            bool wasReadable = importer.isReadable;
            if (wasReadable != readable)
            {
                importer.isReadable = readable;
                importer.SaveAndReimport();
            }

            return wasReadable;
        }

        static GameObject FindChildByName(GameObject parent, string keyword)
        {
            foreach (Transform t in parent.GetComponentsInChildren<Transform>(true))
            {
                if (!string.IsNullOrEmpty(t.name) && t.name.Contains(keyword))
                    return t.gameObject;
            }
            return null;
        }
    }
}
