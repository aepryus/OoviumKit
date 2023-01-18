//
//  CoordinateBub.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/14/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class CoordinateBub: Bubble {
    let coordinate: Coordinate
    
    required init(_ coordinate: Coordinate, aetherView: AetherView) {
        self.coordinate = coordinate
        super.init(aetherView: aetherView, aexel: coordinate, origin: CGPoint(x: coordinate.x, y: coordinate.y), size: .zero)
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
