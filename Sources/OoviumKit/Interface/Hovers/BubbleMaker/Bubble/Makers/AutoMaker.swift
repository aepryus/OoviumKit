//
//  AutoMaker.swift
//  OoviumKit
//
//  Created by Joe Charlier on 11/13/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class AutoMaker: Maker {
// Maker ===========================================================================================
    func make(aetherView: AetherView, at: V2) -> Bubble {
        let auto: Auto = aetherView.aether.create(at: at)
        return AutoBub(auto, aetherView: aetherView)
    }
    func drawIcon() {}
}
