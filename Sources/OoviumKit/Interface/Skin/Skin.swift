//
//  Skin.swift
//  Oovium
//
//  Created by Joe Charlier on 4/9/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

enum SkinColor {
	case labelText, labelBack, labelFore, cursor, currentCell, ovalText, ovalFore, ovalBack, headerText, hintText, tailText, signatureText
}

public class Skin {
	
	public init() {}
	
	var fadePercent: CGFloat {
		return 0.2
	}
	var backColor: UIColor {
		return UIColor.black
	}
	var statusBarStyle: UIStatusBarStyle {
		return .lightContent
	}
	
	func color(_ skinColor: SkinColor) -> UIColor {return UIColor.white}
	
	func text(_ text: String, rect: CGRect, uiColor: UIColor, font: UIFont, align: NSTextAlignment) {}
	func text(_ text: String, x: CGFloat, y: CGFloat, uiColor: UIColor) {}
	func placeholder(_ text: String, rect: CGRect, uiColor: UIColor, align: NSTextAlignment) {}

	func gridDraw(path: CGPath, uiColor: UIColor) {}
	func gridFill(path: CGPath, uiColor: UIColor) {}
	func gridCalc(path: CGPath, uiColor: UIColor) {}
	func pulse(context: CGContext, rect: CGRect, uiColor: UIColor) {}
	func lasso(path: CGPath) {}
	func doodle(c: CGContext, path: CGPath, color: UIColor, asleep: Bool) {
		c.addPath(path)
		c.setLineWidth(2)
		c.setStrokeColor(color.alpha(asleep ? 0.25 : 0.5).cgColor)
		c.drawPath(using: .stroke)
	}
	
	func panel(path: CGPath, uiColor: UIColor) {}
	func panel(text: String, rect: CGRect, pen: Pen) {}
	func panelOverride(text: String, rect: CGRect, pen: Pen) {}
	func key(path: CGPath, uiColor: UIColor) {}
	func key(text: String, rect: CGRect, font: UIFont) {}
	func key(image: UIImage, rect: CGRect, font: UIFont) {}
	func shapeKey(path: CGPath) {}
	func bubble(path: CGPath, uiColor: UIColor, width: CGFloat) {}
	func bubble(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor? = nil, pen: Pen? = nil) {}
	func bubble(text: String, rect: CGRect, uiColor: UIColor? = nil, pen: Pen? = nil) {}
	func shape(text: String, rect: CGRect, uiColor: UIColor, maxWidth: CGFloat? = nil) {}
	func message(text: String, rect: CGRect, uiColor: UIColor, font: UIFont) {}
	func aetherPicker(path: CGPath) {}
	func aetherPickerList(path: CGPath) {}
	func aetherCell(path: CGPath, uiColor: UIColor? = nil) {}
	func aetherCell(text: String, rect: CGRect, uiColor: UIColor? = nil) {}
	func wafer(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor) -> CGFloat {return 0}
	func tray(path: CGPath, uiColor: UIColor, width: CGFloat) {}
	func tool(path: CGPath) {}
	func plasma(path: CGPath, uiColor: UIColor) {}
	func about(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor, font: UIFont) {}
	func about(path: CGPath, uiColor: UIColor) {}
	func end(path: CGPath, uiColor: UIColor) {}
	func end(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor) {}
	
	// Static ==========================================================================================
	public static var skin: Skin = TronSkin()
	
	static var backColor: UIColor {
		return skin.backColor
	}
	static var statusBarStyle: UIStatusBarStyle {
		return skin.statusBarStyle
	}
	static var fadePercent: CGFloat {
		return skin.fadePercent
	}
	
	static func color(_ skinColor: SkinColor) -> UIColor {
		return skin.color(skinColor)
	}
	
	static func text(_ text: String, rect: CGRect, uiColor: UIColor, font: UIFont, align: NSTextAlignment) {
		skin.text(text, rect: rect, uiColor: uiColor, font: font, align: align)
	}
	static func text(_ text: String, x: CGFloat, y: CGFloat, uiColor: UIColor) {
		skin.text(text, x: x, y: y, uiColor: uiColor)
	}
	static func placeholder(_ text: String, rect: CGRect, uiColor: UIColor, align: NSTextAlignment) {
		skin.placeholder(text, rect: rect, uiColor: uiColor, align: align)
	}

	static func gridDraw(path: CGPath, uiColor: UIColor) {
		skin.gridDraw(path: path, uiColor: uiColor)
	}
	static func gridFill(path: CGPath, uiColor: UIColor) {
		skin.gridFill(path: path, uiColor: uiColor)
	}
	static func gridCalc(path: CGPath, uiColor: UIColor) {
		skin.gridCalc(path: path, uiColor: uiColor)
	}
	static func pulse(context: CGContext, rect: CGRect, uiColor: UIColor) {
		skin.pulse(context: context, rect: rect, uiColor: uiColor)
	}
	static func lasso(path: CGPath) {
		skin.lasso(path: path)
	}
	static func doodle(c: CGContext, path: CGPath, color: UIColor, asleep: Bool) {
		skin.doodle(c: c, path: path, color: color, asleep: asleep)
	}
	
	public static func panel(path: CGPath, uiColor: UIColor) {
		skin.panel(path: path, uiColor: uiColor)
	}
	public static func panel(text: String, rect: CGRect, pen: Pen) {
		skin.panel(text: text, rect: rect, pen: pen)
	}
	public static func panelOverride(text: String, rect: CGRect, pen: Pen) {
		skin.panelOverride(text: text, rect: rect, pen: pen)
	}
	static func key(path: CGPath, uiColor: UIColor) {
		skin.key(path: path, uiColor: uiColor)
	}
	static func key(text: String, rect: CGRect, font: UIFont) {
		skin.key(text: text, rect: rect, font: font)
	}
	static func key(image: UIImage, rect: CGRect, font: UIFont) {
		skin.key(image: image, rect: rect, font: font)
	}
	static func shapeKey(path: CGPath) {
		skin.shapeKey(path: path)
	}
	public static func bubble(path: CGPath, uiColor: UIColor, width: CGFloat) {
		skin.bubble(path: path, uiColor: uiColor, width: width)
	}
	static func bubble(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor? = nil, pen: Pen? = nil) {
		skin.bubble(text: text, x: x, y: y, uiColor: uiColor, pen: pen)
	}
	static func bubble(text: String, rect: CGRect, uiColor: UIColor? = nil, pen: Pen? = nil) {
		skin.bubble(text: text, rect: rect, uiColor: uiColor, pen: pen)
	}
	static func shape(text: String, rect: CGRect, uiColor: UIColor, maxWidth: CGFloat? = nil) {
		skin.shape(text: text, rect: rect, uiColor: uiColor, maxWidth: maxWidth)
	}
	public static func message(text: String, rect: CGRect, uiColor: UIColor, font: UIFont) {
		skin.message(text: text, rect: rect, uiColor: uiColor, font: font)
	}
	static func aetherPicker(path: CGPath) {
		skin.aetherPicker(path: path)
	}
	static func aetherPickerList(path: CGPath) {
		skin.aetherPickerList(path: path)
	}
	static func aetherCell(path: CGPath, uiColor: UIColor? = nil) {
		skin.aetherCell(path: path, uiColor: uiColor)
	}
	static func aetherCell(text: String, rect: CGRect, uiColor: UIColor? = nil) {
		skin.aetherCell(text: text, rect: rect, uiColor: uiColor)
	}
	static func wafer(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor) -> CGFloat {
		return skin.wafer(text: text, x: x, y: y, uiColor: uiColor)
	}
	static func tray(path: CGPath, uiColor: UIColor, width: CGFloat) {
		skin.tray(path: path, uiColor: uiColor, width: width)
	}
	static func tool(path: CGPath) {
		skin.tool(path: path)
	}
	static func plasma(path: CGPath, uiColor: UIColor) {
		skin.plasma(path: path, uiColor: uiColor)
	}
	static func about(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor, font: UIFont) {
		skin.about(text: text, x: x, y: y, uiColor: uiColor, font: font)
	}
	static func about(path: CGPath, uiColor: UIColor) {
		skin.about(path: path, uiColor: uiColor)
	}
	static func end(path: CGPath, uiColor: UIColor) {
		skin.end(path: path, uiColor: uiColor)
	}
	static func end(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor) {
		skin.end(text: text, x: x, y: y, uiColor: uiColor)
	}
}
