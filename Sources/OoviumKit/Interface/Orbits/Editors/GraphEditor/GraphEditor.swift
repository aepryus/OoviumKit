//
//  GraphEditor.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/19/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import UIKit

class GraphEditor: KeyOrbit {
    var headerLeaf: GraphBub.HeaderLeaf { editable as! GraphBub.HeaderLeaf }
    
    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 8*30, height: 4*30), uiColor: UIColor.cyan, schematic: Schematic(rows: 1, cols: 1))

        schematic.add(row: 0, col: 0, w: 1, h: 1, key: Key(text: "OK", uiColor: UIColor(red: 0.95, green: 0.85, blue: 0.55, alpha: 1), { [unowned self] in
            self.headerLeaf.releaseFocus(.okEqualReturn)
        }))
        
        renderSchematic()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
