//
//  Space.swift
//  OoviumKit
//
//  Created by Joe Charlier on 4/16/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine

protocol SpaceDelegate: AnyObject {
    func onChanged(space: Space)
}

public class Space {
    let url: URL
    let name: String
    weak var delegate: SpaceDelegate? = nil

    init(name: String, url: URL) {
        self.name = name
        self.url = url
    }
    
    var documentsRoot: String { "Documents" }
    
    public func loadFacades(facade: Facade, _ complete: @escaping ([Facade])->()) { complete([]) }
    public func loadAether(facade: Facade, _ complete: @escaping (String?)->()) { complete(nil) }
    public func storeAether(facade: Facade, aether: Aether, _ complete: @escaping (Bool)->()) { complete(true) }
    public func renameAether(facade: Facade, name: String, _ complete: @escaping (Bool)->()) { complete(true) }
    public func renameFolder(facade: Facade, name: String, _ complete: @escaping (Bool)->()) { complete(true) }
    public func removeAether(facade: Facade, _ complete: @escaping (Bool)->()) { complete(true) }
    public func createFolder(facade: Facade, name: String, _ complete: @escaping (Bool)->()) { complete(true) }
    
// Static ==========================================================================================
    public static let anchor: AnchorSpace = AnchorSpace()
    public static let local: LocalSpace = LocalSpace()
    public static var cloud: CloudSpace?
    public static let pequod: PequodSpace = PequodSpace()
    
    public static func digest(facade: Facade, complete: @escaping (Aether?)->()) {
        facade.space.loadAether(facade: facade) { (json: String?) in
            guard let json = json else { complete(nil); return }
            complete(Aether(json: Migrate.migrateAether(json: json)))
        }
    }
}
