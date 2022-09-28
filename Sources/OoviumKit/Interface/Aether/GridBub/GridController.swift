//
//  File.swift
//  
//
//  Created by Joe Charlier on 9/16/22.
//

import Acheron
import UIKit
import OoviumEngine

protocol Sizable: UIView {
    var aetherView: AetherView { get }

    var widthNeeded: CGFloat { get }
    func resize()
    func setNeedsResize()
}

class GridController: ChainViewKeyDelegate {
    unowned let grid: Grid
    unowned let gridBub: GridBub
    
    var needsResizing:[Sizable] = []
    var columnNeedsResizing:[GridColumn] = []
    var leafNeedsResizing:Bool = false
    
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
        resize()
    }
    func addColumn() {
        let column: Column = grid.addColumn()
        gridBub.addColumn(with: column)
        resize()
    }
    
    func resize() {
        guard needsResizing.count > 0 else { return }
        needsResizing.forEach { $0.resize() }
        needsResizing = []

        guard columnNeedsResizing.count > 0 else { return }
        columnNeedsResizing.forEach { $0.resize() }
        columnNeedsResizing = []

        guard leafNeedsResizing else { return }
        gridBub.gridLeaf.resize()
        leafNeedsResizing = false
        
        gridBub.layoutLeavesIfNeeded()
    }
    
// ChainViewKeyDegate ==============================================================================
    func onArrowUp() { gridBub.gridLeaf.handle(arrow: .up) }
    func onArrowDown() { gridBub.gridLeaf.handle(arrow: .down) }
    func onArrowLeft() { gridBub.gridLeaf.handle(arrow: .left) }
    func onArrowRight() { gridBub.gridLeaf.handle(arrow: .right) }
    func onTab() { gridBub.gridLeaf.gridBub.rotateEndMode() }
}
