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

	init(bubble: Bubble, name: String, token: Token) {
		self.name = name
		self.token = token
		super.init(bubble: bubble)
		backgroundColor = UIColor.clear
        mooring = bubble.createMooring(token: token)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let path = CGPath(ellipseIn: rect.insetBy(dx: 1, dy: 1), transform: nil)
		hitPath = path
		Skin.tray(path: path, uiColor: bubble.uiColor, width: 2)
		Skin.shape(text: name, rect: CGRect(x: 0, y: 0, width: rect.width-1, height: rect.height+1), uiColor: bubble.uiColor)
	}
	
// Citable =========================================================================================
	func token(at: CGPoint) -> Token? { token }
}
