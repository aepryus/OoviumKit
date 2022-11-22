//
//  NewButton.swift
//  Oovium
//
//  Created by Joe Charlier on 8/25/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class NewButton: UIButton {
	var path: CGPath {
		didSet { setNeedsDisplay() }
	}
	var aetherPicker: AetherPicker!
	
	init(frame: CGRect, path: CGPath) {
		self.path = path
		super.init(frame: frame)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
// UIView ==========================================================================================
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? { path.contains(point) ? super.hitTest(point, with: event) : nil }
	override func draw(_ rect: CGRect) {
		Skin.aetherPicker(path: path)
		
		let p: CGFloat = 2*Oo.s
		let q: CGFloat = 13*Oo.s
		let sp: CGFloat = 4*Oo.s
		let bw: CGFloat = 60*Oo.s
		let lw: CGFloat = 18*Oo.s
		let sq: CGFloat = sp*sqrt(2)
		let r: CGFloat = q-sp/2
		
		let x1 = p
		
		let x8 = x1+sq
		let x9 = x8+r
		let x11 = x9+bw
		let x13 = x11+bw
		let x12 = x13-r
		
		let x15 = x12+sq
		let x16 = x15+r
		let x18 = x16+lw
		let x20 = x18+lw
		
		let y1 = p
		let y6 = y1+r
		let y7 = y6+r

		let pen: Pen = Pen(font: UIFont.systemFont(ofSize: 14*Oo.s), color: UIColor.green, alignment: .center)
		Skin.panel(text: aetherPicker.expanded ? NSLocalizedString("new", comment: "") : "\u{22C5}\u{22C5}\u{22C5}", rect: CGRect(x: x16, y: y1+2, width: x20-x16, height: y7-y1), pen: pen)
	}
}
