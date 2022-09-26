//
//  File.swift
//  
//
//  Created by Joe Charlier on 9/16/22.
//

import Acheron
import Foundation
import OoviumEngine

class GridController: ChainViewKeyDelegate {
    unowned let grid: Grid
    unowned let gridBub: GridBub
    
    var cellWidthNeeded: [String:CGFloat] = [:]
    var headerWidthNeeded: [String:CGFloat] = [:]
    var footerWidthNeeded: [String:CGFloat] = [:]
    var columnWidthNeeded: [String:CGFloat] = [:]

    init(_ gridBub: GridBub) {
        self.gridBub = gridBub
        self.grid = gridBub.grid
    }
    
    func addRow() {
        let cells: [Cell] = grid.addRow()
        gridBub.addRow(with: cells)
        grid.columns.filter({ $0.aggregate != .none }).forEach {
            $0.footerTower.buildStream()
            $0.footerTower.buildTask()
        }
        architect()
    }
    func addColumn() {
        let column: Column = grid.addColumn()
        gridBub.addColumn(with: column)
        architect()
    }
    
    func architect() { gridBub.architect() }
    
// ChainViewKeyDegate ==============================================================================
    func onArrowUp() { gridBub.gridLeaf.handle(arrow: .up) }
    func onArrowDown() { gridBub.gridLeaf.handle(arrow: .down) }
    func onArrowLeft() { gridBub.gridLeaf.handle(arrow: .left) }
    func onArrowRight() { gridBub.gridLeaf.handle(arrow: .right) }
    func onTab() { gridBub.gridLeaf.gridBub.rotateEndMode() }
}
