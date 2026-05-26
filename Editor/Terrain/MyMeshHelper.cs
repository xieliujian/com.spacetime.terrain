using System;
using System.Collections.Generic;
using UnityEngine;

namespace ST.Terrain
{
    /// <summary>
    /// Mesh 几何辅助工具：LOD 高度对齐、边界扩充、平面 Mesh 创建。
    /// </summary>
    public class MyMeshHelper
    {
        static MyMeshHelper m_Instance;
        public static MyMeshHelper S => m_Instance ?? (m_Instance = new MyMeshHelper());

        // ─── LOD 高度对齐 ─────────────────────────────────────────────────

        /// <summary>
        /// 将高精度 <paramref name="srcMesh"/> 的顶点高度同步到低精度 <paramref name="dstMesh"/>，
        /// 消除 LOD 切换时的接缝。
        /// </summary>
        public void MergeVerticesHeight(Mesh dstMesh, Mesh srcMesh,
            float meshWidth, float meshLength, bool allPoints = false)
        {
            Vector3[] dstV = dstMesh.vertices;
            Vector3[] dstN = dstMesh.normals;
            Vector4[] dstT = dstMesh.tangents;
            Vector2[] dstU = dstMesh.uv;

            Vector3[] srcV = srcMesh.vertices;
            Vector3[] srcN = srcMesh.normals;
            Vector4[] srcT = srcMesh.tangents;
            Vector2[] srcU = srcMesh.uv;

            for (int i = 0; i < dstV.Length; i++)
            {
                if (!allPoints && !IsBorderVertex(meshWidth, meshLength, dstV[i]))
                    continue;

                float srcY    = 0f;
                int   srcIdx  = 0;
                if (FindSrcY(srcV, dstV[i], ref srcY, ref srcIdx))
                {
                    dstV[i]   = new Vector3(dstV[i].x, srcY, dstV[i].z);
                    dstN[i]   = srcN[srcIdx];
                    dstT[i]   = srcT[srcIdx];
                    dstU[i]   = srcU[srcIdx];
                }
                else
                {
                    dstN[i] = new Vector3(0, -1, 0);
                }
            }

            dstMesh.vertices  = dstV;
            dstMesh.normals   = dstN;
            dstMesh.tangents  = dstT;
            dstMesh.uv        = dstU;
            dstMesh.RecalculateBounds();
        }

        // ─── 边界扩充 ─────────────────────────────────────────────────────

        /// <summary>
        /// 对低精度 Mesh 的边界三角形进行细分（仅 LOD1/2 边缘融合用）。
        /// </summary>
        public void ExpandMeshVerticesOfBorder(Mesh inMesh,
            int vWidth, int vLength, int baseLength, bool isSquare, int recursion = 1)
        {
            Vector3[] origVerts = inMesh.vertices;
            int[] origTris      = inMesh.triangles;
            float realW = inMesh.bounds.size.x;
            float realL = inMesh.bounds.size.z;

            var uvs      = new List<Vector2>();
            var finalVDict = new Dictionary<Vector3, int>();
            var finalTList = new List<int>();

            int triCount = origTris.Length / 3;
            int index    = 0;

            for (int i = 0; i < triCount; i++)
            {
                int sqIdx = i / 2;
                bool isBorder = IsTriangleBorder(triCount, vWidth - 1, vLength - 1,
                    sqIdx, baseLength, isSquare);

                Vector3[] tri = {
                    origVerts[origTris[i * 3]],
                    origVerts[origTris[i * 3 + 1]],
                    origVerts[origTris[i * 3 + 2]]
                };

                if (!isBorder)
                {
                    index = AddTriangle(finalVDict, finalTList, uvs, index, realW, realL, tri);
                }
                else
                {
                    var children = new List<Vector3[]>();
                    index = SubdivideTriangle(finalVDict, finalTList, uvs, index, realW, realL, tri, children);

                    for (int r = 1; r < recursion; r++)
                    {
                        var next = new List<Vector3[]>();
                        foreach (var child in children)
                            index = SubdivideTriangle(finalVDict, finalTList, uvs, index, realW, realL, child, next);
                        children = next;
                    }
                }
            }

            inMesh.vertices  = GetVertexArray(finalVDict);
            inMesh.triangles = finalTList.ToArray();
            inMesh.uv        = uvs.ToArray();
            inMesh.RecalculateBounds();
            inMesh.RecalculateNormals();
            inMesh.RecalculateTangents();
        }

        // ─── 简单平面 Mesh 创建 ───────────────────────────────────────────

        public Mesh CreateMesh(int width, int length)
        {
            Mesh mesh = new Mesh();
            int vw = width, vl = length;

            var verts   = new Vector3[vw * vl];
            var uvs     = new Vector2[vw * vl];
            var indices = new int[(vw - 1) * (vl - 1) * 6];
            int vi = 0, ii = 0;

            for (int z = 0; z < vl; z++)
                for (int x = 0; x < vw; x++)
                {
                    verts[vi] = new Vector3(x, 0, z);
                    uvs[vi]   = new Vector2(x / (float)vw, z / (float)vl);
                    vi++;
                }

            for (int i = 0; i < vw - 1; i++)
                for (int j = 0; j < vl - 1; j++)
                {
                    indices[ii++] = i * vl + j;
                    indices[ii++] = (i + 1) * vl + j;
                    indices[ii++] = (i + 1) * vl + j + 1;
                    indices[ii++] = i * vl + j;
                    indices[ii++] = (i + 1) * vl + j + 1;
                    indices[ii++] = i * vl + j + 1;
                }

            mesh.vertices     = verts;
            mesh.uv           = uvs;
            mesh.indexFormat  = UnityEngine.Rendering.IndexFormat.UInt32;
            mesh.SetTriangles(indices, 0);
            mesh.bounds = new Bounds(
                new Vector3(vw * .5f, 0, vl * .5f),
                new Vector3(vw, 100, vl));
            return mesh;
        }

        // ─── Private helpers ──────────────────────────────────────────────

        bool IsBorderVertex(float w, float l, Vector3 v)
            => v.x <= 0.01f || v.x >= w - 0.01f || v.z <= 0.01f || v.z >= l - 0.01f;

        bool FindSrcY(Vector3[] srcVerts, Vector3 target, ref float srcY, ref int index)
        {
            float tx = (int)(target.x + 0.5f);
            float tz = (int)(target.z + 0.5f);
            for (int i = 0; i < srcVerts.Length; i++)
            {
                if (Math.Abs(srcVerts[i].x - tx) < 0.1f &&
                    Math.Abs(srcVerts[i].z - tz) < 0.1f)
                {
                    srcY  = srcVerts[i].y;
                    index = i;
                    return true;
                }
            }
            return false;
        }

        bool IsTriangleBorder(int total, int wSq, int lSq, int sqIdx, int baseLen, bool isSquare)
        {
            if (sqIdx < lSq) return true;
            if (sqIdx >= total / 2 - lSq) return true;

            int step = 4 * 2 + (baseLen - 2);
            if (isSquare)
            {
                if (sqIdx % lSq == 0 || (sqIdx + 1) % lSq == 0) return true;
            }
            else
            {
                int rel = sqIdx - lSq;
                if (rel >= 0 && sqIdx <= total / 2 - lSq)
                {
                    int m = rel % step;
                    if (m <= 3 || m >= step - 4) return true;
                    m = (rel - step) % step;
                    if (m <= -1 && m >= -4) return true;
                }
            }
            return false;
        }

        int AddTriangle(Dictionary<Vector3, int> dict, List<int> tList,
            List<Vector2> uvs, int index, float w, float l, Vector3[] tri)
        {
            foreach (Vector3 v in tri)
            {
                if (TryAdd(dict, v, index))
                { uvs.Add(new Vector2(v.x / w, v.z / l)); index++; }
                tList.Add(dict[v]);
            }
            return index;
        }

        int SubdivideTriangle(Dictionary<Vector3, int> dict, List<int> tList,
            List<Vector2> uvs, int index, float w, float l,
            Vector3[] tri, List<Vector3[]> children)
        {
            Vector3 v01 = (tri[0] + tri[1]) * .5f;
            Vector3 v12 = (tri[1] + tri[2]) * .5f;
            Vector3 v02 = (tri[0] + tri[2]) * .5f;

            foreach (Vector3 v in new[] { tri[0], tri[1], tri[2], v01, v12, v02 })
                if (TryAdd(dict, v, index))
                { uvs.Add(new Vector2(v.x / w, v.z / l)); index++; }

            void AddTri(Vector3 a, Vector3 b, Vector3 c, Vector3[] ch)
            {
                tList.Add(dict[a]); tList.Add(dict[b]); tList.Add(dict[c]);
                children.Add(ch);
            }

            AddTri(tri[0], v01, v02, new[] { tri[0], v01, v02 });
            AddTri(v01, tri[1], v12, new[] { v01, tri[1], v12 });
            AddTri(tri[2], v02, v12, new[] { tri[2], v02, v12 });
            AddTri(v02, v01, v12,   new[] { v02, v01, v12 });

            return index;
        }

        bool TryAdd(Dictionary<Vector3, int> dict, Vector3 v, int index)
        {
            if (dict.ContainsKey(v)) return false;
            dict.Add(v, index);
            return true;
        }

        Vector3[] GetVertexArray(Dictionary<Vector3, int> dict)
        {
            Vector3[] result = new Vector3[dict.Count];
            foreach (var kv in dict) result[kv.Value] = kv.Key;
            return result;
        }
    }

    /// <summary>Mesh 克隆扩展方法</summary>
    public static class MeshExtensions
    {
        public static Mesh Clone(this Mesh mesh)
        {
            var copy = new Mesh();
            foreach (var p in typeof(Mesh).GetProperties())
                if (p.GetSetMethod() != null)
                    p.SetValue(copy, p.GetValue(mesh, null), null);
            return copy;
        }
    }
}
