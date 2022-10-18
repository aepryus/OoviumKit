//
//  EqualLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 12/9/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class EqualLeaf: Leaf, Tappable {
	
	var onTapped: ()->() = {}

	init(bubble: Bubble) {
		super.init(bubble: bubble, hitch: .topLeft, anchor: CGPoint.zero, size: CGSize(width: 36, height: 36))
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
		
	var gridBub: GridBub {
		return bubble as! GridBub
	}

// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let d: CGFloat = 6
        let circlePath: CGPath = CGPath(roundedRect: rect.insetBy(dx: d, dy: d), cornerWidth: (width-d)/2, cornerHeight: (height-d)/2, transform: nil)
        Skin.gridFill(path: circlePath, uiColor: bubble.uiColor)
        Skin.gridDraw(path: circlePath, uiColor: bubble.uiColor)
		Skin.bubble(text: "=", rect: CGRect(x: 3, y: 8, width: rect.width-6, height: 24), pen: Pen(color: bubble.uiColor, alignment: .center))
	}
	
// Tappable ========================================================================================
	func onTap() { onTapped() }
}
