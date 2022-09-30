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

// UIDocument ======================================================================================
	override func contents(forType typeName: String) throws -> Any {
		guard let data = aether.unload().toJSON().data(using: .utf8) else { return "" }
		return data
	}
	override func load(fromContents contents: Any, ofType typeName: String?) throws {
		guard let data = contents as? Data, let json: String = String(data: data, encoding: .utf8) else { return }
		self.json = Migrate.migrateAether(json: json)
		aether = Aether()
		aether.load(attributes: self.json.toAttributes())

		switch documentState {
			case .inConflict:
                print("[\(aether.name)] conflicted...", terminator: "")
                
//                var versions: [NSFileVersion] = []
//                guard let current = NSFileVersion.currentVersionOfItem(at: fileURL),
//                      let other = NSFileVersion.otherVersionsOfItem(at: fileURL)
//                else { return }
//
//                versions.append(current)
//                versions.append(contentsOf: other)
//
//                versions.forEach {
//                    guard let date = $0.modificationDate else { return }
//                    print(date)
//                }

//                try! current.replaceItem(at: fileURL)
                
                guard let other: [NSFileVersion] = NSFileVersion.otherVersionsOfItem(at: fileURL) else { return }
                do {
                    try NSFileVersion.removeOtherVersionsOfItem(at: fileURL)
                    other.forEach { $0.isResolved = true }
                    print(" [RESOLVED]")
                } catch {
                    print(" [FAILED]")
                    print("inConflict resolution failed [\(error)]")
                }
                
//            case .closed:
//                print("[\(aether.name)] closed")
//            case .editingDisabled:
//                print("[\(aether.name)] editingDisabled")
//            case .normal:
//                print("[\(aether.name)] normal")
//                guard let other = NSFileVersion.otherVersionsOfItem(at: fileURL) else { return }
//                print(" >>>>>>>>>>> [\(other.count)]")
//            case .progressAvailable:
//                print("[\(aether.name)] progressAvailable")
//            case .savingError:
//                print("[\(aether.name)] savingError")
			default: break
        }
	}
	override func handleError(_ error: Error, userInteractionPermitted: Bool) {
		print("ERROR: \(error)")
	}
}
