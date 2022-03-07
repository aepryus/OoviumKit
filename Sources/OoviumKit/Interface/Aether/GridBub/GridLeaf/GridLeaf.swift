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
	enum Arrow {
		case left, right, up, down
	}
	
	let grid: Grid
	
	let gridView: GridView = GridView()

	let anchorCell: AnchorCell = AnchorCell()
	let bottomLeftCell: BottomLeftCell = BottomLeftCell()
	var lefterCells: [LefterCell] = []
	var headerCells: [HeaderCell] = []
	var footerCells: [FooterCell] = []
	var gridCells: [GridCell] = []
	
	var gridBub: GridBub {
		return bubble as! GridBub
	}
	var uiColor: UIColor {
		return gridBub.uiColor
	}
	
	init(bubble: Bubble, grid: Grid) {
		self.grid = grid
		
		super.init(bubble: bubble)
		
		anchorCell.gridLeaf = self
		bottomLeftCell.gridLeaf = self
		
		for _ in 0..<grid.rows {
			lefterCells.append(LefterCell(frame: .zero))
		}
		for _ in 0..<grid.columns.count {
			headerCells.append(HeaderCell(frame: .zero))
			footerCells.append(FooterCell(frame: .zero))
		}
		for _ in 0..<grid.cells.count {
			gridCells.append(GridCell(frame: .zero))
		}

		gridView.backgroundColor = UIColor.clear
		if #available(iOS 11.0, *) {
			gridView.contentInsetAdjustmentBehavior = .never
		}
		gridView.gridViewDelegate = self
		addSubview(gridView)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	func render() {
		gridView.reloadData()
		size = gridView.bounds.size
	}

	func addRow() {
		lefterCells.append(LefterCell(frame: .zero))
		for _ in 0..<grid.columns.count {
			let cell = GridCell(frame: .zero)
			gridCells.append(cell)
		}
	}
	func deleteRow(rowNo: Int) {
		grid.deleteRow(rowNo: rowNo-1)
		lefterCells[rowNo-1].removeFromSuperview()
		lefterCells.remove(at: rowNo-1)
		for i in 0..<grid.columns.count {
			let cellNo: Int = rowNo*grid.columns.count-1-i
			gridCells[cellNo].removeFromSuperview()
			gridCells.remove(at: cellNo)
		}
		render()
		gridBub.render()
	}
	func slide(rowNo: Int, dy: CGFloat) {
		let lefterCell: LefterCell = lefterCells[rowNo]
		let footerHeight: CGFloat = grid.hasFooter ? footerCells[0].height : 0
		let dy: CGFloat = dy.clamped(to: (30-lefterCell.top)...(height-lefterCell.height-lefterCell.top-footerHeight))
		let slider: UIView = UIView(frame: bounds.offsetBy(dx: 0, dy: dy))
		slider.isUserInteractionEnabled = false
		slider.addSubview(lefterCell)
		for colNo in 0..<grid.columns.count {
			let cellNo: Int = rowNo*grid.columns.count + colNo
			slider.addSubview(gridCells[cellNo])
		}
		gridView.hide(rowNo: rowNo, cy: lefterCell.center.y+dy)
		addSubview(slider)
	}
	func move(rowNo: Int, to: Int) {
		grid.move(rowNo: rowNo, to: to)
		render()
		gridBub.render()
	}

	
	func addColumn() {
		headerCells.append(HeaderCell(frame: .zero))
		footerCells.append(FooterCell(frame: .zero))
		var i: Int = grid.columns.count-1
		for _ in 0..<grid.rows {
			let cell = GridCell(frame: .zero)
			gridCells.insert(cell, at: i)
			i += grid.columns.count
		}
	}
	func deleteColumn(column: Column) {
		let colNo: Int = column.colNo
		for rowNo in 0..<grid.rows {
			let cellNo = grid.columns.count*(grid.rows-1-rowNo)+colNo
			gridCells.remove(at: cellNo)
		}
		headerCells.remove(at: colNo)
		footerCells.remove(at: colNo)
		grid.deleteColumn(column)
		render()
		gridBub.render()
	}
	func slide(column: Column, dx: CGFloat) {
		let colNo: Int = column.colNo
		let headerCell: HeaderCell = headerCells[colNo]
		let dx: CGFloat = dx.clamped(to: (30-headerCell.left)...(width-headerCell.width-headerCell.left))
		let slider: UIView = UIView(frame: bounds.offsetBy(dx: dx, dy: 0))
		slider.isUserInteractionEnabled = false
		slider.addSubview(headerCell)
		if grid.hasFooter {slider.addSubview(footerCells[colNo])}
		for rowNo in 0..<grid.rows {
			let cellNo: Int = rowNo*grid.columns.count + colNo
			slider.addSubview(gridCells[cellNo])
		}
		gridView.hide(column: column, cx: headerCell.center.x+dx)
		addSubview(slider)
	}
	func move(column: Column, to: Int) {
		grid.move(column: column, to: to)
		render()
		gridBub.render()
	}
	
	private func nextCol(colNo: Int) -> Int {
		var nextNo = (colNo + 1) % grid.columns.count
		while grid.column(colNo: nextNo)!.calculated {
			nextNo = (nextNo + 1) % grid.columns.count
		}
		return nextNo
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
		if rowNo == grid.rows { gridBub.addRow() }
		let i: Int = rowNo*grid.columns.count+colNo
		gridCells[i].makeFocus()
	}
	func focus(arrow: GridLeaf.Arrow, from cell: GridCell) {
		var colNo: Int = cell.cell.colNo
		var rowNo: Int = cell.cell.rowNo
		switch arrow {
			case .left: colNo -= 1
			case .right: colNo += 1
			case .up: rowNo -= 1
			case .down: rowNo += 1
		}
		guard 0..<grid.columns.count ~= colNo && 0..<grid.rows ~= rowNo else { return }
		let i: Int = rowNo*grid.columns.count+colNo
		gridCells[i].makeFocus(dismissEditor: false)
	}
	
// UIView ==========================================================================================
//	override func setNeedsDisplay() {
//		super.setNeedsDisplay()
//		anchorCell.setNeedsDisplay()
//		bottomLeftCell.setNeedsDisplay()
//		headerCells.forEach {$0.setNeedsDisplay()}
//		footerCells.forEach {$0.setNeedsDisplay()}
//		lefterCells.forEach {$0.setNeedsDisplay()}
//		gridCells.forEach {$0.setNeedsDisplay()}
//	}
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
			let cell: FooterCell = footerCells[cI]
			if cell.column !== grid.columns[cI] {
				cell.column = grid.columns[cI]
				cell.leftMost = leftMost
				cell.gridLeaf = self
			}
			cell.setNeedsDisplay()
			return cell
		} else if column == 0 {
			let cell: LefterCell = lefterCells[rI]
			if cell.rowNo != row {
//				cell.aetherView = aetherView
				cell.rowNo = row
				cell.bottomMost = bottomMost
				cell.gridLeaf = self
				cell.setNeedsDisplay()
			}
			return cell
		} else if row == 0 {
			let cell: HeaderCell = headerCells[cI]
			if cell.column !== grid.columns[cI] {
//				cell.aetherView = aetherView
				cell.column = grid.columns[cI]
				cell.leftMost = leftMost
				cell.gridLeaf = self
				cell.setNeedsDisplay()
			}
			return cell
		} else {
			let cell: GridCell = gridCells[rI * grid.columns.count + cI]
			if cell.cell !== grid.cells[rI * grid.columns.count + cI] {
//				cell.aetherView = aetherView
				cell.cell = grid.cells[rI * grid.columns.count + cI]
				cell.leftMost = leftMost
				cell.bottomMost = bottomMost
				cell.gridLeaf = self
				cell.bounds.size = size(gridView: gridView, column: column, row: row)
				cell.render()
			}
			return cell
		}
	}
	func size(gridView: GridView, column: Int, row: Int) -> CGSize {
		let width: CGFloat
		let height: CGFloat

		if column == 0 {
			width = 30
		} else {
			width = grid.column(colNo: column-1)!.width
		}
		
		if row == 0 {
			height = 30
		} else {
			height = 24
		}
		
		return CGSize(width: width, height: height)
	}
}
