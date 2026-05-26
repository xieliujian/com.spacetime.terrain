using System.IO;
using UnityEditor;
using UnityEngine;

namespace ST.Terrain
{
    public enum TextureFileType { PNG, TGA }

    /// <summary>
    /// 地形导出工具函数集合，替代原 SceneLoadUtility / TextureHelper / ScenePathUtils。
    /// </summary>
    public static class TerrainExportUtility
    {
        #region Path Helpers

        /// <summary>
        /// 将绝对路径转换为相对于工程的 Assets/ 路径。
        /// </summary>
        public static string AbsPath2AssetsPath(string absPath)
        {
            string dataPath = Application.dataPath;
            absPath = absPath.Replace("\\", "/");
            dataPath = dataPath.Replace("\\", "/");

            if (absPath.StartsWith(dataPath))
            {
                return "Assets" + absPath.Substring(dataPath.Length);
            }

            int assetsIndex = absPath.IndexOf("/Assets/");
            if (assetsIndex >= 0)
            {
                return absPath.Substring(assetsIndex + 1);
            }

            return absPath;
        }

        /// <summary>
        /// 获取当前场景的目录和名称。
        /// </summary>
        public static (string sceneDir, string sceneName) GetCurrentSceneParts()
        {
            if (TerrainBridge.getSceneParts != null)
                return TerrainBridge.getSceneParts();

            string scenePath = UnityEditor.SceneManagement.EditorSceneManager.GetActiveScene().path;
            if (string.IsNullOrEmpty(scenePath))
                return ("Assets/", "UnknownScene");

            string dir = System.IO.Path.GetDirectoryName(scenePath).Replace("\\", "/");
            if (!dir.EndsWith("/")) dir += "/";
            string name = System.IO.Path.GetFileNameWithoutExtension(scenePath);
            return (dir, name);
        }

        /// <summary>
        /// 确保目录存在；<paramref name="clearExisting"/> 为 true 时若已存在则先删除再创建。
        /// </summary>
        public static bool EnsureDirectory(string parentPath, string folderName, bool clearExisting = false)
        {
            string fullPath = Path.Combine(parentPath, folderName).Replace("\\", "/");

            if (clearExisting && Directory.Exists(fullPath))
            {
                Directory.Delete(fullPath, true);
            }

            if (!Directory.Exists(fullPath))
            {
                Directory.CreateDirectory(fullPath);
                return true;
            }
            return false;
        }

        #endregion

        #region Texture Helpers

        /// <summary>
        /// 将 Texture2D 保存到磁盘文件。
        /// </summary>
        public static void SaveTextureToDisk(Texture2D tex, string fullPath, TextureFileType type)
        {
            byte[] bytes;
            switch (type)
            {
                case TextureFileType.TGA: bytes = tex.EncodeToTGA(); break;
                default:                  bytes = tex.EncodeToPNG(); break;
            }

            string dir = Path.GetDirectoryName(fullPath);
            if (!string.IsNullOrEmpty(dir) && !Directory.Exists(dir))
                Directory.CreateDirectory(dir);

            File.WriteAllBytes(fullPath, bytes);
        }

        /// <summary>
        /// 检查纹理是否有 Alpha 通道（基于 TextureFormat）。
        /// </summary>
        public static bool TextureHasAlpha(Texture2D tex)
        {
            if (tex == null) return false;
            switch (tex.format)
            {
                case TextureFormat.ARGB32:
                case TextureFormat.RGBA32:
                case TextureFormat.ARGB4444:
                case TextureFormat.RGBA4444:
                case TextureFormat.DXT5:
                case TextureFormat.BC7:
                case TextureFormat.ASTC_4x4:
                case TextureFormat.ASTC_5x5:
                case TextureFormat.ASTC_6x6:
                case TextureFormat.ASTC_8x8:
                case TextureFormat.ASTC_10x10:
                case TextureFormat.ASTC_12x12:
                    return true;
                default:
                    return false;
            }
        }

        #endregion
    }
}
