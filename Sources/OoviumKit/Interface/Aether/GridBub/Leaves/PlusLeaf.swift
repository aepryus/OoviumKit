//
//  PlusLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 11/17/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import UIKit

class PlusLeaf: Leaf, FocusTappable {
	
	var onTapped: (AetherView)->() = {AetherView in}
	
	init(bubble: Bubble) {
		super.init(bubble: bubble, hitch: .top, anchor: CGPoint.zero, size: CGSize(width: 36, height: 36))
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	var gridBub: GridBub {
		return bubble as! GridBub
	}
		
// Events ==========================================================================================
	func onTap(aetherView: AetherView) {
		onTapped(aetherView)
	}
		
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let d: CGFloat = 6
        let circlePath: CGPath = CGPath(roundedRect: rect.insetBy(dx: d, dy: d), cornerWidth: (width-d)/2, cornerHeight: (height-d)/2, transform: nil)
        Skin.gridFill(path: circlePath, uiColor: bubble.uiColor)
        Skin.gridDraw(path: circlePath, uiColor: bubble.uiColor)
//		Skin.bubble(path: CGPath(roundedRect: rect.insetBy(dx: d, dy: d), cornerWidth: (width-d)/2, cornerHeight: (height-d)/2, transform: nil), uiColor: bubble.uiColor, width: Oo.s)
			
		let p: CGFloat = 13
		let ir: CGFloat = width/2
		
		let x1 = p
		let x2 = ir
		let x3 = 2*ir-p
		
		let y1 = p
		let y2 = ir
		let y3 = 2*ir-p

		let path: CGMutablePath = CGMutablePath()
		
		path.move(to: CGPoint(x: x2, y: y1))
		path.addLine(to: CGPoint(x: x2, y: y3))
		path.move(to: CGPoint(x: x1, y: y2))
		path.addLine(to: CGPoint(x: x3, y: y2))

		Skin.bubble(path: path, uiColor: bubble.uiColor, width: 1)
		
		hitPath = path.mutableCopy()!
		(hitPath as! CGMutablePath).addPath(CGPath(roundedRect: rect.insetBy(dx: d, dy: d), cornerWidth: (width-d)/2, cornerHeight: (height-d)/2, transform: nil))
	}
}
