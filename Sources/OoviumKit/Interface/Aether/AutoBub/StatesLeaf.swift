//
//  StatesLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 6/27/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import UIKit

class StatesLeaf: Leaf, ChainLeafDelegate, Colorable {
	lazy var chainLeaf: ChainLeaf = {ChainLeaf(bubble: bubble, hitch: .left, anchor: CGPoint(x: 151, y: 43), size: CGSize(width: 80, height: 36), delegate: self)}()
	lazy var colorLeaves: [ColorLeaf] = buildColorLeaves()
	var states: CGFloat = 2
	var expanded: Bool = false
	
	let x1, x2, x3, x4, x5, x6, x7, x8, x9: CGFloat
	let y3, y4, y5, y6, y8, y9, y10, y11, ey5, ey11: CGFloat
	
	let collapsedPath: CGPath
	var expandedPath: CGPath!
	
	init(bubble: Bubble) {
		let autoBub = bubble as! AutoBub
		
		let op: CGFloat = 5
		let ow: CGFloat = 2
		let ob: CGFloat = 30
		let or: CGFloat = 2
//		let qs: CGFloat = 32
//		let qn: CGFloat = 12
//		let qp: CGFloat = 3
//		let qw: CGFloat = qn != 0 ? sqrt(qn-1)+1 : 0
		let cw: CGFloat = 50
		let pp: CGFloat = 2
		
		x1 = pp
		x2 = x1 + cw/2
		x3 = x2 + cw/2 + op
		x4 = x3 + 20
		x5 = x4 + ow
		x6 = x5 - ob
		x7 = (x5-x6)/2
		x9 = x7+172//max(x5 + qw*qs + (qw+1)*qp+5, 160+100)
		x8 = (x5+x9)/2
		
//		y1 = op
//		y2 = y1 + cw
		y3 = pp
		y4 = y3 + 20
		y5 = y4 + ow
		y6 = y5 + ob
		y8 = 0
		y9 = y3
		y11 = y3+3
		y10 = (y8+y11)/2
		
//		CGFloat ox1 = px4;
//		CGFloat ox2 = px5;
//		CGFloat ox3 = px6+op;
//		CGFloat ox4 = px7+op;
//
//		CGFloat oy1 = py4;
//		CGFloat oy2 = py5;
//		CGFloat oy3 = py6+op;
//		CGFloat oy4 = py7+op;

		let path: CGMutablePath = CGMutablePath()
		
		path.move(to: CGPoint(x: x2, y: y5))
		path.addArc(tangent1End: CGPoint(x: x1, y: y5), tangent2End: CGPoint(x: x1, y: y4), radius: 1)
		path.addLine(to: CGPoint(x: x1, y: y4))
		path.addCurve(to: CGPoint(x: x2, y: y3), control1: CGPoint(x: x1+18, y: y4), control2: CGPoint(x: x2-or, y: y3))
		path.addCurve(to: CGPoint(x: x3-3, y: y4), control1: CGPoint(x: x2+or, y: y3), control2: CGPoint(x: x3-24, y: y4))
		path.addArc(tangent1End: CGPoint(x: x5, y: y4), tangent2End: CGPoint(x: x5, y: y6), radius: 12)
		path.addArc(tangent1End: CGPoint(x: x5, y: y6), tangent2End: CGPoint(x: x7, y: y6), radius: 12)
		path.addArc(tangent1End: CGPoint(x: x6, y: y6), tangent2End: CGPoint(x: x6, y: y5), radius: 12)
		path.addArc(tangent1End: CGPoint(x: x6, y: y5), tangent2End: CGPoint(x: x2, y: y5), radius: 12)
		path.closeSubpath()
		
		collapsedPath = path
		
		let ey1 = pp
		let ey2 = ey1 + 25
		let ey3 = ey2 + 25
		let ey4 = ey3 + 25
		ey5 = ey4 + 25
//		let ey6 = ey5 - pp + op + y3
//		let ey7 = ey5 - pp + op + y4
//		let ey8 = ey5 - pp + op + y5
//		let ey9 = ey5 - pp + op + y6
		ey11 = ey1 + 200
//		let ey10 = (ey9+ey11)/2
		
	
		super.init(bubble: bubble, hitch: .topLeft, anchor: CGPoint(x: 74-pp, y: 129-pp), size: CGSize(width: 100, height: 100))
//		self.backgroundColor = UIColor.orange.alpha(0.5)
		
		
//		super.init(bubble: bubble, anchor: CGPoint(x: 74-pp, y: 129-pp), hitch: .topLeft, size: CGSize(width: x5-x1+2*pp, height: y6-y3+2*pp))
		self.backgroundColor = UIColor.clear
		
		chainLeaf.placeholder = "states"
		chainLeaf.chainView.chain = autoBub.auto.statesChain
		chainLeaf.minWidth = 80
		chainLeaf.radius = 15
		chainLeaf.colorable = self

		renderExpandedPath()

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap(_:))))
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func loadStateNo() {
		let tower = (bubble as! AutoBub).auto.statesTower
		states = CGFloat(tower.value)
		
		if states < 2 {
			states = 2
			if chainLeaf.chain.tokens.count != 0 {
				chainLeaf.chainView.chain.replaceWith(tokens: "0:2")
				chainLeaf.chainView.ok()
			}
		}
		else if states > 32 {
			states = 32
			chainLeaf.chainView.chain.replaceWith(tokens: "0:3;0:2")
			chainLeaf.chainView.ok()
		}
	}
	func buildColorLeaves() -> [ColorLeaf] {
		let qw: CGFloat = ceil(states.squareRoot())
//		let qh: CGFloat = qw*qw - states < qw ? qw : qw-1
		var qx: CGFloat = 0
		var qy: CGFloat = 0
		let ax: CGFloat = 158
		let ay: CGFloat = 68
		
		let auto = (bubble as! AutoBub).auto

		var colorLeaves: [ColorLeaf] = []
		for i in 0..<Int(states) {
			let colorLeaf = ColorLeaf(bubble: self.bubble, hitch: .topLeft, anchor: CGPoint(x: ax+qx*35, y: ay+qy*35), size: CGSize(width: 30, height: 30))
			colorLeaf.state = auto.states[i]
			colorLeaves += [colorLeaf]
			
			qx += 1
			if (qx == qw) {
				qx = 0
				qy += 1
			}
		}
		return colorLeaves
	}
	func renderColorLeaves() {
        colorLeaves.forEach { $0.removeFromBubble() }
		
		if expanded {
			colorLeaves = buildColorLeaves()
			for leaf in colorLeaves {
				bubble.add(leaf: leaf)
			}
		}
		
		(bubble as! AutoBub).renderMinSize()
	}
	func renderExpandedPath() {
		let op: CGFloat = 5
		let or: CGFloat = 2
		let pp: CGFloat = 2
		let qw: CGFloat = ceil(states.squareRoot())
		let qh: CGFloat = qw*qw - states < qw ? qw : qw-1

		let ex2 = max(x5 + 8 + qw*35, chainLeaf.left+chainLeaf.calcWidth()-left+9)
		let ex1 = (x7+ex2)/2
		
		let ey1 = pp
		let ey2 = ey1 + 25
		let ey3 = ey2 + 25
		let ey4 = ey3 + 25
		let ey6 = ey5 - pp + op + y3
		let ey7 = ey5 - pp + op + y4
		let ey8 = ey5 - pp + op + y5
		let ey9 = ey5 - pp + op + y6
		let ey11 = ey1 + 46 + qh*35
		let ey10 = (ey9+ey11)/2
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x2, y: ey8))
		path.addArc(tangent1End: CGPoint(x: x1, y: ey8), tangent2End: CGPoint(x: x1, y: ey7), radius: 1)
		path.addLine(to: CGPoint(x: x1, y: ey7))
		path.addCurve(to: CGPoint(x: x2, y: ey6), control1: CGPoint(x: x1+18, y: ey7), control2: CGPoint(x: x2-or, y: ey6))
		path.addCurve(to: CGPoint(x: x3-3, y: ey7), control1: CGPoint(x: x2+or, y: ey6), control2: CGPoint(x: x3-24, y: ey7))
		path.addArc(tangent1End: CGPoint(x: x4, y: ey7), tangent2End: CGPoint(x: x4, y: ey6), radius: 25)
		path.addCurve(to: CGPoint(x: x3, y: ey4), control1: CGPoint(x: x4, y: ey6-24), control2: CGPoint(x: x3, y: ey4+or))
		path.addCurve(to: CGPoint(x: x4, y: ey3), control1: CGPoint(x: x3, y: ey4-or), control2: CGPoint(x: x4, y: ey3+18))
		path.addCurve(to: CGPoint(x: x3, y: ey2), control1: CGPoint(x: x4, y: ey3-18), control2: CGPoint(x: x3, y: ey2+or))
		path.addCurve(to: CGPoint(x: x4, y: ey1), control1: CGPoint(x: x3, y: ey2-or), control2: CGPoint(x: x4, y: ey1+18))
		path.addLine(to: CGPoint(x: ex1, y: ey1))
		path.addArc(tangent1End: CGPoint(x: ex2, y: ey1), tangent2End: CGPoint(x: ex2, y: ey10), radius: 12)
		path.addArc(tangent1End: CGPoint(x: ex2, y: ey11), tangent2End: CGPoint(x: ex1, y: ey11), radius: 12)
		
		if states < 7 || states > 12 {
			path.addArc(tangent1End: CGPoint(x: x5, y: ey11), tangent2End: CGPoint(x: x5, y: ey10), radius: 12)
		} else {
			path.addArc(tangent1End: CGPoint(x: x5, y: ey11), tangent2End: CGPoint(x: x5, y: ey9-12), radius: 12)
		}
		
		path.addArc(tangent1End: CGPoint(x: x5, y: ey9), tangent2End: CGPoint(x: x7, y: ey9), radius: 12)
		path.addArc(tangent1End: CGPoint(x: x6, y: ey9), tangent2End: CGPoint(x: x6, y: ey8), radius: 12)
		path.addArc(tangent1End: CGPoint(x: x6, y: ey8), tangent2End: CGPoint(x: x2, y: ey8), radius: 12)
		path.closeSubpath()
		
		expandedPath = path
		hitPath = path
		
		size = expanded
			? CGSize(width: ex2+pp, height: max(ey9,ey11)+pp)
			: CGSize(width: x5-x1+2*pp, height: y6-y3+2*pp)
		
	}
	func render() {
		renderColorLeaves()
		renderExpandedPath()
		setNeedsDisplay()
	}
	func transform() {
		expanded = !expanded
		let pp: CGFloat = 2
		anchor = CGPoint(x: 74-pp, y: 24-pp+(expanded ? 0 : 105))
		size = expanded
			? CGSize(width: x9-x1+2*pp, height: ey11-y3+2*pp)
			: CGSize(width: x5-x1+2*pp, height: y6-y3+2*pp)

		if expanded { bubble.add(leaf: chainLeaf) }
        else { chainLeaf.removeFromBubble() }
        
		bubble.layoutLeaves()
		render()
		bubble.layoutLeaves()
	}
	
// Events ==========================================================================================
	@objc func onTap(_ gesture: UITapGestureRecognizer) {
		let rect = expanded
			? CGRect(x: 51.5, y: 29.5+ey5+3, width: 24, height: 24).insetBy(dx: -5, dy: -5)
			: CGRect(x: 51.5, y: 29.5, width: 24, height: 24).insetBy(dx: -5, dy: -5)
		guard rect.contains(gesture.location(in: self)) else { return }
		transform()
	}
	
// UIView ==========================================================================================
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let path: CGPath = expanded ? expandedPath : collapsedPath
		if path.contains(point) {return self}
		return nil
	}
	override func draw(_ rect: CGRect) {
		Skin.plasma(path: expanded ? expandedPath : collapsedPath, uiColor: UIColor.white)
		let rect = CGRect(x: 52, y: 26+(expanded ? ey5+3 : 0), width: 24, height: 24)
		Skin.tray(path: CGPath(ellipseIn: rect, transform: nil), uiColor: UIColor.white, width: 1.5)
		Skin.shape(text: "*", rect: CGRect(x: 51.5, y: 29.5+(expanded ? ey5+3 : 0), width: 24, height: 24), uiColor: UIColor.white)
	}
	
// Colorable =======================================================================================
	var uiColor: UIColor {
		return UIColor.white
	}
	
// ChainLeafDelegate ===============================================================================
	func onChange() {
		bubble.layoutLeavesIfNeeded()
	}
	func onEdit() {
		bubble.layoutLeavesIfNeeded()
	}
	func onOK(leaf: ChainLeaf) {
		loadStateNo()
		
		let auto = (bubble as! AutoBub).auto
		auto.buildStates()

		render()
		bubble.layoutLeavesIfNeeded()
	}
	func onCalculate() {}
}
