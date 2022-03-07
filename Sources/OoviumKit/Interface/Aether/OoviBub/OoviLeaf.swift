//
//  OoviLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 10/24/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class OoviLeaf: Leaf, UITextFieldDelegate, Editable {
	unowned let oovi: Oovi

	var focus: Bool = false

	var textField: OOTextField
	var colorField: ColorField

	init(bubble: Bubble, oovi: Oovi) {
		self.oovi = oovi
		
		textField = OOTextField(frame: CGRect(x: 10, y: 10, width: 80, height: 36), backColor: UIColor.black, foreColor: oovi.uiColor, textColor: UIColor.white)
		textField.text = oovi.name
		colorField = ColorField(color: oovi.uiColor)
		
		super.init(bubble: bubble, hitch: .topLeft, anchor: CGPoint.zero, size: CGSize.zero)
		
		self.backgroundColor = UIColor.clear

		textField.delegate = self

//		NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: .UIKeyboardWillHide, object: nil)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	var ooviBub: OoviBub {
		return bubble as! OoviBub
	}
	

// Events ==========================================================================================
//	@objc func onKeyboardWillHide() {
//		_ = textFieldShouldReturn(textField)
//	}
	func onTap(aetherView: AetherView) {
		if !focus {
			makeFocus()
		} else {
			releaseFocus()
		}
	}
	func onColorChange() {
		textField.foreColor = ooviBub.oovi.color.uiColor
		colorField.color = ooviBub.oovi.color.uiColor
	}
	
// Editable ========================================================================================
	var editor: Orbit {
		return orb.ooviEditor.edit(editable: self)
	}
	func onMakeFocus() {
		addSubview(textField)
		addSubview(colorField)
		focus = true
		setNeedsDisplay()
	}
	func onReleaseFocus() {
		textField.resignFirstResponder()
		textField.removeFromSuperview()
		colorField.removeFromSuperview()
		focus = false
		setNeedsDisplay()
		oovi.compileRecipies()
	}
	func cite(_ citable: Citable, at: CGPoint) {}

// UIView ==========================================================================================
	override func layoutSubviews() {
		textField.top(dy: 20, size: CGSize(width: 96, height: 28))
		colorField.top(dy: textField.bottom+6, size: CGSize(width: 50, height: 32))
	}
	override func draw(_ rect: CGRect) {
		let path = CGPath(ellipseIn: rect.insetBy(dx: 3, dy: 3), transform: nil)
		Skin.bubble(path: path, uiColor: oovi.uiColor, width: 4.0/3.0*Oo.s)
		
		if !focus {
			let pen = Pen(font: UIFont(name: "Bangla MN", size: 20) ?? UIFont.systemFont(ofSize: 20))
			let size = (oovi.name as NSString).size(withAttributes: pen.attributes)
			Skin.text(oovi.name, rect: CGRect(x: 0, y: (rect.size.height-size.height)/2, width: rect.size.width, height: size.height), uiColor: oovi.uiColor, font: pen.font, align: .center)
		}
	}

// UITextFieldDelegate =============================================================================
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		oovi.name = textField.text ?? ""
		textField.resignFirstResponder()
		releaseFocus()
		return true
	}
//	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//		oovi.name = textField.text ?? ""
//		return true
//	}
}
