using UnityEditor;
using UnityEngine;
#if HAS_UNITY_TERRAIN_TOOLS
using UnityEngine.TerrainTools;
#endif

namespace ST.Terrain
{
    public static class TerrainTextureExport
    {
        public static void GenerateBaseTexture(TerrainExportData data)
        {
            string textureFolder = TerrainExportPath.GetTerrainOutputPath() + "/texture";

            int size = 512;
#if HAS_UNITY_TERRAIN_TOOLS
            var atd = data.terrain.gameObject.GetComponent<AdditionalTerrainData>();
            if (atd != null && atd.hightBaseTex.Count > 0)
            {
                foreach (var entry in atd.hightBaseTex)
                {
                    if (entry.x == (int)(data.offsetX * 2) &&
                        entry.y == (int)(data.offsetY * 2))
                    {
                        size = 2048;
                        break;
                    }
                }
            }
#endif

            Texture2D[] texs = TerrainBridge.exportBaseTexture(data.terrain, size);
            Texture2D baseTex   = texs != null ? texs[0] : null;
            Texture2D normalTex = texs != null ? texs[1] : null;

            string basePath   = string.Format("{0}/{1}-Basemap-Diffuse.png",   textureFolder, data.terrain.name);
            string normalPath = string.Format("{0}/{1}-Basemap-Normal.png",    textureFolder, data.terrain.name);

            if (baseTex   != null) TerrainExportUtility.SaveTextureToDisk(baseTex,   basePath,   TextureFileType.PNG);
            if (normalTex != null)
            {
                Texture2D fixed_normal = SwapRBChannels(normalTex);
                TerrainExportUtility.SaveTextureToDisk(fixed_normal, normalPath, TextureFileType.PNG);
                string assetPath = TerrainExportUtility.AbsPath2AssetsPath(normalPath);
                AssetDatabase.ImportAsset(assetPath);
                var importer = AssetImporter.GetAtPath(assetPath) as TextureImporter;
                if (importer != null)
                {
                    importer.textureType = TextureImporterType.NormalMap;
                    importer.SaveAndReimport();
                }
            }

            data.baseTexPath   = basePath;
            data.normalTexPath = normalPath;
        }

        // TTM ExportBasemapNormalTexture 输出 BGRA 通道顺序，需要交换 R/B 还原为标准 RGB 法线
        static Texture2D SwapRBChannels(Texture2D src)
        {
            Color32[] pixels = src.GetPixels32();
            for (int i = 0; i < pixels.Length; i++)
            {
                byte r = pixels[i].r;
                pixels[i].r = pixels[i].b;
                pixels[i].b = r;
            }
            var dst = new Texture2D(src.width, src.height, TextureFormat.RGBA32, false, true);
            dst.SetPixels32(pixels);
            dst.Apply();
            return dst;
        }

        public static void GenerateSplatTexture(UnityEngine.Terrain terrain)
        {
            string textureFolder = TerrainExportPath.GetTerrainOutputPath() + "/texture";
            Texture2D[] splatTextures = TerrainBridge.exportSplatmapTextures(terrain, true);
            if (splatTextures == null) return;

            for (int i = 0; i < splatTextures.Length; i++)
            {
                string path = string.Format("{0}/{1}-Splatmap-{2}.tga", textureFolder, terrain.name, i);
                TerrainExportUtility.SaveTextureToDisk(splatTextures[i], path, TextureFileType.TGA);
            }
        }
    }
}
