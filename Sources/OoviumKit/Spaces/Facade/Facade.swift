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
    var name: String { "" }
    public var parent: DirFacade? { nil }
    var space: Space { .local }
    public var ooviumKey: String { "" }
    var description: String { "" }
    var url: URL { URL(string: "")! }
    
// Static ==========================================================================================
    static var facades: [String:Facade] = [:]
    public static func create(space: Space) -> Facade {
        var facade: Facade? = facades[space.name]
        if facade == nil {
            facade = SpaceFacade(space: space)
            facades[space.name] = facade
        }
        return facade!
    }
    public static func create(url: URL) -> Facade {
        var facade: Facade? = facades[url.ooviumKey]
        if facade == nil {
            let parentURL: URL = url.deletingLastPathComponent()
            let parent: DirFacade = Facade.create(url: parentURL) as! DirFacade
            if url.hasDirectoryPath {
                facade = FolderFacade(name: url.itemName, parent: parent)
            } else {
                facade = AetherFacade(name: url.itemName, parent: parent)
            }
            facades[url.ooviumKey] = facade
        }
        return facade!
    }
    private static func sliceKey(ooviumKey: String) -> (String, String) {
        if let loc: Int = ooviumKey.lastLoc(of: "/") {
            return (ooviumKey[...(loc-1)], ooviumKey[(loc+1)...])
        } else if let loc: Int = ooviumKey.loc(of: "::") {
            return (ooviumKey[...(loc-1)], ooviumKey[(loc+2)...])
        } else {
            fatalError()
        }
    }
    public static func create(ooviumKey: String) -> Facade {
        var facade: Facade? = facades[ooviumKey]
        if facade == nil {
            let sliceKey: (String, String) = Facade.sliceKey(ooviumKey: ooviumKey)
            let parent: DirFacade = Facade.create(ooviumKey: sliceKey.0) as! DirFacade
            let url: URL = parent.url.appendingPathComponent(sliceKey.1)
            var isDir : ObjCBool = false
            if FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir), isDir.boolValue {
                facade = FolderFacade(name: sliceKey.1, parent: parent)
            } else {
                facade = AetherFacade(name: sliceKey.1, parent: parent)
            }
            facades[ooviumKey] = facade
        }
        return facade!
    }
}

//public class Facade {
//
//    public var url: URL
//    var type: FacadeType
//    var name: String {
//        didSet {
//            var oldKey: String = "\(space.name)::"
//            if path.count > 0 { oldKey += "\(path)/" }
//            oldKey += oldValue
//            Facade.facades[oldKey] = nil
//            var key: String = spaceKey
//            if type == .aether { key += ".oo" }
//            url = space.url.appendingPathComponent(key)
//            Facade.facades[url.ooviumKey] = self
//        }
//    }
//    public unowned var parent: Facade?
//    unowned var _space: Space?
//    var document: AnyObject?
//
//    private init(space: Space) {
//        url = space.url
//        type = .space
//        name = "\(space.name)"
//        parent = space !== Space.anchor ? Facade.create(space: Space.anchor) : nil
//        _space = space
//    }
//    private init(url: URL) {
//        if url.path.contains("/../") { fatalError() }
//        self.url = url
//        type = self.url.hasDirectoryPath ? .folder : .aether
//        name = self.url.itemName
//        if self.url.pathComponents.count > 1 { parent = Facade.create(url: self.url.deletingLastPathComponent()) }
//    }
//    private init(ooviumKey: String) {
//        var ooviumKey: String = ooviumKey
//        if !ooviumKey.contains("::") || ooviumKey.contains("::/") { ooviumKey = "Local::aether01" }
//        let loc: Int = ooviumKey.loc(of: "::")!
//        let spaceName: String = ooviumKey[0...loc-1]
//        let pathName: String = ooviumKey[(loc+2)...]
//        let spaceFacade: Facade = Facade.facades[spaceName]!
//        self.url = NSURL.fileURL(withPath: "\(spaceFacade.url.path)/\(pathName).oo")
//        type = self.url.hasDirectoryPath ? .folder : .aether
//        name = self.url.itemName
//        if self.url.pathComponents.count > 1 { parent = Facade.create(url: self.url.deletingLastPathComponent()) }
//    }
//
//    var space: Space {
//        if let space = _space { return space }
//        if let parent = parent, self !== parent { return parent.space }
//        return Space.local
//    }
//    var path: String {
//        guard let parent = parent, parent.type != .space else { return "" }
//        guard type == .folder else { return parent.spaceKey }
//        guard parent.spaceKey.count > 0 else { return "" }
//        return "\(parent.spaceKey)/\(name)"
//    }
//    public var spaceKey: String {
//        var sb: String = ""
//        if path.count > 0 { sb += "\(path)/" }
//        sb += name
//        return sb
//    }
//    public var ooviumKey: String {
//        guard type != .space else { return space.name }
//        return "\(space.name)::\(spaceKey)"
//    }
//
//    public func loadFacades(_ complete: @escaping ([Facade])->()) { space.loadFacades(facade: self, complete) }
//    public func store(aether: Aether, _ complete: @escaping (Bool)->()) { space.storeAether(facade: self, aether: aether, complete) }
//    public func renameAether(name: String, _ complete: @escaping (Bool)->()) { space.renameAether(facade: self, name: name, complete) }
//    public func renameFolder(name: String, _ complete: @escaping (Bool)->()) { space.renameFolder(facade: self, name: name, complete) }
//    public func createFolder(name: String, _ complete: @escaping (Bool)->()) { space.createFolder(facade: self, name: name, complete) }
//
//
//    public func printFacade() {
//        Swift.print("[ Facade ] =======================================")
//        Swift.print("\tname: [\(name)] ")
//        Swift.print("\tpath: [\(path)] ")
//        Swift.print("\tspace: [\(space.name)] ")
//        Swift.print("\tspaceKey: [\(spaceKey)] ")
//        Swift.print("\tooviumKey: [\(ooviumKey)] ")
//        Swift.print("\turl: [\(url)]")
//    }
//
//}
