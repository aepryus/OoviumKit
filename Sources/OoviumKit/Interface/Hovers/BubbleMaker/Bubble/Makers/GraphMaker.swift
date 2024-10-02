//
//  GraphMaker.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/14/23.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit
import OoviumEngine

class GraphMaker: Maker {
// Maker ===========================================================================================
    func make(aetherView: AetherView, at: V2) -> Bubble {
        let graph: Graph = aetherView.create(at: at)
        return GraphBub(graph, aetherView: aetherView)
    }
    func drawIcon() {
        let bw = 20*Oo.s
        let bh = 20*Oo.s
        let r: CGFloat = 6*Oo.s

        let x1 = bw-10*Oo.s
        let x2 = bw
        let x3 = bw+10*Oo.s
        
        let y1 = bh-8*Oo.s
        let y2 = bh
        let y3 = bh+8*Oo.s
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: x1, y: y2))
        path.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x2, y: y1), radius: r)
        path.addArc(tangent1End: CGPoint(x: x3, y: y1), tangent2End: CGPoint(x: x3, y: y2), radius: r)
        path.addArc(tangent1End: CGPoint(x: x3, y: y3), tangent2End: CGPoint(x: x2, y: y3), radius: r)
        path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x1, y: y2), radius: r)
        path.closeSubpath()
        
        Skin.bubble(path: path, uiColor: OOColor.cobolt.uiColor, width: 4.0/3.0*Oo.s)
    }
}
