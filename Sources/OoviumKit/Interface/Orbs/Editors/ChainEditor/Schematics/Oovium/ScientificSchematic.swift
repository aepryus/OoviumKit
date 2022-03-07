//
//  ScientificSchematic.swift
//  Oovium
//
//  Created by Joe Charlier on 3/4/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

public class ScientificSchematic: ChainSchematic {
	let inverseSchematic: InverseSchematic = InverseSchematic()
	
	public init() {
		super.init(rows: 5, cols: 3, cyanKey: "sci", imageNamed: "Scientific")
		
		inverseSchematic.scientifcSchematic = self
		
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
			me.chainEditor.keyView.schematic = me.inverseSchematic
		}))
		
		add(row: 1, col: 0, key: Key(text: "ln", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.ln)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 1, key: Key(text: "log", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.log)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 2, key: Key(text: "log\u{2082}", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.log2)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 2, col: 0, key: Key(text: "sin", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.sin)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 2, col: 1, key: Key(text: "cos", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.cos)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 2, col: 2, key: Key(text: "tan", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.tan)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 3, col: 0, key: Key(text: "sinh", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.sinh)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 3, col: 1, key: Key(text: "cosh", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.cosh)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 3, col: 2, key: Key(text: "tanh", uiColor: cherry, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.tanh)
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
	
// ChainEditor =====================================================================================
	override var chainEditor: ChainEditor! {
		didSet {inverseSchematic.chainEditor = chainEditor}
	}
}
