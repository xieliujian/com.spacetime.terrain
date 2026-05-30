using UnityEditor;
using UnityEngine;

namespace ST.Terrain
{
    public class TerrainExportWindow : EditorWindow
    {
        bool m_NeedCollider = false;

        [MenuItem("SpaceTime/Terrain/Export Terrain To Mesh")]
        public static void ShowWindow()
        {
            var win = GetWindow<TerrainExportWindow>("Terrain Export");
            win.minSize = new Vector2(300, 160);
        }

        void OnGUI()
        {
            GUILayout.Label("Terrain → Mesh 导出", EditorStyles.boldLabel);
            EditorGUILayout.Space(6);

            m_NeedCollider = EditorGUILayout.Toggle("LOD0 附加 MeshCollider", m_NeedCollider);
            EditorGUILayout.Space(10);

            GUI.backgroundColor = new Color(0.4f, 0.85f, 0.4f);
            if (GUILayout.Button("Export All Terrains In Scene", GUILayout.Height(44)))
            {
                RunExport(m_NeedCollider);
            }
            GUI.backgroundColor = Color.white;

            EditorGUILayout.Space(6);
            EditorGUILayout.HelpBox(
                "将当前场景中所有激活的 Terrain 组件转换为 Mesh，\n" +
                "导出结果存放于场景同名目录下的 RuntimeTerrainData/ 文件夹内。",
                MessageType.Info);
        }

        static void RunExport(bool needCollider)
        {
            if (TerrainBridge.exportMesh == null)
            {
                EditorUtility.DisplayDialog("导出失败",
                    "TerrainBridge.exportMesh 未注册，请确认 Amazing Assets Terrain To Mesh 插件已正确安装。",
                    "OK");
                return;
            }

            TerrainBridge.needTerrainCollider = needCollider;

            try
            {
                var work = new TerrainExportWork();
                work.Execute();

                AssetDatabase.SaveAssets();
                AssetDatabase.Refresh();

                var tempNode = GameObject.Find(TerrainExportTools.TERRAIN_MESH_ROOT_NAME);
                if (tempNode != null)
                    DestroyImmediate(tempNode);

                EditorUtility.DisplayDialog("导出完成", "Terrain → Mesh 导出成功！", "OK");
            }
            catch (System.Exception e)
            {
                EditorUtility.ClearProgressBar();
                Debug.LogError("[TerrainExport] " + e);
                EditorUtility.DisplayDialog("导出失败", e.Message, "OK");
            }
        }
    }
}
