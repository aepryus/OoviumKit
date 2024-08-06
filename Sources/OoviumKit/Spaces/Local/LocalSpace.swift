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
        let url: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("aethers", isDirectory: true)
        if !FileManager.default.fileExists(atPath: url.absoluteString) {
            do  {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
            } catch {
                print("LocalSpace.init ERROR [\(error)]")
            }
        }
        super.init(name: "Local".localized, url: url)
	}

// Space ===========================================================================================
    override var documentsRoot: String { "aethers" }
    public override func loadFacades(facade: DirFacade, _ complete: @escaping ([Facade]) -> ()) {
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
    public override func loadAether(facade: AetherFacade, _ complete: @escaping (String?) -> ()) {
        let url: URL = facade.url
        if  let data = FileManager.default.contents(atPath: url.path),
            let json: String = String(data: data, encoding: .utf8) {
            complete(json)
        } else {
            print("no file at \(url.path)")
            complete(nil)
        }
    }
    public override func storeAether(facade: AetherFacade, aether: Aether, _ complete: @escaping (Bool) -> ()) {
        let url: URL = facade.url
        FileManager.default.createFile(atPath: url.path, contents: aether.unload().toJSON().data(using: .utf8), attributes: nil)
        complete(true)
    }
    public override func renameAether(facade: AetherFacade, name: String, _ complete: @escaping (Bool) -> ()) {
        let fURL: URL = facade.url
        let tURL: URL = fURL.deletingLastPathComponent().appendingPathComponent(name).appendingPathExtension("oo")
        do {
            try FileManager.default.moveItem(atPath: fURL.path, toPath: tURL.path)
            delegate?.onChanged(space: self)
            complete(true)
        } catch {
            print("renameAether ERROR: [\(error)]")
            complete(false)
        }
    }
    public override func renameFolder(facade: FolderFacade, name: String, _ complete: @escaping (Bool) -> ()) {
        let fURL: URL = facade.url
        let tURL: URL = fURL.deletingLastPathComponent().appendingPathComponent(name)
        do {
            try FileManager.default.moveItem(atPath: fURL.path, toPath: tURL.path)
            facade.name = name
            delegate?.onChanged(space: self)
            complete(true)
        } catch {
            print("renameAether ERROR: [\(error)]")
            complete(false)
        }
    }
    public override func removeAether(facade: AetherFacade, _ complete: @escaping (Bool) -> ()) {
        let url: URL = facade.url
        do {
            try FileManager.default.removeItem(atPath: url.path)
            complete(true)
        } catch {
            print("removeAether ERROR: [\(error)]")
            complete(false)
        }
    }
    public override func createFolder(facade: DirFacade, name: String, _ complete: @escaping (Bool) -> ()) {
        do {
            try FileManager.default.createDirectory(at: facade.url.appendingPathComponent(name, isDirectory: true), withIntermediateDirectories: true)
            complete(true)
        } catch {
            print("removeAether ERROR: [\(error)]")
            complete(false)
        }
    }
}
