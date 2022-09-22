//
//  EvolizerSchematic.swift
//  Oovium
//
//  Created by Joe Charlier on 3/3/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

public class EvolizerSchematic: ChainSchematic {
	public init() {
		super.init(rows: 5, cols: 3, cyanKey: "evo", imageNamed: "Evolizer")
		
		let indigo = UIColor(red: 123/255, green: 180/255, blue: 244/255, alpha: 1)
		let kiwi = UIColor(red: 0.75, green: 0.8, blue: 0.38, alpha: 1)
		
		add(row: 0, col: 0, key: Key(text: "chill", uiColor: indigo, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.chill)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 0, col: 1, key: ImageKey(image: UIImage(named: "Eat")!, uiColor: indigo, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.eat)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 0, key: ImageKey(image: UIImage(named: "Flirt")!, uiColor: indigo, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.flirt)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 1, key: ImageKey(image: UIImage(named: "Fight")!, uiColor: indigo, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.fight)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 2, key: ImageKey(image: UIImage(named: "Flee")!, uiColor: indigo, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.flee)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 2, col: 0, w: 2, h: 1, key: ImageKey(image: UIImage(named: "Wander")!, uiColor: indigo, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.wander)
			me.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 3, col: 2, key: Key(text: "true", uiColor: kiwi, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.yes)
			me.chainEditor.presentFirstSchematic()
		}))
		add(row: 4, col: 2, key: Key(text: "false", uiColor: kiwi, { [weak self] in
			guard let me = self else { return }
			me.chainEditor.chainView.post(token: Token.no)
			me.chainEditor.presentFirstSchematic()
		}))
	}
}
