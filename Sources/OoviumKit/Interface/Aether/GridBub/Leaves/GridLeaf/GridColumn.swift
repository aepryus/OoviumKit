//
//  GridColumn.swift
//  OoviumKit
//
//  Created by Joe Charlier on 9/20/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine

class GridColumn {
    let controller: GridController
    let column: Column
    let headerCell: HeaderCell
    var gridCells: [GridCell] = []
    var footerCell: FooterCell? = nil
        
    init(controller: GridController, column: Column, headerCell: HeaderCell) {
        self.controller = controller
        self.column = column
        self.headerCell = headerCell
    }

    var widthNeeded: CGFloat {
        if let widthNeeded: CGFloat = controller.columnWidthNeeded[column.iden] { return widthNeeded }
        var widthNeeded: CGFloat = max(90, headerCell.widthNeeded)
        if let footerCell { widthNeeded = max(widthNeeded, footerCell.widthNeeded) }
        gridCells.forEach { widthNeeded = max(widthNeeded, $0.widthNeeded) }
        controller.cellWidthNeeded[column.iden] = widthNeeded
        return widthNeeded
    }
    func clearWidthNeeded() {
        controller.columnWidthNeeded[column.iden] = nil
    }

    func addGridCell(controller: GridController, column: GridColumn, cell: Cell) {
        let gridCell: GridCell = GridCell(controller: controller, column: column, cell: cell)
        gridCells.append(gridCell)
    }    
}
