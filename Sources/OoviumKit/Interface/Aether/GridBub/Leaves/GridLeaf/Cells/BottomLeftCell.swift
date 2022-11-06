//
//  BottomLeftCell.swift
//  Oovium
//
//  Created by Joe Charlier on 12/1/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import UIKit

class BottomLeftCell: UICollectionViewCell {
    unowned let controller: GridController

    init(controller: GridController) {
        self.controller = controller
        super.init(frame: .zero)
		backgroundColor = .clear
	}
	required init?(coder: NSCoder) { fatalError() }
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let p: CGFloat = 1
		let path: CGMutablePath = CGMutablePath()
		
		path.move(to: CGPoint(x: p, y: 0))
		path.addLine(to: CGPoint(x: p, y: height-p))
		path.addLine(to: CGPoint(x: width, y: height-p))
		
		path.move(to: CGPoint(x: width-p, y: 0))
		path.addLine(to: CGPoint(x: width-p, y: height-p))
		
        let color: UIColor = controller.gridBub.gridLeaf.uiColor
        Skin.gridCalc(path: CGPath(rect: CGRect(x: 0, y: 0, width: width-p, height: height-p), transform: nil), uiColor: color.tint(0.25))
        Skin.gridDraw(path: path, uiColor: color)
	}
}
