//
//  NameLeaf.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/10/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class NameLeaf: Leaf, UITextFieldDelegate {

    var aetherField: SignatureField? = nil

    init(bubble: Bubble) {
        super.init(bubble: bubble)
        size = CGSize(width: 120, height: 36)
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    var color: UIColor { bubble.uiColor }
    var systemBub: SystemBub { bubble as! SystemBub }

    func makeEditable() {
        let p: CGFloat = 3                        // padding
        let nw: CGFloat = width - 2*p             // name width

        let x1 = p

        let y1 = p

        aetherField = SignatureField(frame: CGRect(x: x1, y: y1+0.5, width: nw, height: 28))
        aetherField?.delegate = self
        aetherField?.text = systemBub.system.name
        aetherField?.textColor = Skin.color(.signatureText)
        addSubview(aetherField!)
        
        setNeedsDisplay()

        if Screen.mac { aetherField?.becomeFirstResponder() }
    }
    func makeReadable() {
        systemBub.system.name = aetherField?.text ?? ""
        aetherField?.removeFromSuperview()
        aetherField = nil
        setNeedsDisplay()
    }

// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        let path = CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 15, cornerHeight: 15, transform: nil)
        hitPath = path
        Skin.bubble(path: path, uiColor: color, width: 4.0/3.0*Oo.s)

        if !systemBub.open {
            Skin.bubble(text: systemBub.system.name, rect: CGRect(x: 3, y: 3.5, width: rect.width-6, height: 30), uiColor: bubble.uiColor)
        }
    }

// UITextFieldDelegate =============================================================================
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { true }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if Screen.mac { systemBub.releaseFocus(.okEqualReturn) }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var i = 0
        for c in string.unicodeScalars {
            if range.location == 0 && i == 0 && !NSCharacterSet.letters.contains(c) { return false }
            if !NSCharacterSet.alphanumerics.contains(c) { return false }
            i += 1
        }
        return true
    }
}
