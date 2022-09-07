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
	init() {
        super.init(
            name: "Local".localized,
            url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("aethers", isDirectory: true)
        )
	}

	static var rootPath: String {
		FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.relativePath
	}

// Space ===========================================================================================
    override public func loadFacades(facade: Facade, _ complete: @escaping ([Facade]) -> ()) {
        let url: URL = facade.url
        var items: [Facade] = []
        do {
            let folderURLs: [URL] = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter( { $0.hasDirectoryPath } )
            items += folderURLs.map({ Facade.create(url: $0) })
                .sorted { $0.name.uppercased() < $1.name.uppercased() }

            let aetherURLs: [URL] = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).filter({ $0.pathExtension == "oo" })
            items += aetherURLs.map({ Facade.create(url: $0) })
                .sorted { $0.name.uppercased() < $1.name.uppercased() }
            
        } catch { print("\(error)") }
        complete(items)
    }
    override public func loadAether(facade: Facade, _ complete: @escaping (String?) -> ()) {
        let url: URL = facade.url
        if  let data = FileManager.default.contents(atPath: url.path),
            let json: String = String(data: data, encoding: .utf8) {
            complete(json)
        } else {
            print("no file at \(url.path)")
            complete(nil)
        }
    }
    override public func storeAether(facade: Facade, aether: Aether, _ complete: @escaping (Bool) -> ()) {
        let url: URL = facade.url
        FileManager.default.createFile(atPath: url.path, contents: aether.unload().toJSON().data(using: .utf8), attributes: nil)
        complete(true)
    }
    override public func renameAether(facade: Facade, name: String, _ complete: @escaping (Bool) -> ()) {
        let fURL: URL = facade.url
        facade.name = name
        let tURL: URL = facade.url
        do {
            try FileManager.default.moveItem(atPath: fURL.path, toPath: tURL.path)
            delegate?.onChanged(space: self)
            complete(true)
        } catch {
            print("renameAether ERROR: [\(error)]")
            complete(false)
        }
    }
    override public func removeAether(facade: Facade, _ complete: @escaping (Bool) -> ()) {
        let url: URL = facade.url
        do {
            try FileManager.default.removeItem(atPath: url.path)
            complete(true)
        } catch {
            print("removeAether ERROR: [\(error)]")
            complete(false)
        }
    }
    override public func createFolder(facade: Facade, name: String, _ complete: @escaping (Bool) -> ()) {
        let url: URL = facade.url
        do {
            try FileManager.default.createDirectory(at: url.appendingPathComponent(name, isDirectory: true), withIntermediateDirectories: true)
            complete(true)
        } catch {
            print("removeAether ERROR: [\(error)]")
            complete(false)
        }
    }
}
