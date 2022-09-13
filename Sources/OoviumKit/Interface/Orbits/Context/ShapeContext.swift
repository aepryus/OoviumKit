//
//  ShapeContext.swift
//  Oovium
//
//  Created by Joe Charlier on 9/20/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

private class ShapeKey: Key {
	let shape: OOShape
	
	init(shape: OOShape, _ closure: @escaping()->()) {
		self.shape = shape
		super.init(text: "", uiColor: UIColor.white, font: UIFont(name: "Verdana", size: 14)!, closure)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let path = CGPath(roundedRect: rect.insetBy(dx: 4*Oo.s, dy: 4*Oo.s), cornerWidth: 20/3*Oo.s, cornerHeight: 20/3*Oo.s, transform: nil)
		let c = UIGraphicsGetCurrentContext()!

		c.addPath(path)
		c.setLineWidth(6)
		UIColor.white.alpha(0.3).setStroke()
		c.drawPath(using: .stroke)

		c.addPath(path)
		c.setLineWidth(4)
		UIColor.white.alpha(0.6).setStroke()
		c.drawPath(using: .stroke)
		
		c.addPath(path)
		c.setLineWidth(2)
		UIColor.white.setFill()
		UIColor.white.alpha(0.07).setStroke()
		c.drawPath(using: .fillStroke)

		shape.shape.drawKey(rect)
	}
}

class ShapeContext: Context {
	unowned var colorContext: ColorContext!

    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 74, height: 174), offset: UIOffset(horizontal: (-84-3)*Oo.gS, vertical: 0), uiColor: .yellow, schematic: Schematic(rows: 4, cols: 1))
		
		self.schematic.add(row: 0, col: 0, key: ShapeKey(shape: .ellipse,   { self.execute(.ellipse) }))
		self.schematic.add(row: 1, col: 0, key: ShapeKey(shape: .rounded,   { self.execute(.rounded) }))
		self.schematic.add(row: 2, col: 0, key: ShapeKey(shape: .rectangle, { self.execute(.rectangle) }))
		self.schematic.add(row: 3, col: 0, key: ShapeKey(shape: .diamond,   { self.execute(.diamond) }))
		
		self.schematic = schematic
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	func execute(_ ooShape: OOShape) {
        dismiss()
        (aetherView.selected as! Set<TextBub>).forEach { $0.shape = ooShape }
	}

// Hover ===========================================================================================
	override func onInvoke() {
		orb.remove(orbit: colorContext)
	}
}
