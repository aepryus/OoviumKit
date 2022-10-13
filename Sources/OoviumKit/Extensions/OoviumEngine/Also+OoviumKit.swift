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
	public var facadeAether: (Facade, Aether)? {
//		guard let (facade, aether) = facadeSpace.digest(aetherPath: aetherPath) else { return nil }
//		return (facade, aether)
        return nil
	}
	public var aetherName: String {
        ""
//		Space.split(aetherPath: aetherPath).1
	}
	public var alsoAether: Aether? { facadeAether?.1 }
	public var functionCount: Int { alsoAether?.functions(not: [aether]).count ?? 0 }
}
