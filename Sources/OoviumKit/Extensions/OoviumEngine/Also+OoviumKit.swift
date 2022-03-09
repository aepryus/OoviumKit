//
//  Also+OoviumKit.swift
// 	OoviumKit
//
//  Created by Joe Charlier on 3/9/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine

extension Also {
	public var spaceAether: (Space, Aether)? {
//		guard let (space, aether) = Space.digest(aetherPath: aetherPath) else { return nil }
//		return (space, aether)
		return nil
	}
	public var aetherName: String {
		Space.split(aetherPath: aetherPath).1
	}
	public var alsoAether: Aether? {
		spaceAether?.1
	}
	public var functionCount: Int {
		return alsoAether?.functions(not: [aether]).count ?? 0
	}
}
