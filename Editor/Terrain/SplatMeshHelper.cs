using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace ST.Terrain
{
    /// <summary>
    /// 将 LOD0 Mesh 按 tile 切割为多 SubMesh，用于 VT（虚拟纹理）渲染。
    /// SubMesh 顺序（列优先）:
    ///   56 57 ... 63
    ///    ...
    ///    8  9 ... 15
    ///    0  1 ...  7
    /// </summary>
    public static class SplatMeshHelper
    {
        [MenuItem("Assets/ST/Terrain/SplitMeshVT")]
        static void SplitMeshVTMenu()
        {
            if (Selection.activeObject == null) return;
            string path = AssetDatabase.GetAssetPath(Selection.activeObject);
            Mesh mesh = AssetDatabase.LoadAssetAtPath<Mesh>(path);
            if (mesh == null) return;

            Mesh newMesh = SplitMeshToSubMesh(mesh, 65, 65, 8);
            AssetDatabase.CreateAsset(newMesh, path.Replace(".asset", "VT.asset"));
        }

        /// <summary>在已有 Mesh 上原地切分（更新 outMesh）</summary>
        public static Mesh SplitMeshToSubMesh(Mesh mesh, int vRowCount, int vColCount,
            int tileCount, Mesh outMesh)
        {
            BuildSubMeshData(mesh, vRowCount, vColCount, tileCount,
                out var verts, out var norms, out var tangs, out var uvs,
                out var indices, out int rowCount, out int colCount);

            outMesh.Clear();
            outMesh.vertices = verts;
            outMesh.normals  = norms;
            outMesh.uv       = uvs;
            outMesh.subMeshCount = rowCount * colCount;
            AssignSubMeshIndices(outMesh, indices, rowCount, colCount, tileCount);
            return outMesh;
        }

        /// <summary>创建新 Mesh 并切分</summary>
        public static Mesh SplitMeshToSubMesh(Mesh mesh, int vRowCount, int vColCount, int tileCount)
        {
            BuildSubMeshData(mesh, vRowCount, vColCount, tileCount,
                out var verts, out var norms, out var tangs, out var uvs,
                out var indices, out int rowCount, out int colCount);

            Mesh newMesh = new Mesh();
            newMesh.vertices = verts;
            newMesh.normals  = norms;
            newMesh.uv       = uvs;
            newMesh.subMeshCount = rowCount * colCount;
            AssignSubMeshIndices(newMesh, indices, rowCount, colCount, tileCount);
            return newMesh;
        }

        // ─── Private ──────────────────────────────────────────────────────

        static void BuildSubMeshData(Mesh mesh, int vRowCount, int vColCount, int tileCount,
            out Vector3[] outVerts, out Vector3[] outNorms, out Vector4[] outTangs,
            out Vector2[] outUVs, out List<int> outIndices,
            out int rowCount, out int colCount)
        {
            rowCount = vRowCount / tileCount;
            colCount = vColCount / tileCount;

            Vector3[] srcVerts  = mesh.vertices;
            Vector3[] srcNorms  = mesh.normals;
            Vector4[] srcTangs  = mesh.tangents;
            Vector2[] srcUVs    = mesh.uv;

            var verts   = new List<Vector3>();
            var norms   = new List<Vector3>();
            var tangs   = new List<Vector4>();
            var uvs     = new List<Vector2>();
            var indices = new List<int>();

            for (int c = 0; c < colCount; c++)
                for (int r = 0; r < rowCount; r++)
                    CollectTileData(vRowCount, vColCount, r, c, tileCount,
                        srcVerts, srcNorms, srcTangs, srcUVs,
                        verts, norms, tangs, uvs, indices);

            outVerts   = verts.ToArray();
            outNorms   = norms.ToArray();
            outTangs   = tangs.ToArray();
            outUVs     = uvs.ToArray();
            outIndices = indices;
        }

        static void AssignSubMeshIndices(Mesh mesh, List<int> indices,
            int rowCount, int colCount, int tileCount)
        {
            int stride = tileCount * tileCount * 2 * 3;
            for (int c = 0; c < colCount; c++)
            {
                for (int r = 0; r < rowCount; r++)
                {
                    int sub = r * colCount + c;
                    mesh.SetIndices(indices, sub * stride, stride,
                        MeshTopology.Triangles, sub);
                }
            }
        }

        /// <summary>
        /// 每个 tile 独立顶点（不共享），确保顶点索引连续，避免 GPU 多余顶点拉取。
        /// </summary>
        static void CollectTileData(int vRowCount, int vColCount,
            int tileRow, int tileCol, int tileCount,
            Vector3[] verts, Vector3[] norms, Vector4[] tangs, Vector2[] uvs,
            List<Vector3> outV, List<Vector3> outN, List<Vector4> outT,
            List<Vector2> outU, List<int> outI)
        {
            int startRow  = tileCount * tileRow;
            int startCol  = tileCount * tileCol;
            int baseIndex = outV.Count;

            for (int c = 0; c <= tileCount; c++)
            {
                for (int r = 0; r <= tileCount; r++)
                {
                    int idx = (startRow + r) * vColCount + startCol + c;
                    outV.Add(verts[idx]);
                    outN.Add(norms[idx]);
                    outU.Add(uvs[idx]);
                    outT.Add(tangs[idx]);
                }
            }

            for (int c = 0; c < tileCount; c++)
            {
                for (int r = 0; r < tileCount; r++)
                {
                    int ld = baseIndex + c * (tileCount + 1) + r;
                    int lt = ld + 1;
                    int rd = ld + (tileCount + 1);
                    int rt = rd + 1;

                    outI.Add(ld); outI.Add(rt); outI.Add(lt);
                    outI.Add(ld); outI.Add(rd); outI.Add(rt);
                }
            }
        }
    }
}
