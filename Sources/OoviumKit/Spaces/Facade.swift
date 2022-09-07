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
            Facade.facades[url.path] = nil
            url = space.url.appendingPathComponent(spaceKey)
            Facade.facades[url.path] = self
        }
    }
    unowned var parent: Facade?
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
        self.url = url
        type = url.hasDirectoryPath ? .folder : .aether
        name = url.itemName
        if url.pathComponents.count > 1 { parent = Facade.create(url: url.deletingLastPathComponent()) }
    }
    
    var space: Space { _space ?? parent!.space }
    var path: String {
        guard let parent = parent else { return "" }
        guard type == .folder else { return parent.path }
        guard parent.path.count > 0 else { return name }
        return "\(parent.path)/\(name)"
    }
    public var spaceKey: String { "\(path)/\(name).oo" }
    public var ooviumKey: String { "\(space.name)::\(spaceKey)" }
    
    public func loadFacades(_ complete: @escaping ([Facade])->()) { space.loadFacades(facade: self, complete) }
    public func store(aether: Aether, _ complete: @escaping (Bool)->()) { space.storeAether(facade: self, aether: aether, complete) }
    public func renameAether(name: String, _ complete: @escaping (Bool)->()) { space.renameAether(facade: self, name: name, complete) }
    public func createFolder(name: String, _ complete: @escaping (Bool)->()) { space.createFolder(facade: self, name: name, complete) }

// Static ==========================================================================================
    static var facades: [String:Facade] = [:]
    public static func create(space: Space) -> Facade {
        let facade: Facade = facades[space.url.path] ?? Facade(space: space)
        facades[space.url.path] = facade
        return facade
    }
    public static func create(url: URL) -> Facade {
        let facade: Facade = facades[url.path] ?? Facade(url: url)
        facades[url.path] = facade
        return facade
    }
}
