//
//  GateBub.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class GateBub: Bubble, ChainLeafDelegate, Citable {
	let gate: Gate
	
	lazy var ifLeaf: ChainLeaf = { ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint.zero, size: CGSize(width: 70, height: 36), alwaysShow: false, delegate: self) }()
	lazy var thenLeaf: ChainLeaf = { ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint.zero, size: CGSize(width: 70, height: 36), alwaysShow: false, delegate: self) }()
	lazy var elseLeaf: ChainLeaf = { ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint.zero, size: CGSize(width: 70, height: 36), alwaysShow: false, delegate: self) }()
	
    lazy var mooring: Mooring = { createMooring(key: gate.resultKey) }()
	
	var overrideHitchPoint: CGPoint = CGPoint.zero
	
	init(_ gate: Gate, aetherView: AetherView) {
		self.gate = gate
		
		super.init(aetherView: aetherView, aexel: gate, origin: CGPoint(x: self.gate.x, y: self.gate.y), size: CGSize.zero)
		
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
		
		render()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
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
		let y9 = y8+h
		
		overrideHitchPoint = CGPoint(x: x3, y: y9/2)

		ifLeaf.anchor = CGPoint(x: x1-p, y: y1-p)
		thenLeaf.anchor = CGPoint(x: x4-p, y: y4-p)
		elseLeaf.anchor = CGPoint(x: x7-p, y: y7-p)

		plasma = CGMutablePath()
		guard let plasma = plasma else { return }
		
		plasma.move(to: CGPoint(x: x5, y: y5))
		plasma.addQuadCurve(to: CGPoint(x: x2, y: y2), control: CGPoint(x: x2, y: y5))
		plasma.addQuadCurve(to: CGPoint(x: x8, y: y8), control: CGPoint(x: x2, y: y8))
		plasma.addQuadCurve(to: CGPoint(x: x3, y: y2), control: CGPoint(x: x7, y: y8))
		plasma.addQuadCurve(to: CGPoint(x: x5, y: y5), control: CGPoint(x: x3, y: y5))
		plasma.closeSubpath()
		
		layoutLeaves()
	}
	
// Bubble ==========================================================================================
    override var uiColor: UIColor { !selected ? OOColor.marine.uiColor : UIColor.yellow }
	override func positionMoorings() {
		let w: CGFloat = ifLeaf.size.width
		let p: CGFloat = 3
		mooring.point = aetherView.scrollView.convert(CGPoint(x: w - p, y: 59 - 2*p), from: self)
		super.positionMoorings()
	}
	override var hitchPoint: CGPoint { overrideHitchPoint }
	
// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        guard let plasma = plasma else { return }
        Skin.plasma(path: plasma, uiColor: uiColor, stroke: 1)
    }

// ChainLeafDelegate ===============================================================================
	func onChange() { render() }
	func onEdit() { render() }
	func onOK(leaf: ChainLeaf) { render() }
	func onCalculate() {
        render()
    }
	
// Citable =========================================================================================
	func tokenKey(at: CGPoint) -> TokenKey? { gate.resultKey }
}
