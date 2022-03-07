//
//  ExtendedColorContext.swift
//  Oovium
//
//  Created by Joe Charlier on 9/20/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class ExtendedColorContext: Context {
	init() {
		super.init(size: CGSize(width: 174, height: 174), uiColor: UIColor.yellow, schematic: Schematic(rows: 4, cols: 8))

		self.schematic.add(row: 0, col: 0, key: Key(text: "", uiColor: OOColor.clear.uiColor, {self.execute(.clear)}))
		self.schematic.add(row: 0, col: 1, key: Key(text: "", uiColor: OOColor.white.uiColor, {self.execute(.white)}))
		self.schematic.add(row: 0, col: 2, key: Key(text: "", uiColor: OOColor.grey.uiColor, {self.execute(.grey)}))
		self.schematic.add(row: 0, col: 3, key: Key(text: "", uiColor: OOColor.black.uiColor, {self.execute(.black)}))
		self.schematic.add(row: 1, col: 0, key: Key(text: "", uiColor: OOColor.cgaRed.uiColor, {self.execute(.cgaRed)}))
		self.schematic.add(row: 1, col: 1, key: Key(text: "", uiColor: OOColor.cgaLightRed.uiColor, {self.execute(.cgaLightRed)}))
		self.schematic.add(row: 1, col: 2, key: Key(text: "", uiColor: OOColor.cgaCyan.uiColor, {self.execute(.cgaCyan)}))
		self.schematic.add(row: 1, col: 3, key: Key(text: "", uiColor: OOColor.cgaLightCyan.uiColor, {self.execute(.cgaLightCyan)}))
		self.schematic.add(row: 2, col: 0, key: Key(text: "", uiColor: OOColor.cgaBrown.uiColor, {self.execute(.cgaBrown)}))
		self.schematic.add(row: 2, col: 1, key: Key(text: "", uiColor: OOColor.cgaYellow.uiColor, {self.execute(.cgaYellow)}))
		self.schematic.add(row: 2, col: 2, key: Key(text: "", uiColor: OOColor.cgaBlue.uiColor, {self.execute(.cgaBlue)}))
		self.schematic.add(row: 2, col: 3, key: Key(text: "", uiColor: OOColor.cgaLightBlue.uiColor, {self.execute(.cgaLightBlue)}))
		self.schematic.add(row: 3, col: 0, key: Key(text: "", uiColor: OOColor.cgaGreen.uiColor, {self.execute(.cgaGreen)}))
		self.schematic.add(row: 3, col: 1, key: Key(text: "", uiColor: OOColor.cgaLightGreen.uiColor, {self.execute(.cgaLightGreen)}))
		self.schematic.add(row: 3, col: 2, key: Key(text: "", uiColor: OOColor.cgaMagenta.uiColor, {self.execute(.cgaMagenta)}))
		self.schematic.add(row: 3, col: 3, key: Key(text: "", uiColor: OOColor.cgaLightMagenta.uiColor, {self.execute(.cgaLightMagenta)}))
		
		self.schematic.add(row: 4, col: 0, key: Key(text: "", uiColor: OOColor.red.uiColor, {self.execute(.red)}))
		self.schematic.add(row: 4, col: 1, key: Key(text: "", uiColor: OOColor.orange.uiColor, {self.execute(.orange)}))
		self.schematic.add(row: 4, col: 2, key: Key(text: "", uiColor: OOColor.yellow.uiColor, {self.execute(.yellow)}))
		self.schematic.add(row: 4, col: 3, key: Key(text: "", uiColor: OOColor.lime.uiColor, {self.execute(.lime)}))
		self.schematic.add(row: 5, col: 0, key: Key(text: "", uiColor: OOColor.maroon.uiColor, {self.execute(.maroon)}))
		self.schematic.add(row: 5, col: 1, key: Key(text: "", uiColor: OOColor.peach.uiColor, {self.execute(.peach)}))
		self.schematic.add(row: 5, col: 2, key: Key(text: "", uiColor: OOColor.paleYellow.uiColor, {self.execute(.paleYellow)}))
		self.schematic.add(row: 5, col: 3, key: Key(text: "", uiColor: OOColor.olive.uiColor, {self.execute(.olive)}))
		self.schematic.add(row: 6, col: 0, key: Key(text: "", uiColor: OOColor.magenta.uiColor, {self.execute(.magenta)}))
		self.schematic.add(row: 6, col: 1, key: Key(text: "", uiColor: OOColor.lavender.uiColor, {self.execute(.lavender)}))
		self.schematic.add(row: 6, col: 2, key: Key(text: "", uiColor: OOColor.marine.uiColor, {self.execute(.marine)}))
		self.schematic.add(row: 6, col: 3, key: Key(text: "", uiColor: OOColor.green.uiColor, {self.execute(.green)}))
		self.schematic.add(row: 7, col: 0, key: Key(text: "", uiColor: OOColor.violet.uiColor, {self.execute(.violet)}))
		self.schematic.add(row: 7, col: 1, key: Key(text: "", uiColor: OOColor.cyan.uiColor, {self.execute(.cyan)}))
		self.schematic.add(row: 7, col: 2, key: Key(text: "", uiColor: OOColor.cobolt.uiColor, {self.execute(.cobolt)}))
		self.schematic.add(row: 7, col: 3, key: Key(text: "", uiColor: OOColor.blue.uiColor, {self.execute(.blue)}))
		
		self.schematic = schematic
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	func execute(_ ooColor: OOColor) {
	}
}
