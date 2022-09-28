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

class FooterCell: UICollectionViewCell, Sizable, Citable, FocusTappable, TowerListener {
    unowned let controller: GridController
    unowned let column: Column

    var leftMost: Bool = false
    
    var gridBub: GridBub { controller.gridBub }
    var gridLeaf: GridLeaf { gridBub.gridLeaf }

    let pen: Pen
	
    init(controller: GridController, column: Column) {
        self.controller = controller
        self.column = column
        
        pen = Pen(color: controller.gridBub.gridLeaf.uiColor, alignment: column.alignment)
        
        super.init(frame: .zero)
        
		backgroundColor = .clear
        
        self.column.footerTower.listener = self
	}
	required init?(coder: NSCoder) { fatalError() }
    
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
        if column.aggregate != .none && column.aggregate != .running {
			Skin.bubble(text: column.footerTower.obje.display, rect: CGRect(x: 3, y: 1, width: width-9, height: height-2), pen: pen)
		}
	}
	
// Sizable =========================================================================================
    var aetherView: AetherView { controller.gridBub.aetherView }
    var widthNeeded: CGFloat = 0
    func setNeedsResize() { controller.needsResizing.append(self) }
    func resize() {
        if column.aggregate == .none || column.aggregate == .running { widthNeeded = 0 }
        else { widthNeeded = column.footerTower.obje.display.size(pen: pen).width + 12 }
    }

// Citable =========================================================================================
	func token(at: CGPoint) -> Token? { column.footerTower.variableToken }
	
// TowerListener ===================================================================================
	func onTriggered() {
        setNeedsResize()
    }
}
