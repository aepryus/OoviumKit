//
//  ObjectLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 11/9/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class ObjectLeaf: Leaf, Editable, ChainViewDelegate, TowerListener, DoubleTappable, UITextFieldDelegate, Colorable {
	let object: Object
	
	let chainView: ChainView = ChainView()
	var textField: OOTextField? = nil

	var mooring: Mooring = Mooring()

	init(bubble: Bubble) {
		object = (bubble as! ObjectBub).object
		
		super.init(bubble: bubble)

		self.backgroundColor = UIColor.clear

		chainView.chain = object.chain
		initMoorings()
		chainView.delegate = self
		object.tower.listener = self
		addSubview(chainView)
		chainView.frame = CGRect(x: 12.75, y: 7, width: chainView.calcWidth(), height: 21)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	var uiColor: UIColor {
		if bubble.selected {
			return UIColor.yellow
		} else if focused {
			return UIColor.black.tint(0.8)
		} else {
			return Oovium.color(for: chainView.chain.tower.obje.def)
		}
	}
	
	var objectBub: ObjectBub {
		return bubble as! ObjectBub
	}

	func openLabel() {
		bubble.aetherView.locked = true
		textField = OOTextField(frame: CGRect(x: 7, y: 6, width: 60, height: 28), backColor: Skin.color(.labelBack), foreColor: Skin.color(.labelFore), textColor: Skin.color(.labelText))
//		textField?.contentVerticalAlignment = .top
		textField?.text = object.label
		textField!.delegate = self
		addSubview(textField!)
		textField!.becomeFirstResponder()
		render()
		NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	func closeLabel() {
		object.label = textField?.text ?? ""
		NotificationCenter.default.removeObserver(self)
		textField?.resignFirstResponder()
		textField?.removeFromSuperview()
		textField = nil
		render()
		bubble.aetherView.locked = false
	}
	
	var beingEdited: Bool {
		return self === bubble.aetherView.focus
	}
	func render() {
		var width: CGFloat = 9
		var height: CGFloat = 35
		
		// Bounds Width
		width = max(width, chainView.calcWidth() - 4)
		if textField != nil {
			width = max(width, 74)
		} else if object.label.count > 0 {
			let pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!)
			width = max(width, (object.label as NSString).size(withAttributes: pen.attributes).width)
		}
		width += 26
		
		// Bounds Height
		if object.label.count > 0 && object.chain.tokens.count > 0 || textField != nil {
			height = max(height, 60)
		}
		
		size = CGSize(width: width, height: height)
		
		// Chain Position
		let y: CGFloat = 7 + (object.label.count > 0 || textField != nil ? 26 : 0)
		if beingEdited {
			chainView.at = CGPoint(x: 12, y: y)
			chainView.hitch = .topLeft
		} else {
			chainView.at = CGPoint(x: width/2+1, y: y+10.5)
			chainView.hitch = .center
		}
		chainView.render()
		
		setNeedsDisplay()
		
		// textField
		textField?.frame = CGRect(x: 7, y: 6, width: width-14, height: 28)
		textField?.setNeedsDisplay()

		bubble.layoutLeaves()
	}
	
// Moorings ========================================================================================
	func initMoorings() {
		mooring.colorable = self
		bubble.aetherView.moorings[object.token] = self.mooring
	}
	func deinitMoorings() {
		mooring.clearLinks()
		bubble.aetherView.moorings[object.token] = nil
	}

// Events ==========================================================================================
	var editor: Orbit {
		orb.chainEditor.chainView = chainView
		return orb.chainEditor
	}
	func onTap(aetherView: AetherView) {
		if chainView.chain.editing {
			releaseFocus()
		} else {
			makeFocus()
		}
	}
	@objc func onDoubleTap() {
		guard !bubble.aetherView.readOnly else { return }
		if chainView.chain.editing {
			releaseFocus()
		}
		openLabel()
	}
	@objc func onKeyboardWillHide() {
		releaseFocus()
	}
	func onEdit() {
	}
	
	func onOK() {
		releaseFocus()
	}

// ChainViewDelegate ===============================================================================
	var color: UIColor {
		return focused || object.tower.variableToken.status == .ok ? uiColor : UIColor.red
	}
	
	func onChange() {
		let newWidth = max(chainView.width+24, 36)
		self.size = CGSize(width: newWidth, height: 35)
		render()
		objectBub.onChange()
	}
	func onBackspace(token: Token) {
		onChange()
		guard let mooring = bubble.aetherView.mooring(token: token) else {return}
		self.mooring.unlink(mooring: mooring)
	}
		
// TowerListener ===================================================================================
	func onCalculate() {
		render()
	}

// Leaf ============================================================================================
	override func wire() {
		for token in object.chain.tokens {
			if let mooring = bubble.aetherView.moorings[token] {
				bubble.aetherView.link(from: self.mooring, to: mooring, wake: false)
			}
		}
	}
	override func positionMoorings() {
		mooring.point = self.bubble.aetherView.scrollView.convert(self.bubble.center, from: self.bubble.superview)
		mooring.positionDoodles()
	}
	
// UIView ==========================================================================================
	override func setNeedsDisplay() {
		super.setNeedsDisplay()
		chainView.setNeedsDisplay()
	}
	override func draw(_ rect: CGRect) {
		let path = CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 10, cornerHeight: 10, transform: nil)
		hitPath = path
		Skin.bubble(path: path, uiColor: color, width: 4.0/3.0*Oo.s)

		if object.label.count > 0 && textField == nil {
			Skin.text(object.label, rect: CGRect(x: 0, y: 10.5, width: rect.size.width-12, height: 21), uiColor: color, font: UIFont(name: "HelveticaNeue", size: 16)!, align: .right)
		}
	}
	
// UITextFieldDelegate =============================================================================
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		closeLabel()
		return true
	}
	
// Editable ========================================================================================
	func onMakeFocus() {
		chainView.edit()
		let newWidth = max(chainView.width+24, 36)
		self.size = CGSize(width: newWidth, height: 35)
		render()
		objectBub.onEdit()
		mooring.wakeDoodles()
	}
	func onReleaseFocus() {
		chainView.ok()
		
		let newWidth = max(chainView.calcWidth()+24, 36)
		self.size = CGSize(width: newWidth, height: 35)
		render()
		objectBub.onOK()
		mooring.sleepDoodles()
	}
	func cite(_ citable: Citable, at: CGPoint) {
		guard let token = citable.token(at: at) else {return}
		guard chainView.attemptToPost(token: token) else {return}
		guard let mooring = bubble.aetherView.mooring(token: token) else {return}
		bubble.aetherView.link(from: self.mooring, to: mooring)
	}
}
