//
//  Shape.swift
//  Oovium
//
//  Created by Joe Charlier on 8/7/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class Shape {
	func drawIcon(color: UIColor) {}
	func drawKey(_ rect: CGRect) {}
	func bounds(size: CGSize) -> CGRect {return CGRect.zero}
	func draw(rect: CGRect, uiColor: UIColor) {}
}
