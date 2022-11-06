//
//  AnchorCell.swift
//  Oovium
//
//  Created by Joe Charlier on 11/10/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import UIKit

class AnchorCell: UICollectionViewCell, Tappable {
    unowned let controller: GridController

    init(controller: GridController) {
        self.controller = controller
        super.init(frame: .zero)
		backgroundColor = UIColor.black.alpha(0.7)
	}
	required init?(coder: NSCoder) { fatalError() }
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let p: CGFloat = 1
		
		Skin.gridFill(path: CGPath(rect: rect.inset(by: UIEdgeInsets(top: p, left: p, bottom: p, right: p)), transform: nil), uiColor: UIColor.black)

		let path: CGMutablePath = CGMutablePath()
		
		path.move(to: CGPoint(x: p, y: height))
		path.addLine(to: CGPoint(x: p, y: p))
		path.addLine(to: CGPoint(x: width, y: p))
		
		path.move(to: CGPoint(x: p, y: height-p))
		path.addLine(to: CGPoint(x: width, y: height-p))
		
		path.move(to: CGPoint(x: width-p, y: p))
		path.addLine(to: CGPoint(x: width-p, y: height))

        Skin.gridDraw(path: path, uiColor: controller.gridBub.gridLeaf.uiColor)
	}

// Tappable ========================================================================================
    func onTap() { controller.onAnchorCellTapped() }
}
