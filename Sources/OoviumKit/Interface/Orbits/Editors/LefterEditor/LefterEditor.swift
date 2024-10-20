//
//  LefterEditor.swift
//  Oovium
//
//  Created by Joe Charlier on 11/25/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import UIKit

class LefterEditor: KeyOrbit {
	var lefterCell: LefterCell { editable as! LefterCell }
	
    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 8*30, height: 4*30), uiColor: UIColor.cyan, schematic: Schematic(rows: 3, cols: 1))

		schematic.add(row: 0, col: 0, w: 1, h: 2, key: Key(text: "delete", uiColor: UIColor.cyan, { [unowned self] in
			self.lefterCell.gridLeaf.aetherView.invokeConfirmModal("delete selected row?".localized) { [unowned self] in
                self.lefterCell.releaseFocus(.administrative)
				if self.lefterCell.gridLeaf.grid.rows > 1 {
                    self.lefterCell.controller.delete(rowNo: self.lefterCell.rowNo)
				} else {
                    self.lefterCell.gridLeaf.gridBub.aetherView.aether.remove(aexel: self.lefterCell.gridLeaf.gridBub.grid)
                    self.lefterCell.gridLeaf.gridBub.aetherView.remove(bubble: self.lefterCell.gridLeaf.gridBub)
				}
				self.dismiss()
			}
		}))
		schematic.add(row: 2, col: 0, w: 1, h: 1, key: Key(text: "OK", uiColor: UIColor(red: 0.95, green: 0.85, blue: 0.55, alpha: 1), { [unowned self] in
            self.lefterCell.releaseFocus(.okEqualReturn)
		}))
		
		renderSchematic()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
}
