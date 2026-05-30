using AmazingAssets.TerrainToMesh;
using UnityEditor;
using UnityEngine;

namespace ST.Terrain
{
    [InitializeOnLoad]
    public static class TerrainBridgeSetup
    {
        static TerrainBridgeSetup()
        {
            TerrainBridge.exportMesh = ExportMesh;
            TerrainBridge.exportSplatmapTextures = ExportSplatmapTextures;
            TerrainBridge.exportBaseTexture = ExportBaseTexture;
            TerrainBridge.exportSplatmapMaterial = ExportSplatmapMaterial;
        }

        static Mesh ExportMesh(UnityEngine.Terrain terrain, int vertexCountX, int vertexCountY)
        {
            var extractor = new TerrainToMeshDataExtractor(terrain.terrainData);
            return extractor.ExportMesh(vertexCountX, vertexCountY, Normal.CalculateFromMesh);
        }

        static Texture2D[] ExportSplatmapTextures(UnityEngine.Terrain terrain, bool includeAlpha)
        {
            var extractor = new TerrainToMeshDataExtractor(terrain.terrainData);
            return extractor.ExportSplatmapTextures(terrain.terrainData.alphamapResolution, includeAlpha);
        }

        static Texture2D[] ExportBaseTexture(UnityEngine.Terrain terrain, int size)
        {
            var extractor = new TerrainToMeshDataExtractor(terrain.terrainData);
            Texture2D diffuse = extractor.ExportBasemapDiffuseTexture(size, false, false);
            Texture2D normal  = extractor.ExportBasemapNormalTexture(size, false);
            return new Texture2D[] { diffuse, normal };
        }

        static Material ExportSplatmapMaterial(UnityEngine.Terrain terrain)
        {
            var extractor = new TerrainToMeshDataExtractor(terrain.terrainData);
            return extractor.ExportSplatmapMaterial(false);
        }
    }
}
