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
	
    lazy var chainView: ChainView = ChainView(editable: self, responder: nil)
    
    var gridLeaf: GridLeaf { controller.gridBub.gridLeaf }
    var mooring: Mooring!
	
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
        
        mooring = controller.gridBub.createMooring(key: cell.tokenKey)
        mooring.fog = controller.gridBub
	}
	required init?(coder: NSCoder) { fatalError() }
    
    var isFocus: Bool { self === gridLeaf.aetherView.focus }
    
    func load(cell: Cell) {
        self.cell = cell
        chainView.chain = cell.chain
    }
    
    func wireMoorings() {
        cell.chain.tokenKeys.forEach { (key: TokenKey) in
            guard let mooring = gridLeaf.aetherView.moorings[key] else { return }
            mooring.attach(self.mooring, wake: false)
        }
    }
    func positionMoorings() { mooring.point = gridLeaf.aetherView.scrollView.convert(self.center, from: self.superview) }
    
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

// Tappable ========================================================================================
	func onFocusTap(aetherView: AetherView) {
		guard !cell.column.calculated else { return }
        if chainView.editing { releaseFocus(.focusTap) }
        else { makeFocus() }
	}

// Editable ========================================================================================
	var aetherView: AetherView { gridLeaf.aetherView }
    var editor: Orbit { orb.chainEditor }
	func onMakeFocus() {
        gridLeaf.focusCell = self
        chainView.edit()
        orb.chainEditor.chainView = chainView
        gridLeaf.beingEdited = true
		gridLeaf.gridBub.cellGainedFocus()
        setNeedsDisplay()
        controller.gridBub.determineLeaves()
        mooring.wakeDoodles()
	}
	func onReleaseFocus() {
        gridLeaf.focusCell = nil
		chainView.ok()
        gridLeaf.beingEdited = false
        controller.gridBub.determineLeaves()
        setNeedsDisplay()
        mooring.sleepDoodles()
	}
	func cite(_ citable: Citable, at: CGPoint) {
		guard let key = citable.tokenKey(at: at) else { return }
        _ = chainView.attemptToPost(key: key)
	}
    func nextFocus(release: Release) -> Editable? { controller.nextGridCell(from: self, release: release) }

	
// Citable =========================================================================================
    func tokenKey(at: CGPoint) -> TokenKey? { cell.chain.key }
	
// ChainViewDelegate ===============================================================================
    var color: UIColor { isFocus ? UIColor.cyan.shade(0.5) : gridLeaf.uiColor }
    
    func becomeFirstResponder() { gridLeaf.becomeFirstResponder() }
    func resignFirstResponder() { gridLeaf.resignFirstResponder() }

    func onTokenKeyAdded(_ key: TokenKey) {
        guard let upstream: Mooring = gridLeaf.gridBub.aetherView.moorings[key] else { return }
        upstream.attach(mooring)
    }
    func onTokenKeyRemoved(_ key: TokenKey) {
        guard let upstream: Mooring = gridLeaf.gridBub.aetherView.moorings[key] else { return }
        upstream.detach(mooring)
    }

    func onWidthChanged(oldWidth: CGFloat?, newWidth: CGFloat) {
        guard oldWidth != newWidth else { return }
        setNeedsResize()
    }
    func onChanged() { controller.resize() }
    func onCalculated() { controller.resize() }
}
