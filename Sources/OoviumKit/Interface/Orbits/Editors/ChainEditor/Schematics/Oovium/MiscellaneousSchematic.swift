//
//  MiscellaneousSchematic.swift
//  Oovium
//
//  Created by Joe Charlier on 3/3/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

public class MiscellaneousSchematic: ChainSchematic {
	public init() {
		super.init(rows: 5, cols: 3, cyanKey: "mis", imageNamed: "Miscellaneous")
		
		let cherry = UIColor(red: 1, green: 0.77, blue: 0.68, alpha: 1)
//		let blueberry = UIColor(red: 0.33, green: 0.53, blue: 0.77, alpha: 1)
		let plum = UIColor(red: 0.71, green: 0.65, blue: 0.87, alpha: 1)
		let almond: UIColor = UIColor(red: 0.93, green: 0.93, blue: 0.7, alpha: 1)
		
		add(row: 0, col: 0, key: Key(text: "round", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: .round)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 0, col: 1, key: Key(text: "floor", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: .floor)
			me.chainEditor.presentFirstSchematic()
		}))
//		add(row: 0, col: 2, key: Key(text: "lex", uiColor: blueberry, {
//			self.presentSciSchematic()
//			me.chainEditor.presentFirstSchematic()
//		}))
		
		add(row: 1, col: 0, key: Key(text: "if", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: .iif)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 1, key: Key(text: "min", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: .min)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 2, key: Key(text: "max", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: .max)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 2, col: 0, key: Key(text: "=", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: .equal)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 2, col: 1, key: Key(text: "<", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: .less)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 2, col: 2, key: Key(text: ">", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: .greater)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 3, col: 0, key: Key(text: "\u{2260}", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: .notEqual)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 3, col: 1, key: Key(text: "\u{2264}", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: .lessOrEqual)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 3, col: 2, key: Key(text: "\u{2265}", uiColor: plum, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: .greaterOrEqual)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 4, col: 0, key: Key(text: "∑", uiColor: cherry, { [weak self] in
			guard let me = self else { return }
            me.chainEditor.chainView.post(token: .sum)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 4, col: 1, key: Key(text: "[ ]", uiColor: almond, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.braket()
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 4, col: 2, key: Key(text: "k", uiColor: almond, font: UIFont(name: "TimesNewRomanPS-ItalicMT", size: 20*Oo.s)!, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: .k)
			me.chainEditor.presentFirstSchematic()
		}))
	}
}
