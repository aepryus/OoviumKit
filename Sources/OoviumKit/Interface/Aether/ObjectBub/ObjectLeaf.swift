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

class ObjectLeaf: Leaf, Editable, ChainViewDelegate, DoubleTappable, Colorable, UITextFieldDelegate {
	private let object: Object
	
    lazy var chainView: ChainView = ChainView(editable: self, responder: aetherView.responder)
	private var textField: OOTextField? = nil

	private var mooring: Mooring = Mooring()

	init(bubble: Bubble) {
		object = (bubble as! ObjectBub).object
		
		super.init(bubble: bubble)

		chainView.chain = object.chain
		chainView.delegate = self
		addSubview(chainView)

        initMoorings()
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
		if object.label.count > 0 && object.chain.tokens.count > 0 || textField != nil { height = max(height, 60) }

        size = CGSize(width: width, height: height)
		bubble.layoutLeaves()
        chainView.left(dx: 12, dy: object.label.count > 0 || textField != nil ? 13 : 0, height: 21)

        setNeedsDisplay()
        
        // textField
        textField?.frame = CGRect(x: 7, y: 6, width: width-14, height: 28)
        textField?.setNeedsDisplay()
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
	func onFocusTap(aetherView: AetherView) {
        if chainView.chain.editing { releaseFocus(.focusTap) }
        else { makeFocus() }
	}
	@objc func onDoubleTap() {
		guard !bubble.aetherView.readOnly else { return }
        if chainView.chain.editing { releaseFocus(.administrative) }
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
        object.chain.tokens.forEach {
            guard let mooring = bubble.aetherView.moorings[$0] else { return }
            bubble.aetherView.link(from: self.mooring, to: mooring, wake: false)
        }
    }
    override func positionMoorings() {
        mooring.point = self.bubble.aetherView.scrollView.convert(self.bubble.center, from: self.bubble.superview)
        mooring.positionDoodles()
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
	}
	func cite(_ citable: Citable, at: CGPoint) {
		guard let token = citable.token(at: at) else { return }
		guard chainView.attemptToPost(token: token) else { return }
	}
    
// ChainViewDelegate ===============================================================================
    var color: UIColor { focused || object.token.status == .ok ? uiColor : UIColor.red }
    
    func becomeFirstResponder() { chainView.becomeFirstResponder() }
    func resignFirstResponder() { chainView.resignFirstResponder() }

    func onTokenAdded(_ token: Token) {
        guard let mooring = bubble.aetherView.mooring(token: token) else { return }
        bubble.aetherView.link(from: self.mooring, to: mooring)
    }
    func onTokenRemoved(_ token: Token) {
        guard let mooring = bubble.aetherView.mooring(token: token) else { return }
        bubble.aetherView.unlink(from: self.mooring, to: mooring)
    }

    func onWidthChanged(oldWidth: CGFloat?, newWidth: CGFloat) { render() }
    func onChanged() { objectBub.layoutLeavesIfNeeded() }
    
// Colorable =======================================================================================
    var uiColor: UIColor { bubble.selected ? .yellow : (focused ? .black.tint(0.8) : chainView.chain.tower.obje.uiColor) }

// UITextFieldDelegate =============================================================================
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        closeLabel()
        return true
    }
}
