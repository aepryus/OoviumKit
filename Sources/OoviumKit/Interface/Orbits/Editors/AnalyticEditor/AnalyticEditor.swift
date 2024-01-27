//
//  AnalyticEditor.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/12/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class AnalyticEditor: KeyOrbit {
    var systemBub: SystemBub { editable as! SystemBub }
    
    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 134, height: 174), uiColor: OOColor.olive.uiColor, schematic: Schematic(rows: 1, cols: 1))

        schematic.add(row: 0, col: 0, w: 1, h: 1, key: Key(text: NSLocalizedString("OK", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: OOColor.olive.uiColor, {
            self.systemBub.releaseFocus(.okEqualReturn)
        }))
        
        renderSchematic()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
