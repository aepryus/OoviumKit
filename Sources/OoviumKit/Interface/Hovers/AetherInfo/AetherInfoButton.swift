//
//  AetherInfoButton.swift
//  Oovium
//
//  Created by Joe Charlier on 8/30/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class AetherInfoButton: UIButton {
	let path: CGPath
	let uiColor: UIColor
	let key: String
	let textRect: CGRect
	
	let pen: Pen
	
	init(frame: CGRect, path: CGPath, uiColor: UIColor, key: String, textRect: CGRect) {
		self.path = path
		self.uiColor = uiColor
		self.key = key
		self.textRect = textRect
		
		self.pen = Pen(font: UIFont.systemFont(ofSize: 14*Oo.s), color: UIColor.white, alignment: .center)

		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
// UIView ==========================================================================================
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		return path.contains(point) ? super.hitTest(point, with: event) : nil
	}
	override func draw(_ rect: CGRect) {
		Skin.key(path: path, uiColor: uiColor)
		Skin.panelOverride(text: NSLocalizedString(key, comment: ""), rect: textRect, pen: pen)
	}
}
