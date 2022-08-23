//
//  KeyOrbit.swift
//  Oovium
//
//  Created by Joe Charlier on 2/5/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import UIKit

public class KeyOrbit: Orbit {
	let uiColor: UIColor
	var schematic: Schematic {
		didSet { renderSchematic() }
	}
	
	init(size: CGSize, offset: UIOffset = .zero, uiColor: UIColor = UIColor.orange, schematic: Schematic = Schematic(rows: 1, cols: 1)) {
		self.uiColor = uiColor
		self.schematic = schematic
		super.init(size: size, offset: offset)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}

	func renderSchematic() {
		subviews.forEach { $0.removeFromSuperview() }
		schematic.render(rect: bounds)
		schematic.keySlots.forEach { addSubview($0.key) }
	}
	
// Hover ===========================================================================================
//	override func rescale() {
//		super.rescale()
//		renderSchematic()
//	}
//	override func reRender() {
//		schematic.keySlots.forEach { $0.key.setNeedsDisplay() }
//	}

// UIView ==========================================================================================
	override public func draw(_ rect: CGRect) {
		let path = CGMutablePath()
		path.addRoundedRect(in: rect.insetBy(dx: 2*Oo.s, dy: 2*Oo.s), cornerWidth: 10*Oo.s, cornerHeight: 10*Oo.s)
		Skin.panel(path: path, uiColor: uiColor)
	}
}
