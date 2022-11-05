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

class GridMaker: Maker {
	
// Maker ===========================================================================================
	func make(aetherView: AetherView, at: V2) -> Bubble {
        let grid: Grid = aetherView.aether.create(at: at)
		return GridBub(grid, aetherView: aetherView)
	}
	func drawIcon() {
		let lw: CGFloat = 15*Oo.s
		let cw: CGFloat = lw
		let rh: CGFloat = 7*Oo.s
		let v: CGFloat = 1*Oo.s
		let r: CGFloat = 4*Oo.s
		let ir: CGFloat = 1*Oo.s
		let hh = 2*r
		
		let x1: CGFloat = 6*Oo.s
		let x2 = x1+r+v
		let x3 = x2+ir+v
		let x4 = x3+r
		let x5 = x4+r
		let x6 = x3+cw/2
		let x7 = x3+cw
		let x8 = x7+ir+v
		let x9 = x8+r+v
		
		let y1: CGFloat = 10*Oo.s
		let y2 = y1+r
		let y3 = y1+hh
		let y4 = y3+rh-r
		let y5 = y3+rh
		let y6 = y5+ir+v
		let y7 = y6+r+v
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x6, y: y1))
		path.addArc(tangent1End: CGPoint(x: x9, y: y1), tangent2End: CGPoint(x: x9, y: y2), radius: r)
		path.addArc(tangent1End: CGPoint(x: x9, y: y3), tangent2End: CGPoint(x: x8, y: y3), radius: r)
		path.addArc(tangent1End: CGPoint(x: x7, y: y3), tangent2End: CGPoint(x: x7, y: y4), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x7, y: y5), tangent2End: CGPoint(x: x6, y: y5), radius: r)
		path.addArc(tangent1End: CGPoint(x: x5, y: y5), tangent2End: CGPoint(x: x5, y: y6), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x5, y: y7), tangent2End: CGPoint(x: x4, y: y7), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y7), tangent2End: CGPoint(x: x3, y: y4), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y3), tangent2End: CGPoint(x: x2, y: y3), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x1, y: y2), radius: r)
		path.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x6, y: y1), radius: r)
		path.closeSubpath()
		
		path.move(to: CGPoint(x: x2, y: y3))
		path.addLine(to: CGPoint(x: x8, y: y3))
		path.move(to: CGPoint(x: x3, y: y1))
		path.addLine(to: CGPoint(x: x3, y: y4))
		path.move(to: CGPoint(x: x7, y: y1))
		path.addLine(to: CGPoint(x: x7, y: y4))
		path.move(to: CGPoint(x: x3, y: y5))
		path.addLine(to: CGPoint(x: x6, y: y5))
		
		Skin.bubble(path: path, uiColor: UIColor.purple, width: 4.0/3.0*Oo.s)
	}
}

class GridBub: Bubble, ChainLeafDelegate {
	let grid: Grid
    
    lazy var controller: GridController = { GridController(self) }()
	
	lazy var gridLeaf: GridLeaf = { GridLeaf(controller: controller) }()
	lazy var addRowLeaf: PlusLeaf = { PlusLeaf(bubble: self) }()
	lazy var addColumnLeaf: PlusLeaf = { PlusLeaf(bubble: self) }()
	lazy var equalLeaf: EqualLeaf = { EqualLeaf(bubble: self) }()
	lazy var chainLeaf: ChainLeaf = { ChainLeaf(bubble: self, delegate: self) }()
	
	var editingColNo: Int? = nil
	var suppressChainLeafRemoval: Bool = false
	var cellHasFocus: Bool = false
	
	init(_ grid: Grid, aetherView: AetherView) {
		self.grid = grid
		
		super.init(aetherView: aetherView, aexel: grid, origin: CGPoint(x: self.grid.x, y: self.grid.y), size: CGSize.zero)
		
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
//        determineLeaves()
        if !gridLeaf.isFirstResponder && ChainResponder.hasExternalKeyboard { gridLeaf.becomeFirstResponder() }
	}
	func cellLostFocus() {
		cellHasFocus = false
//        determineLeaves()
//        gridLeaf.resignFirstResponder()
	}
	
	func attachChainLeaf(to headerCell: HeaderCell) {
		editingColNo = headerCell.column.colNo
		chainLeaf.chain = headerCell.column.chain
		chainLeaf.anchor = headerCell.center + CGPoint(x: 0, y: -72)
		add(leaf: chainLeaf)
		chainLeaf.render()
		render()
	}
	func removeChainLeaf() {
		editingColNo = nil
		remove(leaf: chainLeaf)
		render()
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
	override func onSelect() {
		gridLeaf.gridView.subviews.forEach { $0.setNeedsDisplay() }
	}
	override func onUnselect() {
		gridLeaf.gridView.subviews.forEach { $0.setNeedsDisplay() }
	}

// Bubble ==========================================================================================
    override var uiColor: UIColor { !selected ? UIColor.purple : UIColor.yellow }
    override var hitch: Position { .topLeft }
	override var hitchPoint: CGPoint { CGPoint(x: grid.exposed ? 4.5 : 0, y: editingColNo != nil ? 57 : (grid.exposed ? 4.5 : 0)) }
	override func wireMoorings() {}
	
// UIView ==========================================================================================
	override func setNeedsDisplay() {
		super.setNeedsDisplay()
		gridLeaf.setNeedsDisplay()
	}
	override func draw(_ rect: CGRect) {
		guard let plasma = plasma else { return }
        Skin.plasma(path: plasma, uiColor: uiColor, stroke: 1)
	}
	
// ChainLeafDelegate ===============================================================================
    var usesMooring: Bool { false }
	func onChange() {
		layoutLeavesIfNeeded()
	}
	func onWillEdit() {
		suppressChainLeafRemoval = true
	}
	func onEdit() {
		layoutLeavesIfNeeded()
	}
	func onOK(leaf: ChainLeaf) {
		guard let editingColNo = editingColNo, let column: Column = grid.column(colNo: editingColNo) else { fatalError() }
		column.disseminate()
		column.calculate()
		removeChainLeaf()
        controller.resize()
	}
	func onCalculate() {}
}
