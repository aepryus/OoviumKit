//
//  ColorContext.swift
//  Oovium
//
//  Created by Joe Charlier on 9/20/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class ColorContext: Context {
	unowned var shapeContext: ShapeContext!
	
    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 174, height: 174), offset: UIOffset(horizontal: (-84-3)*Oo.gS, vertical: 0), uiColor: .yellow, schematic: Schematic(rows: 4, cols: 4))
		
		self.schematic.add(row: 0, col: 0, key: Key(text: "", uiColor: OOColor.red.uiColor,         { self.execute(.red) }))
		self.schematic.add(row: 0, col: 1, key: Key(text: "", uiColor: OOColor.orange.uiColor,      { self.execute(.orange) }))
		self.schematic.add(row: 0, col: 2, key: Key(text: "", uiColor: OOColor.yellow.uiColor,      { self.execute(.yellow) }))
		self.schematic.add(row: 0, col: 3, key: Key(text: "", uiColor: OOColor.lime.uiColor,        { self.execute(.lime) }))
		self.schematic.add(row: 1, col: 0, key: Key(text: "", uiColor: OOColor.maroon.uiColor,      { self.execute(.maroon) }))
		self.schematic.add(row: 1, col: 1, key: Key(text: "", uiColor: OOColor.peach.uiColor,       { self.execute(.peach) }))
		self.schematic.add(row: 1, col: 2, key: Key(text: "", uiColor: OOColor.paleYellow.uiColor,  { self.execute(.paleYellow) }))
		self.schematic.add(row: 1, col: 3, key: Key(text: "", uiColor: OOColor.olive.uiColor,       { self.execute(.olive) }))
		self.schematic.add(row: 2, col: 0, key: Key(text: "", uiColor: OOColor.magenta.uiColor,     { self.execute(.magenta) }))
		self.schematic.add(row: 2, col: 1, key: Key(text: "", uiColor: OOColor.lavender.uiColor,    { self.execute(.lavender) }))
		self.schematic.add(row: 2, col: 2, key: Key(text: "", uiColor: OOColor.marine.uiColor,      { self.execute(.marine) }))
		self.schematic.add(row: 2, col: 3, key: Key(text: "", uiColor: OOColor.green.uiColor,       { self.execute(.green) }))
		self.schematic.add(row: 3, col: 0, key: Key(text: "", uiColor: OOColor.violet.uiColor,      { self.execute(.violet) }))
		self.schematic.add(row: 3, col: 1, key: Key(text: "", uiColor: OOColor.cyan.uiColor,        { self.execute(.cyan) }))
		self.schematic.add(row: 3, col: 2, key: Key(text: "", uiColor: OOColor.cobolt.uiColor,      { self.execute(.cobolt) }))
		self.schematic.add(row: 3, col: 3, key: Key(text: "", uiColor: OOColor.blue.uiColor,        { self.execute(.blue) }))
		
		self.schematic = schematic
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	func execute(_ ooColor: OOColor) {
        dismiss()
        (aetherView.selected as! Set<TextBub>).forEach { $0.color = ooColor }
	}
	
// Hover ===========================================================================================
	override func onInvoke() {
		orb.remove(orbit: shapeContext)
	}
}
