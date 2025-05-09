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

class ObjectLeaf: Leaf, Editable, ChainViewDelegate, DoubleTappable, UITextFieldDelegate {
	private let object: Object
	
    lazy var chainView: ChainView = ChainView(editable: self, responder: aetherView.responder)
	private var textField: OOTextField? = nil

	init(bubble: Bubble) {
		object = (bubble as! ObjectBub).object
		
		super.init(bubble: bubble)
        
        mooring = bubble.createMooring(key: object.chain.key!)

		chainView.chain = object.chain
		chainView.delegate = self
		addSubview(chainView)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	deinit { NotificationCenter.default.removeObserver(self) }
	
    private var objectBub: ObjectBub { bubble as! ObjectBub }
    private var beingEdited: Bool { self === bubble.aetherView.focus }
    
	func openLabel() {
		bubble.aetherView.locked = true
		textField = OOTextField(frame: CGRect(x: 7, y: 6, width: 60, height: 28), backColor: Skin.color(.labelBack), foreColor: Skin.color(.labelFore), textColor: Skin.color(.labelText))
		textField?.text = object.label
		textField!.delegate = self
		addSubview(textField!)
		textField!.becomeFirstResponder()
		render()
		NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	private func closeLabel() {
		object.label = textField?.text ?? ""
		NotificationCenter.default.removeObserver(self)
		textField?.resignFirstResponder()
		textField?.removeFromSuperview()
		textField = nil
		render()
		bubble.aetherView.locked = false
	}
	
	func render() {
		var width: CGFloat = 9
		var height: CGFloat = 35
		
		// Bounds Width
		width = max(width, chainView.width - 4)
		if textField != nil { width = max(width, 74) }
        else if object.label.count > 0 { width = max(width, object.label.size(pen: Pen(font: .ooAether(size: 16))).width) }
		width += 26
		
		// Bounds Height
		if object.label.count > 0 && !object.chain.isEmpty || textField != nil { height = max(height, 60) }

        size = CGSize(width: width, height: height)
		bubble.layoutLeaves()
        chainView.left(dx: 12, dy: object.label.count > 0 || textField != nil ? 13 : 0, height: 21)

        setNeedsDisplay()
        
        // textField
        textField?.frame = CGRect(x: 7, y: 6, width: width-14, height: 28)
        textField?.setNeedsDisplay()
	}
	
// Events ==========================================================================================
	func onFocusTap(aetherView: AetherView) {
        if chainView.editing { releaseFocus(.focusTap) }
        else { makeFocus() }
	}
	@objc func onDoubleTap() {
		guard !bubble.aetherView.readOnly else { return }
        if chainView.editing { releaseFocus(.administrative) }
		openLabel()
	}
    @objc func onKeyboardWillHide() { releaseFocus(.okEqualReturn) }

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
            Skin.text(object.label, rect: CGRect(x: 0, y: 10.5, width: rect.size.width-12, height: 21), uiColor: color, font: .ooAether(size: 16), align: .right)
		}
	}
	
// Leaf ============================================================================================
    override func wireMoorings() {
        object.chain.tokenKeys.forEach { (key: TokenKey) in
            guard let mooring = bubble.aetherView.moorings[key] else { return }
            mooring.attach(self.mooring, wake: false)
        }
    }
        
// Editable ========================================================================================
    var editor: Orbit {
        orb.chainEditor.chainView = chainView
        return orb.chainEditor
    }

    func onMakeFocus() {
        chainView.edit()
        render()
        objectBub.layoutLeavesIfNeeded()
        mooring.wakeDoodles()
        aetherView.responder.chainView = chainView
        if ChainResponder.hasExternalKeyboard { chainView.becomeFirstResponder() }
	}
	func onReleaseFocus() {
        if ChainResponder.hasExternalKeyboard { chainView.resignFirstResponder() }
		chainView.ok()
		render()
		objectBub.onOK()
		mooring.sleepDoodles()
        aetherView.responder.chainView = nil
	}
    func onCancelFocus() {
        if ChainResponder.hasExternalKeyboard { chainView.resignFirstResponder() }
        chainView.cancel()
        render()
        objectBub.onOK()
        mooring.sleepDoodles()
        aetherView.responder.chainView = nil
    }
	func cite(_ citable: Citable, at: CGPoint) {
		guard let tokenKey = citable.tokenKey(at: at) else { return }
		guard chainView.attemptToPost(key: tokenKey) else { return }
	}
    
// ChainViewDelegate ===============================================================================
    var color: UIColor { bubble.uiColor }
    
    func becomeFirstResponder() { chainView.becomeFirstResponder() }
    func resignFirstResponder() { chainView.resignFirstResponder() }

    func onTokenKeyAdded(_ key: TokenKey) {
        guard let upstream: Mooring = bubble.aetherView.moorings[key] else { return }
        upstream.attach(mooring)
    }
    func onTokenKeyRemoved(_ key: TokenKey) {
        guard let upstream: Mooring = bubble.aetherView.moorings[key] else { return }
        upstream.detach(mooring)
    }

    func onWidthChanged(oldWidth: CGFloat?, newWidth: CGFloat) { render() }
    func onChanged() { objectBub.layoutLeavesIfNeeded() }
    
// UITextFieldDelegate =============================================================================
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        closeLabel()
        return true
    }
}
