//
//  MiruMaker.swift
//  OoviumKit
//
//  Created by Joe Charlier on 11/13/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class MiruMaker: Maker {
// Maker ===========================================================================================
    func make(aetherView: AetherView, at: V2) -> Bubble {
        let miru: Miru = aetherView.aether.create(at: at)
        return MiruBub(miru, aetherView: aetherView)
    }
    func drawIcon() {}
}
