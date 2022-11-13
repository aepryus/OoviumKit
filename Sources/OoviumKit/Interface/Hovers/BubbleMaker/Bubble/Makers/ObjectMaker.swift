//
//  ObjectMaker.swift
//  OoviumKit
//
//  Created by Joe Charlier on 11/13/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class ObjectMaker: Maker {
// Maker ===========================================================================================
    func make(aetherView: AetherView, at: V2) -> Bubble {
        let object: Object = aetherView.aether.create(at: at)
        return ObjectBub(object, aetherView: aetherView)
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
        
        Skin.bubble(path: path, uiColor: UIColor.green, width: 4.0/3.0*Oo.s)
    }
}

