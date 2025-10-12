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
    public var name: String { "" }
    public var parent: DirFacade? { nil }
    var space: Space { .local }
    public var ooviumKey: String { "" }
    var description: String { "" }
    public var url: URL { URL(string: "")! }
    
// Static ==========================================================================================
    private static var facades: [String:Facade] = [:]
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
    public static func reKey(oldKey: String, newKey: String) {
        guard let facade: Facade = facades[oldKey] else { return }
        facades[oldKey] = nil
        facades[newKey] = facade
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
    public static func create(ooviumKey: String, forceDir: Bool = false) -> Facade {
        var facade: Facade? = facades[ooviumKey]
        if facade == nil {
            let sliceKey: (String, String) = Facade.sliceKey(ooviumKey: ooviumKey)
            let parent: DirFacade = Facade.create(ooviumKey: sliceKey.0, forceDir: true) as! DirFacade
            let url: URL = parent.url.appendingPathComponent(sliceKey.1)
            var isDir : ObjCBool = false
            if forceDir || (FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir) && isDir.boolValue) {
                facade = FolderFacade(name: sliceKey.1, parent: parent)
            } else {
                facade = AetherFacade(name: sliceKey.1, parent: parent)
            }
            facades[ooviumKey] = facade
        }
        return facade!
    }
    static func fingerprint(facades: [Facade]) -> String {
        var sb: String = ""
        facades.forEach { sb += "\($0.ooviumKey);" }
        return sb
    }
}
