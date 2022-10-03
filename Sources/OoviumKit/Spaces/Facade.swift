//
//  Facade.swift
//  OoviumKit
//
//  Created by Joe Charlier on 9/6/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine

public class Facade {
    enum FacadeType { case aether, folder, space }
    
    public var url: URL
    var type: FacadeType
    var name: String {
        didSet {
            Facade.facades[url.ooviumKey] = nil
            var key: String = spaceKey
            if type == .aether { key += ".oo" }
            url = space.url.appendingPathComponent(key)
            Facade.facades[url.ooviumKey] = self
        }
    }
    public unowned var parent: Facade?
    unowned var _space: Space?
    var document: AnyObject?
    
    private init(space: Space) {
        url = space.url
        type = .space
        name = "\(space.name)"
        parent = space !== Space.anchor ? Facade.create(space: Space.anchor) : nil
        _space = space
    }
    private init(url: URL) {
        if url.path.contains("/../") { fatalError() }
        self.url = url
        type = self.url.hasDirectoryPath ? .folder : .aether
        name = self.url.itemName
        if self.url.pathComponents.count > 1 { parent = Facade.create(url: self.url.deletingLastPathComponent()) }
    }
    private init(ooviumKey: String) {
        var ooviumKey: String = ooviumKey
        if !ooviumKey.contains("::") || ooviumKey.contains("::/") { ooviumKey = "Local::aether01" }
        let loc: Int = ooviumKey.loc(of: "::")!
        let spaceName: String = ooviumKey[0...loc-1]
        let pathName: String = ooviumKey[(loc+2)...]
        let spaceFacade: Facade = Facade.facades[spaceName]!
        self.url = NSURL.fileURL(withPath: "\(spaceFacade.url.path)/\(pathName).oo")
        type = self.url.hasDirectoryPath ? .folder : .aether
        name = self.url.itemName
        if self.url.pathComponents.count > 1 { parent = Facade.create(url: self.url.deletingLastPathComponent()) }
    }

    var space: Space {
        if let space = _space { return space }
        if let parent = parent, self !== parent { return parent.space }
        return Space.local
    }
    var path: String {
        guard let parent = parent else { return "" }
        guard type == .folder else { return parent.path }
        guard parent.path.count > 0 else { return name }
        return "\(parent.path)/\(name)"
    }
    public var spaceKey: String {
        var sb: String = ""
        if path.count > 0 { sb += "\(path)/" }
        sb += name
        return sb
    }
    public var ooviumKey: String { "\(space.name)::\(spaceKey)" }
    
    public func loadFacades(_ complete: @escaping ([Facade])->()) { space.loadFacades(facade: self, complete) }
    public func store(aether: Aether, _ complete: @escaping (Bool)->()) { space.storeAether(facade: self, aether: aether, complete) }
    public func renameAether(name: String, _ complete: @escaping (Bool)->()) { space.renameAether(facade: self, name: name, complete) }
    public func createFolder(name: String, _ complete: @escaping (Bool)->()) { space.createFolder(facade: self, name: name, complete) }
    
    public func printFacade() {
        Swift.print("[ Facade ] =======================================")
        Swift.print("\tname: [\(name)] ")
        Swift.print("\tpath: [\(path)] ")
        Swift.print("\tspace: [\(space.name)] ")
        Swift.print("\tspaceKey: [\(spaceKey)] ")
        Swift.print("\tooviumKey: [\(ooviumKey)] ")
        Swift.print("\turl: [\(url)]")
    }

// Static ==========================================================================================
    static var facades: [String:Facade] = [:]
    public static func create(space: Space) -> Facade {
        let facade: Facade = facades[space.url.ooviumKey] ?? Facade(space: space)
        facades[space.url.ooviumKey] = facade
        return facade
    }
    public static func create(url: URL) -> Facade {
        let facade: Facade = facades[url.ooviumKey] ?? Facade(url: url)
        facades[url.ooviumKey] = facade
        return facade
    }
    public static func create(ooviumKey: String) -> Facade {
        let facade: Facade = facades[ooviumKey] ?? Facade(ooviumKey: ooviumKey)
        facades[ooviumKey] = facade
        return facade
    }
}
