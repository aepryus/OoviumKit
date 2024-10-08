//
//  AetherDocument.swift
//  Oovium
//
//  Created by Joe Charlier on 4/11/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class AetherDocument: UIDocument {
	var json: String = ""
	var aether: Aether = Aether()
    
// UIDocument ======================================================================================
	override func contents(forType typeName: String) throws -> Any {
		guard let data = aether.unload().toJSON().data(using: .utf8) else { return "" }
		return data
	}
	override func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard var data = contents as? Data else { return }
        
        if documentState == .inConflict {
            print("[CONFLICT] [\(aether.name)] conflicted...", terminator: "")
            
            guard let conflictVersions: [NSFileVersion] = NSFileVersion.unresolvedConflictVersionsOfItem(at: fileURL) else { return }
            let sortedVersions: [NSFileVersion] = conflictVersions.sorted { $0.modificationDate ?? .now > $1.modificationDate ?? .now }
            guard let mostRecentVersion: NSFileVersion = sortedVersions.first else { return }
            do {
                try mostRecentVersion.replaceItem(at: fileURL)
                try NSFileVersion.removeOtherVersionsOfItem(at: fileURL)
                sortedVersions.forEach { $0.isResolved = true }
                data = try Data(contentsOf: fileURL)
            }
            catch { print("[CONFLICT] resolution failed [\(error)]") }
        }
                
		guard let json: String = String(data: data, encoding: .utf8) else { return }
		self.json = try Migrate.migrateAether(json: json)
		aether = Aether()
		aether.load(attributes: self.json.toAttributes())
	}
	override func handleError(_ error: Error, userInteractionPermitted: Bool) {
		print("ERROR: \(error)")
	}
}
