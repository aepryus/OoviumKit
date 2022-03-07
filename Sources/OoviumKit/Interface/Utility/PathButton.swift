//
//  PathButton.swift
//  Oovium
//
//  Created by Joe Charlier on 2/6/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class PathButton: UIButton {
	var path: CGPath {
		didSet {
			let box = path.boundingBox.insetBy(dx: -2, dy: -2)
			var transform = CGAffineTransform(translationX: -box.origin.x, y: -box.origin.y)
			self.path = path.copy(using: &transform)!
			frame = box
		}
	}
	var uiColor: UIColor {didSet{setNeedsDisplay()}}
	var key: String
	var offset: UIOffset
	
	var pen: Pen
	
	init(uiColor: UIColor = UIColor.white, key: String) {
		path = CGMutablePath()
		self.uiColor = uiColor
		self.key = key
		offset = UIOffset.zero
		
		self.pen = Pen(font: UIFont.oovium(size: 14*Oo.s), color: uiColor, alignment: .center)

		super.init(frame: CGRect.zero)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	func draw(path: CGPath) {
		Skin.bubble(path: path, uiColor: uiColor, width: 2)
		Skin.bubble(text: key.localized, rect: path.boundingBox.offsetBy(dx: offset.horizontal, dy: offset.vertical), pen: pen)
//		Skin.panelOverride(text: key.localized, rect: bounds.offsetBy(dx: offset.horizontal, dy: offset.vertical), pen: pen)
	}
	
// UIView ==========================================================================================
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		return path.contains(point) ? super.hitTest(point, with: event) : nil
	}
	override func draw(_ rect: CGRect) {
		draw(path: path)
	}
}
