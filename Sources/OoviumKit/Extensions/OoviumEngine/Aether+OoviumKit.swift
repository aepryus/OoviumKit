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
	public var aethers: [Aether] {
		return [self] + aexels.compactMap { ($0 as? Also)?.alsoAether }
	}

// Functions =======================================================================================
	public func functions(not: [Aether]) -> [String] {
		guard !not.contains(self) else {return []}
		var names: [String] = []
		aexels.forEach {
			if $0 is Mechlike {names.append($0.name)}
			else if $0 is Also {
				names += ($0 as! Also).alsoAether!.functions(not: not+[self])
			}
		}
		return names.sorted { (left: String, right: String) -> Bool in
			return left.uppercased() < right.uppercased()
		}
	}
	public var functions: [String] {
		return functions(not: [])
	}
	public func function(name: String, not: [Aether]) -> Mechlike? {
		guard !not.contains(self) else {return nil}
		for aexel in aexels {
			guard let function = aexel as? Mechlike else {continue}
			if function.name == name {return function}
		}
		for aexel in aexels {
			guard let also = aexel as? Also else {continue}
			if let function = also.alsoAether?.function(name: name, not: not+[self]) {return function}
		}
		return nil
	}
	public func function(name: String) -> Mechlike? {
		function(name: name, not: [])
	}
}
