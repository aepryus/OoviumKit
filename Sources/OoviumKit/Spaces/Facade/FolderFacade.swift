//
//  FolderFacade.swift
//  OoviumKit
//
//  Created by Joe Charlier on 10/7/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

public class FolderFacade: DirFacade {
    var _name: String
    var _parent: DirFacade
    
    init(name: String, parent: DirFacade) {
        _name = name
        _parent = parent
    }
    
// Facade ==========================================================================================
    override public var name: String {
        set {
            let prefix: String = (parent is SpaceFacade) ? "::" : "/"
            let oldKey: String = parent.ooviumKey + prefix + _name
            _name = newValue
            let newKey: String = parent.ooviumKey + prefix + _name
            Facade.reKey(oldKey: oldKey, newKey: newKey)
        }
        get { _name }
    }
    override public var parent: DirFacade { _parent }
    override var space: Space { parent.space }
    override public var ooviumKey: String {
        let prefix: String = (parent is SpaceFacade) ? "::" : "/"
        return parent.ooviumKey + prefix + name
    }
    override var url: URL { parent.url.appendingPathComponent(name) }
    
// Convenience =====================================================================================
    public func renameFolder(name: String, _ complete: @escaping (Bool)->()) { space.renameFolder(facade: self, name: name, complete) }
}
