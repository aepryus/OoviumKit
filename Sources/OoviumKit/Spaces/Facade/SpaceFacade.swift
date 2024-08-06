//
//  SpaceFacade.swift
//  OoviumKit
//
//  Created by Joe Charlier on 10/7/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

public class SpaceFacade: DirFacade {
    var _space: Space
    var _parent: SpaceFacade?
    
    init(space: Space) {
        _space = space
        _parent = space !== Space.anchor ? Facade.create(space: Space.anchor) as? SpaceFacade : nil
    }
    
// Facade ==========================================================================================
    override var name: String { space.name }
    public override var parent: DirFacade? { _parent }
    override var space: Space { _space }
    public override var ooviumKey: String { name }
    override var url: URL { space.url }
}
