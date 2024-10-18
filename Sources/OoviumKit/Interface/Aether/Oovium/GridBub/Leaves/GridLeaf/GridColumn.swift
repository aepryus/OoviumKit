//
//  GridColumn.swift
//  OoviumKit
//
//  Created by Joe Charlier on 9/20/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit
import OoviumEngine

class GridColumn {
    unowned let controller: GridController
    let column: Column
    
    let headerCell: HeaderCell
    var gridCells: [GridCell] = []
    var footerCell: FooterCell? = nil

    var widthNeeded: CGFloat = 90

    init(controller: GridController, column: Column, headerCell: HeaderCell) {
        self.controller = controller
        self.column = column
        self.headerCell = headerCell
    }

    func resize() {
        widthNeeded = max(90, headerCell.widthNeeded)
        if let footerCell { widthNeeded = max(widthNeeded, footerCell.widthNeeded) }
        gridCells.forEach { widthNeeded = max(widthNeeded, $0.widthNeeded) }
    }
    func setNeedsResize() {
        controller.columnNeedsResizing.append(self)
        controller.gridBub.gridLeaf.setNeedsResize()
    }
    func addGridCell(controller: GridController, column: GridColumn, cell: Cell) {
        let gridCell: GridCell = GridCell(controller: controller, column: column, cell: cell)
        gridCells.append(gridCell)
    }    
}
