//
//  AetherFacade.swift
//  OoviumKit
//
//  Created by Joe Charlier on 10/7/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine

public class AetherFacade: Facade {
    var _name: String
    private var _parent: DirFacade
    
//    var document: AnyObject?
    
    public init(name: String, parent: DirFacade) {
        _name = name
        _parent = parent
    }
    
// Facade ==========================================================================================
    public override var name: String { _name }
    public override var parent: DirFacade { _parent }
    override var space: Space { parent.space }
    public override var ooviumKey: String {
        let prefix: String = (parent is SpaceFacade) ? "::" : "/"
        return parent.ooviumKey + prefix + name
    }
    override var description: String { name }
    override var url: URL { parent.url.appendingPathComponent(name).appendingPathExtension("oo") }
    
// Convenience =====================================================================================
    public func load(_ complete: @escaping (String?)->()) throws { try space.loadAether(facade: self, complete) }
    public func store(aether: Aether, _ complete: @escaping (Bool)->()) { space.storeAether(facade: self, aether: aether, complete) }
    public func renameAether(name: String, _ complete: @escaping (Bool)->()) { space.renameAether(facade: self, name: name, complete) }
    public func duplicateAether(facade: AetherFacade, aether: Aether, _ complete: @escaping (AetherFacade?, Aether?) -> ()) { space.duplicateAether(facade: facade, aether: aether, complete) }

// Utility =========================================================================================
    private func isChild(of facade: Facade) -> Bool {
        var parent: Facade? = self
        while parent != nil {
            if parent === facade { return true }
            parent = parent?.parent
        }
        return false
    }
    func clothesLine(facade: Facade) -> String? {
        guard isChild(of: facade) else { return nil }
        return ooviumKey[facade.ooviumKey.count...]
    }
}
