//
//  VarsLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 10/24/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class VarsLeaf: Leaf {
	unowned let oovi: Oovi
	var varViews: [VarView] = []
	
	init(bubble: Bubble, names: [String], oovi: Oovi) {
		self.oovi = oovi
		
		super.init(bubble: bubble, hitch: .topLeft, anchor: CGPoint.zero, size: CGSize.zero)
		
		self.backgroundColor = UIColor.clear
		
//		for name in names {
//			let token = oovi.aether.variableToken(tag: "Oovi\(self.oovi.no).\(name)")
//			let varView = VarView(bubble: bubble , token: token)
//			addSubview(varView)
//			varViews.append(varView)
//		}
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	private static func range(x: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
		if x < min {return min}
		if x > max {return max}
		return x
	}
	
// Leaf ============================================================================================
	override func positionMoorings() {
//		for varView in varViews {
//			varView.mooring.point = self.bubble.aetherView.scrollView.convert(self.center, from: self.superview)
//			varView.mooring.positionDoodles()
//		}
	}
	
// UIView ==========================================================================================
	override func layoutSubviews() {
		let p: CGFloat = 2
		let vh: CGFloat = (bounds.size.height - 2*p) / CGFloat(varViews.count)
		var y: CGFloat = 2
		for varView in varViews {
			varView.frame = CGRect(x: 0, y: y, width: bounds.size.width, height: vh)
			y += vh
		}
	}
	override func draw(_ rect: CGRect) {
		let p: CGFloat = 2

		let c = UIGraphicsGetCurrentContext()!
		bubble.uiColor.setStroke()
		UIColor.black.setFill()
		c.addPath(CGPath(roundedRect: rect.insetBy(dx: 1, dy: 1), cornerWidth: 8, cornerHeight: 8, transform: nil))
		c.drawPath(using: .fillStroke)
		
		let vh: CGFloat = (rect.size.height - 2*p) / CGFloat(varViews.count)
		
		var y: CGFloat = 0
		for i in 0..<varViews.count {
			y += vh
			
			if i != varViews.count-1 {
				bubble.uiColor.setFill()
				c.fill(CGRect(x: 0, y: y, width: rect.size.width, height: 1))
			}
		}
		
	}
}
