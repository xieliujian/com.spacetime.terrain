namespace ST.Terrain
{
    /// <summary>
    /// 地形导出流水线，注册 8 个步骤交由外部调度器依次执行。
    /// </summary>
    public class TerrainExportWork
    {
        public string name = "TerrainExport";

        private System.Collections.Generic.List<(string stepName, System.Action step)> m_Steps
            = new System.Collections.Generic.List<(string, System.Action)>();

        public TerrainExportWork()
        {
            m_Steps.Clear();
            m_Steps.Add(("PreProcess",             TerrainExportTools.PreProcess));
            m_Steps.Add(("CollectProcessTerrain",  TerrainExportTools.CollectProcessTerrain));
            m_Steps.Add(("GenerateMesh",            TerrainExportTools.GenerateMesh));
            m_Steps.Add(("GenerateBaseTexture",     TerrainExportTools.GenerateBaseTexture));
            m_Steps.Add(("GenerateMaterial",        TerrainExportTools.GenerateMaterial));
            m_Steps.Add(("ReRefreshRes",            TerrainExportTools.ReRefreshRes));
            m_Steps.Add(("GeneratePrefab",          TerrainExportTools.GeneratePrefab));
            m_Steps.Add(("Clear",                   TerrainExportTools.Clear));
        }

        public void Execute()
        {
            foreach (var (stepName, step) in m_Steps)
            {
                UnityEngine.Debug.Log($"[TerrainExport] Step: {stepName}");
                step?.Invoke();
            }
        }
    }
}
