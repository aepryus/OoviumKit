//
//  HeaderEditor.swift
//  Oovium
//
//  Created by Joe Charlier on 11/25/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class HeaderEditor: KeyOrbit {
	let topSchematic: Schematic = Schematic(rows: 3, cols: 3)
	let footerSchematic: Schematic = Schematic(rows: 3, cols: 3)
	let alignmentSchematic: Schematic = Schematic(rows: 3, cols: 3)

	var headerCell: HeaderCell {
		return editable as! HeaderCell
	}

    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 8*30, height: 4*30), uiColor: UIColor.cyan, schematic: Schematic(rows: 3, cols: 3))

		let tan: UIColor = UIColor(red: 0.95, green: 0.85, blue: 0.55, alpha: 1)
		
		topSchematic.add(row: 0, col: 0, w: 1, h: 2, key: Key(text: "footer", uiColor: UIColor.cyan, { [unowned self] in
			self.schematic = self.footerSchematic
		}))
		topSchematic.add(row: 0, col: 1, w: 1, h: 2, key: Key(text: "justify", uiColor: UIColor.cyan, { [unowned self] in
			self.schematic = self.alignmentSchematic
		}))
		topSchematic.add(row: 0, col: 2, w: 1, h: 2, key: Key(text: "delete", uiColor: UIColor.cyan, { [unowned self] in
			self.headerCell.gridLeaf.aetherView.invokeConfirmModal("delete selected column?".localized) { [unowned self] in
                self.headerCell.releaseFocus(.administrative)
				if self.headerCell.gridBub.grid.columns.count > 1 {
                    self.headerCell.gridBub.controller.delete(column: self.headerCell.column)
				} else {
                    self.headerCell.gridBub.aetherView.aether.remove(aexel: self.headerCell.gridBub.grid)
					self.headerCell.gridBub.aetherView.remove(bubble: self.headerCell.gridBub)
				}
				self.dismiss()
			}
		}))
		topSchematic.add(row: 2, col: 0, w: 3, h: 1, key: Key(text: "OK", uiColor: tan, { [unowned self] in
            self.headerCell.releaseFocus(.okEqualReturn)
		}))
		
		footerSchematic.add(row: 0, col: 0, w: 1, h: 1, key: Key(text: "sum", uiColor: UIColor.cyan, { [unowned self] in
			self.headerCell.column.aggregate = .sum
            self.headerCell.column.disseminate()
            self.headerCell.triggerColumnCalculation()
			self.headerCell.renderColumn()
			self.schematic = self.topSchematic
		}))
		footerSchematic.add(row: 1, col: 0, w: 1, h: 1, key: Key(text: "match", uiColor: UIColor.cyan, { [unowned self] in
			self.headerCell.column.aggregate = .match
            self.headerCell.column.disseminate()
            self.headerCell.triggerColumnCalculation()
			self.headerCell.renderColumn()
			self.schematic = self.topSchematic
		}))
		footerSchematic.add(row: 0, col: 1, w: 1, h: 1, key: Key(text: "average", uiColor: UIColor.cyan, { [unowned self] in
			self.headerCell.column.aggregate = .average
            self.headerCell.column.disseminate()
            self.headerCell.triggerColumnCalculation()
			self.headerCell.renderColumn()
			self.schematic = self.topSchematic
		}))
		footerSchematic.add(row: 1, col: 1, w: 1, h: 1, key: Key(text: "running", uiColor: UIColor.cyan, { [unowned self] in
			self.headerCell.column.aggregate = .running
            self.headerCell.column.disseminate()
            self.headerCell.triggerColumnCalculation()
			self.headerCell.renderColumn()
			self.schematic = self.topSchematic
		}))
		footerSchematic.add(row: 0, col: 2, w: 1, h: 1, key: Key(text: "none", uiColor: UIColor.cyan, { [unowned self] in
			self.headerCell.column.aggregate = .none
            self.headerCell.column.disseminate()
            self.headerCell.triggerColumnCalculation()
			self.headerCell.renderColumn()
			self.schematic = self.topSchematic
		}))
		footerSchematic.add(row: 1, col: 2, w: 1, h: 1, key: Key(text: "count", uiColor: UIColor.cyan, { [unowned self] in
			self.headerCell.column.aggregate = .count
            self.headerCell.column.disseminate()
            self.headerCell.triggerColumnCalculation()
			self.headerCell.renderColumn()
			self.schematic = self.topSchematic
		}))
		footerSchematic.add(row: 2, col: 0, w: 3, h: 1, key: Key(text: "cancel", uiColor: tan, { [unowned self] in
			self.schematic = self.topSchematic
		}))
		
		alignmentSchematic.add(row: 0, col: 0, w: 1, h: 2, key: Key(text: "left", uiColor: UIColor.cyan, { [unowned self] in
			self.headerCell.column.justify = .left
			self.headerCell.renderColumn()
			self.schematic = self.topSchematic
		}))
		alignmentSchematic.add(row: 0, col: 1, w: 1, h: 2, key: Key(text: "center", uiColor: UIColor.cyan, { [unowned self] in
			self.headerCell.column.justify = .center
			self.headerCell.renderColumn()
			self.schematic = self.topSchematic
		}))
		alignmentSchematic.add(row: 0, col: 2, w: 1, h: 2, key: Key(text: "right", uiColor: UIColor.cyan, { [unowned self] in
			self.headerCell.column.justify = .right
			self.headerCell.renderColumn()
			self.schematic = self.topSchematic
		}))
		alignmentSchematic.add(row: 2, col: 0, w: 3, h: 1, key: Key(text: "cancel", uiColor: tan, { [unowned self] in
			self.schematic = self.topSchematic
		}))

		self.schematic = topSchematic
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
}
