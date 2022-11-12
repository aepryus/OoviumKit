//
//  AlsoMaker.swift
//  OoviumKit
//
//  Created by Joe Charlier on 11/13/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class AlsoMaker: Maker {
// Maker ===========================================================================================
    func make(aetherView: AetherView, at: V2) -> Bubble {
        let also: Also = aetherView.aether.create(at: at)
        return AlsoBub(also, aetherView: aetherView)
    }
    func drawIcon() {
        // Plasma ======================================
        let sw: CGFloat = 12*Oo.s
        
        let x2 = 40*Oo.s/2
        let x1 = x2 - sw/2
        let x3 = x2 + sw/2
        
        let y1: CGFloat = 11*Oo.s
        let y2: CGFloat = 30*Oo.s
        
        let p1: CGPoint = CGPoint(x: x1, y: y1)
        let p2: CGPoint = CGPoint(x: x2, y: y2)
        let p3: CGPoint = CGPoint(x: x3, y: y1)
        
        let c1: CGPoint = CGPoint(x: sw/2 * 1.2, y: sw/2 * 0.3)
        let c4: CGPoint = CGPoint(x: -sw/2 * 1.2, y: sw/2 * 0.3)

        let c2: CGPoint = CGPoint(x: -sw/2 * 0.1, y: sw/2 * 0.5)
        let c3: CGPoint = CGPoint(x: sw/2 * 0.1, y: sw/2 * 0.5)

        let plasma = CGMutablePath()
        plasma.move(to: p1)
        plasma.addCurve(to: p2, control1: p1 + c1, control2: p2 + c2)
        plasma.addCurve(to: p3, control1: p2 + c3, control2: p3 + c4)
        plasma.closeSubpath()

        let color = RGB.tint(color: UIColor.blue, percent: 0.5)
        let c = UIGraphicsGetCurrentContext()!
        c.setFillColor(color.alpha(0.4).cgColor)
        c.setStrokeColor(color.alpha(0.9).cgColor)
        c.addPath(plasma)
        c.drawPath(using: .fillStroke)
        
        // Leafs =======================================
        let path = CGMutablePath()
        path.addRoundedRect(in: CGRect(x: 8*Oo.s, y: 7*Oo.s, width: 24*Oo.s, height: 8*Oo.s), cornerWidth: 4*Oo.s, cornerHeight: 4*Oo.s)
        path.addRoundedRect(in: CGRect(x: 10*Oo.s, y: 20*Oo.s, width: 20*Oo.s, height: 6*Oo.s), cornerWidth: 3*Oo.s, cornerHeight: 3*Oo.s)
        path.addRoundedRect(in: CGRect(x: 10*Oo.s, y: 26*Oo.s, width: 20*Oo.s, height: 6*Oo.s), cornerWidth: 3*Oo.s, cornerHeight: 3*Oo.s)
            
        Skin.bubble(path: path, uiColor: UIColor.blue, width: 4.0/3.0*Oo.s)
    }
}
