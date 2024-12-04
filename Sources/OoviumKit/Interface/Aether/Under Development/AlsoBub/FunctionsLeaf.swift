//
//  FunctionsLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 4/20/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class FunctionsLeaf: Leaf, Citable {
	private let also: Also
	
	init(bubble: Bubble) {
		also = (bubble as! AlsoBub).also
		super.init(bubble: bubble)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	var alsoBub: AlsoBub {
		return bubble as! AlsoBub
	}
	
	var color: UIColor {
		return !bubble.selected ? Text.Color.blue.uiColor : bubble.uiColor
	}
	
	func render() {
		size = CGSize(width: 120, height: CGFloat(also.functionCount)*27*s+2*2*s)
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		guard also.functionCount > 0 else { return }
		let r: CGFloat = 13.5*s
		let p: CGFloat = 2*s

		let x2: CGFloat = p+r
		let x4: CGFloat = width-p-r
		
		var y1: CGFloat = p
		var y2: CGFloat = p+r
		
		let path: CGMutablePath = CGMutablePath()
		
		path.move(to: CGPoint(x: x2, y: y1))
		path.addArc(center: CGPoint(x: x4, y: y2), radius: r, startAngle: 3/2*CGFloat.pi, endAngle: 1/2*CGFloat.pi, clockwise: false)
		path.addArc(center: CGPoint(x: x2, y: y2), radius: r, startAngle: 1/2*CGFloat.pi, endAngle: 3/2*CGFloat.pi, clockwise: false)
		for _ in 0..<max(also.functionCount-1,0) {
			y1 += 2*r
			y2 += 2*r
			path.move(to: CGPoint(x: x4, y: y1))
			path.addArc(center: CGPoint(x: x4, y: y2), radius: r, startAngle: 3/2*CGFloat.pi, endAngle: 1/2*CGFloat.pi, clockwise: false)
			path.addArc(center: CGPoint(x: x2, y: y2), radius: r, startAngle: 1/2*CGFloat.pi, endAngle: 3/2*CGFloat.pi, clockwise: false)
		}
		
		Skin.bubble(path: path, uiColor: color, width: 4.0/3.0*Oo.s)
		
//		y1 = p
//		for i in 0..<also.functionCount {
//			Skin.bubble(text: also.alsoAether!.functions(not: [also.aether])[i], rect: CGRect(x: 0, y: y1, width: width, height: r*2), uiColor: color)
//			y1 += 2*r
//		}
	}
	
// Citable =========================================================================================
	func tokenKey(at: CGPoint) -> TokenKey? {
        nil
//		let i: Int = Int(at.y / 27*s)
//		guard i < also.functionCount, let name: String = also.alsoAether?.functions(not: [also.aether])[i] else { return nil }
//        return also.alsoAether?.function(name: name, not: [also.aether])?.mechlikeToken.key ?? nil
	}
}
