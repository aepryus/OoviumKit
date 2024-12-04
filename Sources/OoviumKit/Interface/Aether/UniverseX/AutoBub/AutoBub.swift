//
//  AutoBub.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class AutoBub: Bubble, ChainLeafDelegate {
	let auto: Automata
    
    lazy var aLeaf: SpaceLeaf = SpaceLeaf(bubble: self, name: "A", tokenKey: auto.aTokenKey)
	lazy var bLeaf: SpaceLeaf = SpaceLeaf(bubble: self, name: "B", tokenKey: auto.bTokenKey)
	lazy var cLeaf: SpaceLeaf = SpaceLeaf(bubble: self, name: "C", tokenKey: auto.cTokenKey)
	lazy var dLeaf: SpaceLeaf = SpaceLeaf(bubble: self, name: "D", tokenKey: auto.dTokenKey)
	lazy var eLeaf: SpaceLeaf = SpaceLeaf(bubble: self, name: "E", tokenKey: auto.eTokenKey)
	lazy var fLeaf: SpaceLeaf = SpaceLeaf(bubble: self, name: "F", tokenKey: auto.fTokenKey)
	lazy var gLeaf: SpaceLeaf = SpaceLeaf(bubble: self, name: "G", tokenKey: auto.gTokenKey)
	lazy var hLeaf: SpaceLeaf = SpaceLeaf(bubble: self, name: "H", tokenKey: auto.hTokenKey)
	lazy var selfLeaf: SpaceLeaf = SpaceLeaf(bubble: self, name: "Self", tokenKey: auto.selfTokenKey)
	
	lazy var nextLeaf: ChainLeaf = ChainLeaf(bubble: self, delegate: self)
	
	lazy var statesLeaf: StatesLeaf = StatesLeaf(bubble: self)
	
	var armPath: CGMutablePath = CGMutablePath()
	
	var px4: CGFloat = 0
	var ox5: CGFloat = 0
	var x6: CGFloat = 0
	var y6: CGFloat = 0
	var qx3: CGFloat = 0
	var qy3: CGFloat = 0
	var p: CGFloat = 8
	
	init(_ auto: Automata, aetherView: AetherView) {
		self.auto = auto
		
		super.init(aetherView: aetherView, aexel: auto, origin: CGPoint(x: self.auto.x, y: self.auto.y), size: CGSize(width: 36, height: 36))
		
		let cw: CGFloat = 50
		let sw: CGFloat = 32
		let sh: CGFloat = 32
		let iw: CGFloat = cw - sw
		let ih: CGFloat = cw - sh
		
		let x1 = p;
		let x2 = x1 + sw;
		let x3 = x2 + iw;
		let x4 = x3 + sw;
		let x5 = x4 + iw;
		x6 = x5 + sw;
		
		let y1 = p;
		let y2 = y1 + sh;
		let y3 = y2 + ih;
		let y4 = y3 + sh;
		let y5 = y4 + ih;
		y6 = y5 + sh;
		
		let q: CGFloat = 1
		
		aLeaf.anchor = CGPoint(x: x1-q, y: y1-q)
		aLeaf.hitch = .topLeft
		aLeaf.size = CGSize(width: sw+2*q, height: sh+2*q)
		add(leaf: aLeaf)
		
		bLeaf.anchor = CGPoint(x: x3-q, y: y1-q)
		bLeaf.hitch = .topLeft
		bLeaf.size = CGSize(width: sw+2*q, height: sh+2*q)
		add(leaf: bLeaf)

		cLeaf.anchor = CGPoint(x: x5-q, y: y1-q)
		cLeaf.hitch = .topLeft
		cLeaf.size = CGSize(width: sw+2*q, height: sh+2*q)
		add(leaf: cLeaf)

		dLeaf.anchor = CGPoint(x: x5-q, y: y3-q)
		dLeaf.hitch = .topLeft
		dLeaf.size = CGSize(width: sw+2*q, height: sh+2*q)
		add(leaf: dLeaf)

		eLeaf.anchor = CGPoint(x: x5-q, y: y5-q)
		eLeaf.hitch = .topLeft
		eLeaf.size = CGSize(width: sw+2*q, height: sh+2*q)
		add(leaf: eLeaf)

		fLeaf.anchor = CGPoint(x: x3-q, y: y5-q)
		fLeaf.hitch = .topLeft
		fLeaf.size = CGSize(width: sw+2*q, height: sh+2*q)
		add(leaf: fLeaf)

		gLeaf.anchor = CGPoint(x: x1-q, y: y5-q)
		gLeaf.hitch = .topLeft
		gLeaf.size = CGSize(width: sw+2*q, height: sh+2*q)
		add(leaf: gLeaf)

		hLeaf.anchor = CGPoint(x: x1-q, y: y3-q)
		hLeaf.hitch = .topLeft
		hLeaf.size = CGSize(width: sw+2*q, height: sh+2*q)
		add(leaf: hLeaf)
		
		let pp: CGFloat = 4
//		let tr: CGFloat = 18
//		let br: CGFloat = 6

//		let px1 = pp;
//		let px2 = (x1+x2)/2;
		let px3 = (x2+x3)/2;
		px4 = (x3+x4)/2;
		let px5 = (x4+x5)/2;
//		let px6 = (x5+x6)/2;
		let px7 = x6+pp;
		
//		let py1 = pp;
//		let py2 = (y1+y2)/2;
		let py3 = (y2+y3)/2;
//		let py4 = (y3+y4)/2;
		let py5 = (y4+y5)/2;
//		let py6 = (y5+y6)/2;
//		let py7 = y6+pp;
		
//		let r = px2-px1

		selfLeaf.anchor = CGPoint(x: px3-q, y: py3-q)
		selfLeaf.hitch = .topLeft
		selfLeaf.size = CGSize(width: px5-px3+2*q, height: py5-py3+2*q)
		add(leaf: selfLeaf)

		add(leaf: nextLeaf)
		nextLeaf.chain = auto.resultChain
		nextLeaf.minWidth = 96
		nextLeaf.hitch = .topLeft
		nextLeaf.anchor = CGPoint(x: 18-3, y: y6+24-3)
		nextLeaf.placeholder = "next Self"
		nextLeaf.radius = 15
        
        statesLeaf.chainLeaf.chain = auto.statesChain
		
		setLeavesNeedLayout()
		layoutLeaves()
		
//		armPath.move(to: CGPoint(x: px3, y: py4))
//		armPath.addQuadCurve(to: CGPoint(x: 36+(96-6)/2, y: y6+48+15), control: CGPoint(x: x1-6-4, y: y6))
//		armPath.addQuadCurve(to: CGPoint(x: px5, y: py4), control: CGPoint(x: x1+6-4, y: y6))

        let by: CGFloat = 0.4
        
		let plasma = CGMutablePath()
        
        let s: CGPoint = CGPoint(x: 9, y: 0)
        let c: CGPoint = selfLeaf.center
        let n: CGPoint = nextLeaf.center
        let a: CGPoint = c - s
        let b: CGPoint = c + s
        let e: CGFloat = 3
        
        armPath.move(to: a)
        armPath.addCurve(to: n, control1: (a+n)/2-s*e, control2: (a+n)/2-s*e)
        armPath.addCurve(to: b, control1: (b+n)/2-s*e, control2: (b+n)/2-s*e)
        armPath.closeSubpath()
        
        plasma.move(to: aLeaf.center)
        plasma.addCurve(to: bLeaf.center, control1: pinch(aLeaf.center, by: by), control2: pinch(bLeaf.center, by: by))
        plasma.addCurve(to: cLeaf.center, control1: pinch(bLeaf.center, by: by), control2: pinch(cLeaf.center, by: by))
        plasma.addCurve(to: dLeaf.center, control1: pinch(cLeaf.center, by: by), control2: pinch(dLeaf.center, by: by))
        plasma.addCurve(to: eLeaf.center, control1: pinch(dLeaf.center, by: by), control2: pinch(eLeaf.center, by: by))
        plasma.addCurve(to: fLeaf.center, control1: pinch(eLeaf.center, by: by), control2: pinch(fLeaf.center, by: by))
        plasma.addCurve(to: gLeaf.center, control1: pinch(fLeaf.center, by: by), control2: pinch(gLeaf.center, by: by))
        plasma.addCurve(to: hLeaf.center, control1: pinch(gLeaf.center, by: by), control2: pinch(hLeaf.center, by: by))
        plasma.addCurve(to: aLeaf.center, control1: pinch(hLeaf.center, by: by), control2: pinch(aLeaf.center, by: by))
        
        self.plasma = plasma

		// ColorLeafs
		let qs: CGFloat = 32
		let qp: CGFloat = 3

		let qn: CGFloat = CGFloat(auto.states.count)
		let qw: CGFloat = qn != 0 ? floor(sqrt(qn-1))+1 : 0
		let qh: CGFloat = qn != 0 ? (qn > qw * (qw-1) ? qw : qw-1) : 0

		let qx1: CGFloat = 154
		qx3 = qx1 + qw*qs + (qw+1)*qp
		
		let qy1: CGFloat = 64
		qy3 = qy1 + qh*qs + (qh+1)*qp

		// Trnsform
		let op: CGFloat = 5
		let ow: CGFloat = 2
//		let ob: CGFloat = 30
//		let or: CGFloat = 2

//		let ox1 = px4
//		let ox2 = px5
//		let ox3 = px6+op
		let ox4 = px7+op
		ox5 = ox4+ow
//		let ox6 = ox5-ob
//		let ox7 = (ox5-ox6)/2
		
//		let oy1 = py4
//		let oy2 = py5
//		let oy3 = py6+op
//		let oy4 = py7+op
//		let oy5 = oy4+ow
//		let oy6 = oy5+ob
		
//		statesLeaf.frame = CGRect(x: 120, y: 140, width: 30, height: 30)
		if !auto.aether.readOnly {
			statesLeaf.loadStateNo()
			statesLeaf.render()
			add(leaf: statesLeaf)
			statesLeaf.renderColorLeaves()
		}
		
//		padding = CGSize(width: 7, height: 7)
		renderMinSize()
		
		setNeedsDisplay()
		layoutLeaves()
		statesLeaf.renderExpandedPath()
		layoutLeaves()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func renderMinSize() {
		var w: CGFloat = max(x6+p,36+nextLeaf.width-6+p)
		w = max(w, ox5+p)
		
		var h: CGFloat = y6+78+p
		
		if statesLeaf.superview != nil {
//			w = max(w, px4+statesLeaf.width+p)
//			w = max(w, qx3+p)
			h = max(h, qy3+p)+7
		}
//		minSize = CGSize(width: w, height: h)
	}
    
    private func pinch(_ point: CGPoint, by: CGFloat) -> CGPoint {
        let c: CGPoint = selfLeaf.center
        return c + (point-c)*by
    }
	
// Bubble ==========================================================================================
	override var uiColor: UIColor { Text.Color.cobolt.uiColor }
    override var hitch: Position { .topLeft }
    override var selectable: Bool { false }

// UIView ==========================================================================================
	public override func draw(_ rect: CGRect) {
		guard let plasma = plasma else { return }
		
		let c = UIGraphicsGetCurrentContext()!

		UIColor(red: 0.5, green: 0.5, blue: 0.8, alpha: 0.4).setFill()
		UIColor(red: 0.6, green: 0.6, blue: 0.8, alpha: 1).setStroke()

		c.addPath(armPath)
		c.drawPath(using: .fillStroke)

		c.addPath(plasma)
		c.drawPath(using: .fillStroke)
	}
	
// ChainLeafDelegate ===============================================================================
	func onChange() {
		layoutLeavesIfNeeded()
		nextLeaf.render()
	}
	func onEdit() {
		layoutLeavesIfNeeded()
		nextLeaf.render()
	}
	func onOK(leaf: ChainLeaf) {
		layoutLeavesIfNeeded()
		nextLeaf.render()
	}
	func onCalculate() {}
}
