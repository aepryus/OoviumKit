//
//  LexiconSchematic.swift
//  Oovium
//
//  Created by Joe Charlier on 1/29/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class LexiconSchematic: ChainSchematic {

	init() {
		super.init(rows: 5, cols: 3, cyanKey: "dev", imageNamed: "Development")
		
		let cherry = UIColor(red: 1, green: 0.77, blue: 0.68, alpha: 1)
		let plum = UIColor(red: 0.71, green: 0.65, blue: 0.87, alpha: 1)

		add(row: 0, col: 0, key: Key(text: "abs", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.abs)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 0, col: 1, w: 2, h: 1, key: Key(text: "random", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.random)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 1, col: 0, key: Key(text: "sec", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.sec)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 1, key: Key(text: "csc", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.csc)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 2, key: Key(text: "cot", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.cot)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 2, col: 0, key: Key(text: "!", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.not)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 2, col: 1, key: Key(text: "&&", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.and)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 2, col: 2, key: Key(text: "||", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.or)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 3, col: 0, w: 2, h: 1, key: Key(text: "Complex", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.complex)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 3, col: 2, key: Key(text: "%", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.mod)
			me.chainEditor.presentFirstSchematic()
		}))

		add(row: 4, col: 0, w: 2, h: 1, key: Key(text: "Vector", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.vector)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 4, col: 2, key: Key(text: "\u{2022}", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.dot)
			me.chainEditor.presentFirstSchematic()
		}))
	}
}
