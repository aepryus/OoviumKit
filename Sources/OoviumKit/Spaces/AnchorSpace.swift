//
//  AnchorSpace.swift
//  Oovium
//
//  Created by Joe Charlier on 3/30/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Foundation

class AnchorSpace: Space {

	init() { super.init(type: .anchor, path: "", name: "◎") }

// Space ===========================================================================================
	override func loadSpaces(complete: @escaping ([Space]) -> ()) {
		var spaces: [Space] = []
		spaces += [Space.local]
		if let cloud = Space.cloud { spaces += [cloud] }
		spaces += [Space.pequod]
		complete(spaces)
	}
}
