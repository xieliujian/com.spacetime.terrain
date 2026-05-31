# com.spacetime.terrain

Unity Terrain → Mesh 导出管线，用于大规模场景渲染。

## 功能概述

将场景中的 Unity `Terrain` 对象导出为运行时可用的 LOD Mesh Prefab，整合到流式加载场景的 `RuntimeTerrainData` 目录中。

## 导出流水线

`TerrainExportWork` 注册以下 8 个步骤：

| 步骤 | 方法 | 说明 |
|------|------|------|
| 1 | `PreProcess` | 清空缓存目录，初始化输出文件夹（texture / asset / mat / prefab） |
| 2 | `CollectProcessTerrain` | 遍历场景 Terrain，按 2×2 切分为子块，生成 Splatmap 纹理 |
| 3 | `GenerateMesh` | 通过 TTM Bridge 生成 LOD0(65×65)，并生成 LOD1/LOD2/LODVT/LODVT1 |
| 4 | `GenerateBaseTexture` | 导出 BasemapDiffuse + BasemapNormal 纹理（512 或 2048） |
| 5 | `GenerateMaterial` | 创建 Splatmap 材质与 Basemap 材质，绑定所有纹理和 Shader 参数 |
| 6 | `ReRefreshRes` | 强制 ImportAsset 刷新所有生成的资源 |
| 7 | `GeneratePrefab` | 组装 LOD Prefab（每块含 LOD0/LOD1/LOD2/LODVT/LODVT1 子对象） |
| 8 | `Clear` | 将生成的 `.asset` 设为不可读（`m_IsReadable: 0`），减少运行时内存 |

## Mesh LOD 说明

| LOD | 顶点数 | SubMesh | 材质 | 用途 |
|-----|--------|---------|------|------|
| LOD0 | 65×65 | 1 | Splatmap | 近距离高精度 |
| LOD1 | 模板对齐 | 1 | Basemap | 中距离 |
| LOD2 | 模板对齐 | 1 | Basemap | 远距离 |
| LODVT | 65×65 | 64 (8×8 tile) | Splatmap | VT 渲染 |
| LODVT1 | 65×65 | 16 (4×4 tile) | Splatmap | VT 渲染（低精度）|

## 输出目录结构

```
{SceneDir}/{SceneName}/RuntimeTerrainData/
├── texture/    ← Splatmap / Basemap 纹理
├── asset/      ← Mesh .asset 文件
├── mat/        ← 材质文件
└── prefab/     ← LOD Prefab
```

## 包结构

```
com.spacetime.terrain/
├── package.json
├── README.md
├── Runtime/
│   ├── com.spacetime.terrain.runtime.asmdef
│   └── Scripts/
├── Editor/
│   ├── com.spacetime.terrain.editor.asmdef
│   └── Terrain/
│       ├── TerrainExportWork.cs        ← 流水线编排
│       ├── TerrainExportTools.cs       ← 主调度 + 2×2 切分 + 数据类
│       ├── TerrainMeshExport.cs        ← Mesh/LOD 生成
│       ├── TerrainTextureExport.cs     ← 纹理导出
│       ├── TerrainMaterialExport.cs    ← 材质生成
│       ├── TerrainPrefabExport.cs      ← Prefab 组装
│       ├── TerrainMeshReCalcNormal.cs  ← 跨块法线缝合
│       ├── SplatMeshHelper.cs          ← VT SubMesh 切割工具
│       └── MyMeshHelper.cs             ← LOD 高度对齐工具
├── Shaders/
│   └── com.spacetime.terrain.shaders.asmdef
└── readme/
```

## 依赖

- `com.lingren.sceneload` — 提供 `SceneLoadBridge`（TTM 导出委托注入点）、`SceneLoadUtility`、`ExportWork` 基类等
- `Amazing Assets Terrain To Mesh` — 第三方插件，通过 `SceneLoadPluginsBridge` 注入 `SceneLoadBridge.ttmExportMesh`

## 使用方式

`TerrainExportWork` 由 `SceneExportWork` 中的 `ExportWorkScheduler` 统一调度，通过场景导出窗口（`SceneExportWin`）触发。

## 疑难杂症

见 [readme/KnownIssues.md](readme/KnownIssues.md)。
