using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace ST.Terrain
{
    public struct VertexKey
    {
        readonly long m_X, m_Y, m_Z;
        const int  TOLERANCE   = 100000;
        const long FNV32_INIT  = 0x811c9dc5;
        const long FNV32_PRIME = 0x01000193;

        public VertexKey(Vector3 position)
        {
            m_X = (long)(Mathf.Round(position.x * TOLERANCE));
            m_Y = (long)(Mathf.Round(position.y * TOLERANCE));
            m_Z = (long)(Mathf.Round(position.z * TOLERANCE));
        }

        public override bool Equals(object obj)
        {
            VertexKey k = (VertexKey)obj;
            return m_X == k.m_X && m_Y == k.m_Y && m_Z == k.m_Z;
        }

        public override int GetHashCode()
        {
            long rv = FNV32_INIT;
            rv ^= m_X; rv *= FNV32_PRIME;
            rv ^= m_Y; rv *= FNV32_PRIME;
            rv ^= m_Z; rv *= FNV32_PRIME;
            return rv.GetHashCode();
        }
    }

    public struct VertexEntry
    {
        public int MeshIndex, TriangleIndex, VertexIndex;
        public VertexEntry(int mi, int ti, int vi)
        { MeshIndex = mi; TriangleIndex = ti; VertexIndex = vi; }
    }

    public static class TerrainMeshExport
    {
        public static int s_DefaultVertexCountX      = 65;
        public static int s_DefaultVertexCountY      = 65;
        public static int s_DefaultSubMeshVertexCount = 8;

        public static void GenerateMesh(TerrainExportData data)
        {
            string runFolder      = TerrainExportPath.GetTerrainOutputPath();
            string assetFolder    = TerrainExportUtility.AbsPath2AssetsPath(runFolder + "/asset/");

            int vx = s_DefaultVertexCountX;
            int vy = s_DefaultVertexCountY;
            int sm = s_DefaultSubMeshVertexCount;

            // LOD0 ── TTM 主网格
            Mesh lod0 = TerrainBridge.exportMesh(data.terrain, vx, vy);
            lod0.RecalculateBounds();
            lod0.RecalculateNormals();
            lod0.RecalculateTangents();

            string lod0Path = string.Format("{0}{1}-Mesh.asset", assetFolder, data.terrain.name);
            AssetDatabase.CreateAsset(lod0, lod0Path);
            data.meshLOD0Path = lod0Path;

            // LOD1/2 ── 降采样平面网格对齐高度
            data.meshLOD1Path = ProcessLODMesh(data, lod0, 33, "Mesh1");
            data.meshLOD2Path = ProcessLODMesh(data, lod0, 17, "Mesh2");

            // LODVT / LODVT1 ── SubMesh 切割（VT 渲染）
            data.meshLODVTPath  = ProcessLODVTMesh(data, lod0, vx, vy, sm,     "MeshVT");
            data.meshLODVT1Path = ProcessLODVTMesh(data, lod0, vx, vy, sm / 2, "MeshVT1");
        }

        static string ProcessLODMesh(TerrainExportData data, Mesh lod0Mesh,
            int vertexCount, string meshName)
        {
            string runFolder   = TerrainExportPath.GetTerrainOutputPath();
            string assetFolder = TerrainExportUtility.AbsPath2AssetsPath(runFolder + "/asset/");
            string outPath     = string.Format("{0}{1}-{2}.asset", assetFolder, data.terrain.name, meshName);

            Mesh mesh = AssetDatabase.LoadAssetAtPath<Mesh>(outPath);
            if (mesh == null)
                mesh = MyMeshHelper.S.CreateMesh(vertexCount, vertexCount);

            MyMeshHelper.S.MergeVerticesHeight(mesh, lod0Mesh,
                lod0Mesh.bounds.size.x, lod0Mesh.bounds.size.z, true);
            mesh.RecalculateTangents();

            if (AssetDatabase.LoadAssetAtPath<Mesh>(outPath) != null)
                EditorUtility.SetDirty(mesh);
            else
                AssetDatabase.CreateAsset(mesh, outPath);

            return outPath;
        }

        static string ProcessLODVTMesh(TerrainExportData data, Mesh lod0Mesh,
            int vx, int vy, int tileCount, string meshName)
        {
            string runFolder   = TerrainExportPath.GetTerrainOutputPath();
            string assetFolder = TerrainExportUtility.AbsPath2AssetsPath(runFolder + "/asset/");
            string outPath     = string.Format("{0}{1}-{2}.asset", assetFolder, data.terrain.name, meshName);

            Mesh mesh = AssetDatabase.LoadAssetAtPath<Mesh>(outPath);
            if (mesh != null)
            {
                SplatMeshHelper.SplitMeshToSubMesh(lod0Mesh, vx, vy, tileCount, mesh);
                mesh.RecalculateBounds();
                mesh.RecalculateNormals();
                mesh.RecalculateTangents();
                RecalculateNormals(mesh, 120f);
                EditorUtility.SetDirty(mesh);
            }
            else
            {
                mesh = SplatMeshHelper.SplitMeshToSubMesh(lod0Mesh, vx, vy, tileCount);
                mesh.RecalculateBounds();
                mesh.RecalculateNormals();
                mesh.RecalculateTangents();
                RecalculateNormals(mesh, 120f);
                EditorUtility.SetDirty(mesh);
                AssetDatabase.CreateAsset(mesh, outPath);
            }
            return outPath;
        }

        /// <summary>
        /// 基于角度阈值重算法线（平滑角度内的面共享法线）
        /// </summary>
        public static void RecalculateNormals(Mesh mesh, float angle)
        {
            float threshold = Mathf.Cos(angle * Mathf.Deg2Rad);
            Vector3[] vertices = mesh.vertices;
            Vector3[] normals  = new Vector3[vertices.Length];
            Vector3[][] triNormals = new Vector3[mesh.subMeshCount][];
            var dict = new Dictionary<VertexKey, List<VertexEntry>>(vertices.Length);

            for (int s = 0; s < mesh.subMeshCount; s++)
            {
                int[] tris = mesh.GetTriangles(s);
                triNormals[s] = new Vector3[tris.Length / 3];

                for (int i = 0; i < tris.Length; i += 3)
                {
                    int i1 = tris[i], i2 = tris[i + 1], i3 = tris[i + 2];
                    Vector3 n = Vector3.Cross(vertices[i2] - vertices[i1], vertices[i3] - vertices[i1]);
                    float mag = n.magnitude;
                    if (mag > 0) n /= mag;

                    int ti = i / 3;
                    triNormals[s][ti] = n;

                    AddEntry(dict, vertices[i1], new VertexEntry(s, ti, i1));
                    AddEntry(dict, vertices[i2], new VertexEntry(s, ti, i2));
                    AddEntry(dict, vertices[i3], new VertexEntry(s, ti, i3));
                }
            }

            foreach (var list in dict.Values)
            {
                for (int i = 0; i < list.Count; i++)
                {
                    var lhs = list[i];
                    Vector3 sum = Vector3.zero;
                    for (int j = 0; j < list.Count; j++)
                    {
                        var rhs = list[j];
                        if (lhs.VertexIndex == rhs.VertexIndex)
                            sum += triNormals[rhs.MeshIndex][rhs.TriangleIndex];
                        else if (Vector3.Dot(
                            triNormals[lhs.MeshIndex][lhs.TriangleIndex],
                            triNormals[rhs.MeshIndex][rhs.TriangleIndex]) >= threshold)
                            sum += triNormals[rhs.MeshIndex][rhs.TriangleIndex];
                    }
                    normals[lhs.VertexIndex] = sum.normalized;
                }
            }
            mesh.normals = normals;
        }

        static void AddEntry(Dictionary<VertexKey, List<VertexEntry>> dict, Vector3 v, VertexEntry e)
        {
            var key = new VertexKey(v);
            if (!dict.TryGetValue(key, out var list))
            {
                list = new List<VertexEntry>(4);
                dict.Add(key, list);
            }
            list.Add(e);
        }
    }
}
