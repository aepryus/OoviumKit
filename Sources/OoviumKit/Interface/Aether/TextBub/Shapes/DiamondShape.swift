//
//  DiamondShape.swift
//  Oovium
//
//  Created by Joe Charlier on 8/7/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class DiamondShape: Shape {
// Shape ===========================================================================================
	override func drawIcon(color: UIColor) {
		let p: CGFloat = 8*Oo.s
		let q: CGFloat = 8*Oo.s
		let r: CGFloat = 4*Oo.s
		let w: CGFloat = 40*Oo.s
		let h: CGFloat = 40*Oo.s
		
		let x1 = p
		let x3 = w/2
		let x5 = w-p
		let x2 = (x1+x3)/2
		let x4 = (x3+x5)/2
		
		let y1 = q
		let y3 = h/2
		let y5 = h-q
		let y2 = (y1+y3)/2
		let y4 = (y3+y5)/2
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x2, y: y2))
		path.addArc(tangent1End: CGPoint(x: x3, y: y1), tangent2End: CGPoint(x: x4, y: y2), radius: r)
		path.addArc(tangent1End: CGPoint(x: x5, y: y3), tangent2End: CGPoint(x: x4, y: y4), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y5), tangent2End: CGPoint(x: x2, y: y4), radius: r)
		path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x2, y: y2), radius: r)
		path.closeSubpath()
		
		Skin.bubble(path: path, uiColor: UIColor.lightGray, width: 2*Oo.s)
	}
	override func drawKey(_ rect: CGRect) {
		let p: CGFloat = 6
		let r: CGFloat = 5*Oo.s
		
		let x3 = rect.size.width/2
		let x1 = x3-rect.size.height/2+p
		let x5 = x3+rect.size.height/2-p
		let x2 = (x1+x3)/2
		let x4 = (x3+x5)/2
		
		let y1 = p
		let y3 = rect.size.height/2
		let y5 = rect.size.height-p
		let y2 = (y1+y3)/2
		let y4 = (y3+y5)/2
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x2, y: y2))
		path.addArc(tangent1End: CGPoint(x: x3, y: y1), tangent2End: CGPoint(x: x4, y: y2), radius: r)
		path.addArc(tangent1End: CGPoint(x: x5, y: y3), tangent2End: CGPoint(x: x4, y: y4), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y5), tangent2End: CGPoint(x: x2, y: y4), radius: r)
		path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x2, y: y2), radius: r)
		path.closeSubpath()
		
		Skin.shapeKey(path: path)
	}
	override func bounds(size: CGSize) -> CGRect {
		return CGRect(x: 0, y: 0, width: size.width+size.height+12, height: size.width+size.height+12)
	}
	override func draw(rect: CGRect, uiColor: UIColor) {
		let p: CGFloat = 3
		let r: CGFloat = 10
		
		let x1 = p + rect.origin.x
		let x3 = rect.size.width/2
		let x5 = rect.size.width-p
		let x2 = (x1+x3)/2
		let x4 = (x3+x5)/2
		
		let y1 = p + rect.origin.x
		let y3 = rect.size.height/2
		let y5 = rect.size.height-p
		let y2 = (y1+y3)/2
		let y4 = (y3+y5)/2
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x2, y: y2))
		path.addArc(tangent1End: CGPoint(x: x3, y: y1), tangent2End: CGPoint(x: x4, y: y2), radius: r)
		path.addArc(tangent1End: CGPoint(x: x5, y: y3), tangent2End: CGPoint(x: x4, y: y4), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y5), tangent2End: CGPoint(x: x2, y: y4), radius: r)
		path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x2, y: y2), radius: r)
		path.closeSubpath()
		
        Skin.shape(path: path, uiColor: uiColor)
	}
}
