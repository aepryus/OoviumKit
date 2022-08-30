//
//  CloudSpace.swift
//  Oovium
//
//  Created by Joe Charlier on 4/3/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation
import OoviumEngine

public class CloudSpace: Space {
    let url: URL
    var spaces: [CloudSpace] = []
    var names: [String] = []
    var metadata: [String:NSMetadataItem] = [:]
    
    public init(path: String, parent: Space) {
        var space: Space = parent
        while space.parent is CloudSpace { space = space.parent! }
        let cloudURL: URL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents")
        url = path == "" ? cloudURL : cloudURL.appendingPathComponent(path)
        super.init(type: .cloud, path: path, name: path == "" ? "iCloud" : url.lastPathComponent, parent: parent)
    }
    
    func load(metadataItems: [NSMetadataItem]) {
        metadataItems.forEach {
            guard var name: String = $0.value(forAttribute: NSMetadataItemDisplayNameKey) as? String else { return }
            if Screen.mac { name = (name as NSString).deletingPathExtension } // because of a Catalyst bug
            names.append(name)
            metadata[name] = $0
        }
        names.sort { $0.uppercased() < $1.uppercased() }
    }
    func wipeAll() {
        spaces = []
        names = []
        metadata = [:]
    }
    
// Space ===========================================================================================
    override public func loadSpaces(complete: @escaping ([Space]) -> ()) {
        complete(spaces)
    }
    override public func newSpace(name: String, _ complete: () -> ()) {
        complete()
    }
    override public func loadNames(complete: @escaping ([String]) -> ()) {
        complete(names)
    }
    override public func loadAether(name: String, complete: @escaping (String?) -> ()) {
        Cloud.loadAether(key: path+name, complete: complete)
    }
    override public func storeAether(_ aether: Aether, complete: @escaping (Bool) -> ()) {
        Cloud.storeAether(aether, key: path+aether.name, complete: complete)
    }
    override public func removeAether(name: String, complete: @escaping (Bool) -> ()) {
        complete(true)
    }
}
