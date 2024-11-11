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
        let citadel: Citadel = gridBub.aetherView.citadel

        citadel.plugIn(aexons: cells)
        
        grid.columns.filter({ $0.aggregate != .none }).forEach {
            let footerTower: Tower = citadel.tower(key: $0.footerTokenKey)!
            footerTower.buildStream()
            footerTower.buildTask()
        }
        
        citadel.trigger(keys: cells.map({ $0.chain.key! }))
                
        let cellTowers: [Tower] = cells.map({ citadel.tower(key: $0.chain.key!)! })
        cellTowers.forEach({ $0.buildStream() })

        resizeEverything()
    }
    func delete(rowNo: Int) {
        gridBub.gridLeaf.delete(rowNo: rowNo)
        let subs: [TokenKey:TokenKey?] = grid.delete(rowNo: rowNo)
        gridBub.aetherView.citadel.rekey(subs: subs)
        gridBub.aetherView.citadel.reevaluate()
        resizeEverything()
    }
    func addColumn() {
        let citadel: Citadel = gridBub.aetherView.citadel
        let column: Column = grid.addColumn()

        citadel.plugIn(aexons: [column])

        citadel.trigger(keys: column.cellKeys())

        let cellTowers: [Tower] = column.cellKeys().map({ citadel.tower(key: $0)! })
        cellTowers.forEach({ $0.buildStream() })

        gridBub.addColumn(with: column)
        resizeEverything()
    }
    func delete(column: Column) {
        gridBub.gridLeaf.delete(column: column)
        let keys: [TokenKey] = grid.deleteColumn(column)
        gridBub.aetherView.citadel.nuke(keys: keys)
        resizeEverything()
    }
    
// Sizing ==========================================================================================
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
        
        gridBub.render()
    }
    func resizeEverything() {
        // This forces FooterCells to be generated, perhaps a more direct way is preferable
        gridBub.gridLeaf.gridView.reloadData()
        gridBub.gridLeaf.columns.forEach {
            $0.headerCell.setNeedsResize()
            if grid.hasFooter { $0.footerCell?.setNeedsResize() }
            $0.gridCells.forEach { $0.setNeedsResize() }
        }
        resize()
        gridBub.render()
    }
    
// Events ==========================================================================================
    func onAnchorCellTapped() { gridBub.morph() }
    
    func nextGridCell(from gridCell: GridCell, release: Release) -> Editable? {
        switch release {
            case .focusTap, .administrative:
                return nil
            case .okEqualReturn:
                if gridBub.grid.equalMode == .close { return nil }
                return gridBub.gridLeaf.equalRelease(gridCell: gridCell)
            case .arrow(let arrow):
                return gridBub.gridLeaf.arrowRelease(gridCell: gridCell, arrow: arrow)
        }
    }
    
// ChainViewKeyDelegate ============================================================================
    func onArrowUp() { gridBub.gridLeaf.focusCell?.releaseFocus(.arrow(.up)) }
    func onArrowDown() { gridBub.gridLeaf.focusCell?.releaseFocus(.arrow(.down)) }
    func onArrowLeft() { gridBub.gridLeaf.focusCell?.releaseFocus(.arrow(.left)) }
    func onArrowRight() { gridBub.gridLeaf.focusCell?.releaseFocus(.arrow(.right)) }
    func onTab() { gridBub.rotateEndMode() }
}
