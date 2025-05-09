//
//  TypeMaker.swift
//  OoviumKit
//
//  Created by Joe Charlier on 11/13/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class TypeMaker: Maker {
// Maker ===========================================================================================
    func make(aetherView: AetherView, at: V2) -> Bubble {
        let type: Type = aetherView.create(at: at)
        return TypeBub(type, aetherView: aetherView)
    }
    func drawIcon() {
        
        let w: CGFloat = 34*Oo.s
        let p: CGFloat = 3*Oo.s
        let or: CGFloat = 4*Oo.s
        let r: CGFloat = 2*Oo.s
        let lh: CGFloat = 7*Oo.s
        let n: CGFloat = 2
        let q: CGFloat = 3*Oo.s
        
        let x1: CGFloat = 9*Oo.s
        let x2 = x1+q
        let x4 = w/2
        let x7 = w-p
        let x6 = x7-q
        
        let y1: CGFloat = 7*Oo.s+p-1*Oo.s
        let y2 = y1+or
        let y3 = y2+or
        let y4 = y3+n*lh
        
        let path = CGMutablePath()
        path.move(to: CGPoint(x: x6, y: y3))
        path.addArc(tangent1End: CGPoint(x: x6, y: y4), tangent2End: CGPoint(x: x4, y: y4), radius: r)
        path.addArc(tangent1End: CGPoint(x: x2, y: y4), tangent2End: CGPoint(x: x2, y: y3), radius: r)
        path.addLine(to: CGPoint(x: x2, y: y3))
        path.closeSubpath()

        for i in 1..<Int(n) {
            path.move(to: CGPoint(x: x2, y: y3+CGFloat(i)*lh))
            path.addLine(to: CGPoint(x: x6, y: y3+CGFloat(i)*lh))
        }
        
        path.move(to: CGPoint(x: x4, y: y1))
        path.addArc(tangent1End: CGPoint(x: x7, y: y1), tangent2End: CGPoint(x: x7, y: y2), radius: or)
        path.addArc(tangent1End: CGPoint(x: x7, y: y3), tangent2End: CGPoint(x: x4, y: y3), radius: or)
        path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x1, y: y2), radius: or)
        path.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x4, y: y1), radius: or)
        path.closeSubpath()

        Skin.bubble(path: path, uiColor: Text.Color.lavender.uiColor, width: 4.0/3.0*Oo.s)
    }
}
