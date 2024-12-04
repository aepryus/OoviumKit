//
//  SystemEditor.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/11/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class SystemEditor: KeyOrbit {
    var systemBub: SystemBub { editable as! SystemBub }
    
    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 270, height: 174), uiColor: Text.Color.olive.uiColor, schematic: Schematic(rows: 3, cols: 2))

        schematic.add(row: 0, col: 0, w: 1, h: 1, key: Key(text: NSLocalizedString("Add Variable", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: Text.Color.lavender.uiColor, {
            self.systemBub.addVariable()
        }))
        schematic.add(row: 1, col: 0, w: 1, h: 1, key: Key(text: NSLocalizedString("Delete Variable", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: Text.Color.lavender.uiColor, {
            self.systemBub.deleteVariable()
        }))
        schematic.add(row: 0, col: 1, w: 1, h: 1, key: Key(text: NSLocalizedString("Add Constant", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: Text.Color.cobolt.uiColor, {
            self.systemBub.addConstant()
        }))
        schematic.add(row: 1, col: 1, w: 1, h: 1, key: Key(text: NSLocalizedString("Delete Constant", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: Text.Color.cobolt.uiColor, {
            self.systemBub.deleteConstant()
        }))
        schematic.add(row: 2, col: 0, w: 2, h: 1, key: Key(text: NSLocalizedString("OK", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: Text.Color.olive.uiColor, {
            self.systemBub.releaseFocus(.okEqualReturn)
        }))
        
        renderSchematic()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
