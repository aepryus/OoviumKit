//
//  InputModal.swift
//  Oovium
//
//  Created by Joe Charlier on 8/23/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class InputModal: Modal, UITextFieldDelegate {
    let messageLabel: UILabel = UILabel()
    let textField: OOTextField = OOTextField(frame: .zero, backColor: Skin.color(.labelBack), foreColor: Skin.color(.labelFore), textColor: Skin.color(.labelText))
    let ok: Trapezoid = Trapezoid(title: "OK".localized, leftSlant: .up, rightSlant: .vertical)
    let cancel: Trapezoid = Trapezoid(title: "Cancel".localized, leftSlant: .vertical, rightSlant: .down)
    
    var complete: (String?)->() = { (input: String?) in }
    var input: String? = nil

    init(message: String) {
        super.init(anchor: .center, size: CGSize(width: 240*Oo.gS, height: 110*Oo.gS), offset: .zero)

        messageLabel.text = message
        messageLabel.textAlignment = .center
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
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
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
        let p: CGFloat = 1*gS
        let bh: CGFloat = (32+6)*gS
        let bw: CGFloat = (128+7)*gS
        
        let x1: CGFloat = p
        let x3: CGFloat = x1 + bw
        let x2: CGFloat = x3 - bh*2/3
        let x6: CGFloat = width - p
        let x4: CGFloat = x6 - bw
        let x5: CGFloat = x4 + bh*2/3
        
        let y1: CGFloat = p
        let y3: CGFloat = height - p
        let y2: CGFloat = y3 - bh
        
        let p1 = CGPoint(x: x1, y: y1)
        let p2 = CGPoint(x: x6, y: y1)
        let p3 = CGPoint(x: x6, y: y2)
        let p4 = CGPoint(x: x5, y: y2)
        let p5 = CGPoint(x: x4, y: y3)
        let p6 = CGPoint(x: x3, y: y3)
        let p7 = CGPoint(x: x2, y: y2)
        let p8 = CGPoint(x: x1, y: y2)
        
        let wr: CGFloat = 10*s
        let ar: CGFloat = 5*s

        let path: CGMutablePath = CGMutablePath()
        path.move(to: (p1+p8)/2)
        path.addArc(tangent1End: p1, tangent2End: (p1+p2)/2, radius: ar)
        path.addArc(tangent1End: p2, tangent2End: (p2+p3)/2, radius: ar)
        path.addArc(tangent1End: p3, tangent2End: (p3+p4)/2, radius: ar)
        path.addArc(tangent1End: p4, tangent2End: (p4+p5)/2, radius: wr)
        path.addArc(tangent1End: p5, tangent2End: (p5+p6)/2, radius: wr)
        path.addArc(tangent1End: p6, tangent2End: (p6+p7)/2, radius: wr)
        path.addArc(tangent1End: p7, tangent2End: (p7+p8)/2, radius: wr)
        path.addArc(tangent1End: p8, tangent2End: (p8+p1)/2, radius: ar)
        path.closeSubpath()

        let lw: CGFloat = 2*Screen.s

        let c: CGContext = UIGraphicsGetCurrentContext()!
        c.addPath(path)
        c.setStrokeColor(UIColor.green.tint(0.8).shade(0.5).cgColor)
        c.setFillColor(UIColor.green.shade(0.9).cgColor)
        c.setLineWidth(lw)
        c.drawPath(using: .fillStroke)
    }
    override func layoutSubviews() {
        messageLabel.top(dy: 9*gS, width: width-20*gS, height: 48*gS)
        textField.center(dy: 2*gS, width: 256*gS, height: 32*gS)
        cancel.bottomLeft(dx: 1*gS, dy: -1*gS, width: 128*gS, height: 32*gS)
        ok.bottomRight(dx: -1*gS, dy: -1*gS, width: 128*gS, height: 32*gS)
    }
    
// UITextFieldDelegate =============================================================================
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onOK()
        return true
    }
}
