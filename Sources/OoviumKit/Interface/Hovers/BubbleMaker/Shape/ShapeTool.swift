//
//  ShapeTool.swift
//  Oovium
//
//  Created by Joe Charlier on 8/4/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class ShapeTool: Tool {
	let shape: Text.Shape
	
	init(shape: Text.Shape) {
		self.shape = shape
		super.init()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		super.draw(rect)
		shape.shape.drawIcon(color: UIColor.lightGray)
	}
}
