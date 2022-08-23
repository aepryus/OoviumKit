//
//  ChainSchematic.swift
//  Oovium
//
//  Created by Joe Charlier on 3/3/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Foundation

public class ChainSchematic: Schematic {
	let cyanKey: String
	let imageNamed: String
	weak var chainEditor: ChainEditor!
	
	init(rows: Int, cols: Int, cyanKey: String, imageNamed: String) {
		self.cyanKey = cyanKey
		self.imageNamed = imageNamed
		super.init(rows: rows, cols: cols)
	}
}
