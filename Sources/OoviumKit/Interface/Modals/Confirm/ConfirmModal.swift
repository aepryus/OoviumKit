//
//  ConfirmModal.swift
//  Oovium
//
//  Created by Joe Charlier on 9/21/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class ConfirmModal: Modal {
	var message: String = "" {
		didSet { setNeedsDisplay() }
	}
	var closure: ()->() = {}
	
	init(aetherView: AetherView) {
		super.init(anchor: .center, size: CGSize(width: 200, height: 120), offset: .zero)

		let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
		addGestureRecognizer(gesture)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func executeYes() {
		dismiss()
		closure()
	}
	func executeNo() {
		dismiss()
	}
	
// Events ==========================================================================================
	@objc func onTap(_ gesture: UITapGestureRecognizer) {
		let v = gesture.location(in: self)
		
		let p: CGFloat = 2*Oo.s
		let w: CGFloat = 200*Oo.s
		let q: CGFloat = 24*Oo.s
		let sp: CGFloat = 4*Oo.s
		
		let x9 = p+2*q-sp
		let x10 = w-p-2*q+sp
		let y9 = p+2*q-2*sp
		
		guard v.y > y9 else {return}
		
		if v.x < x9 {
			executeYes()
		} else if v.x > x10 {
			executeNo()
		}
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let p: CGFloat = 2*Oo.s
		let w: CGFloat = 200*Oo.s
		let h: CGFloat = 120*Oo.s
		let q: CGFloat = 24*Oo.s
		let o: CGFloat = 16*Oo.s
		let sp: CGFloat = 4*Oo.s
		let sq: CGFloat = sp*sqrt(2)
		let r: CGFloat = 4*Oo.s
		let ir: CGFloat = 2*Oo.s
		let or: CGFloat = 8*Oo.s
		
		let x1 = p
		let x2 = x1+q
		let x3 = x2+q
		let x4 = w/2
		let x7 = w-p
		let x6 = x7-q
		let x5 = x6-q
		let x9 = x3-sp
		let x8 = (x1+x9)/2
		let x10 = x5+sp
		let x11 = (x7+x10)/2
		
		let y1 = p
		let y7 = h-p
		let y6 = y7-o
		let y5 = y6-o
		let y4 = y5-q
		let y3 = y4-q
		let y2 = (y1+y3)/2
		let y8 = y3+sq
		let y9 = y8+(x7-x11)
		let y10 = y9+(x7-x11)
		
		let c = UIGraphicsGetCurrentContext()!
		
		var path = CGMutablePath()													// main area
		path.move(to: CGPoint(x: x1, y: y2))
		path.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x4, y: y1), radius: r)
		path.addArc(tangent1End: CGPoint(x: x7, y: y1), tangent2End: CGPoint(x: x7, y: y2), radius: r)
		path.addArc(tangent1End: CGPoint(x: x7, y: y3), tangent2End: CGPoint(x: x6, y: y4), radius: or)
		path.addArc(tangent1End: CGPoint(x: x5, y: y5), tangent2End: CGPoint(x: x5, y: y6), radius: or)
		path.addArc(tangent1End: CGPoint(x: x5, y: y7), tangent2End: CGPoint(x: x4, y: y7), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y7), tangent2End: CGPoint(x: x3, y: y6), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y5), tangent2End: CGPoint(x: x2, y: y4), radius: or)
		path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x1, y: y2), radius: or)
		path.closeSubpath()
		c.addPath(path)
		Skin.bubble(path: path, uiColor: UIColor.orange, width: 4/3*Oo.s)
		
		path = CGMutablePath()														// yes button
		path.move(to: CGPoint(x: x1, y: y6))
		path.addArc(tangent1End: CGPoint(x: x1, y: y8), tangent2End: CGPoint(x: x8, y: y9), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x9, y: y10), tangent2End: CGPoint(x: x9, y: y6), radius: or)
		path.addArc(tangent1End: CGPoint(x: x9, y: y7), tangent2End: CGPoint(x: x8, y: y7), radius: r)
		path.addArc(tangent1End: CGPoint(x: x1, y: y7), tangent2End: CGPoint(x: x1, y: y6), radius: r)
		path.closeSubpath()

		path.move(to: CGPoint(x: x10, y: y6))
		path.addArc(tangent1End: CGPoint(x: x10, y: y10), tangent2End: CGPoint(x: x11, y: y9), radius: or)
		path.addArc(tangent1End: CGPoint(x: x7, y: y8), tangent2End: CGPoint(x: x7, y: y6), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x7, y: y7), tangent2End: CGPoint(x: x11, y: y7), radius: r)
		path.addArc(tangent1End: CGPoint(x: x10, y: y7), tangent2End: CGPoint(x: x10, y: y6), radius: r)
		path.closeSubpath()
		
		c.addPath(path)
		Skin.bubble(path: path, uiColor: UIColor.cyan, width: 4/3*Oo.s)
		
		Skin.text(message, rect: CGRect(x: 13, y: 8*Oo.s, width: rect.size.width-26, height: rect.size.height-16), uiColor: UIColor.orange, font: UIFont(name: "HelveticaNeue", size: 18*Oo.s)!, align: .center)
		Skin.text(NSLocalizedString("Yes", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), rect: CGRect(x: x1-Oo.s, y: y10, width: x9-x1, height: y7-y6), uiColor: UIColor.cyan, font: UIFont(name: "HelveticaNeue", size: 15*Oo.s)!, align: .center)
		Skin.text(NSLocalizedString("No", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), rect: CGRect(x: x10+Oo.s-2, y: y10, width: x9-x1+4, height: y7-y6), uiColor: UIColor.cyan, font: UIFont(name: "HelveticaNeue", size: 15*Oo.s)!, align: .center)
	}
}
