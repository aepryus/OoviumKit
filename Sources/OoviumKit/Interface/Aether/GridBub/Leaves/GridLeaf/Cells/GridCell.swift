//
//  GridCell.swift
//  Oovium
//
//  Created by Joe Charlier on 3/2/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class GridCell: UICollectionViewCell, Sizable, Editable, Citable, ChainViewDelegate {
    unowned let controller: GridController
    unowned let column: GridColumn
    var cell: Cell
    
	var leftMost: Bool = false
	var bottomMost: Bool = false
	var tapped: Bool = false
	
	let chainView: ChainView = ChainView()
    
    var gridLeaf: GridLeaf { controller.gridBub.gridLeaf }
	
    init(controller: GridController, column: GridColumn, cell: Cell) {
        self.controller = controller
        self.column = column
        self.cell = cell
        
        super.init(frame: .zero)

        backgroundColor = UIColor.clear
        
        chainView.chain = cell.chain
		chainView.delegate = self
        chainView.keyDelegate = controller
		addSubview(chainView)
        
        self.cell.tower.listener = chainView
	}
	required init?(coder: NSCoder) { fatalError() }
    
    var isFocus: Bool { self === gridLeaf.aetherView.focus }
    
    func load(cell: Cell) {
        self.cell = cell
        chainView.chain = cell.chain
    }
    
// UIView ==========================================================================================
	override func setNeedsDisplay() {
		super.setNeedsDisplay()
		chainView.setNeedsDisplay()
	}
    override func layoutSubviews() {
        let p: CGFloat = 3
        let h: CGFloat = 24
        switch cell.column.justify {
            case .left:     chainView.left(dx: p, height: h)
            case .center:   chainView.center(height: h)
            case .right:    chainView.right(dx: -p, height: h)
        }
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
    
// Sizable =========================================================================================
    var widthNeeded: CGFloat = 90
    func resize() {
        widthNeeded = chainView.width+6
        setNeedsDisplay()
    }
    func setNeedsResize() {
        controller.needsResizing.append(self)
        column.setNeedsResize()
    }
//    func resize() {
//        let oldWidthNeeded: CGFloat? = controller.cellWidthNeeded[cell.iden]
//        let newWidthNeeded: CGFloat = widthNeeded
//
//        if newWidthNeeded != oldWidthNeeded {
//            column.setNeedsRearch()
//            controller.cellWidthNeeded[cell.iden] = newWidthNeeded
//        }
//    }

// Tappable ========================================================================================
	func onTap(aetherView: AetherView) {
		guard !cell.column.calculated else { return }
		if chainView.chain.editing {
			tapped = true
			releaseFocus()
		} else { makeFocus() }
	}

// Editable ========================================================================================
	var aetherView: AetherView { gridLeaf.aetherView }
	var editor: Orbit {
		orb.chainEditor.chainView = chainView
		return orb.chainEditor
	}
	func onMakeFocus() {
        gridLeaf.focusCell = self
		chainView.edit()
		gridLeaf.gridBub.cellGainedFocus()
//        controller.architect()
	}
	func onReleaseFocus() {
        gridLeaf.focusCell = nil
		chainView.ok()
//        controller.architect()
		if !tapped {
            gridLeaf.released(cell: self)
        }
		else {
//            gridLeaf.gridBub.cellLostFocus()
        }
		tapped = false
        setNeedsDisplay()
	}
	func cite(_ citable: Citable, at: CGPoint) {
		guard let token = citable.token(at: at) else { return }
		_ = chainView.attemptToPost(token: token)
	}
	
// Citable =========================================================================================
	func token(at: CGPoint) -> Token? { cell.token }
	
// ChainViewDelegate ===============================================================================
    var color: UIColor { isFocus ? UIColor.cyan.shade(0.5) : gridLeaf.uiColor }

    func onEditStart() { setNeedsDisplay() }
    func onEditStop() { releaseFocus(dismissEditor: tapped || controller.grid.equalMode == .close) }

    func onTokenAdded(_ token: Token) {}
    func onTokenRemoved(_ token: Token) {}

    func onWidthChanged(oldWidth: CGFloat?, newWidth: CGFloat) {
        guard oldWidth != newWidth else { return }
        setNeedsResize()
    }
    func onChanged() { controller.resize() }
}
