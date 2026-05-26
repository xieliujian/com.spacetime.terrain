using UnityEngine;

namespace ST.Terrain
{
    [System.Serializable]
    public struct MyLMStruct
    {
        public int MyLightMapIndex;
        public Vector4 MyLightMapOffset;
    }

    /// <summary>
    /// 存储地形分块 Prefab 的 Lightmap 信息，因为切分地形时 LightMap 信息会丢失。
    /// </summary>
    public class LightMapStorageHelper : MonoBehaviour
    {
        public MyLMStruct MyLightMapData;
    }
}
