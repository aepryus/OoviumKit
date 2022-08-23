//
//  Space.swift
//  Oovium
//
//  Created by Joe Charlier on 4/16/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation
import OoviumEngine

protocol SpaceDelegate: AnyObject {
	func onChanged(space: Space)
}

public class Space {
	public enum SpaceType: String { case anchor, local, cloud, pequod }
	
	let type: SpaceType
	let path: String
	let name: String
	unowned let parent: Space?
	weak var delegate: SpaceDelegate? = nil

	public init(type: SpaceType, path: String, name: String, parent: Space? = nil) {
		self.type = type
		self.path = path
		self.name = name
		self.parent = parent
	}

	public var key: String {
		return "\(type.rawValue)::\(path)"
	}

	public func loadSpaces(complete: @escaping ([Space])->()) { complete([]) }
	public func loadNames(complete: @escaping ([String])->()) { complete([]) }
	public func loadAether(name: String, complete: @escaping (String?)->()) { complete(nil) }
	public func storeAether(_ aether: Aether, complete: @escaping (Bool)->() = {(Bool) in}) { complete(true) }
	public func removeAether(name: String, complete: @escaping (Bool)->() = {(Bool) in}) { complete(true) }

	public func newAether(complete: @escaping (Aether?)->()) {
		loadNames { (names: [String]) in
			let aether = Aether()
			var aetherNo: Int = 0
			var name: String = ""
			repeat {
				aetherNo += 1
				name = String(format: "%@%02d", "aether".localized, aetherNo)
			} while names.contains(name)
			aether.name = name
			self.storeAether(aether) { (success: Bool) in
				complete(aether)
			}
		}
	}

	public func loadDeepSpaces(complete: ([Space])->()) {
		var deepSpaces: [Space] = [self]
		let group = DispatchGroup()
		group.enter()
		loadSpaces { (spaces: [Space]) in
			spaces.forEach {
				group.enter()
				$0.loadDeepSpaces { (spaces: [Space]) in
					deepSpaces += spaces
					group.leave()
				}
			}
			group.leave()
		}
		let semaphore = DispatchSemaphore(value: 1)
		group.notify(queue: .main) {
			semaphore.signal()
		}
		semaphore.wait()
		complete(deepSpaces)
	}

	public func aetherPath(aether: Aether) -> String {
		if path == "" { return "\(key)\(aether.name)" }
		else { return "\(key)/\(aether.name)" }
	}

// Static ==========================================================================================
	public static let anchor: AnchorSpace = AnchorSpace()
	public static let local: LocalSpace = LocalSpace(parent: Space.anchor)
	public static var cloud: CloudSpace? = nil
	public static let pequod: PequodSpace = PequodSpace(path: "", parent: Space.anchor)

	public static var spaces: [String:Space] = [:]
	public static func loadSpaces(complete: ()->()) {
		Space.anchor.loadDeepSpaces { (spaces: [Space]) in
			spaces.forEach { self.spaces[$0.key] = $0 }
			print("Available Spaces ================================")
			self.spaces.forEach { print("\t \($0.key)") }
		}
	}
	public static func split(aetherPath: String) -> (String, String) {
		if let p: Int = aetherPath.lastLoc(of: "/") {
			return (aetherPath[...(p-1)], aetherPath[(p+1)...])
		} else if let p: Int = aetherPath.loc(of: "::") {
			return (aetherPath[...(p+1)], aetherPath[(p+2)...])
		} else {
            return ("", "")
//			fatalError()
		}
	}
	public static func digest(space: Space, name: String, complete: @escaping (Aether?)->()) {
		space.loadAether(name: name) { (json: String?) in
			guard let json = json else { complete(nil); return }
			complete(Aether(json: Migrate.migrateAether(json: json)))
		}
	}
	public static func digest(aetherPath: String, complete: @escaping ((Space, Aether)?)->()) {
		let (key, name) = split(aetherPath: aetherPath)

		guard let space: Space = spaces[key] else { return }

		digest(space: space, name: name) { (aether: Aether?) in
			guard let aether = aether else { complete(nil); return }
			complete((space, aether))
		}
	}
}
