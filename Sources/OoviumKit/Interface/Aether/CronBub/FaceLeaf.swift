//
//  FaceLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 2/18/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class FaceLeaf: Leaf, FocusTappable, TowerListener, Citable {
	
	init(bubble: Bubble) {
		super.init(bubble: bubble, hitch: .top, anchor: CGPoint.zero, size: CGSize(width: 80, height: 36))
        self.mooring = bubble.createMooring(token: cronBub.cron.token)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	var cronBub: CronBub { bubble as! CronBub }
	
	func render() {
		let text = cronBub.cron.tower.obje.display
		let pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!)
		let width = max((text as NSString).size(withAttributes: pen.attributes).width + 36, 80)
		if width != size.width {
			size = CGSize(width: width, height: size.height)
			bubble.layoutLeaves()
		}
	}

// Events ==========================================================================================
	func onFocusTap(aetherView: AetherView) { cronBub.morph() }
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let path = CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 15, cornerHeight: 15, transform: nil)
		hitPath = path
		Skin.bubble(path: path, uiColor: bubble.uiColor, width: Oo.s)
		Skin.bubble(text: "\(cronBub.cron.tower.obje.display)", rect: CGRect(x: 0, y: 7.5, width: rect.width, height: 20), uiColor: bubble.uiColor)
	}
	
// Citable =========================================================================================
	func token(at: CGPoint) -> Token? { cronBub.cron.token }
	
// TowerListener ===================================================================================
	func onTriggered() {
		self.render()
		self.setNeedsDisplay()
	}
}
