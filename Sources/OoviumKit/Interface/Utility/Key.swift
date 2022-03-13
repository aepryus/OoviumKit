//
//  Key.swift
//  Oovium
//
//  Created by Joe Charlier on 4/10/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

public class Key: UIControl {
	let text: String
	let uiColor: UIColor
	let activeColor: UIColor
	var font: UIFont
	
	private var current: UIColor {
		return isHighlighted ? UIColor.red : (active ? activeColor : uiColor)
	}

	public var active: Bool = false {
		didSet { setNeedsDisplay() }
	}
	
	public init(text: String, uiColor: UIColor, activeColor: UIColor? = nil, font: UIFont, _ closure: @escaping()->()) {
		self.text = text
		self.uiColor = uiColor
		self.activeColor = activeColor ?? uiColor.tint(0.5)
		self.font = font
		super.init(frame: .zero)
		addAction { closure() }
		backgroundColor = UIColor.clear
	}
	public convenience init(text: String, uiColor: UIColor, activeColor: UIColor? = nil, _ closure: @escaping()->()) {
		self.init(text: text, uiColor: uiColor, activeColor: activeColor, font: UIFont(name: "Verdana", size: 14*Oo.s)!, closure)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
// UIView ==========================================================================================
	override public func draw(_ rect: CGRect) {
		let path = CGPath(roundedRect: rect.insetBy(dx: floor(3*Oo.s), dy: floor(3*Oo.s)), cornerWidth: 7*Oo.s, cornerHeight: 7*Oo.s, transform: nil)
		Skin.key(path: path, uiColor: current)
		Skin.key(text: text, rect: rect.offsetBy(dx: 0, dy: -0.5), font: font)
	}
	override public var isHighlighted: Bool {
		didSet { setNeedsDisplay() }
	}
}
