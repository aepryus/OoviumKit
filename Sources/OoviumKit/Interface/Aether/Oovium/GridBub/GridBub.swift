//
//  GridBub.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class GridBub: Bubble, ChainLeafDelegate {
	let grid: Grid
    
    lazy var controller: GridController = GridController(self)
	
	var gridLeaf: GridLeaf!
    lazy var addRowLeaf: PlusLeaf = PlusLeaf(controller: controller)
    lazy var addColumnLeaf: PlusLeaf = PlusLeaf(controller: controller)
	lazy var equalLeaf: EqualLeaf = EqualLeaf(bubble: self)
	lazy var chainLeaf: ChainLeaf = ChainLeaf(bubble: self, delegate: self)
	
	var editingColNo: Int? = nil
	var suppressChainLeafRemoval: Bool = false
	var cellHasFocus: Bool = false
	
	init(_ grid: Grid, aetherView: AetherView) {
		self.grid = grid
		
		super.init(aetherView: aetherView, aexel: grid, origin: CGPoint(x: self.grid.x, y: self.grid.y), size: CGSize.zero)
        
        controller = GridController(self)
        gridLeaf = GridLeaf(controller: controller)
		
		gridLeaf.size = CGSize(width: 360, height: 360)
		gridLeaf.hitch = .topLeft
		gridLeaf.anchor = CGPoint.zero
		add(leaf: gridLeaf)
		
		addColumnLeaf.size = CGSize(width: 39, height: 39)
		addColumnLeaf.hitch = .topLeft
		add(leaf: addColumnLeaf)
		addColumnLeaf.onTapped = { [unowned self] (aetherView: AetherView) in
            controller.addColumn()
		}
		
		addRowLeaf.size = CGSize(width: 39, height: 39)
		addRowLeaf.hitch = .topLeft
		add(leaf: addRowLeaf)
		addRowLeaf.onTapped = { [unowned self] (aetherView: AetherView) in
            controller.addRow()
		}
		
		equalLeaf.size = CGSize(width: 39, height: 39)
		add(leaf: equalLeaf)
		equalLeaf.onTapped = { [unowned self] in
			rotateEndMode()
		}
		
        controller.resizeEverything()
		
		chainLeaf.delegate = self
		chainLeaf.hitch = .top
		chainLeaf.size = CGSize(width: 100, height: 36)
		chainLeaf.minWidth = 100
		chainLeaf.radius = 15
        chainLeaf.chainView.chain = grid.columns[0].chain
		
        determineLeaves()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func determineLeaves() {
		if grid.exposed {
			add(leaf: addRowLeaf)
			add(leaf: addColumnLeaf)
		} else {
			remove(leaf: addRowLeaf)
			remove(leaf: addColumnLeaf)
		}
        if gridLeaf.beingEdited {
			add(leaf: equalLeaf)
		} else {
			remove(leaf: equalLeaf)
		}
		render()
	}
	func morph() {
		grid.exposed = !grid.exposed
        determineLeaves()
	}
	func rotateEndMode() {
		grid.equalMode = grid.equalMode.next
		render()
	}
	
	func cellGainedFocus() {
		cellHasFocus = true
        if !gridLeaf.isFirstResponder && ChainResponder.hasExternalKeyboard { gridLeaf.becomeFirstResponder() }
	}
	func cellLostFocus() {
		cellHasFocus = false
        determineLeaves()
	}
	
	func attachChainLeaf(to headerCell: HeaderCell) {
		editingColNo = headerCell.column.colNo
		chainLeaf.chain = headerCell.column.chain
		chainLeaf.anchor = headerCell.center + CGPoint(x: 0, y: -72)
		add(leaf: chainLeaf)
		chainLeaf.render()
		render()
        chainLeaf.chainView.resize()
        chainLeaf.wireMoorings()
	}
	func removeChainLeaf() {
		editingColNo = nil
		remove(leaf: chainLeaf)
		render()
        chainLeaf.unwireMoorings()
//        aetherView.moorings[chainLeaf.chain.tower.variableToken] = nil
	}
    func addColumn(with column: Column) { gridLeaf.addColumn(with: column) }
    func addRow(with cells: [Cell]) { gridLeaf.addRow(with: cells) }
    
	func render() {
		addColumnLeaf.anchor = CGPoint(x: gridLeaf.size.width + 10, y: -4.5)
		addRowLeaf.anchor = CGPoint(x: -4.5, y: gridLeaf.size.height + 10)
		
		switch grid.equalMode {
			case .right:
				equalLeaf.anchor = CGPoint(x: gridLeaf.size.width + 10, y: gridLeaf.size.height - 29.5)
			case .close:
				equalLeaf.anchor = CGPoint(x: gridLeaf.size.width - 2, y: gridLeaf.size.height - 2)
			case .down:
				equalLeaf.anchor = CGPoint(x: gridLeaf.size.width - 29.5, y: gridLeaf.size.height + 10)
		}
		layoutLeaves()
		
		plasma = CGMutablePath()
		guard let plasma = plasma else { return }
		
		var a: CGPoint = CGPoint.zero
		var b: CGPoint = CGPoint.zero
		var c: CGPoint = CGPoint.zero
		
		if grid.exposed {
			a = CGPoint(x: addRowLeaf.center.x-10, y: gridLeaf.bottom-10)
			b = CGPoint(x: addRowLeaf.center.x, y: addRowLeaf.center.y)
			c = CGPoint(x: addRowLeaf.center.x+10, y: gridLeaf.bottom-10)
			plasma.move(to: c)
			plasma.addQuadCurve(to: b, control: (b+c)/2+CGPoint(x: -6, y: 0))
			plasma.addQuadCurve(to: a, control: (a+b)/2+CGPoint(x: 6, y: 0))
			plasma.closeSubpath()
			
			a = CGPoint(x: gridLeaf.right-10, y: addColumnLeaf.center.y-10)
			b = CGPoint(x: addColumnLeaf.center.x, y: addColumnLeaf.center.y)
			c = CGPoint(x: gridLeaf.right-10, y: addColumnLeaf.center.y+10)
			plasma.move(to: c)
			plasma.addQuadCurve(to: b, control: (b+c)/2+CGPoint(x: 0, y: -6))
			plasma.addQuadCurve(to: a, control: (a+b)/2+CGPoint(x: 0, y: 6))
			plasma.closeSubpath()
		}
		
        if gridLeaf.beingEdited {
			a = CGPoint(x: gridLeaf.right-3, y: gridLeaf.bottom-17)
			b = CGPoint(x: equalLeaf.center.x, y: equalLeaf.center.y)
			c = CGPoint(x: gridLeaf.right-17, y: gridLeaf.bottom-3)
			let d: CGPoint = ((a+c)/2+b)/2
			let e: CGPoint = (b+c)/2
			let f: CGPoint = (a+b)/2
			plasma.move(to: c)
			plasma.addQuadCurve(to: b, control: e+(d-e)*1.3)
			plasma.addQuadCurve(to: a, control: f+(d-f)*1.3)
			plasma.closeSubpath()
		}
		
		if editingColNo != nil {
			a = CGPoint(x: chainLeaf.center.x-20, y: chainLeaf.center.y)
			b = CGPoint(x: chainLeaf.center.x-24, y: gridLeaf.top+13)
			c = CGPoint(x: chainLeaf.center.x+24, y: gridLeaf.top+13)
			let d: CGPoint = CGPoint(x: chainLeaf.center.x+20, y: chainLeaf.center.y)
			plasma.move(to: a)
			plasma.addQuadCurve(to: b, control: (a+b)/2+CGPoint(x: 24, y: 0))
			plasma.addLine(to: c)
			plasma.addQuadCurve(to: d, control: (c+d)/2+CGPoint(x: -24, y: 0))
			plasma.closeSubpath()
		}
		
		aetherView.stretch()
	}
	
// Events ==========================================================================================
	override func onSelect() { gridLeaf.gridView.subviews.forEach { $0.setNeedsDisplay() } }
	override func onUnselect() { gridLeaf.gridView.subviews.forEach { $0.setNeedsDisplay() } }

// Bubble ==========================================================================================
    override var uiColor: UIColor { !selected ? UIColor.purple : UIColor.yellow }
    override var hitch: Position { .topLeft }
	override var hitchPoint: CGPoint { CGPoint(x: grid.exposed ? 4.5 : 0, y: editingColNo != nil ? 57 : (grid.exposed ? 4.5 : 0)) }
	override func wireMoorings() {}
	
// UIView ==========================================================================================
	override func setNeedsDisplay() {
		super.setNeedsDisplay()
		gridLeaf?.setNeedsDisplay()
	}
	override func draw(_ rect: CGRect) {
		guard let plasma = plasma else { return }
        Skin.plasma(path: plasma, uiColor: uiColor, stroke: 1)
	}
	
// ChainLeafDelegate ===============================================================================
	func onChange() { layoutLeavesIfNeeded() }
	func onWillFocusTap() { suppressChainLeafRemoval = true }
	func onEdit() { layoutLeavesIfNeeded() }
	func onOK(leaf: ChainLeaf) {
		guard let editingColNo = editingColNo, let column: Column = grid.column(colNo: editingColNo) else { fatalError() }
		column.disseminate()

        let aetherExe: AetherExe = aetherView.aetherExe

        aetherView.aetherExe.trigger(keys: column.cellKeys())
        
        let cellTowers: [Tower] = column.cellKeys().map({ aetherExe.tower(key: $0)! })
        cellTowers.forEach({ $0.buildStream() })

		removeChainLeaf()
        controller.resize()
	}
	func onCalculate() {}
}
