//
//  ColorField.swift
//  Oovium
//
//  Created by Joe Charlier on 10/26/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class ColorField: UIView {
	var color: UIColor {
		didSet {setNeedsDisplay()}
	}
	
	init(color: UIColor) {
		self.color = color
		super.init(frame: CGRect.zero)
		self.backgroundColor = UIColor.clear
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		color.setFill()
		RGB.shade(color: color, percent: 0.5).setStroke()
		let c = UIGraphicsGetCurrentContext()!
		let w: CGFloat = 2
		let path = CGPath(ellipseIn: rect.insetBy(dx: w/2, dy: w/2), transform: nil)
		c.setLineWidth(w)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
}
