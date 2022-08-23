//
//  EvoNumSchematic.swift
//  Oovium
//
//  Created by Joe Charlier on 3/3/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

public class EvoNumSchematic: ChainSchematic {
	public init() {
		super.init(rows: 6, cols: 4, cyanKey: "num", imageNamed: "Number")
		
		let lemon = UIColor(red: 0.95, green: 0.85, blue: 0.55, alpha: 1)
		let banana = UIColor(red: 1, green: 0.85, blue: 0.27, alpha: 1)
		let orange = UIColor(red: 1, green: 0.6, blue: 0.18, alpha: 1)
		
		add(row: 0, col: 0, key: Key(text: "", uiColor: UIColor.cyan) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.toggleCyanKeyPad()
		})
		add(row: 0, col: 1, key: Key(text: "(,)", uiColor: banana) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.parenthesis()
		})
		add(row: 0, col: 2, w: 2, h: 1, key: Key(text: "\u{232B}", uiColor: lemon) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.backspace()
		})
		
		add(row: 1, col: 0, key: Key(text: "%", uiColor: banana, { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.mod)
		}))
		add(row: 1, col: 1, key: Key(text: "^", uiColor: banana) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.power)
		})
		add(row: 1, col: 2, key: Key(text: "\u{00F7}", uiColor: banana) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.divide)
		})
		add(row: 1, col: 3, key: Key(text: "\u{00D7}", uiColor: banana) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.multiply)
		})
		
		add(row: 2, col: 0, key: Key(text: "7", uiColor: orange) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.seven)
		})
		add(row: 2, col: 1, key: Key(text: "8", uiColor: orange) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.eight)
		})
		add(row: 2, col: 2, key: Key(text: "9", uiColor: orange) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.nine)
		})
		add(row: 2, col: 3, key: Key(text: "\u{2212}", uiColor: banana) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.subtract)
		})
		
		add(row: 3, col: 0, key: Key(text: "4", uiColor: orange) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.four)
		})
		add(row: 3, col: 1, key: Key(text: "5", uiColor: orange) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.five)
		})
		add(row: 3, col: 2, key: Key(text: "6", uiColor: orange) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.six)
		})
		add(row: 3, col: 3, key: Key(text: "+", uiColor: banana) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.add)
		})
		
		add(row: 4, col: 0, key: Key(text: "1", uiColor: orange) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.one)
		})
		add(row: 4, col: 1, key: Key(text: "2", uiColor: orange) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.two)
		})
		add(row: 4, col: 2, key: Key(text: "3", uiColor: orange) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.three)
		})
		add(row: 4, col: 3, w: 1, h: 2, key: Key(text: "=", uiColor: lemon) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.okDelegate()
		})
		
		add(row: 5, col: 0, w: 2, h: 1, key: Key(text: "0", uiColor: orange) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.zero)
		})
		add(row: 5, col: 2, key: Key(text: ".", uiColor: orange) { [weak self] in
			guard let me = self else {return}
			me.chainEditor.chainView.post(token: Token.period)
		})
	}
}
