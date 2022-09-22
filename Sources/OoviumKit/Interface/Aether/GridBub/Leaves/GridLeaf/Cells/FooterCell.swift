//
//  FooterCell.swift
//  Oovium
//
//  Created by Joe Charlier on 3/2/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class FooterCell: UICollectionViewCell, Citable, FocusTappable, TowerListener {
//	var column: Column! {
//		didSet { column.footerTower.listener = self }
//	}
	var leftMost: Bool = false
	unowned var gridLeaf: GridLeaf!
    unowned let column: GridColumn
	
	init(column: GridColumn) {
        self.column = column
        super.init(frame: .zero)
		backgroundColor = .clear
	}
	required init?(coder: NSCoder) {fatalError()}
    
    private var _widthNeeded: CGFloat?
    var widthNeeded: CGFloat {
        if let _widthNeeded { return _widthNeeded }
        _widthNeeded = 90
        return _widthNeeded!
    }
    func clearWidthNeeded() {
        _widthNeeded = nil
        column.clearWidthNeeded()
    }

// Tappable ========================================================================================
	func onTap(aetherView: AetherView) {}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let p: CGFloat = 1
		let path: CGMutablePath = CGMutablePath()
		
		path.move(to: CGPoint(x: 0, y: height-p))
		path.addLine(to: CGPoint(x: width-(leftMost ? p : 0), y: height-p))
		
		if !leftMost {path.move(to: CGPoint(x: width-p, y: height-p))}
		path.addLine(to: CGPoint(x: width-p, y: 0))
		
		Skin.gridCalc(path: CGPath(rect: CGRect(x: 0, y: 0, width: width-p, height: height-p), transform: nil), uiColor: gridLeaf.uiColor.tint(0.25))
		Skin.gridDraw(path: path, uiColor: gridLeaf.uiColor)
        if column.column.aggregate != .none && column.column.aggregate != .running {
			Skin.bubble(text: column.column.footerTower.obje.display, rect: CGRect(x: 3, y: 1, width: width-9, height: height-2), pen: Pen(color: gridLeaf.uiColor, alignment: column.column.alignment))
		}
	}
	
// Citable =========================================================================================
	func token(at: CGPoint) -> Token? {
		return column.column.footerTower.variableToken
	}
	
// TowerListener ===================================================================================
	func onTriggered() {
		setNeedsDisplay()
	}
}
