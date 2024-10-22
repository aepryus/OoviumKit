//
//  AlertModal.swift
//  OoviumKit
//
//  Created by Joe Charlier on 10/22/24.
//  Copyright © 2024 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class AlertModal: Modal {
    var message: String = ""
    var leftTitle: String?
    var rightTitle: String = ""
    
    let messageLabel: UILabel = UILabel()
    let rightButton: Trapezoid = Trapezoid(title: "OK".localized, leftSlant: .up, rightSlant: .vertical)
    let leftButton: Trapezoid = Trapezoid(title: "Cancel".localized, leftSlant: .vertical, rightSlant: .down)
    
    var complete: (()->())?
    var input: String? = nil
    
    lazy var pen: Pen = Pen(font: .ooExplore(size: 15*gS), color: .green.tint(0.7), alignment: .center)

    init(message: String, left: String? = nil, right: String, complete: (()->())?) {
        self.message = message
        self.leftTitle = left
        self.rightTitle = right
        self.complete = complete
        
        super.init(anchor: .center, size: CGSize(width: 300, height: 165), offset: .zero)

        messageLabel.text = message
        messageLabel.pen = pen
        messageLabel.numberOfLines = 0
        addSubview(messageLabel)
        
        rightButton.title = rightTitle
        addSubview(rightButton)
        if let leftTitle {
            leftButton.title = leftTitle
            addSubview(leftButton)
        }

        leftButton.addAction { [unowned self] in self.dismiss() }
        rightButton.addAction { [unowned self] in self.onOK() }
        
        let size: CGSize = pen.size(text: message, width: 300*gS-20*gS)
        self.size = CGSize(width: size.width/gS + 40, height: size.height/gS + 80)
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
//    func invoke(_ complete: @escaping (String?)->()) {
//        super.invoke()
//        self.complete = complete
//    }
    
// Events ==========================================================================================
    private func onOK() {
        dismiss()
        complete?()
    }

// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        let p: CGFloat = 1*gS
        let bh: CGFloat = (32+6)*gS
        let bw: CGFloat = (128+8)*gS
        
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
        
        let p9 = CGPoint(x: x1, y: y3)
        
        let wr: CGFloat = 10*s
        let ar: CGFloat = 5*s

        let path: CGMutablePath = CGMutablePath()
        path.move(to: (p1+p8)/2)
        path.addArc(tangent1End: p1, tangent2End: (p1+p2)/2, radius: ar)
        path.addArc(tangent1End: p2, tangent2End: (p2+p3)/2, radius: ar)
        path.addArc(tangent1End: p3, tangent2End: (p3+p4)/2, radius: ar)
        path.addArc(tangent1End: p4, tangent2End: (p4+p5)/2, radius: wr)
        path.addArc(tangent1End: p5, tangent2End: (p5+p6)/2, radius: wr)
        
        if leftTitle != nil {
            path.addArc(tangent1End: p6, tangent2End: (p6+p7)/2, radius: wr)
            path.addArc(tangent1End: p7, tangent2End: (p7+p8)/2, radius: wr)
            path.addArc(tangent1End: p8, tangent2End: (p8+p1)/2, radius: ar)
        } else {
            path.addArc(tangent1End: p9, tangent2End: (p1+p9)/2, radius: wr)
        }
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
        let size: CGSize = pen.size(text: message, width: 300*gS-20*gS)
        messageLabel.top(dy: 20*gS, size: size)
        leftButton.bottomLeft(dx: 1*gS, dy: -1*gS, width: 128*gS, height: 32*gS)
        rightButton.bottomRight(dx: -1*gS, dy: -1*gS, width: 128*gS, height: 32*gS)
    }
    
// UITextFieldDelegate =============================================================================
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onOK()
        return true
    }
}
