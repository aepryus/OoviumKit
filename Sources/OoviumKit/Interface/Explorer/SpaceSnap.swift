//
//  SpaceSnap.swift
//  Oovium
//
//  Created by Joe Charlier on 8/23/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

class SpaceSnap: Snap {
    var item: Facade

    init(item: Facade, navigator: AetherNavigator) {
        self.item = item
        super.init(text: item.name, anchor: self.item.parent == nil)
        addAction { navigator.explorer.facade = item }
    }
    required init?(coder: NSCoder) { fatalError() }
    
    var anchor: Bool { item.parent == nil }
}
