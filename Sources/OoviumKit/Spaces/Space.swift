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
    
    public func loadFacades(facade: DirFacade, _ complete: @escaping ([Facade])->()) { complete([]) }
    public func loadAether(facade: AetherFacade, _ complete: @escaping (String?)->()) throws { complete(nil) }
    public func storeAether(facade: AetherFacade, aether: Aether, _ complete: @escaping (Bool)->()) { complete(true) }
    public func renameAether(facade: AetherFacade, name: String, _ complete: @escaping (Bool)->()) { complete(true) }
    public func duplicateAether(facade: AetherFacade, aether: Aether, _ complete: @escaping (AetherFacade?, Aether?)->()) { complete(nil, nil) }
    public func renameFolder(facade: FolderFacade, name: String, _ complete: @escaping (Bool)->()) { complete(true) }
    public func removeAether(facade: AetherFacade, _ complete: @escaping (Bool)->()) { complete(true) }
    public func createFolder(facade: DirFacade, name: String, _ complete: @escaping (Bool)->()) { complete(true) }
    
// Static ==========================================================================================
    public static let anchor: AnchorSpace = AnchorSpace()
    public static let local: LocalSpace = LocalSpace()
    public static var cloud: CloudSpace?
    public static let pequod: PequodSpace = PequodSpace()
    public static let statics: StaticsSpace = StaticsSpace()
}
