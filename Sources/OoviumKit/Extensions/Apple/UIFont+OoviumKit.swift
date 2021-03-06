//
//  UIFont+AE.swift
//  Pangaea
//
//  Created by Joe Charlier on 2/9/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import UIKit

public extension UIFont {
	static func placeholder(size: CGFloat) -> UIFont {
		return UIFont(name: "Verdana-Italic", size: size)!
	}
	static func verdana(size: CGFloat) -> UIFont {
		return UIFont(name: "Verdana", size: size)!
	}
	static func oovium(size: CGFloat) -> UIFont {
		return UIFont.systemFont(ofSize: size)
	}
}
