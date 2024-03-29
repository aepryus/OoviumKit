//
//  RoundedShape.swift
//  Oovium
//
//  Created by Joe Charlier on 8/7/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class RoundedShape: Shape {
// Shape ===========================================================================================
	override func drawIcon(color: UIColor) {
		let p: CGFloat = 8*Oo.s
		let q: CGFloat = 13*Oo.s
		let w: CGFloat = 40*Oo.s-2*p
		let h: CGFloat = 40*Oo.s-2*q
		
		let x1 = p
		let y1 = q
		
		let path = CGPath(roundedRect: CGRect(x: x1, y: y1, width: w, height: h), cornerWidth: 5, cornerHeight: 5, transform: nil)
		Skin.bubble(path: path, uiColor: color, width: 2*Oo.s)
	}
	override func drawKey(_ rect: CGRect) {
		let path = CGPath(roundedRect: rect.insetBy(dx: 10*Oo.s, dy: 10*Oo.s), cornerWidth: 10*Oo.s, cornerHeight: 10*Oo.s, transform: nil)
		Skin.shapeKey(path: path)
	}
	override func bounds(size: CGSize) -> CGRect {
		return CGRect(x: 0, y: 0, width: size.width+30, height: size.height+20)
	}
	override func draw(rect: CGRect, uiColor: UIColor) {
		let path = CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 15, cornerHeight: 15, transform: nil)
        Skin.shape(path: path, uiColor: uiColor)
	}
}
