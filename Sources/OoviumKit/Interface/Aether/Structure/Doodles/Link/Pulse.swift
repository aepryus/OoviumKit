//
//  Pulse.swift
//  Oovium
//
//  Created by Joe Charlier on 9/22/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class Pulse: CALayer {
	var color: UIColor {
		didSet {
			setNeedsDisplay()
		}
	}
	
	override init() {
		color = UIColor.red
		super.init()
		bounds = CGRect(x: 0, y: 0, width: 9, height: 9)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
// CALayer =========================================================================================
	override func draw(in ctx: CGContext) {
		Skin.pulse(context: ctx, rect: CGRect(x: 2, y: 2, width: 5, height: 5), uiColor: color)
	}
}
