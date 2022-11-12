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
