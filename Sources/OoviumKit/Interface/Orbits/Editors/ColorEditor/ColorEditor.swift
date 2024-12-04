//
//  ColorEditor.swift
//  Oovium
//
//  Created by Joe Charlier on 9/6/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class ColorEditor: KeyOrbit {
	var state: State? = nil
	var colorLeaf: ColorLeaf? = nil

    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 8*30, height: 4*30), offset: UIOffset(horizontal: -6, vertical: -6), uiColor: UIColor.white, schematic: Schematic(rows: 4, cols: 8))

		schematic.add(row: 0, col: 0, key: Key(text: "", uiColor: Text.Color.clear.uiColor, {self.execute(.clear)}))
		schematic.add(row: 1, col: 0, key: Key(text: "", uiColor: Text.Color.white.uiColor, {self.execute(.white)}))
		schematic.add(row: 2, col: 0, key: Key(text: "", uiColor: Text.Color.grey.uiColor, {self.execute(.grey)}))
		schematic.add(row: 3, col: 0, key: Key(text: "", uiColor: Text.Color.black.uiColor, {self.execute(.black)}))
		schematic.add(row: 0, col: 1, key: Key(text: "", uiColor: Text.Color.cgaRed.uiColor, {self.execute(.cgaRed)}))
		schematic.add(row: 1, col: 1, key: Key(text: "", uiColor: Text.Color.cgaLightRed.uiColor, {self.execute(.cgaLightRed)}))
		schematic.add(row: 2, col: 1, key: Key(text: "", uiColor: Text.Color.cgaCyan.uiColor, {self.execute(.cgaCyan)}))
		schematic.add(row: 3, col: 1, key: Key(text: "", uiColor: Text.Color.cgaLightCyan.uiColor, {self.execute(.cgaLightCyan)}))
		schematic.add(row: 0, col: 2, key: Key(text: "", uiColor: Text.Color.cgaBrown.uiColor, {self.execute(.cgaBrown)}))
		schematic.add(row: 1, col: 2, key: Key(text: "", uiColor: Text.Color.cgaYellow.uiColor, {self.execute(.cgaYellow)}))
		schematic.add(row: 2, col: 2, key: Key(text: "", uiColor: Text.Color.cgaBlue.uiColor, {self.execute(.cgaBlue)}))
		schematic.add(row: 3, col: 2, key: Key(text: "", uiColor: Text.Color.cgaLightBlue.uiColor, {self.execute(.cgaLightBlue)}))
		schematic.add(row: 0, col: 3, key: Key(text: "", uiColor: Text.Color.cgaGreen.uiColor, {self.execute(.cgaGreen)}))
		schematic.add(row: 1, col: 3, key: Key(text: "", uiColor: Text.Color.cgaLightGreen.uiColor, {self.execute(.cgaLightGreen)}))
		schematic.add(row: 2, col: 3, key: Key(text: "", uiColor: Text.Color.cgaMagenta.uiColor, {self.execute(.cgaMagenta)}))
		schematic.add(row: 3, col: 3, key: Key(text: "", uiColor: Text.Color.cgaLightMagenta.uiColor, {self.execute(.cgaLightMagenta)}))

		schematic.add(row: 0, col: 4, key: Key(text: "", uiColor: Text.Color.red.uiColor, {self.execute(.red)}))
		schematic.add(row: 1, col: 4, key: Key(text: "", uiColor: Text.Color.maroon.uiColor, {self.execute(.maroon)}))
		schematic.add(row: 2, col: 4, key: Key(text: "", uiColor: Text.Color.magenta.uiColor, {self.execute(.magenta)}))
		schematic.add(row: 3, col: 4, key: Key(text: "", uiColor: Text.Color.violet.uiColor, {self.execute(.violet)}))
		schematic.add(row: 0, col: 5, key: Key(text: "", uiColor: Text.Color.orange.uiColor, {self.execute(.orange)}))
		schematic.add(row: 1, col: 5, key: Key(text: "", uiColor: Text.Color.peach.uiColor, {self.execute(.peach)}))
		schematic.add(row: 2, col: 5, key: Key(text: "", uiColor: Text.Color.cyan.uiColor, {self.execute(.cyan)}))
		schematic.add(row: 3, col: 5, key: Key(text: "", uiColor: Text.Color.lavender.uiColor, {self.execute(.lavender)}))
		schematic.add(row: 0, col: 6, key: Key(text: "", uiColor: Text.Color.yellow.uiColor, {self.execute(.yellow)}))
		schematic.add(row: 1, col: 6, key: Key(text: "", uiColor: Text.Color.paleYellow.uiColor, {self.execute(.paleYellow)}))
		schematic.add(row: 2, col: 6, key: Key(text: "", uiColor: Text.Color.marine.uiColor, {self.execute(.marine)}))
		schematic.add(row: 3, col: 6, key: Key(text: "", uiColor: Text.Color.cobolt.uiColor, {self.execute(.cobolt)}))
		schematic.add(row: 0, col: 7, key: Key(text: "", uiColor: Text.Color.lime.uiColor, {self.execute(.lime)}))
		schematic.add(row: 1, col: 7, key: Key(text: "", uiColor: Text.Color.olive.uiColor, {self.execute(.olive)}))
		schematic.add(row: 2, col: 7, key: Key(text: "", uiColor: Text.Color.green.uiColor, {self.execute(.green)}))
		schematic.add(row: 3, col: 7, key: Key(text: "", uiColor: Text.Color.blue.uiColor, {self.execute(.blue)}))

		renderSchematic()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func execute(_ ooColor: Text.Color) {
		orb.deorbit()
		state?.color = ooColor.rawValue
		colorLeaf?.setNeedsDisplay()
	}
}
