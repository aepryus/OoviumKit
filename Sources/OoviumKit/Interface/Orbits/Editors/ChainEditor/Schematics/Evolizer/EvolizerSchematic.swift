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
		
		add(row: 0, col: 0, key: Key(text: "chill", uiColor: indigo, { [unowned self] in
            self.chainEditor.chainView.post(token: Token.chill)
            self.chainEditor.presentFirstSchematic()
		}))
		add(row: 0, col: 1, key: ImageKey(image: UIImage(named: "Eat")!, uiColor: indigo, { [unowned self] in
            self.chainEditor.chainView.post(token: Token.eat)
            self.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 0, key: ImageKey(image: UIImage(named: "Flirt")!, uiColor: indigo, { [unowned self] in
            self.chainEditor.chainView.post(token: Token.flirt)
            self.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 1, key: ImageKey(image: UIImage(named: "Fight")!, uiColor: indigo, { [unowned self] in
            self.chainEditor.chainView.post(token: Token.fight)
            self.chainEditor.presentFirstSchematic()
		}))
		add(row: 1, col: 2, key: ImageKey(image: UIImage(named: "Flee")!, uiColor: indigo, { [unowned self] in
            self.chainEditor.chainView.post(token: Token.flee)
            self.chainEditor.presentFirstSchematic()
		}))
		add(row: 2, col: 0, w: 2, h: 1, key: ImageKey(image: UIImage(named: "Wander")!, uiColor: indigo, { [unowned self] in
            self.chainEditor.chainView.post(token: Token.wander)
            self.chainEditor.presentFirstSchematic()
		}))
		
		add(row: 3, col: 2, key: Key(text: "true", uiColor: kiwi, { [unowned self] in
            self.chainEditor.chainView.post(token: Token.yes)
            self.chainEditor.presentFirstSchematic()
		}))
		add(row: 4, col: 2, key: Key(text: "false", uiColor: kiwi, { [unowned self] in
            self.chainEditor.chainView.post(token: Token.no)
            self.chainEditor.presentFirstSchematic()
		}))
	}
}
