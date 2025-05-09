//
//  LefterCell.swift
//  Oovium
//
//  Created by Joe Charlier on 3/2/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import UIKit

class LefterCell: UICollectionViewCell, Editable, AnchorPannable {
    unowned let controller: GridController
    
	var rowNo: Int = -1 {
		didSet {setNeedsDisplay()}
	}
	var bottomMost: Bool = false

    init(controller: GridController) {
        self.controller = controller
        super.init(frame: .zero)
		backgroundColor = UIColor.clear
	}
	required init?(coder: NSCoder) { fatalError() }
    
    var gridLeaf: GridLeaf { controller.gridBub.gridLeaf }
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let p: CGFloat = 1
		let path: CGMutablePath = CGMutablePath()
		
		path.move(to: CGPoint(x: p, y: 0))
		path.addLine(to: CGPoint(x: p, y: height-(bottomMost ? p : 0)))
		
		if !bottomMost {path.move(to: CGPoint(x: p, y: height-p))}
		path.addLine(to: CGPoint(x: width, y: height-p))
		
		path.move(to: CGPoint(x: width-p, y: 0))
		path.addLine(to: CGPoint(x: width-p, y: height-(bottomMost ? p : 0)))
		
		if gridLeaf.gridBub.aetherView.focus !== self {
			Skin.gridCalc(path: CGPath(rect: CGRect(x: 0, y: 0, width: width-p, height: height-p), transform: nil), uiColor: gridLeaf.uiColor.tint(0.25))
			Skin.text("\(rowNo)", rect: CGRect(x: 0, y: 1, width: width, height: height), uiColor: gridLeaf.uiColor, font: UIFont(name: "Verdana", size: 15)!, align: .center)
		} else {
			Skin.gridCalc(path: CGPath(rect: CGRect(x: 0, y: 0, width: width-p, height: height-p), transform: nil), uiColor: UIColor.cyan.shade(0.5))
			Skin.text("\(rowNo)", rect: CGRect(x: 0, y: 1, width: width, height: height), uiColor: UIColor.cyan.shade(0.5), font: UIFont(name: "Verdana", size: 15)!, align: .center)
		}
        Skin.gridDraw(path: path, uiColor: gridLeaf.uiColor)
	}

// Tappable ========================================================================================
	func onFocusTap(aetherView: AetherView) {
		if aetherView.focus !== self { makeFocus() }
        else { releaseFocus(.focusTap) }
	}

// Editable ========================================================================================
	var aetherView: AetherView { gridLeaf.aetherView }
	var editor: Orbit { orb.lefterEditor.edit(editable: self) }
	func cedeFocusTo(other: FocusTappable) -> Bool {
		guard let lefterCell = other as? LefterCell else {return false}
		return gridLeaf === lefterCell.gridLeaf
	}
	func onMakeFocus() { setNeedsDisplay() }
	func onReleaseFocus() { setNeedsDisplay() }
    func onCancelFocus() { releaseFocus(.administrative) }
	func cite(_ citable: Citable, at: CGPoint) {}
	
// AnchorPannable ==================================================================================
	func onPan(offset: CGPoint) {
		gridLeaf.slide(rowNo: rowNo, dy: offset.y)
	}
	func onReleased(offset: CGPoint) {
		let to: Int = gridLeaf.gridView.row(cy: center.y+offset.y).clamped(to: 1...(gridLeaf.grid.rows))
        controller.move(rowNo: rowNo, toRowNo: to)
	}
}
