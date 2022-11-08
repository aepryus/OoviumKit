//
//  OoviBub.swift
//  Oovium
//
//  Created by Joe Charlier on 10/24/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class OoviMaker: Maker {
	
// Maker ===========================================================================================
	func make(aetherView: AetherView, at: V2) -> Bubble {
        let oovi: Oovi = aetherView.aether.create(at: at)
		return OoviBub(oovi, aetherView: aetherView)
	}
	func drawIcon() {
		let r: CGFloat = 4.0/1.5*Oo.s
		let p: CGFloat = 3.0/1.5*Oo.s
		let n = 1.0
		
		let or: CGFloat = 4.5/1.5*Oo.s
		
		let rw: CGFloat = 16.0/1.5*Oo.s
		let tw: CGFloat = 12.0/1.5*Oo.s
		let cw: CGFloat = 12.0/1.5*Oo.s
		let sh: CGFloat = 6.0/1.5*Oo.s
		
		let low: CGFloat = 80.0/4/1.5*Oo.s
		let liw:CGFloat = 16.0/1.5*Oo.s
		let row: CGFloat = 80.0/4/1.5*Oo.s
		let riw: CGFloat = 65.0/4/1.5*Oo.s
		
		let vo: CGFloat = 35.0/4/1.5*Oo.s
		let ro: CGFloat = -4.0/1.5*Oo.s
		
		let x3 = p+max(tw,max(cw,low))+7.0/1.5*Oo.s
		let x6 = x3-cw
		let x7 = x3+cw
		let x8 = x3-low
		let x9 = x3-liw
		let x10 = x3+riw
		let x11 = x3+row
		let x12 = x3+ro
		let x14 = x12+rw
		let x13 = (x12+x14)/2
		let x15 = x3-vo
		let x16 = x15+50.0/4/1.5*Oo.s
		var x17 = x15+60.0/4/1.5*Oo.s
		
		let y4: CGFloat = p+7.0/1.5*Oo.s
		let y5 = y4+or
		let y6 = y5+or
		let y7 = y6+sh
		let y8 = y7+or
		let y9 = y8+or
		let y10 = y9+sh
		let y11 = y10+or
		let y12 = y11+or
		let y13 = (y4+y8)/2
		let y14 = (y6+y8)/2
		let y15 = (y4+y11)/2
		let y16 = (y6+y11)/2
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x3, y: y4))
		path.addArc(tangent1End: CGPoint(x: x7, y: y4), tangent2End: CGPoint(x: x7, y: y5), radius: r)
		path.addArc(tangent1End: CGPoint(x: x7, y: y6), tangent2End: CGPoint(x: x3, y: y6), radius: r)
		path.addArc(tangent1End: CGPoint(x: x6, y: y6), tangent2End: CGPoint(x: x6, y: y5), radius: r)
		path.addArc(tangent1End: CGPoint(x: x6, y: y4), tangent2End: CGPoint(x: x3, y: y4), radius: r)
		path.closeSubpath()
		
		// Result ======================================
		path.move(to: CGPoint(x: x12, y: y8))
		path.addArc(tangent1End: CGPoint(x: x12, y: y7), tangent2End: CGPoint(x: x13, y: y7), radius: r)
		path.addArc(tangent1End: CGPoint(x: x14, y: y7), tangent2End: CGPoint(x: x14, y: y8), radius: r)
		path.addArc(tangent1End: CGPoint(x: x14, y: y9), tangent2End: CGPoint(x: x13, y: y9), radius: r)
		path.addArc(tangent1End: CGPoint(x: x12, y: y9), tangent2End: CGPoint(x: x12, y: y8), radius: r)
		path.closeSubpath()
		
		// Vertebrae ===================================
		
		for i in 0..<Int(n) {
			let i: CGFloat = CGFloat(i)
			x17 = x15 + (30.0*Oo.s-2*p)/1.5
			path.move(to: CGPoint(x: x15, y: y11+2*or*i))
			path.addArc(tangent1End: CGPoint(x: x15, y: y10+2*or*i), tangent2End: CGPoint(x: x16, y: y10+2*or*i), radius: r)
			path.addArc(tangent1End: CGPoint(x: x17, y: y10+2*or*i), tangent2End: CGPoint(x: x17, y: y11+2*or*i), radius: r)
			path.addArc(tangent1End: CGPoint(x: x17, y: y12+2*or*i), tangent2End: CGPoint(x: x16, y: y12+2*or*i), radius: r)
			path.addArc(tangent1End: CGPoint(x: x15, y: y12+2*or*i), tangent2End: CGPoint(x: x15, y: y11+2*or*i), radius: r)
			path.closeSubpath()
		}
		
		let arrow = CGMutablePath()
		arrow.move(to: CGPoint(x: x3, y: y4))
		arrow.addQuadCurve(to: CGPoint(x: x8, y: y15), control: CGPoint(x: x8, y: y4))
		arrow.addQuadCurve(to: CGPoint(x: x16, y: y11), control: CGPoint(x: x8, y: y11))
		arrow.addQuadCurve(to: CGPoint(x: x9, y: y16), control: CGPoint(x: x9, y: y11))
		arrow.addQuadCurve(to: CGPoint(x: x3, y: y6), control: CGPoint(x: x9, y: y6))
		arrow.addQuadCurve(to: CGPoint(x: x10, y: y14), control: CGPoint(x: x10, y: y6))
		arrow.addQuadCurve(to: CGPoint(x: x12+9*Oo.s, y: y8), control: CGPoint(x: x10, y: y8))
		arrow.addQuadCurve(to: CGPoint(x: x11, y: y13), control: CGPoint(x: x11, y: y8))
		arrow.addQuadCurve(to: CGPoint(x: x3, y: y4), control: CGPoint(x: x11, y: y4))
		arrow.closeSubpath()
		
		let color = RGB.tint(color: UIColor(red: 135/255, green: 164/255, blue: 91/255, alpha: 1), percent: 0.5)
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(color.alpha(0.4).cgColor)
		c.setStrokeColor(color.alpha(0.9).cgColor)
		c.addPath(arrow)
		c.drawPath(using: .fillStroke)
		
		Skin.bubble(path: path, uiColor: UIColor(red: 135/255, green: 164/255, blue: 91/255, alpha: 1), width: 4.0/3.0*Oo.s)
	}
}

public class OoviBub: Bubble, ChainLeafDelegate {
	
	let oovi: Oovi
	
	var ooviLeaf: OoviLeaf!
	var traitsLeaf: VarsLeaf!
	var seesLeaf: VarsLeaf!
	var statusLeaf: VarsLeaf!
	var otherLeaf: VarsLeaf!
	var stepLeaf: ChainLeaf!
	var amorousLeaf: ChainLeaf!
	
	public var onOKEV: ((Oovi)->())? = nil
	
	init(_ oovi: Oovi, aetherView: AetherView) {
		self.oovi = oovi
		
        super.init(aetherView: aetherView, aexel: oovi, origin: CGPoint(x: self.oovi.x, y: self.oovi.y), size: CGSize(width: 500, height: 300))
		
		self.backgroundColor = UIColor.clear

		ooviLeaf = OoviLeaf(bubble: self, oovi: oovi)
		traitsLeaf = VarsLeaf(bubble: self, names: ["speed", "energy", "vision", "attack", "armor", "health"], oovi: oovi)
		seesLeaf = VarsLeaf(bubble: self, names: ["fruits", "mates", "friends", "enemies"], oovi: oovi)
		statusLeaf = VarsLeaf(bubble: self, names: ["capacity", "remaining", "used"], oovi: oovi)
		otherLeaf = VarsLeaf(bubble: self, names: ["gender", "pregnant", "damage"], oovi: oovi)

		amorousLeaf = ChainLeaf(bubble: self, hitch: .left, anchor: CGPoint(x: 170, y: 228), size: CGSize(width: 49, height: 36), delegate: self)
		amorousLeaf.chain = oovi.amorousChain
		amorousLeaf.minWidth = 110
		amorousLeaf.radius = 15
		amorousLeaf.placeholder = "amorous?"

		stepLeaf = ChainLeaf(bubble: self, hitch: .left, anchor: CGPoint(x: 196, y: 278), size: CGSize(width: 100, height: 36), delegate: self)
		stepLeaf.chain = oovi.stepChain
		stepLeaf.minWidth = 110
		stepLeaf.radius = 15
		stepLeaf.placeholder = "action"

		let vh: CGFloat = 20
		let p: CGFloat = 9
		let sh: CGFloat = 8

		ooviLeaf.anchor = CGPoint(x: 0, y: 121)
		ooviLeaf.size = CGSize(width: 169, height: 100)
		add(leaf: ooviLeaf)
		
		var x: CGFloat = 169+(47+p)/2

		var w: CGFloat = 47+p
		traitsLeaf.anchor = CGPoint(x: x-w/2, y: sh*3)
		traitsLeaf.size = CGSize(width: w, height: vh*6+2*2)
		add(leaf: traitsLeaf)
		x += 81
		
		w = 55+p
		seesLeaf.anchor = CGPoint(x: x-w/2, y: sh*2)
		seesLeaf.size = CGSize(width: w, height: vh*4+2*2)
		add(leaf: seesLeaf)
		x += 88
		
		w = 64+p
		statusLeaf.anchor = CGPoint(x: x-w/2, y: sh)
		statusLeaf.size = CGSize(width: w, height: vh*3+2*2)
		add(leaf: statusLeaf)
		x += 88
		
		w = 59+p
		otherLeaf.anchor = CGPoint(x: x-w/2, y: 0)
		otherLeaf.size = CGSize(width: w, height: vh*3+2*2)
		add(leaf: otherLeaf)

		add(leaf: amorousLeaf)
		add(leaf: stepLeaf)

		setLeavesNeedLayout()
		layoutLeavesIfNeeded()

		// Plasma ===========
		plasma = CGMutablePath()
		guard let plasma = plasma else { return }
		let d: CGFloat = 3.5
		x = 169+(47+p)/2
		w = 47+p
		let a: CGFloat = 20

		// Step 1
		let a1 = CGPoint(x: 169*1/4, y: 121+50)
		let a2 = CGPoint(x: 169*2/4, y: 121+50)
		let a3 = CGPoint(x: 169*3/4, y: 121+50)
		
		let b1 = CGPoint(x: 170+49/2, y: 210+36/2)
		let b2 = CGPoint(x: 196+100/2, y: 260+36/2)

		var p2 = CGPoint(x: x-w/2+d, y: sh*3+d)
		var p3 = CGPoint(x: x-w/2+d, y: sh*3+vh*6+2*2-d)
		
		plasma.move(to: a1)
		plasma.addQuadCurve(to: p2, control: CGPoint(x: a1.x, y: p2.y)+CGPoint(x: 10, y: 40))
		plasma.addLine(to: p3)
		plasma.addQuadCurve(to: a3, control: CGPoint(x: a3.x, y: p3.y)+CGPoint(x: -30, y: -50))
		plasma.addQuadCurve(to: b1, control: CGPoint(x: a3.x, y: b1.y)+CGPoint(x: 30, y: 10))
		plasma.addQuadCurve(to: a2, control: CGPoint(x: a2.x, y: b1.y)+CGPoint(x: 20, y: 0))
		plasma.addQuadCurve(to: b2, control: CGPoint(x: a2.x, y: b2.y)+CGPoint(x: -20, y: 0))
		plasma.addQuadCurve(to: a1, control: CGPoint(x: a1.x, y: b2.y)+CGPoint(x: -10, y: 0))
		
		// Step 2
		var p1 = CGPoint(x: x+w/2-d, y: sh*3+d)
		var p4 = CGPoint(x: x+w/2-d, y: sh*3+vh*6+2*2-d)
		x += 81
		w = 55+p
		p2 = CGPoint(x: x-w/2+d, y: sh*2+d)
		p3 = CGPoint(x: x-w/2+d, y: sh*2+vh*4+2*2-d)
		
		var c1 = (p1+p2)/2+CGPoint(x: 0, y: a)
		var c2 = (p3+p4)/2+CGPoint(x: 0, y: -a)
		
		plasma.move(to: p1)
		plasma.addQuadCurve(to: p2, control: c1)
		plasma.addLine(to: p3)
		plasma.addQuadCurve(to: p4, control: c2)

		// Step 3
		p1 = CGPoint(x: x+w/2-d, y: sh*2+d)
		p4 = CGPoint(x: x+w/2-d, y: sh*2+vh*4+2*2-d)
		x += 88
		w = 52+p
		p2 = CGPoint(x: x-w/2+d, y: sh+d)
		p3 = CGPoint(x: x-w/2+d, y: sh+vh*3+2*2-d)

		c1 = (p1+p2)/2+CGPoint(x: 0, y: a)
		c2 = (p3+p4)/2+CGPoint(x: 0, y: -a)

		plasma.move(to: p1)
		plasma.addQuadCurve(to: p2, control: c1)
		plasma.addLine(to: p3)
		plasma.addQuadCurve(to: p4, control: c2)

		// Step 4
		p1 = CGPoint(x: x+w/2-d, y: sh+d)
		p4 = CGPoint(x: x+w/2-d, y: sh+vh*3+2*2-d)
		x += 88
		w = 59+p
		p2 = CGPoint(x: x-w/2+d, y: d)
		p3 = CGPoint(x: x-w/2+d, y: vh*2+2*2-d)

		c1 = (p1+p2)/2+CGPoint(x: 0, y: a)
		c2 = (p3+p4)/2+CGPoint(x: 0, y: -a)

		plasma.move(to: p1)
		plasma.addQuadCurve(to: p2, control: c1)
		plasma.addLine(to: p3)
		plasma.addQuadCurve(to: p4, control: c2)
	}
	public required init?(coder aDecoder: NSCoder) { fatalError() }

	func ok() {
        ooviLeaf.releaseFocus(.okEqualReturn)
		if let onOKEV = onOKEV {
			onOKEV(oovi)
		}
	}
	
	func colorChanged() {
		ooviLeaf.onColorChange()
	}
	
// Bubble ==========================================================================================
    override var uiColor: UIColor { !selected ? oovi.uiColor : UIColor.yellow }
    override var hitch: Position { .topLeft }
	override var selectable: Bool { false }
	
// UIView ==========================================================================================
    public override func draw(_ rect: CGRect) {
        guard let plasma = plasma else { return }
        Skin.plasma(path: plasma, uiColor: uiColor, stroke: 0.5, fill: 0.2)
    }

// ChainLeafDelegate ===============================================================================
	func onChange() {
		layoutLeavesIfNeeded()
	}
	func onEdit() {
		layoutLeavesIfNeeded()
	}
	func onOK(leaf: ChainLeaf) {
		layoutLeavesIfNeeded()
	}
	func onCalculate() {}
}
