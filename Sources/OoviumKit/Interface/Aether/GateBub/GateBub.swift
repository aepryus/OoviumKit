//
//  GateBub.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class GateMaker: Maker {
// Maker ===========================================================================================
	func make(aetherView: AetherView, at: V2) -> Bubble {
		let gate = aetherView.aether.createGate(at: at)
		return GateBub(gate, aetherView: aetherView)
	}
	func drawIcon() {
		let bw: CGFloat = 20.0*Oo.s
		let p: CGFloat = 2.0*Oo.s
		let iw: CGFloat = (bw-2.0*p)/1.5
		let tw: CGFloat = (bw-2.0*p)/1.5
		let ew: CGFloat = (bw-2.0*p)/1.5
		let h: CGFloat = (7.0*Oo.s-p)/1.5
		let b: CGFloat = 4.0*Oo.s/1.5
		let r: CGFloat = 3.0*Oo.s
		
		let x1 = p+6.0/1.5*Oo.s
		let x3 = x1+iw
		let x2 = (x1+x3)/2.0
		let x4 = 36.0*Oo.s/1.5
		let x6 = x4+tw
		let x5 = (x4+x6)/2.0
		let x7 = 29.0*Oo.s/1.5
		let x9 = x7+ew
		let x8 = (x7+x9)/2.0
		
		let y4 = p+10.0/1.5*Oo.s
		let y5 = y4+h
		let y6 = y5+h
		let y1 = y6+b
		let y2 = y1+h
		let y3 = y2+h
		let y7 = y3+b
		let y8 = y7+h
		let y9 = y8+h
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x1, y: y2))
		path.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x2, y: y1), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y1), tangent2End: CGPoint(x: x3, y: y2), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y3), tangent2End: CGPoint(x: x2, y: y3), radius: r)
		path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x1, y: y2), radius: r)
		path.closeSubpath()

		path.move(to: CGPoint(x: x4, y: y5))
		path.addArc(tangent1End: CGPoint(x: x4, y: y4), tangent2End: CGPoint(x: x5, y: y4), radius: r)
		path.addArc(tangent1End: CGPoint(x: x6, y: y4), tangent2End: CGPoint(x: x6, y: y5), radius: r)
		path.addArc(tangent1End: CGPoint(x: x6, y: y6), tangent2End: CGPoint(x: x5, y: y6), radius: r)
		path.addArc(tangent1End: CGPoint(x: x4, y: y6), tangent2End: CGPoint(x: x4, y: y5), radius: r)
		path.closeSubpath()

		path.move(to: CGPoint(x: x7, y: y8))
		path.addArc(tangent1End: CGPoint(x: x7, y: y7), tangent2End: CGPoint(x: x8, y: y7), radius: r)
		path.addArc(tangent1End: CGPoint(x: x9, y: y7), tangent2End: CGPoint(x: x9, y: y8), radius: r)
		path.addArc(tangent1End: CGPoint(x: x9, y: y9), tangent2End: CGPoint(x: x8, y: y9), radius: r)
		path.addArc(tangent1End: CGPoint(x: x7, y: y9), tangent2End: CGPoint(x: x7, y: y8), radius: r)
		path.closeSubpath()
		
		let arrow = CGMutablePath()
		arrow.move(to: CGPoint(x: x5, y: y5))
		arrow.addQuadCurve(to: CGPoint(x: x2, y: y2), control: CGPoint(x: x2, y: y5))
		arrow.addQuadCurve(to: CGPoint(x: x8, y: y8), control: CGPoint(x: x2, y: y8))
		arrow.addQuadCurve(to: CGPoint(x: x3, y: y2), control: CGPoint(x: x7, y: y8))
		arrow.addQuadCurve(to: CGPoint(x: x5, y: y5), control: CGPoint(x: x3, y: y5))
		arrow.closeSubpath()

		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(OOColor.marine.uiColor.alpha(0.4).cgColor)
		c.setStrokeColor(OOColor.marine.uiColor.alpha(0.7).cgColor)
		c.addPath(arrow)
		c.drawPath(using: .fillStroke)
		
		Skin.bubble(path: path, uiColor: OOColor.marine.uiColor, width: 4.0/3.0*Oo.s)
	}
}

class GateBub: Bubble, ChainLeafDelegate, Citable {
	let gate: Gate
	
	lazy var ifLeaf: ChainLeaf = {ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint.zero, size: CGSize(width: 70, height: 36), delegate: self)}()
	lazy var thenLeaf: ChainLeaf = {ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint.zero, size: CGSize(width: 70, height: 36), delegate: self)}()
	lazy var elseLeaf: ChainLeaf = {ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint.zero, size: CGSize(width: 70, height: 36), delegate: self)}()
	
	let mooring: Mooring = Mooring()
	
	var overrideHitchPoint: CGPoint = CGPoint.zero
	
	init(_ gate: Gate, aetherView: AetherView) {
		self.gate = gate
		
		super.init(aetherView: aetherView, aexel: gate, origin: CGPoint(x: self.gate.x, y: self.gate.y), hitch: .center, size: CGSize.zero)
		
		ifLeaf.chain = gate.ifChain
		ifLeaf.minWidth = 70
		ifLeaf.radius = 15
		ifLeaf.placeholder = "if"
		add(leaf: ifLeaf)
		
		thenLeaf.chain = gate.thenChain
		thenLeaf.minWidth = 70
		thenLeaf.radius = 15
		thenLeaf.placeholder = "then"
		add(leaf: thenLeaf)
		
		elseLeaf.chain = gate.elseChain
		elseLeaf.minWidth = 70
		elseLeaf.radius = 15
		elseLeaf.placeholder = "else"
		add(leaf: elseLeaf)
		
		self.aetherView.moorings[gate.token] = mooring
		
		mooring.colorable = self
		
		render()
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	func render() {
		let p: CGFloat = 3
		let iw: CGFloat = ifLeaf.size.width - 2*p
		let tw: CGFloat = thenLeaf.size.width - 2*p
		let ew: CGFloat = elseLeaf.size.width - 2*p
		let h: CGFloat = 18 - p
		let b: CGFloat = 5
		
		let x1 = p
		let x3 = x1 + iw				// right side of if leaf
		let x2 = x3 - 32				// left side of swoosh
		let x4 = x3 + 53				// left side of then
		let x6 = x4 + tw				// ride side of then
		let x5 = (x4+x6)/2
		let x7 = x3+13					// left side of else
		let x9 = x7+ew					// ride side of else
		let x8 = (x7+x9)/2

		let y4 = p
		let y5 = y4+h
		let y6 = y5+h
		let y1 = y6+b
		let y2 = y1+h
		let y3 = y2+h
		let y7 = y3+b
		let y8 = y7+h
//		let y9 = y8+h
		
		overrideHitchPoint = CGPoint(x: x3, y: 0)

		ifLeaf.anchor = CGPoint(x: x1-p, y: y1-p)
		thenLeaf.anchor = CGPoint(x: x4-p, y: y4-p)
		elseLeaf.anchor = CGPoint(x: x7-p, y: y7-p)

		plasma = CGMutablePath()
		guard let plasma = plasma else {return}
		
		plasma.move(to: CGPoint(x: x5, y: y5))
		plasma.addQuadCurve(to: CGPoint(x: x2, y: y2), control: CGPoint(x: x2, y: y5))
		plasma.addQuadCurve(to: CGPoint(x: x8, y: y8), control: CGPoint(x: x2, y: y8))
		plasma.addQuadCurve(to: CGPoint(x: x3, y: y2), control: CGPoint(x: x7, y: y8))
		plasma.addQuadCurve(to: CGPoint(x: x5, y: y5), control: CGPoint(x: x3, y: y5))
		plasma.closeSubpath()
		
		layoutLeaves()
		
		mooring.point = aetherView.scrollView.convert(CGPoint(x: x3, y: y2), from: self)
		mooring.positionDoodles()
	}
	
// Bubble ==========================================================================================
	override var uiColor: UIColor {
		return !selected ? OOColor.marine.uiColor : UIColor.yellow
	}
	override func positionMoorings() {
		let w: CGFloat = ifLeaf.size.width
		let p: CGFloat = 3
		mooring.point = aetherView.scrollView.convert(CGPoint(x: w - p, y: 59 - 2*p), from: self)
		super.positionMoorings()
	}
	override var hitchPoint: CGPoint {
		return overrideHitchPoint
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		guard let plasma = plasma else {return}
		
		let c = UIGraphicsGetCurrentContext()!
		c.addPath(plasma)
		
		uiColor.alpha(0.4).setFill()
		uiColor.alpha(0.7).setStroke()

		c.drawPath(using: .fillStroke)
	}

// ChainLeafDelegate ===============================================================================
	func onChange() {
		render()
	}
	func onEdit() {
		render()
	}
	func onOK(leaf: ChainLeaf) {
		render()
	}
	func onCalculate() {}
	
// Citable =========================================================================================
	func token(at: CGPoint) -> Token? {
		return gate.token
	}
}
