//
//  EvoDevSchematic.swift
//  Oovium
//
//  Created by Joe Charlier on 3/4/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

public class EvoDevSchematic: ChainSchematic {
	public init() {
		super.init(rows: 5, cols: 3, cyanKey: "dev", imageNamed: "Miscellaneous")
		
		let cherry = UIColor(red: 1, green: 0.77, blue: 0.68, alpha: 1)
		//		let blueberry = UIColor(red: 0.33, green: 0.53, blue: 0.77, alpha: 1)
		let plum = UIColor(red: 0.71, green: 0.65, blue: 0.87, alpha: 1)
		
		add(row: 0, col: 0, key: Key(text: "round", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.round)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 0, col: 1, key: Key(text: "floor", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.floor)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 0, col: 2, key: Key(text: "∑", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.sum)
			me.chainEditor.presentFirstSchematic()
		}))

		add(row: 1, col: 0, key: Key(text: "if", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.iif)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 1, key: Key(text: "min", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.min)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 2, key: Key(text: "max", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.max)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 2, col: 0, key: Key(text: "=", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.equal)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 2, col: 1, key: Key(text: "<", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.less)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 2, col: 2, key: Key(text: ">", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.greater)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 3, col: 0, key: Key(text: "\u{2260}", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.notEqual)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 3, col: 1, key: Key(text: "\u{2264}", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.lessOrEqual)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 3, col: 2, key: Key(text: "\u{2265}", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.greaterOrEqual)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 4, col: 0, key: Key(text: "!", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.not)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 4, col: 1, key: Key(text: "&&", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.and)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 4, col: 2, key: Key(text: "||", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.or)
			me.chainEditor.presentFirstSchematic()
		}))
	}
}
