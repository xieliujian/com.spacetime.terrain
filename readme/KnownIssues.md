# 疑难杂症

## LOD 地形接缝问题

### 问题描述

导出的模型地形在 LOD0/LOD1/LOD2 之间存在明显的接缝线，相邻地形块之间有可见的缝隙。

### 问题原因

导出的贴图（Basemap Diffuse、Basemap Normal、Splatmap）默认使用 `Repeat` Wrap 模式，导致边界处采样到对面边缘的像素，产生接缝。

### 解决方案

将所有导出的贴图 Wrap 模式设置为 `Clamp`，确保边界处采样边缘像素而不是对面边缘。

**代码修改位置：** `Editor/Terrain/TerrainTextureExport.cs`

#### 1. Basemap Diffuse 贴图

在 `GenerateBaseTexture` 方法中添加：

```csharp
// 设置 Basemap Diffuse 贴图的 Wrap 模式为 Clamp，消除 LOD 接缝
if (baseTex != null)
{
    string assetPath = TerrainExportUtility.AbsPath2AssetsPath(basePath);
    AssetDatabase.ImportAsset(assetPath);
    var importer = AssetImporter.GetAtPath(assetPath) as TextureImporter;
    if (importer != null)
    {
        importer.wrapMode = TextureWrapMode.Clamp;
        importer.SaveAndReimport();
    }
}
```

#### 2. Basemap Normal 贴图

在 `GenerateBaseTexture` 方法中修改：

```csharp
var importer = AssetImporter.GetAtPath(assetPath) as TextureImporter;
if (importer != null)
{
    importer.textureType = TextureImporterType.NormalMap;
    importer.wrapMode = TextureWrapMode.Clamp;  // 添加此行
    importer.SaveAndReimport();
}
```

#### 3. Splatmap 贴图

在 `GenerateSplatTexture` 方法中修改：

```csharp
var importer = AssetImporter.GetAtPath(assetPath) as TextureImporter;
if (importer != null)
{
    importer.sRGBTexture = false;
    importer.wrapMode = TextureWrapMode.Clamp;  // 添加此行
    importer.SaveAndReimport();
}
```

### 验证方法

1. 重新导出地形
2. 检查导出的贴图 Wrap 模式是否为 `Clamp`
3. 在场景中加载地形，切换到 LOD0/LOD1/LOD2 查看接缝是否消失

### 注意事项

- 贴图压缩设置保持默认，不需要设置为 `Uncompressed`
- 此修改对所有导出的地形贴图生效
- 如果已有导出的地形，需要重新导出以应用此修改

---

## BasemapNormal 法线导出通道错误

**问题描述**

`TerrainBridgeSetup.ExportBaseTexture` 导出的法线贴图颜色不正确，与 `TTMExportBaseTexture` 导出结果不一致。

**根因**

`TerrainToMeshDataExtractor.ExportBasemapNormalTexture(size, swapChannels)` 第二个参数控制是否在内部交换 R/B 通道以还原标准 RGB 法线格式。

- `TTMExportBaseTexture`（`SceneLoadPluginsBridge`）传入 `true` → 通道正确
- `TerrainBridgeSetup.ExportBaseTexture` 传入 `false` → 通道错误（BGRA 顺序）

**修复**

1. `TerrainBridgeSetup.cs` — `ExportBasemapNormalTexture(size, false)` 改为 `(size, true)`
2. `TerrainTextureExport.cs` — 删除 `SwapRBChannels` 调用及整个方法（该方法是对上述错误的补偿，修复源头后不再需要）

**涉及文件**

- `Editor/Terrain/TerrainBridgeSetup.cs`
- `Editor/Terrain/TerrainTextureExport.cs`
