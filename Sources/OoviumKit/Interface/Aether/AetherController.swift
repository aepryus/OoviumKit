//
//  AetherController.swift
//  OoviumKit
//
//  Created by Joe Charlier on 11/13/24.
//  Copyright © 2024 Aepryus Software. All rights reserved.
//

import OoviumEngine

public class AetherController {
    unowned let aetherView: AetherView
    
    init(aetherView: AetherView) {
        self.aetherView = aetherView
    }
    
    public func toggleExplorer() {
        if aetherView.aetherHover.aetherNameView.editing { aetherView.aetherHover.controller.onAetherViewReturn() }
        aetherView.slideToggle()
    }
    public func duplicateAether() {
        guard let facade = aetherView.facade else { return }
        facade.duplicateAether(facade: facade, aether: aetherView.aether, { (aetherFacade: AetherFacade?, aether: Aether?) in
            guard let aetherFacade, let aether else { return }
            self.aetherView.swapToAether(facade: aetherFacade, aether: aether)
        })
    }
}
