//
//  AnchorSpace.swift
//  Oovium
//
//  Created by Joe Charlier on 3/30/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Foundation

public class AnchorSpace: Space {

    init() { super.init(name: "◎", url: URL(string: "oovium.com")!) }

// Space ===========================================================================================
    public override func loadFacades(facade: Facade, _ complete: @escaping ([Facade]) -> ()) {
        var items: [Facade] = []
        items += [Facade.create(space: Space.local)]
        if let cloud = Space.cloud { items += [Facade.create(space: cloud)] }
//        items += [Facade.create(space: Space.pequod)]
        complete(items)
    }
}
