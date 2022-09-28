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

    var widthNeeded: CGFloat = 90
    func resize() {
        widthNeeded = max(90, headerCell.widthNeeded)
        if let footerCell { widthNeeded = max(widthNeeded, footerCell.widthNeeded) }
        gridCells.forEach { widthNeeded = max(widthNeeded, $0.widthNeeded) }
    }
    func setNeedsResize() {
        controller.columnNeedsResizing.append(self)
        controller.gridBub.gridLeaf.setNeedsResize()
    }

//    var widthNeeded: CGFloat = 90
//    func calculateWidthNeeded() {
//        widthNeeded = max(90, headerCell.widthNeeded)
//        if let footerCell { widthNeeded = max(widthNeeded, footerCell.widthNeeded) }
//        gridCells.forEach { widthNeeded = max(widthNeeded, $0.widthNeeded) }
//    }

//    func clearWidthNeeded() {
//        controller.columnWidthNeeded[column.iden] = nil
//    }
    
//    func setNeedsRearch() { controller.gridBub.gridLeaf.columnsNeedingRearch.append(self) }
//    func rearch() {
//        let oldWidthNeeded: CGFloat? = controller.columnWidthNeeded[column.iden]
//        let newWidthNeeded: CGFloat = widthNeeded
//        
//        if newWidthNeeded != oldWidthNeeded {
//            controller.gridBub.gridLeaf.setNeedsRearch()
//            controller.columnWidthNeeded[column.iden] = newWidthNeeded
//        }
//    }

    func addGridCell(controller: GridController, column: GridColumn, cell: Cell) {
        let gridCell: GridCell = GridCell(controller: controller, column: column, cell: cell)
        gridCells.append(gridCell)
    }    
}
