# Terrain 导出工具

## 工具入口

通过 `SceneExportWin`（场景导出窗口）触发，菜单路径：`LingRen/Scene/SceneExport`。

地形导出是整体场景导出流程的一个子步骤，由 `SceneExportWork` 统一调度。

## 核心代码位置

| 文件 | 职责 |
|------|------|
| `Editor/Terrain/TerrainExportWork.cs` | 注册 8 个流水线步骤 |
| `Editor/Terrain/TerrainExportTools.cs` | 主调度、2×2 地形切分、数据结构定义 |
| `Editor/Terrain/TerrainMeshExport.cs` | LOD Mesh 生成（TTM Bridge + LOD模板对齐）|
| `Editor/Terrain/TerrainTextureExport.cs` | Splatmap / Basemap 纹理导出 |
| `Editor/Terrain/TerrainMaterialExport.cs` | Splatmap 与 Basemap 材质创建 |
| `Editor/Terrain/TerrainPrefabExport.cs` | 多 LOD Prefab 组装 |
| `Editor/Terrain/TerrainMeshReCalcNormal.cs` | 相邻地形块边界法线融合 |
| `Editor/Terrain/SplatMeshHelper.cs` | 将 LOD0 Mesh 切割为 N×N SubMesh（VT）|
| `Editor/Terrain/MyMeshHelper.cs` | 将高精度 Mesh 高度同步到低精度 Mesh |

## 关键参数

- 切分数量：`COUNT_IN_WIDTH = 2, COUNT_IN_LENGTH = 2`（每个 Terrain → 4 块）
- LOD0 顶点：`65 × 65`
- LODVT SubMesh tile：`8`（共 64 个 SubMesh）
- LODVT1 SubMesh tile：`4`（共 16 个 SubMesh）
- 默认扇区尺寸：`128m × 128m`

## TTM Bridge 说明

Mesh 的实际生成依赖第三方插件 **Amazing Assets Terrain To Mesh**。  
通过委托模式注入，在编辑器启动时由 `SceneLoadPluginsBridge` 静态构造函数注册：

```csharp
SceneLoadBridge.ttmExportMesh = TTMExportMesh;
// 内部调用：
// AmazingAssets.TerrainToMesh.TerrainToMeshDataExtractor.ExportMesh(width, height, Normal.CalculateFromMesh)
```

## 注意事项

1. LOD1/LOD2 模板 Prefab 来自 `Assets/scene/common/ttm/TTM-Lod1.prefab` 等，必须预先存在于项目中
2. 生成的 Mesh `.asset` 文件最终会被设为不可读（减少运行时内存占用）
3. `TerrainMeshReCalcNormal.FuseSectorNormalInfo()` 在 `SceneOtherExportWork.CalcNormal` 步调用，而非 `TerrainExportWork` 内部
4. `SplatMeshHelper.SplitMeshToSubMesh` 重新排列顶点，保证每个 SubMesh 的顶点索引连续
