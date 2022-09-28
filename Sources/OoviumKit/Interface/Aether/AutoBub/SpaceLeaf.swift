//
//  SpaceLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 6/27/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class SpaceLeaf: Leaf, Citable {
	let token: Token
	var name: String
	let mooring: Mooring = Mooring()

	init(bubble: Bubble, name: String, token: Token) {
		self.name = name
		self.token = token
		super.init(bubble: bubble)
		backgroundColor = UIColor.clear
		mooring.colorable = self.bubble
		self.bubble.aetherView.moorings[self.token] = self.mooring
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
// Leaf ============================================================================================
	override func positionMoorings() {
		mooring.point = self.bubble.aetherView.scrollView.convert(self.center, from: self.superview)
		mooring.positionDoodles()
	}


// UIView ==========================================================================================
	override var frame: CGRect {
		didSet {mooring.point = self.bubble.aetherView.scrollView.convert(self.center, from: self.superview)}
	}
	override func draw(_ rect: CGRect) {
		let path = CGPath(ellipseIn: rect.insetBy(dx: 1, dy: 1), transform: nil)
		hitPath = path
		Skin.tray(path: path, uiColor: bubble.uiColor, width: 2)
		Skin.shape(text: name, rect: CGRect(x: 0, y: 0, width: rect.width-1, height: rect.height+1), uiColor: bubble.uiColor)
	}
	
// Citable =========================================================================================
	func token(at: CGPoint) -> Token? {
		return token
	}
}
