//
//  LocalSpace.swift
//  Oovium
//
//  Created by Joe Charlier on 4/16/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine

public class LocalSpace: Space {
	let url: URL

	init(parent: Space) {
		self.url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("")
        super.init(type: .local, path: "", name: "Local".localized, parent: parent)
	}
	private init(url: URL, parent: Space) {
		self.url = url
		var path: String = url.relativePath
		let p: Int = path.lastLoc(of: "Documents")!
		path.removeFirst(p+10)
		super.init(type: .local, path: path, name: path == "" ? "Local" : url.lastPathComponent, parent: parent)
	}

	static var rootPath: String {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.relativePath
	}

	func path(name: String) -> String {
		return url.appendingPathComponent("\(name).oo").path
	}

//	func printAll() {
//		print("\nSpaces ===========================")
//		spaces.map { $0.name }.forEach { print(" :: \($0)") }
//
//		print("\nAether ===========================")
//		aetherNames.forEach { print(" :: \($0)") }
//	}

// Space ===========================================================================================
	override public func loadSpaces(complete: @escaping ([Space]) -> ()) {
		var spaces: [Space] = []
		do {
			let contents: [URL] = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter( { $0.hasDirectoryPath } )
			spaces = contents.map({ LocalSpace(url: $0, parent: self) }).sorted { $0.name.uppercased() < $1.name.uppercased() }
		} catch { print("\(error)") }
		complete(spaces)
	}
	override public func loadNames(complete: @escaping ([String]) -> ()) {
		var aetherNames: [String] = []
		do {
			let contents: [URL] = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).filter({
				$0.pathExtension == "oo"
			})
			aetherNames = contents.map({
				$0.deletingPathExtension().lastPathComponent
			}).sorted { $0.uppercased() < $1.uppercased() }
		} catch { print("\(error)") }
		complete(aetherNames.sorted { $0.uppercased() < $1.uppercased() })
	}
	override public func loadAether(name: String, complete: @escaping (String?) -> ()) {
		if	let data = FileManager.default.contents(atPath: path(name: name)),
			let json: String = String(data: data, encoding: .utf8) {
			complete(json)
		} else {
			print("no file at \(path(name: name))")
			complete(nil)
		}
	}
	override public func storeAether(_ aether: Aether, complete: @escaping (Bool) -> ()) {
		FileManager.default.createFile(atPath: path(name: aether.name), contents: aether.unload().toJSON().data(using: .utf8), attributes: nil)
		complete(true)
	}
	override public func removeAether(name: String, complete: @escaping (Bool) -> ()) {
		do {
			try FileManager.default.removeItem(atPath: path(name: name))
		} catch {
			print("\(error)")
		}
		complete(true)
	}
}
