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

class GridLeaf: Leaf, GridViewDelegate, UITextInput, UITextInputTraits {
    unowned let controller: GridController
    unowned let responder: ChainResponder
    
	let grid: Grid
	
	let gridView: GridView = GridView()

	lazy var anchorCell: AnchorCell = AnchorCell(controller: controller)
    lazy var bottomLeftCell: BottomLeftCell = BottomLeftCell(controller: controller)
    var lefterCells: [LefterCell] = []
    var columns: [GridColumn] = []
    
    var focusCell: GridCell?
    var beingEdited: Bool = false
	
	var gridBub: GridBub { bubble as! GridBub }
	var uiColor: UIColor { gridBub.uiColor }
    
    init(controller: GridController) {
        self.controller = controller
        self.grid = controller.grid
        self.responder = controller.gridBub.aetherView.responder
		
        super.init(bubble: controller.gridBub)
		
        for _ in 0..<grid.rows { lefterCells.append(LefterCell(controller: controller)) }
        
        grid.columns.forEach { (column: Column) in
            let gridColumn: GridColumn = GridColumn(controller: controller, column: column, headerCell: HeaderCell(controller: controller, column: column))
            let n: Int = column.colNo
            let cells: [Cell] = grid.cellsForColumn(colNo: n)
//            let cells: [Cell] = grid.cellsForColumn(i: column.colNo)
            cells.forEach { gridColumn.addGridCell(controller: controller, column: gridColumn, cell: $0) }
            columns.append(gridColumn)
        }

		gridView.backgroundColor = UIColor.clear
		if #available(iOS 11.0, *) {
			gridView.contentInsetAdjustmentBehavior = .never
		}
		gridView.gridViewDelegate = self
		addSubview(gridView)
        
        inputAssistantItem.leadingBarButtonGroups.removeAll()
        inputAssistantItem.trailingBarButtonGroups.removeAll()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func setNeedsResize() {
        controller.leafNeedsResizing = true
    }
    func resize() {
        gridView.reloadData()
        size = gridView.bounds.size
    }
    	
    func addRow(with cells: [Cell]) {
        lefterCells.append(LefterCell(controller: controller))
        columns.enumerated().forEach { $0.1.addGridCell(controller: controller, column: $0.1, cell: cells[$0.0]) }
        controller.resize()
	}
	func deleteRow(rowNo: Int) {
		grid.deleteRow(rowNo: rowNo-1)
		lefterCells[rowNo-1].removeFromSuperview()
		lefterCells.remove(at: rowNo-1)
        columns.forEach { $0.gridCells.remove(at: rowNo-1) }
        controller.resizeEverything()
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
        controller.resizeEverything()
	}
    
    func addColumn(with column: Column) {
        let gridColumn: GridColumn = GridColumn(controller: controller, column: column, headerCell: HeaderCell(controller: controller, column: column))
        columns.append(gridColumn)
        if grid.hasFooter { gridColumn.footerCell = FooterCell(controller: controller, column: column) }
        let cells: [Cell] = column.grid.cellsForColumn(colNo: column.colNo)
        for i in 0..<grid.rows { gridColumn.gridCells.append(GridCell(controller: controller, column: gridColumn, cell: cells[i])) }
	}
	func delete(column: Column) {
        columns.remove(at: column.colNo)
        gridBub.chainLeaf.chain = columns[0].column.chain
		grid.deleteColumn(column)
        controller.resizeEverything()
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

        controller.resizeEverything()
	}
	
    private func nextColumnWrapping(colNo: Int) -> Int {
        var nextNo = (colNo + 1) % grid.columns.count
        while grid.column(colNo: nextNo)!.calculated {
            nextNo = (nextNo + 1) % grid.columns.count
        }
        return nextNo
    }
	private func nextColumn(colNo: Int) -> Int {
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
    
    func equalRelease(gridCell: GridCell) -> Editable? {
        let colNo: Int
        let rowNo: Int
        if grid.equalMode == .down {
            colNo = gridCell.cell.colNo
            rowNo = gridCell.cell.rowNo + 1
        } else /*if grid.equalMode == .right*/ {
            colNo = nextColumnWrapping(colNo: gridCell.cell.colNo)
            rowNo = gridCell.cell.rowNo + (colNo == 0 ? 1 : 0)
        }
        if rowNo == grid.rows { controller.addRow() }
        return columns[colNo].gridCells[rowNo]
    }
    func arrowRelease(gridCell: GridCell, arrow: Release.Arrow) -> Editable? {
        var colNo: Int = gridCell.cell.colNo
        var rowNo: Int = gridCell.cell.rowNo
        switch arrow {
            case .left: colNo = prevCol(colNo: colNo)
            case .right: colNo = nextColumn(colNo: colNo)
            case .up: rowNo -= 1
            case .down: rowNo += 1
        }
        guard 0..<grid.columns.count ~= colNo && 0..<grid.rows ~= rowNo else { return gridCell }
        return columns[colNo].gridCells[rowNo]
    }
    
// UIView ==========================================================================================
	override func layoutSubviews() { gridView.frame = self.bounds }
    override func draw(_ rect: CGRect) {}
	
// UIResponder =====================================================================================
    override var canBecomeFirstResponder: Bool { focusCell != nil }
    override var canResignFirstResponder: Bool { true }
        
// GridViewDelegate ================================================================================
	func numberOfRows(gridView: GridView) -> Int { grid.rows + 1 + (grid.hasFooter ? 1 : 0) }
	func numberOfColumns(gridView: GridView) -> Int { grid.columns.count + 1 }
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
			}
            gridCell.setNeedsLayout()
			return gridCell
		}
	}
    func size(gridView: GridView, column: Int, row: Int) -> CGSize {
        CGSize(
            width: column == 0 ? 30 : columns[column-1].widthNeeded,
            height: row == 0 ? 30 : 24
        )
    }

// UITextInput =====================================================================================
    var autocapitalizationType: UITextAutocapitalizationType {
        get { responder.autocapitalizationType }
        set { responder.autocapitalizationType = newValue }
    }
    var keyboardAppearance: UIKeyboardAppearance {
        get { responder.keyboardAppearance }
        set { responder.keyboardAppearance = newValue }
    }
    var markedTextStyle: [NSAttributedString.Key : Any]? {
        get { responder.markedTextStyle }
        set { responder.markedTextStyle = newValue }
    }
    var selectedTextRange: UITextRange? {
        get { responder.selectedTextRange }
        set { responder.selectedTextRange = newValue }
    }
    var inputDelegate: UITextInputDelegate? {
        get { responder.inputDelegate }
        set { responder.inputDelegate = newValue }
    }
    
    var beginningOfDocument: UITextPosition { responder.beginningOfDocument }
    var endOfDocument: UITextPosition { responder.endOfDocument }
    
    func setMarkedText(_ markedText: String?, selectedRange: NSRange) { responder.setMarkedText(markedText, selectedRange: selectedRange) }
    func unmarkText() { responder.unmarkText() }
    func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult { responder.compare(position, to: other) }
    
// Stubbed
    var markedTextRange: UITextRange? { responder.markedTextRange }
    var tokenizer: UITextInputTokenizer { responder.tokenizer }

    func text(in range: UITextRange) -> String? { responder.text(in: range) }
    func replace(_ range: UITextRange, withText text: String) { responder.replace(range, withText: text) }
    func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? { responder.textRange(from: fromPosition, to: toPosition) }
    func position(from position: UITextPosition, offset: Int) -> UITextPosition? { responder.position(from: position, offset: offset) }
    func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? { responder.position(from: position, in: direction, offset: offset) }
    func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int { responder.offset(from: from, to: toPosition) }
    func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? { responder.position(within: range, farthestIn: direction) }
    func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? { responder.characterRange(byExtending: position, in: direction) }
    func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> NSWritingDirection { responder.baseWritingDirection(for: position, in: direction) }
    func setBaseWritingDirection(_ writingDirection: NSWritingDirection, for range: UITextRange) { responder.setBaseWritingDirection(writingDirection, for: range) }
    func firstRect(for range: UITextRange) -> CGRect { responder.firstRect(for: range) }
    func caretRect(for position: UITextPosition) -> CGRect { responder.caretRect(for: position) }
    func selectionRects(for range: UITextRange) -> [UITextSelectionRect] { responder.selectionRects(for: range) }
    func closestPosition(to point: CGPoint) -> UITextPosition? { responder.closestPosition(to: point) }
    func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? { responder.closestPosition(to: point, within: range) }
    func characterRange(at point: CGPoint) -> UITextRange? { responder.characterRange(at: point) }

// UIKeyInput ======================================================================================
    var hasText: Bool { responder.hasText }
    func insertText(_ text: String) {
        responder.insertText(text)
    }
    func deleteBackward() { responder.deleteBackward() }
    
    @objc func leftArrow() { responder.leftArrow() }
    @objc func rightArrow() { responder.rightArrow() }
    @objc func upArrow() { responder.upArrow() }
    @objc func downArrow() { responder.downArrow() }
    @objc func tab() { responder.tab() }
    @objc func backspace() { responder.backspace() }

    override var keyCommands: [UIKeyCommand]? {
        guard isFirstResponder else { return nil }
        let commands: [UIKeyCommand] = [
            UIKeyCommand(action: #selector(rightArrow), input: UIKeyCommand.inputRightArrow),
            UIKeyCommand(action: #selector(leftArrow), input: UIKeyCommand.inputLeftArrow),
            UIKeyCommand(action: #selector(upArrow), input: UIKeyCommand.inputUpArrow),
            UIKeyCommand(action: #selector(downArrow), input: UIKeyCommand.inputDownArrow),
            UIKeyCommand(action: #selector(backspace), input: "\u{8}"),
            UIKeyCommand(action: #selector(tab), input: "\t")
        ]
        if #available(iOS 15, *) { commands.forEach { $0.wantsPriorityOverSystemBehavior = true } }
        return commands
    }

// UITextInputTraits ===============================================================================
    var smartQuotesType: UITextSmartQuotesType {
        get { responder.smartQuotesType }
        set { responder.smartQuotesType = newValue }
    }
}
