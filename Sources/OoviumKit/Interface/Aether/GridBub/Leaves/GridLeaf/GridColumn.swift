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
    let column: Column
    let headerCell: HeaderCell
    var gridCells: [GridCell] = []
    var footerCell: FooterCell? = nil
        
    init(column: Column, headerCell: HeaderCell) {
        self.column = column
        self.headerCell = headerCell
    }
    
    private var _widthNeeded: CGFloat?
    var widthNeeded: CGFloat {
        guard _widthNeeded == nil else { return _widthNeeded! }
        var widthNeeded: CGFloat = max(90, headerCell.widthNeeded)
        if let footerCell { widthNeeded = max(widthNeeded, footerCell.widthNeeded) }
        gridCells.forEach { widthNeeded = max(widthNeeded, $0.widthNeeded) }
        _widthNeeded = widthNeeded
        return widthNeeded
    }
    func clearWidthNeeded() {
        _widthNeeded = nil
        
    }

    func addGridCell(controller: GridController, column: GridColumn, cell: Cell) {
        let gridCell: GridCell = GridCell(controller: controller, column: column, cell: cell)
        gridCells.append(gridCell)
//        gridCell.render()
    }    
}
