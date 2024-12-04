//
//  EndLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 2/18/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class EndLeaf: Leaf, FocusTappable {
	
	init(bubble: Bubble) {
		super.init(bubble: bubble, hitch: .top, anchor: CGPoint.zero, size: CGSize(width: 39, height: 39))
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	var cronBub: CronBub { bubble as! CronBub }
	
// Events ==========================================================================================
	func onFocusTap(aetherView: AetherView) {
        cronBub.cron.endMode = Cron.EndMode(rawValue: (cronBub.cron.endMode.rawValue+1) % 5)!
		setNeedsDisplay()
		cronBub.selectLeaves()
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		Skin.bubble(path: CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 18, cornerHeight: 18, transform: nil), uiColor: bubble.uiColor, width: Oo.s)
		hitPath = CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 18, cornerHeight: 18, transform: nil)

		let p: CGFloat = 11
		let ir: CGFloat = rect.size.width/2
		let sl: CGFloat = 4
		
		let x1 = p
		let x2 = ir
		let x3 = 2*ir-p
		
		let y1 = ir-3
		let y2 = ir
		let y3 = ir+3
		
		let path: CGMutablePath = CGMutablePath()
		
		switch cronBub.cron.endMode {
			case .stop:
				path.move(to: CGPoint(x: x1, y: y1))
				path.addLine(to: CGPoint(x: x1, y: y3))
				path.move(to: CGPoint(x: x1, y: y2))
				path.addLine(to: CGPoint(x: x3, y: y2))
				path.addEllipse(in: CGRect(x: x3-5, y: y2-3, width: 6, height: 6))
			
			case .repeat:
				path.move(to: CGPoint(x: x1, y: y1-sl))
				path.addLine(to: CGPoint(x: x1, y: y3-sl))
				path.move(to: CGPoint(x: x1, y: y2-sl))
				path.addLine(to: CGPoint(x: x3, y: y2-sl))
				path.move(to: CGPoint(x: x3-3, y: y2-2-sl))
				path.addLine(to: CGPoint(x: x3-3, y: y2+2-sl))
				path.addLine(to: CGPoint(x: x3+1, y: y2-sl))
				path.closeSubpath()
			
				path.move(to: CGPoint(x: x1, y: y1+sl))
				path.addLine(to: CGPoint(x: x1, y: y3+sl))
				path.move(to: CGPoint(x: x1, y: y2+sl))
				path.addLine(to: CGPoint(x: x3, y: y2+sl))
				path.move(to: CGPoint(x: x3-3, y: y2-2+sl))
				path.addLine(to: CGPoint(x: x3-3, y: y2+2+sl))
				path.addLine(to: CGPoint(x: x3+1, y: y2+sl))
				path.closeSubpath()
			
			case .bounce:
				path.move(to: CGPoint(x: x1, y: y1-sl))
				path.addLine(to: CGPoint(x: x1, y: y3-sl))
				path.move(to: CGPoint(x: x1, y: y2-sl))
				path.addLine(to: CGPoint(x: x3, y: y2-sl))
				path.move(to: CGPoint(x: x3-3, y: y2-2-sl))
				path.addLine(to: CGPoint(x: x3-3, y: y2+2-sl))
				path.addLine(to: CGPoint(x: x3+1, y: y2-sl))
				path.closeSubpath()
				
				path.move(to: CGPoint(x: x3, y: y1+sl))
				path.addLine(to: CGPoint(x: x3, y: y3+sl))
				path.move(to: CGPoint(x: x1, y: y2+sl))
				path.addLine(to: CGPoint(x: x3, y: y2+sl))
				path.move(to: CGPoint(x: x1+4, y: y2-2+sl))
				path.addLine(to: CGPoint(x: x1+4, y: y2+2+sl))
				path.addLine(to: CGPoint(x: x1, y: y2+sl))
				path.closeSubpath()
			
			case .endless:
				path.move(to: CGPoint(x: x1, y: y1))
				path.addLine(to: CGPoint(x: x1, y: y3))
				path.move(to: CGPoint(x: x1, y: y2))
				path.addLine(to: CGPoint(x: x3, y: y2))
				path.move(to: CGPoint(x: x3-3, y: y2-2))
				path.addLine(to: CGPoint(x: x3-3, y: y2+2))
				path.addLine(to: CGPoint(x: x3+1, y: y2))
				path.closeSubpath()
			
			case .while:
				Skin.end(text: "?", x: 14.5, y: 9.5, uiColor: bubble.uiColor)
				path.move(to: CGPoint(x: x1, y: y1))
				path.addLine(to: CGPoint(x: x1, y: y3))

				path.move(to: CGPoint(x: x1, y: y2))
				path.addLine(to: CGPoint(x: x2-5, y: y2))
				path.move(to: CGPoint(x: x2+3, y: y2))
				path.addLine(to: CGPoint(x: x3, y: y2))

				path.move(to: CGPoint(x: x3-3, y: y2-2))
				path.addLine(to: CGPoint(x: x3-3, y: y2+2))
				path.addLine(to: CGPoint(x: x3+1, y: y2))
				path.closeSubpath()
		}

		Skin.end(path: path, uiColor: bubble.uiColor)
	}
}
