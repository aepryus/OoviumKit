//
//  InverseSchematic.swift
//  Oovium
//
//  Created by Joe Charlier on 3/4/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class InverseSchematic: ChainSchematic {
	weak var scientifcSchematic: ScientificSchematic!
	
	init() {
		super.init(rows: 5, cols: 3, cyanKey: "sci", imageNamed: "Scientific")
		
		let cherry = UIColor(red: 1, green: 0.77, blue: 0.68, alpha: 1)
		let grape = UIColor(red: 0.8, green: 0.4, blue: 0.8, alpha: 1)
		let kiwi = UIColor(red: 0.75, green: 0.8, blue: 0.38, alpha: 1)
		
		add(row: 0, col: 0, key: Key(text: "\u{221A}", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.sqrt)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 0, col: 1, key: Key(text: "n!", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.fac)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 0, col: 2, key: Key(text: "inv", uiColor: grape, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.keyView.schematic = me.scientifcSchematic
		}))
		
		add(row: 1, col: 0, key: Key(text: "e\u{207F}", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.exp)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 1, key: Key(text: "10\u{207F}", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.tenth)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 2, key: Key(text: "2\u{207F}", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.second)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 2, col: 0, key: Key(text: "asin", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.asin)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 2, col: 1, key: Key(text: "acos", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.acos)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 2, col: 2, key: Key(text: "atan", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.atan)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 3, col: 0, key: Key(text: "asinh", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.asinh)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 3, col: 1, key: Key(text: "acosh", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.acosh)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 3, col: 2, key: Key(text: "atanh", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.atanh)
			me.chainEditor.presentFirstSchematic()
		}))
		
		let font = UIFont(name: "TimesNewRomanPS-ItalicMT", size: 20*Oo.s)!
		add(row: 4, col: 0, key: Key(text: "π", uiColor: kiwi, font: font, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.pi)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 4, col: 1, key: Key(text: "e", uiColor: kiwi, font: font, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.e)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 4, col: 2, key: Key(text: "i", uiColor: kiwi, font: font, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.i)
			me.chainEditor.presentFirstSchematic()
		}))

	}
}
