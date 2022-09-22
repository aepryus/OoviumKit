//
//  CustomSchematic.swift
//  Oovium
//
//  Created by Joe Charlier on 3/4/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

public class CustomSchematic: ChainSchematic {
	init() {
		super.init(rows: 5, cols: 1, cyanKey: "cus", imageNamed: "Custom")
	}
	
	public func render(aether: Aether) {
		let cherry = UIColor(red: 1, green: 0.77, blue: 0.68, alpha: 1)
		
		wipe()
		
		for (i , name) in aether.functions.enumerated() {
			add(row: CGFloat(i), col: 0, w: 1, h: 1, key: Key(text: name, uiColor: cherry, font: UIFont.systemFont(ofSize: 16*Oo.s), { [weak self] in
				guard let me = self else { return }
				me.chainEditor.chainView.post(token: aether.functionToken(tag: name))
				me.chainEditor.presentFirstSchematic()
			}))
		}
	}
}
