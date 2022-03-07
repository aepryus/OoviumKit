//
//  OoviEditor.swift
//  Oovium
//
//  Created by Joe Charlier on 11/15/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class OoviEditor: Orbit {
	
	var oovi: Oovi!
	let schematic: Schematic = Schematic(rows: 4, cols: 9)

	var ooviBub: OoviBub {
		return editable as! OoviBub
	}
	
	init() {
		super.init(size: CGSize(width: 9*30, height: 4*30))
//		super.init(anchor: .bottomRight,offset: UIOffset(horizontal: -6, vertical: -6), size: CGSize(width: 9*30, height: 4*30), fixedOffset: UIOffset(horizontal: 0, vertical: 0), schematic: Schematic(rows: 4, cols: 9))

		schematic.add(row: 0, col: 0, key: Key(text: "", uiColor: OOColor.red.uiColor, {self.execute(.red)}))
		schematic.add(row: 0, col: 1, key: Key(text: "", uiColor: OOColor.orange.uiColor, {self.execute(.orange)}))
		schematic.add(row: 0, col: 2, key: Key(text: "", uiColor: OOColor.yellow.uiColor, {self.execute(.yellow)}))
		schematic.add(row: 0, col: 3, key: Key(text: "", uiColor: OOColor.lime.uiColor, {self.execute(.lime)}))
		schematic.add(row: 1, col: 0, key: Key(text: "", uiColor: OOColor.maroon.uiColor, {self.execute(.maroon)}))
		schematic.add(row: 1, col: 1, key: Key(text: "", uiColor: OOColor.peach.uiColor, {self.execute(.peach)}))
		schematic.add(row: 1, col: 2, key: Key(text: "", uiColor: OOColor.paleYellow.uiColor, {self.execute(.paleYellow)}))
		schematic.add(row: 1, col: 3, key: Key(text: "", uiColor: OOColor.olive.uiColor, {self.execute(.olive)}))
		schematic.add(row: 2, col: 0, key: Key(text: "", uiColor: OOColor.magenta.uiColor, {self.execute(.magenta)}))
		schematic.add(row: 2, col: 1, key: Key(text: "", uiColor: OOColor.lavender.uiColor, {self.execute(.lavender)}))
		schematic.add(row: 2, col: 2, key: Key(text: "", uiColor: OOColor.marine.uiColor, {self.execute(.marine)}))
		schematic.add(row: 2, col: 3, key: Key(text: "", uiColor: OOColor.green.uiColor, {self.execute(.green)}))
		schematic.add(row: 3, col: 0, key: Key(text: "", uiColor: OOColor.violet.uiColor, {self.execute(.violet)}))
		schematic.add(row: 3, col: 1, key: Key(text: "", uiColor: OOColor.cyan.uiColor, {self.execute(.cyan)}))
		schematic.add(row: 3, col: 2, key: Key(text: "", uiColor: OOColor.cobolt.uiColor, {self.execute(.cobolt)}))
		schematic.add(row: 3, col: 3, key: Key(text: "", uiColor: OOColor.white.uiColor, {self.execute(.white)}))
		schematic.add(row: 0, col: 4, key: Key(text: "", uiColor: OOColor.cgaRed.uiColor, {self.execute(.cgaRed)}))
		schematic.add(row: 1, col: 4, key: Key(text: "", uiColor: OOColor.cgaBlue.uiColor, {self.execute(.cgaBlue)}))
		schematic.add(row: 2, col: 4, key: Key(text: "", uiColor: OOColor.cgaCyan.uiColor, {self.execute(.cgaCyan)}))
		schematic.add(row: 3, col: 4, key: Key(text: "", uiColor: OOColor.cgaBrown.uiColor, {self.execute(.cgaBrown)}))
		schematic.add(row: 0, col: 5, key: Key(text: "", uiColor: OOColor.cgaGreen.uiColor, {self.execute(.cgaGreen)}))
		schematic.add(row: 1, col: 5, key: Key(text: "", uiColor: OOColor.cgaYellow.uiColor, {self.execute(.cgaYellow)}))
		schematic.add(row: 2, col: 5, key: Key(text: "", uiColor: OOColor.cgaMagenta.uiColor, {self.execute(.cgaMagenta)}))
		schematic.add(row: 3, col: 5, key: Key(text: "", uiColor: OOColor.cgaLightRed.uiColor, {self.execute(.cgaLightRed)}))
		schematic.add(row: 0, col: 6, key: Key(text: "", uiColor: OOColor.cgaLightBlue.uiColor, {self.execute(.cgaLightBlue)}))
		schematic.add(row: 1, col: 6, key: Key(text: "", uiColor: OOColor.cgaLightCyan.uiColor, {self.execute(.cgaLightCyan)}))
		schematic.add(row: 2, col: 6, key: Key(text: "", uiColor: OOColor.cgaLightGreen.uiColor, {self.execute(.cgaLightGreen)}))
		schematic.add(row: 3, col: 6, key: Key(text: "", uiColor: OOColor.cgaLightMagenta.uiColor, {self.execute(.cgaLightMagenta)}))
		
		schematic.add(row: 0, col: 7, w: 2, h: 4, key: Key(text: "OK", uiColor: UIColor.gray, {self.ooviBub.ok()}))
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}

	func execute(_ ooColor: OOColor) {
		oovi.color = ooColor
		ooviBub.setNeedsDisplayWithLeaves()
		ooviBub.colorChanged()
	}

// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let path = CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 10, cornerHeight: 10, transform: nil)
		Skin.bubble(path: path, uiColor: UIColor.gray, width: 2)
	}
}
