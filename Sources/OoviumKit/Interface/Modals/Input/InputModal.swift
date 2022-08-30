//
//  InputModal.swift
//  Oovium
//
//  Created by Joe Charlier on 8/23/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

class InputModal: Modal, UITextFieldDelegate {
    let messageLabel: UILabel = UILabel()
    let textField: OOTextField = OOTextField(frame: .zero, backColor: Skin.color(.labelBack), foreColor: Skin.color(.labelFore), textColor: Skin.color(.labelText))
    let ok: Trapezoid = Trapezoid(title: "OK".localized, leftSlant: .down, rightSlant: .up)
    let cancel: Trapezoid = Trapezoid(title: "Cancel".localized, leftSlant: .up, rightSlant: .down)
    
    var complete: (String?)->() = { (input: String?) in }
    var input: String? = nil

    init(message: String) {
        super.init(anchor: .center, size: CGSize(width: 240*Oo.gS, height: 110*Oo.gS), offset: .zero)

        messageLabel.text = message
        messageLabel.font = UIFont.ooExplore(size: 15*gS)
        messageLabel.numberOfLines = 2
        messageLabel.textColor = .green.tint(0.7)
        addSubview(messageLabel)
        
        textField.font = UIFont.ooExplore(size: 18*gS)
        textField.textColor = .green.tint(0.7)
        textField.delegate = self
        addSubview(textField)

        addSubview(cancel)
        addSubview(ok)

        cancel.addAction { [weak self] in self?.dismiss() }
        ok.addAction { [weak self] in self?.onOK() }
    }
    required init?(coder aDecoder: NSCoder) {fatalError()}
    
    func invoke(_ complete: @escaping (String?)->()) {
        super.invoke()
        self.complete = complete
    }
    
// Events ==========================================================================================
    override func onInvoke() {
        super.onInvoke()
        textField.becomeFirstResponder()
    }
    override func onDismiss() {
        super.onDismiss()
        complete(input)
    }
    private func onOK() {
        input = textField.text
        dismiss()
    }

// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        Skin.bubble(path: CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 10, cornerHeight: 10, transform: nil), uiColor: .green, width: 4.0/3.0*Oo.s)
    }
    override func layoutSubviews() {
//        textField.top(dy: 64*gS, width: 256*gS, height: 32*gS)
//        cancel.topLeft(dx: 16*gS, dy: 144*gS, width: 128*gS, height: 32*gS)
//        ok.topRight(dx: -16*gS, dy: 144*gS, width: 128*gS, height: 32*gS)
        messageLabel.topLeft(dx: 16*gS, dy: 16*gS, width: 200*gS, height: 48*gS)
        textField.center(width: 256*gS, height: 32*gS)
        cancel.bottomLeft(dx: 16*gS, dy: -16*gS, width: 128*gS, height: 32*gS)
        ok.topRight(dx: -16*gS, dy: 16*gS, width: 128*gS, height: 32*gS)
    }
    
// UITextFieldDelegate =============================================================================
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onOK()
        return true
    }
}
