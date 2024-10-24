//
//  AnalyticLeaf.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/12/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class AnalyticLeaf: Leaf, Editable, AnainViewDelegate, DoubleTappable, UITextFieldDelegate {
    private let analytic: Analytic
    
    lazy var anainView: AnainView = AnainView(editable: self, responder: aetherView.anResponder)
    private var textField: OOTextField? = nil

    init(bubble: Bubble) {
        analytic = (bubble as! AnalyticBub).analytic
        
        super.init(bubble: bubble)
        
        mooring = bubble.createMooring(key: analytic.tokenKey)

        anainView.anain = analytic.anain
        anainView.delegate = self
        addSubview(anainView)
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    deinit { NotificationCenter.default.removeObserver(self) }
    
    private var analyticBub: AnalyticBub { bubble as! AnalyticBub }
    private var beingEdited: Bool { self === bubble.aetherView.focus }
    
    func openLabel() {
        bubble.aetherView.locked = true
        textField = OOTextField(frame: CGRect(x: 7, y: 6, width: 60, height: 28), backColor: Skin.color(.labelBack), foreColor: Skin.color(.labelFore), textColor: Skin.color(.labelText))
        textField?.text = analytic.label
        textField!.delegate = self
        addSubview(textField!)
        textField!.becomeFirstResponder()
        render()
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func closeLabel() {
        analytic.label = textField?.text ?? ""
        NotificationCenter.default.removeObserver(self)
        textField?.resignFirstResponder()
        textField?.removeFromSuperview()
        textField = nil
        render()
        bubble.aetherView.locked = false
        Tower.evaluate(towers: Tower.allDownstream(towers: analytic.towers))
    }
    
    func render() {
        var width: CGFloat = 9
        var height: CGFloat = 35
        
        // Bounds Width
        width = max(width, anainView.width - 4)
        if textField != nil { width = max(width, 74) }
        else if analytic.label.count > 0 { width = max(width, analytic.label.size(pen: Pen(font: .ooAether(size: 16))).width) }
        width += 26
        
        // Bounds Height
        if analytic.label.count > 0 && analytic.anain.tokens.count > 0 || textField != nil { height = max(height, 60) }

        size = CGSize(width: width, height: height)
//        bubble.layoutLeaves()
        anainView.left(dx: 12, dy: analytic.label.count > 0 || textField != nil ? 13 : 0, height: 21)

        setNeedsDisplay()
        
        // textField
        textField?.frame = CGRect(x: 7, y: 6, width: width-14, height: 28)
        textField?.setNeedsDisplay()
    }
    
// Events ==========================================================================================
    func onFocusTap(aetherView: AetherView) {
        if anainView.anain.editing { releaseFocus(.focusTap) }
        else { makeFocus() }
    }
    @objc func onDoubleTap() {
        guard !bubble.aetherView.readOnly else { return }
        if anainView.anain.editing { releaseFocus(.administrative) }
        openLabel()
    }
    @objc func onKeyboardWillHide() { releaseFocus(.okEqualReturn) }

// UIView ==========================================================================================
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        anainView.setNeedsDisplay()
    }
    override func draw(_ rect: CGRect) {
        let path = CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 10, cornerHeight: 10, transform: nil)
        hitPath = path
        Skin.bubble(path: path, uiColor: color, width: 4.0/3.0*Oo.s)

        if analytic.label.count > 0 && textField == nil {
            Skin.text(analytic.label, rect: CGRect(x: 0, y: 10.5, width: rect.size.width-12, height: 21), uiColor: color, font: .ooAether(size: 16), align: .right)
        }
    }
    
// Leaf ============================================================================================
    override func wireMoorings() {
        analytic.anain.tokens.forEach {
            guard let mooring = bubble.aetherView.moorings[$0.key] else { return }
            mooring.attach(self.mooring, wake: false)
        }
    }
        
// Editable ========================================================================================
    var editor: Orbit {
        orb.anainEditor.anainView = anainView
        return orb.anainEditor
    }

    func onMakeFocus() {
        anainView.edit()
        render()
        analyticBub.layoutLeavesIfNeeded()
        mooring.wakeDoodles()
        aetherView.anResponder.anainView = anainView
        if ChainResponder.hasExternalKeyboard { anainView.becomeFirstResponder() }
    }
    func onReleaseFocus() {
        if ChainResponder.hasExternalKeyboard { anainView.resignFirstResponder() }
        anainView.ok()
        render()
        analyticBub.onOK()
        mooring.sleepDoodles()
    }
    func cite(_ citable: Citable, at: CGPoint) {
        guard let tokenKey = citable.tokenKey(at: at) else { return }
        guard anainView.attemptToPost(key: tokenKey) else { return }
    }
    
// ChainViewDelegate ===============================================================================
    var color: UIColor { bubble.uiColor }
    
    func becomeFirstResponder() { anainView.becomeFirstResponder() }
    func resignFirstResponder() { anainView.resignFirstResponder() }

    func onTokenAdded(_ token: Token) {
        guard let upstream: Mooring = bubble.aetherView.moorings[token.key] else { return }
        upstream.attach(mooring)
    }
    func onTokenRemoved(_ token: Token) {
        guard let upstream: Mooring = bubble.aetherView.moorings[token.key] else { return }
        upstream.detach(mooring)
    }

    func onWidthChanged(oldWidth: CGFloat?, newWidth: CGFloat) { render() }
    func onChanged() { analyticBub.layoutLeavesIfNeeded() }
    
// UITextFieldDelegate =============================================================================
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        closeLabel()
        return true
    }
}
