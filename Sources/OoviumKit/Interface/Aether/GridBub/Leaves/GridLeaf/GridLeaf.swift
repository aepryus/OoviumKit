//
//  GridLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 11/17/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class GridLeaf: Leaf, GridViewDelegate {
    unowned let controller: GridController
    
	enum Arrow {
		case left, right, up, down
	}
	
	let grid: Grid
	
	let gridView: GridView = GridView()

	let anchorCell: AnchorCell = AnchorCell()
	let bottomLeftCell: BottomLeftCell = BottomLeftCell()
    var lefterCells: [LefterCell] = []
    var columns: [GridColumn] = []
    
    var focusCell: GridCell?
	
	var gridBub: GridBub { bubble as! GridBub }
	var uiColor: UIColor { gridBub.uiColor }
    
    init(controller: GridController) {
        self.controller = controller
        self.grid = controller.grid
		
        super.init(bubble: controller.gridBub)
		
		anchorCell.gridLeaf = self
		bottomLeftCell.gridLeaf = self
		
		for _ in 0..<grid.rows { lefterCells.append(LefterCell()) }
        
        grid.columns.forEach { (column: Column) in
            let gridColumn: GridColumn = GridColumn(controller: controller, column: column, headerCell: HeaderCell(controller: controller, column: column))
            let cells: [Cell] = grid.cellsForColumn(i: column.colNo)
            cells.forEach { gridColumn.addGridCell(controller: controller, column: gridColumn, cell: $0) }
            columns.append(gridColumn)
        }

		gridView.backgroundColor = UIColor.clear
		if #available(iOS 11.0, *) {
			gridView.contentInsetAdjustmentBehavior = .never
		}
		gridView.gridViewDelegate = self
		addSubview(gridView)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
    
    func architect() {
        gridView.reloadData()
        size = gridView.bounds.size
    }
	
	func render() {
		gridView.reloadData()
		size = gridView.bounds.size
	}

    func addRow(with cells: [Cell]) {
		lefterCells.append(LefterCell())
        columns.enumerated().forEach { $0.1.addGridCell(controller: controller, column: $0.1, cell: cells[$0.0]) }
        controller.architect()
	}
	func deleteRow(rowNo: Int) {
		grid.deleteRow(rowNo: rowNo-1)
		lefterCells[rowNo-1].removeFromSuperview()
		lefterCells.remove(at: rowNo-1)
        columns.forEach { $0.gridCells.remove(at: rowNo-1) }
        controller.architect()
	}
	func slide(rowNo: Int, dy: CGFloat) {
		let lefterCell: LefterCell = lefterCells[rowNo]
        let footerHeight: CGFloat = columns[0].footerCell?.height ?? 0
		let dy: CGFloat = dy.clamped(to: (30-lefterCell.top)...(height-lefterCell.height-lefterCell.top-footerHeight))
		let slider: UIView = UIView(frame: bounds.offsetBy(dx: 0, dy: dy))
		slider.isUserInteractionEnabled = false
		slider.addSubview(lefterCell)
        columns.forEach { slider.addSubview($0.gridCells[rowNo]) }
		gridView.hide(rowNo: rowNo, cy: lefterCell.center.y+dy)
		addSubview(slider)
	}
	func move(rowNo: Int, to: Int) {
		grid.move(rowNo: rowNo, to: to)
        columns.forEach {
            let gridCell: GridCell = $0.gridCells.remove(at: rowNo)
            $0.gridCells.insert(gridCell, at: to)
        }
        controller.architect()
	}
    
    func handle(arrow: GridLeaf.Arrow) {
        guard let focusCell else { return }
        focusCell.tapped = true
        focus(arrow: arrow)
    }
	
    func addColumn(with column: Column) {
        let gridColumn: GridColumn = GridColumn(controller: controller, column: column, headerCell: HeaderCell(controller: controller, column: column))
        columns.append(gridColumn)
        if grid.hasFooter { gridColumn.footerCell = FooterCell(controller: controller, column: column) }
        let cells: [Cell] = column.grid.cellsForColumn(i: column.colNo)
        for i in 0..<grid.rows { gridColumn.gridCells.append(GridCell(controller: controller, column: gridColumn, cell: cells[i])) }
	}
	func deleteColumn(column: Column) {
        columns.remove(at: column.colNo)
		grid.deleteColumn(column)
        controller.architect()
	}
	func slide(column: Column, dx: CGFloat) {
		let colNo: Int = column.colNo
        let headerCell: HeaderCell = columns[colNo].headerCell
		let dx: CGFloat = dx.clamped(to: (30-headerCell.left)...(width-headerCell.width-headerCell.left))
		let slider: UIView = UIView(frame: bounds.offsetBy(dx: dx, dy: 0))
		slider.isUserInteractionEnabled = false
		slider.addSubview(headerCell)
        if let footerCell: FooterCell = columns[colNo].footerCell { slider.addSubview(footerCell) }
        columns[colNo].gridCells.forEach { slider.addSubview($0) }
		gridView.hide(column: column, cx: headerCell.center.x+dx)
		addSubview(slider)
	}
	func move(column: Column, to: Int) {
        
        let gridColumn: GridColumn = columns[column.colNo]
        columns.remove(at: column.colNo)
        columns.insert(gridColumn, at: to)

        grid.move(column: column, to: to)

        controller.architect()
	}
	
	private func nextCol(colNo: Int) -> Int {
        var testNo: Int = colNo+1
        var newNo: Int?
        while testNo < grid.columns.count && newNo == nil {
            if !grid.column(colNo: testNo)!.calculated { newNo = testNo }
            testNo += 1
        }
        return newNo ?? colNo
	}
    private func prevCol(colNo: Int) -> Int {
        var testNo: Int = colNo
        var newNo: Int?
        while testNo > 0 && newNo == nil {
            testNo -= 1
            if !grid.column(colNo: testNo)!.calculated { newNo = testNo }
        }
        return newNo ?? colNo
    }
	func released(cell: GridCell) {
		guard grid.equalMode != .close else {
			gridBub.cellLostFocus()
			return
		}
		let colNo: Int
		let rowNo: Int
		if grid.equalMode == .down {
			colNo = cell.cell.colNo
			rowNo = cell.cell.rowNo + 1
		} else /*if grid.equalMode == .right*/ {
			colNo = nextCol(colNo: cell.cell.colNo)
			rowNo = cell.cell.rowNo + (colNo == 0 ? 1 : 0)
		}
        if rowNo == grid.rows { controller.addRow() }
        columns[colNo].gridCells[rowNo].makeFocus()
	}
	func focus(arrow: GridLeaf.Arrow, from gridCell: GridCell? = nil) {
        guard let cell: Cell = (gridCell ?? focusCell)?.cell else { return }
		var colNo: Int = cell.colNo
		var rowNo: Int = cell.rowNo
		switch arrow {
			case .left: colNo = prevCol(colNo: colNo)
			case .right: colNo = nextCol(colNo: colNo)
			case .up: rowNo -= 1
			case .down: rowNo += 1
		}
		guard 0..<grid.columns.count ~= colNo && 0..<grid.rows ~= rowNo else { return }
        columns[colNo].gridCells[rowNo].makeFocus(dismissEditor: false)
	}
	
// UIView ==========================================================================================
	override func layoutSubviews() {
		gridView.frame = self.bounds
	}
	
// GridViewDelegate ================================================================================
	func numberOfRows(gridView: GridView) -> Int {
		return grid.rows + 1 + (grid.hasFooter ? 1 : 0)
	}
	func numberOfColumns(gridView: GridView) -> Int {
		return grid.columns.count + 1
	}
	func cell(gridView: GridView, column: Int, row: Int) -> UIView {
		let rI: Int = row - 1
		let cI: Int = column - 1
		let leftMost: Bool = column == grid.columns.count
		let bottomMost: Bool = !grid.hasFooter && row == grid.rows
		if column == 0 && row == 0 {
			return anchorCell
		} else if grid.hasFooter && row == grid.rows+1 && column == 0 {
			return bottomLeftCell
		} else if grid.hasFooter && row == grid.rows+1 {
            let cell: FooterCell
            if let footerCell: FooterCell = columns[cI].footerCell {
                cell = footerCell
            } else {
                cell = FooterCell(controller: controller, column: columns[cI].column)
                columns[cI].footerCell = cell
            }
            cell.leftMost = leftMost
			cell.setNeedsDisplay()
			return cell
		} else if column == 0 {
			let cell: LefterCell = lefterCells[rI]
			if cell.rowNo != row {
				cell.rowNo = row
				cell.bottomMost = bottomMost
				cell.gridLeaf = self
				cell.setNeedsDisplay()
			}
			return cell
		} else if row == 0 {
            let cell: HeaderCell = columns[cI].headerCell
            cell.leftMost = leftMost
            cell.setNeedsDisplay()
			return cell
		} else {
            let gridCell: GridCell = columns[cI].gridCells[rI]
            let cell: Cell = grid.cells[rI * grid.columns.count + cI]
			if gridCell.cell !== cell {
                gridCell.load(cell: cell)
                gridCell.leftMost = leftMost
                gridCell.bottomMost = bottomMost
                gridCell.bounds.size = size(gridView: gridView, column: column, row: row)
                gridCell.render()
			}
			return gridCell
		}
	}
    func size(gridView: GridView, column: Int, row: Int) -> CGSize {
        CGSize(
            width: column == 0 ? 30 : columns[column-1].widthNeeded,
            height: row == 0 ? 30 : 24
        )
    }

}
