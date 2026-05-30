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
                TerrainExportUtility.SaveTextureToDisk(normalTex, normalPath, TextureFileType.PNG);
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
