# 疑难杂症

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
