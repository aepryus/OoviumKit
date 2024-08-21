//
//  TextMaker.swift
//  OoviumKit
//
//  Created by Joe Charlier on 11/13/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class TextMaker: Maker {
// Maker ===========================================================================================
    func make(aetherView: AetherView, at: V2) -> Bubble {
        let text: Text = aetherView.create(at: at)
        text.shape = aetherView.shape
        text.color = aetherView.color
        return TextBub(text, aetherView: aetherView)
    }
    func drawIcon() {
        OOShape.ellipse.shape.drawIcon(color: UIColor.orange)
    }
}
