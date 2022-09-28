//
//  BottomLeftCell.swift
//  Oovium
//
//  Created by Joe Charlier on 12/1/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import UIKit

class BottomLeftCell: UICollectionViewCell {
	unowned var gridLeaf: GridLeaf!

	override init(frame: CGRect) {
		super.init(frame: frame)
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
		
		Skin.gridCalc(path: CGPath(rect: CGRect(x: 0, y: 0, width: width-p, height: height-p), transform: nil), uiColor: gridLeaf.uiColor.tint(0.25))
		Skin.gridDraw(path: path, uiColor: gridLeaf.uiColor)
	}
}
