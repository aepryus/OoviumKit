//
//  AlsoBub.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class AlsoMaker: Maker {
	
// Maker ===========================================================================================
	func make(aetherView: AetherView, at: V2) -> Bubble {
		let also = aetherView.aether.createAlso(at: at)
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

class AlsoBub: Bubble {
	let also: Also
	
	lazy var alsoLeaf: AlsoLeaf = {AlsoLeaf(bubble: self)}()
	lazy var functionsLeaf: FunctionsLeaf = {FunctionsLeaf(bubble: self)}()

	init(_ also: Also, aetherView: AetherView) {
		self.also = also
		super.init(aetherView: aetherView, aexel: also, origin: CGPoint(x: self.also.x, y: self.also.y), hitch: .top, size: CGSize.zero)
		
		alsoLeaf.size = CGSize(width: 130, height: 40)
		alsoLeaf.hitch = .top
		alsoLeaf.anchor = CGPoint(x: 65, y: 0)
		add(leaf: alsoLeaf)
//		alsoLeaf.render()

		functionsLeaf.size = CGSize(width: 120, height: 100)
		functionsLeaf.hitch = .top
		functionsLeaf.anchor = CGPoint(x: 65, y: 60)
		add(leaf: functionsLeaf)
		
		render()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func render() {
		alsoLeaf.render()
		alsoLeaf.anchor = CGPoint(x: alsoLeaf.size.width/2, y: 0)
		functionsLeaf.anchor = CGPoint(x: alsoLeaf.size.width/2, y: 60)
		functionsLeaf.render()
		
		layoutLeaves()

		let sw: CGFloat = 54*s
		
		let x2 = calculateRect().width/2
		let x1 = x2 - sw/2
		let x3 = x2 + sw/2
		
		let y1: CGFloat = 20
		let y2: CGFloat = 60 + (2*CGFloat(also.functionCount)-1)*13.5*s
		
		let p1: CGPoint = CGPoint(x: x1, y: y1)
		let p2: CGPoint = CGPoint(x: x2, y: y2)
		let p3: CGPoint = CGPoint(x: x3, y: y1)
		
		let c1: CGPoint = CGPoint(x: sw/2 * 1.2, y: sw/2 * 0.3)
		let c4: CGPoint = CGPoint(x: -sw/2 * 1.2, y: sw/2 * 0.3)

		let c2: CGPoint = CGPoint(x: -sw/2 * 0.1, y: sw/2 * 0.5)
		let c3: CGPoint = CGPoint(x: sw/2 * 0.1, y: sw/2 * 0.5)

		plasma = CGMutablePath()
		guard let plasma = plasma, also.functionCount>0 else { return }
		plasma.move(to: p1)
		plasma.addCurve(to: p2, control1: p1 + c1, control2: p2 + c2)
		plasma.addCurve(to: p3, control1: p2 + c3, control2: p3 + c4)
		plasma.closeSubpath()
	}
	
// Events ==========================================================================================
	override func onCreate() {
		alsoLeaf.makeFocus()
	}
	func onOK() {
		if also.aetherPath == "" {
			aetherView.aether.removeAexel(also)
			aetherView.remove(bubble: self)
			aetherView.stretch()
		}
	}
	
// Bubble ==========================================================================================
	override var uiColor: UIColor {
		return !selected ? OOColor.lavender.uiColor : UIColor.yellow
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		guard let plasma = plasma else { return }
		
		let c = UIGraphicsGetCurrentContext()!
		c.addPath(plasma)
		
		UIColor.blue.alpha(0.4).setFill()
		UIColor.blue.alpha(1).setStroke()
		
		c.drawPath(using: .fillStroke)
	}
}
