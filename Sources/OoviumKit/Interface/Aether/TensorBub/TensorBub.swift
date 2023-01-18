//
//  TensorBub.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/14/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class TensorBub: Bubble {
    let tensor: Tensor
    
    required init(_ tensor: Tensor, aetherView: AetherView) {
        self.tensor = tensor
        super.init(aetherView: aetherView, aexel: tensor, origin: CGPoint(x: tensor.x, y: tensor.y), size: .zero)
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
