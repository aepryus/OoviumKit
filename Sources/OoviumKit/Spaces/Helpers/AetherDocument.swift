//
//  AetherDocument.swift
//  Oovium
//
//  Created by Joe Charlier on 4/11/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class AetherDocument: UIDocument {
	var json: String = ""
	var aether: Aether = Aether()

	var n: Int
	static var N: Int = 0

	override init(fileURL url: URL) {
		n = AetherDocument.N+1
		AetherDocument.N += 1
		print("Creating [\(n)]")
		super.init(fileURL: url)
	}

// UIDocument ======================================================================================
	override func contents(forType typeName: String) throws -> Any {
		print("Saving [\(aether.name)]")
		guard let data = aether.unload().toJSON().data(using: .utf8) else { return "" }
		return data
	}
	override func load(fromContents contents: Any, ofType typeName: String?) throws {
		print("Loading [\(n)]...")
		guard let data = contents as? Data, let json: String = String(data: data, encoding: .utf8) else { return }
		self.json = Migrate.migrateAether(json: json)
		aether = Aether()
		aether.load(attributes: self.json.toAttributes())

		switch documentState {
			case .inConflict:
				print("inConflict")
			default: break
		}
	}
	override func handleError(_ error: Error, userInteractionPermitted: Bool) {
		print("ERROR: \(error)")
	}
}
