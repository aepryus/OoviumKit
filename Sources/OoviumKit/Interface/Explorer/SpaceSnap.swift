//
//  SpaceSnap.swift
//  Oovium
//
//  Created by Joe Charlier on 8/23/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

class SpaceSnap: Snap {
    var space: Space

    init(space: Space, navigator: AetherNavigator) {
        self.space = space
        super.init(text: space.name, anchor: space.parent == nil)
        addAction { navigator.explorer.space = space }
    }
    required init?(coder: NSCoder) { fatalError() }
    
    var anchor: Bool { space.parent == nil }
}
