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
    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 174, height: 174), uiColor: UIColor.yellow, schematic: Schematic(rows: 4, cols: 8))

		self.schematic.add(row: 0, col: 0, key: Key(text: "", uiColor: Text.Color.clear.uiColor, {self.execute(.clear)}))
		self.schematic.add(row: 0, col: 1, key: Key(text: "", uiColor: Text.Color.white.uiColor, {self.execute(.white)}))
		self.schematic.add(row: 0, col: 2, key: Key(text: "", uiColor: Text.Color.grey.uiColor, {self.execute(.grey)}))
		self.schematic.add(row: 0, col: 3, key: Key(text: "", uiColor: Text.Color.black.uiColor, {self.execute(.black)}))
		self.schematic.add(row: 1, col: 0, key: Key(text: "", uiColor: Text.Color.cgaRed.uiColor, {self.execute(.cgaRed)}))
		self.schematic.add(row: 1, col: 1, key: Key(text: "", uiColor: Text.Color.cgaLightRed.uiColor, {self.execute(.cgaLightRed)}))
		self.schematic.add(row: 1, col: 2, key: Key(text: "", uiColor: Text.Color.cgaCyan.uiColor, {self.execute(.cgaCyan)}))
		self.schematic.add(row: 1, col: 3, key: Key(text: "", uiColor: Text.Color.cgaLightCyan.uiColor, {self.execute(.cgaLightCyan)}))
		self.schematic.add(row: 2, col: 0, key: Key(text: "", uiColor: Text.Color.cgaBrown.uiColor, {self.execute(.cgaBrown)}))
		self.schematic.add(row: 2, col: 1, key: Key(text: "", uiColor: Text.Color.cgaYellow.uiColor, {self.execute(.cgaYellow)}))
		self.schematic.add(row: 2, col: 2, key: Key(text: "", uiColor: Text.Color.cgaBlue.uiColor, {self.execute(.cgaBlue)}))
		self.schematic.add(row: 2, col: 3, key: Key(text: "", uiColor: Text.Color.cgaLightBlue.uiColor, {self.execute(.cgaLightBlue)}))
		self.schematic.add(row: 3, col: 0, key: Key(text: "", uiColor: Text.Color.cgaGreen.uiColor, {self.execute(.cgaGreen)}))
		self.schematic.add(row: 3, col: 1, key: Key(text: "", uiColor: Text.Color.cgaLightGreen.uiColor, {self.execute(.cgaLightGreen)}))
		self.schematic.add(row: 3, col: 2, key: Key(text: "", uiColor: Text.Color.cgaMagenta.uiColor, {self.execute(.cgaMagenta)}))
		self.schematic.add(row: 3, col: 3, key: Key(text: "", uiColor: Text.Color.cgaLightMagenta.uiColor, {self.execute(.cgaLightMagenta)}))
		
		self.schematic.add(row: 4, col: 0, key: Key(text: "", uiColor: Text.Color.red.uiColor, {self.execute(.red)}))
		self.schematic.add(row: 4, col: 1, key: Key(text: "", uiColor: Text.Color.orange.uiColor, {self.execute(.orange)}))
		self.schematic.add(row: 4, col: 2, key: Key(text: "", uiColor: Text.Color.yellow.uiColor, {self.execute(.yellow)}))
		self.schematic.add(row: 4, col: 3, key: Key(text: "", uiColor: Text.Color.lime.uiColor, {self.execute(.lime)}))
		self.schematic.add(row: 5, col: 0, key: Key(text: "", uiColor: Text.Color.maroon.uiColor, {self.execute(.maroon)}))
		self.schematic.add(row: 5, col: 1, key: Key(text: "", uiColor: Text.Color.peach.uiColor, {self.execute(.peach)}))
		self.schematic.add(row: 5, col: 2, key: Key(text: "", uiColor: Text.Color.paleYellow.uiColor, {self.execute(.paleYellow)}))
		self.schematic.add(row: 5, col: 3, key: Key(text: "", uiColor: Text.Color.olive.uiColor, {self.execute(.olive)}))
		self.schematic.add(row: 6, col: 0, key: Key(text: "", uiColor: Text.Color.magenta.uiColor, {self.execute(.magenta)}))
		self.schematic.add(row: 6, col: 1, key: Key(text: "", uiColor: Text.Color.lavender.uiColor, {self.execute(.lavender)}))
		self.schematic.add(row: 6, col: 2, key: Key(text: "", uiColor: Text.Color.marine.uiColor, {self.execute(.marine)}))
		self.schematic.add(row: 6, col: 3, key: Key(text: "", uiColor: Text.Color.green.uiColor, {self.execute(.green)}))
		self.schematic.add(row: 7, col: 0, key: Key(text: "", uiColor: Text.Color.violet.uiColor, {self.execute(.violet)}))
		self.schematic.add(row: 7, col: 1, key: Key(text: "", uiColor: Text.Color.cyan.uiColor, {self.execute(.cyan)}))
		self.schematic.add(row: 7, col: 2, key: Key(text: "", uiColor: Text.Color.cobolt.uiColor, {self.execute(.cobolt)}))
		self.schematic.add(row: 7, col: 3, key: Key(text: "", uiColor: Text.Color.blue.uiColor, {self.execute(.blue)}))
		
		self.schematic = schematic
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func execute(_ ooColor: Text.Color) {
	}
}
