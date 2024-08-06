//
//  KeyView.swift
//  Oovium
//
//  Created by Joe Charlier on 2/10/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import UIKit

class KeyView: UIView {
	let uiColor: UIColor
	var schematic: Schematic {
		didSet { renderSchematic() }
	}
	
	init(size: CGSize, uiColor: UIColor = UIColor.orange, schematic: Schematic = Schematic(rows: 1, cols: 1)) {
		self.uiColor = uiColor
		self.schematic = schematic
		super.init(frame: CGRect(x: 0, y: 0, width: size.width*Oo.s, height: size.height*Oo.s))
		backgroundColor = .clear
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }

	private func renderSchematic() {
		subviews.forEach { $0.removeFromSuperview() }
		schematic.render(rect: bounds)
		schematic.keySlots.forEach { addSubview($0.key) }
	}
	
// UIView ==========================================================================================
	public override func draw(_ rect: CGRect) {
		let path = CGMutablePath()
		path.addRoundedRect(in: rect.insetBy(dx: 2*Oo.s, dy: 2*Oo.s), cornerWidth: 10*Oo.s, cornerHeight: 10*Oo.s)
		Skin.panel(path: path, uiColor: uiColor)
	}
}
