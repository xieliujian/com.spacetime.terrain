using System.Collections.Generic;
using UnityEngine;

namespace ST.Terrain
{
    public enum EdgeDirection
    {
        Up,
        Bottom,
        Left,
        Right
    }

    public class EdgeRelation
    {
        public EdgeDirection m_NeighbourDirection;
        public GameObject m_NeighbourObject;
        public List<EdgeRelation> m_NeighbourRelationList;

        public EdgeDirection ReversedEdgeDirection
        {
            get
            {
                switch (m_NeighbourDirection)
                {
                    case EdgeDirection.Up:     return EdgeDirection.Bottom;
                    case EdgeDirection.Bottom: return EdgeDirection.Up;
                    case EdgeDirection.Left:   return EdgeDirection.Right;
                    case EdgeDirection.Right:  return EdgeDirection.Left;
                    default:                   return EdgeDirection.Up;
                }
            }
        }
    }
}
