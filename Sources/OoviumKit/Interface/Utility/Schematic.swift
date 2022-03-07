//
//  Schematic.swift
//  Oovium
//
//  Created by Joe Charlier on 4/10/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class KeySlot {
	let row: CGFloat
	let col: CGFloat
	let w: CGFloat
	let h: CGFloat
	let key: UIControl
	
	init(row: CGFloat, col: CGFloat, w: CGFloat, h: CGFloat, key: UIControl) {
		self.row = row
		self.col = col
		self.w = w
		self.h = h
		self.key = key
	}
}

public class Schematic {
	let rows: Int
	let cols: Int
	let scrollable: Bool
	var keySlots = [KeySlot]()

	init(rows: Int, cols: Int, scrollable: Bool = false) {
		self.rows = rows
		self.cols = cols
		self.scrollable = scrollable
	}
	
	func add (row: CGFloat, col: CGFloat, w: CGFloat, h: CGFloat, key: UIControl) {
		keySlots.append(KeySlot(row: row, col: col, w: w, h: h, key: key))
	}
	func add (row: CGFloat, col: CGFloat, key: UIControl) {
		add(row: row, col: col, w: 1, h: 1, key: key)
	}
	func wipe() {
		keySlots.removeAll()
	}
	
	func render(rect: CGRect) {
		let margin: CGFloat = floor(7*Oo.s)
		let bw: CGFloat = floor((rect.size.width - 2*margin) / CGFloat(cols))
		let bh: CGFloat = floor((rect.size.height - 2*margin) / CGFloat(rows))
		
		for keySlot in keySlots {
			keySlot.key.frame = CGRect(x: margin+keySlot.col*bw, y: margin+keySlot.row*bh, width: keySlot.w*bw, height: keySlot.h*bh)
		}
	}
	
}
