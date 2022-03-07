//
//  OOTextField.swift
//  Oovium
//
//  Created by Joe Charlier on 9/2/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

public class OOTextField: UITextField {
	var backColor: UIColor {
		didSet {
			image = nil
			setNeedsDisplay()
		}
	}
	var foreColor: UIColor {
		didSet {
			image = nil
			setNeedsDisplay()}
	}
	
	var image: UIImage? = nil
	
	public init(frame: CGRect, backColor: UIColor, foreColor: UIColor, textColor: UIColor) {
		self.backColor = backColor
		self.foreColor = foreColor
		
		super.init(frame: frame)
		
		self.textColor = textColor
		font = UIFont.verdana(size: 15)
		autocapitalizationType = .none
		autocorrectionType = .no
		textAlignment = .center
		keyboardAppearance = .dark
		inputAssistantItem.leadingBarButtonGroups.removeAll()
		inputAssistantItem.trailingBarButtonGroups.removeAll()
	}
	public convenience init(frame: CGRect, backColor: UIColor, foreColor: UIColor) {
		self.init(frame: frame, backColor: backColor, foreColor: foreColor, textColor: UIColor.black)
	}
	public override convenience init(frame: CGRect) {
		self.init(frame: frame, backColor: UIColor(red: 0.7, green: 0.7, blue: 0.3, alpha: 1), foreColor: UIColor(red: 0.5, green: 0.5, blue: 0.1, alpha: 1))
	}
	public required init?(coder aDecoder: NSCoder) {fatalError()}

// UIView ==========================================================================================
	public override func draw(_ rect: CGRect) {
		
		if image == nil {
			let radius = (rect.size.height-5)/2
			let path = CGPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerWidth: radius, cornerHeight: radius, transform: nil)
			UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
			let c = UIGraphicsGetCurrentContext()!
			backColor.setFill()
			foreColor.setStroke()
			c.addPath(path)
			c.setLineWidth(0.5)
			c.drawPath(using: .fillStroke)
			image = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
		}
		
		image!.draw(in: rect)
	}
	public override var frame: CGRect {
		didSet {
			image = nil
		}
	}
}
