//
//  GridCell.swift
//  Oovium
//
//  Created by Joe Charlier on 3/2/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class GridCell: UICollectionViewCell, Editable, Citable, ChainViewDelegate, TowerListener {
	var cell: Cell! {
		didSet {
			cell.tower.listener = self
			chainView.chain = cell.chain
			chainView.render()
		}
	}
	var leftMost: Bool = false
	var bottomMost: Bool = false
	unowned var gridLeaf: GridLeaf!
	var tapped: Bool = false
	
	let chainView: ChainView = ChainView()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = UIColor.clear
		
		chainView.at = CGPoint(x: width-3, y: 1)
		chainView.hitch = .topRight
		chainView.delegate = self
		addSubview(chainView)
	}
	required init?(coder: NSCoder) {fatalError()}
	
	var isFocus: Bool {
		return self === gridLeaf.aetherView.focus
	}
	
	func render() {
		switch cell.column.justify {
			case .left:
				chainView.hitch = .topLeft
				chainView.at = CGPoint(x: 3, y: 1)
			case .center:
				chainView.hitch = .top
				chainView.at = CGPoint(x: width/2, y: 1)
			case .right:
				chainView.hitch = .topRight
				chainView.at = CGPoint(x: width-3, y: 1)
		}
		chainView.render()
		setNeedsDisplay()
	}

// UIView ==========================================================================================
	override var frame: CGRect {
		didSet {
			guard frame.width != oldValue.width else { return }
			render()
		}
	}
	override func setNeedsDisplay() {
		super.setNeedsDisplay()
		chainView.setNeedsDisplay()
	}
	override func draw(_ rect: CGRect) {
		let p: CGFloat = 1
		let path: CGMutablePath = CGMutablePath()
		
		path.move(to: CGPoint(x: 0, y: height-p))
		path.addLine(to: CGPoint(x: width-(leftMost ? p : 0), y: height-p))
		
		if !leftMost || !bottomMost {path.move(to: CGPoint(x: width-p, y: height-(bottomMost ? p : 0)))}
		path.addLine(to: CGPoint(x: width-p, y: 0))
		
		if cell.column.calculated {
			Skin.gridCalc(path: CGPath(rect: CGRect(x: 0, y: 0, width: width-p, height: height-p), transform: nil), uiColor: color.tint(0.25))
		} else if isFocus {
			Skin.gridCalc(path: CGPath(rect: CGRect(x: 0, y: 0, width: width-p, height: height-p), transform: nil), uiColor: UIColor.cyan.shade(0.5))
		} else {
			Skin.gridFill(path: CGPath(rect: CGRect(x: 0, y: 0, width: width-p, height: height-p), transform: nil), uiColor: color)
		}
		
		Skin.gridDraw(path: path, uiColor: color)
	}

// Tappable ========================================================================================
	func onTap(aetherView: AetherView) {
		guard !cell.column.calculated else {return}
		if chainView.chain.editing {
			tapped = true
			releaseFocus()
			onChange()
		} else {
			makeFocus()
		}
	}

// Editable ========================================================================================
	var aetherView: AetherView { gridLeaf.aetherView }
	var editor: Orbit {
		orb.chainEditor.chainView = chainView
		return orb.chainEditor
	}
	func onMakeFocus() {
		chainView.edit()
		gridLeaf.gridBub.cellGainedFocus()
	}
	func onReleaseFocus() {
		chainView.ok()
		if !tapped { gridLeaf.released(cell: self) }
		else {gridLeaf.gridBub.cellLostFocus()}
		tapped = false
	}
	func cite(_ citable: Citable, at: CGPoint) {
		guard let token = citable.token(at: at) else {return}
		_ = chainView.attemptToPost(token: token)
	}
	
// Citable =========================================================================================
	func token(at: CGPoint) -> Token? {
		return cell.token
	}
	
// ChainViewDelegate ===============================================================================
	var color: UIColor {
		return isFocus ? UIColor.cyan.shade(0.5) : gridLeaf.uiColor
	}
	
	func onChange() {
//		cell._width = nil
		chainView.render()
//		cell.column.renderWidth()
		gridLeaf.render()
		gridLeaf.gridBub.render()
		setNeedsDisplay()
	}
	func onEdit() {
		onChange()
	}
	func onOK() {
		releaseFocus(dismissEditor: gridLeaf.grid.equalMode == .close)
		onChange()
	}
	func onBackspace(token: Token) {
		onChange()
	}
	func onUp() { tapped = true; gridLeaf.focus(arrow: .up, from: self) }
	func onDown() { tapped = true; gridLeaf.focus(arrow: .down, from: self) }
	func onLeft() { tapped = true; gridLeaf.focus(arrow: .left, from: self) }
	func onRight() { tapped = true; gridLeaf.focus(arrow: .right, from: self) }
	func onTab() {
		gridLeaf.gridBub.rotateEndMode()
	}
	
// TowerListener ===================================================================================
	func onCalculate() {
		render()
		cell.renderWidth()
//		cell.column.renderWidth()
		gridLeaf.render()
		gridLeaf.gridBub.render()
	}
}
