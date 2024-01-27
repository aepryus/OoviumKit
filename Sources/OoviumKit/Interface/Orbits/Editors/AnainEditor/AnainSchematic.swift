//
//  AnainSchematic.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/13/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import Foundation

public class AnainSchematic: Schematic {
    let cyanKey: String
    let imageNamed: String
    weak var anainEditor: AnainEditor!
    
    init(rows: Int, cols: Int, cyanKey: String, imageNamed: String) {
        self.cyanKey = cyanKey
        self.imageNamed = imageNamed
        super.init(rows: rows, cols: cols)
    }
}
