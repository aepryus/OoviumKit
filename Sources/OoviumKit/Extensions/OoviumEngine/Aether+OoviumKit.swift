//
//  Aether+OoviumKit.swift
// 	OoviumKit
//
//  Created by Joe Charlier on 3/9/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine

extension Aether {
	public var aethers: [Aether] { [self] + aexels.compactMap { ($0 as? Also)?.alsoAether } }

// Functions =======================================================================================
	public func functions(not: [Aether]) -> [Mechlike] {
		guard !not.contains(self) else {return []}
		var mechlikes: [Mechlike] = []
		aexels.forEach {
			if $0 is Mechlike {
                mechlikes.append($0 as! Mechlike)
            } else if let also: Also = $0 as? Also, let alsoAether: Aether = also.alsoAether {
                mechlikes += alsoAether.functions(not: not+[self])
			}
		}
		return mechlikes.sorted { (left: Mechlike, right: Mechlike) -> Bool in left.name.uppercased() < right.name.uppercased() }
	}
	public var functions: [Mechlike] { functions(not: []) }

	public func function(name: String, not: [Aether]) -> Mechlike? {
		guard !not.contains(self) else { return nil }
		for aexel in aexels {
			guard let function = aexel as? Mechlike else { continue }
			if function.name == name { return function }
		}
		for aexel in aexels {
			guard let also = aexel as? Also else { continue }
			if let function = also.alsoAether?.function(name: name, not: not+[self]) { return function }
		}
		return nil
	}
	public func function(name: String) -> Mechlike? { function(name: name, not: []) }
}
