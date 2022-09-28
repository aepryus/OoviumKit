//
//  ImageKey.swift
//  Oovium
//
//  Created by Joe Charlier on 5/26/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import UIKit

class ImageKey: UIControl {
	let image: UIImage
	let uiColor: UIColor
	let activeColor: UIColor
	var font: UIFont
	
	private var current: UIColor {
		return isHighlighted ? UIColor.red : (active ? activeColor : uiColor)
	}
	
	var active: Bool = false {
		didSet { setNeedsDisplay() }
	}

	init(image: UIImage, uiColor: UIColor, activeColor: UIColor? = nil, font: UIFont, _ closure: @escaping()->()) {
		self.image = image
		self.uiColor = uiColor
		self.activeColor = activeColor ?? uiColor.tint(0.5)
		self.font = font
		super.init(frame: .zero)
		addAction { closure() }
		backgroundColor = UIColor.clear
	}
	convenience init(image: UIImage, uiColor: UIColor, activeColor: UIColor? = nil, _ closure: @escaping()->()) {
		self.init(image: image, uiColor: uiColor, activeColor: activeColor, font: UIFont(name: "Verdana", size: 14*Oo.s)!, closure)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let path = CGPath(roundedRect: rect.insetBy(dx: floor(3*Oo.s), dy: floor(3*Oo.s)), cornerWidth: 7*Oo.s, cornerHeight: 7*Oo.s, transform: nil)
		Skin.key(path: path, uiColor: current)
		Skin.key(image: image, rect: CGRect(x: (width-height)/2, y: -0.5, width: height, height: height), font: font)
	}
	override var isHighlighted: Bool {
		didSet { setNeedsDisplay() }
	}
}
