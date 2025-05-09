//
//  AetherHover.swift
//  Oovium
//
//  Created by Joe Charlier on 3/27/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class AetherHover: UIView {
    static let backColor: CGColor = UIColor.green.shade(0.9).cgColor
    static let lineColor: CGColor = UIColor.green.tint(0.8).cgColor
    static let pen: Pen = Pen(font: .ooExplore(size: 16*Oo.gS), color: .green.tint(0.7), alignment: .center)
    
    static let lw: CGFloat = Oo.gS
    static let wr: CGFloat = 9*Oo.gS
    static let nr: CGFloat = 3*Oo.gS
    static let ar: CGFloat = (wr+nr)/2
    static let h: CGFloat = 32*Oo.s                                     // height of control
    static let l: CGFloat = h-3/2*lw                                    // height of path
    static let p: CGFloat = l/5                                         // padding between elements
    static let r: CGFloat = l/2                                         // radius of screw
    static let R: CGFloat = r+p                                         // radius of screw holder
    static let Q: CGFloat = 2*asin(l/(2*R))/2                           // (half) angle of screw holder
    static let dx: CGFloat = sqrt(pow(R,2)-pow(l/2,2))                  // center x of screw holder from right side
    
    class AetherHoverController {
        let aetherHover: AetherHover
        
        init(aetherHover: AetherHover) {
            self.aetherHover = aetherHover
        }

        var facade: Facade? { aetherHover.aetherView.facade }
        
        @objc func onAetherViewDoubleTap() {
            aetherHover.aetherNameView.takeEditForm()
        }
        func onAetherViewReturn() {
            aetherHover.aetherNameView.takeDisplayForm()
            guard let facade: AetherFacade = facade as? AetherFacade, let newName: String = aetherHover.aetherNameView.textField.text else { return }
            facade.renameAether(name: newName) { (success: Bool) in
                guard success else { return }
                self.aetherHover.aetherView.aether.name = newName
                let oldKey: String = facade.ooviumKey
                self.aetherHover.aetherView.facade?._name = newName
                let newKey: String = facade.ooviumKey
                Facade.reKey(oldKey: oldKey, newKey: newKey)
                self.aetherHover.aetherNameView.setNeedsDisplay()
                facade.store(aether: self.aetherHover.aetherView.aether) { (success: Bool) in }
            }
        }
    }

    class HookView: UIControl {
        private var path: CGMutablePath = CGMutablePath()
        
        init() {
            super.init(frame: .zero)
            backgroundColor = .clear
        }
        required init?(coder: NSCoder) { fatalError() }
        
        // UIView ==================================================================================
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let view: UIView? = super.hitTest(point, with: event)
            if view !== self { return view }
            if path.contains(point) { return self }
            return nil
        }
        override func draw(_ rect: CGRect) {
            let sw: CGFloat = h-lw

            let x1: CGFloat = lw
            let x3: CGFloat = width - lw
            let x2: CGFloat = x3 - sw

            let y1: CGFloat = lw
            let y2: CGFloat = h - lw

            let p1: CGPoint = CGPoint(x: x1, y: y1)
            let p2: CGPoint = CGPoint(x: x3, y: y1)
            let p3: CGPoint = CGPoint(x: x2, y: y2)
            let p4: CGPoint = CGPoint(x: x1, y: y2)

            path = CGMutablePath()
            path.move(to: (p1+p4)/2)
            path.addArc(tangent1End: p1, tangent2End: (p1+p2)/2, radius: ar)
            path.addArc(tangent1End: p2, tangent2End: (p2+p3)/2, radius: nr)
            path.addArc(tangent1End: p3, tangent2End: (p3+p4)/2, radius: wr)
            path.addArc(tangent1End: p4, tangent2End: (p4+p1)/2, radius: ar)
            path.closeSubpath()
            
            Skin.skin.explorer(path: path)
            
            let dy: CGFloat = 5*Oo.gS
            let dx: CGFloat = 5*Oo.gS
            
            let x4: CGFloat = 7*Oo.gS
            let x5: CGFloat = 23*Oo.gS
            
            let y3: CGFloat = 10.5*Oo.gS
            let y4: CGFloat = y3 + dy
            let y5: CGFloat = y4 + dy
            
            let path: CGMutablePath = CGMutablePath()
            path.move(to: CGPoint(x: x4, y: y3))
            path.addLine(to: CGPoint(x: x5+2*dx, y: y3))
            path.move(to: CGPoint(x: x4, y: y4))
            path.addLine(to: CGPoint(x: x5+dx, y: y4))
            path.move(to: CGPoint(x: x4, y: y5))
            path.addLine(to: CGPoint(x: x5, y: y5))
            
            Skin.skin.explorer(path: path)
        }
    }
    class AetherNameView: UIView, UITextFieldDelegate {
        let controller: AetherHoverController
        let textField: OOTextField = OOTextField(frame: .zero, backColor: Skin.color(.labelBack), foreColor: Skin.color(.labelFore), textColor: Skin.color(.labelText))
        
        var editing: Bool = false
        
        private var path: CGMutablePath = CGMutablePath()
        
        init(controller: AetherHoverController) {
            self.controller = controller
            super.init(frame: .zero)
            backgroundColor = .clear
            
            textField.font = UIFont.ooExplore(size: 16*gS)
            textField.textColor = .green.tint(0.7)
            textField.delegate = self

            let gesture = UITapGestureRecognizer(target: controller, action: #selector(AetherHoverController.onAetherViewDoubleTap))
            gesture.numberOfTapsRequired = 2
            addGestureRecognizer(gesture)
        }
        required init?(coder: NSCoder) { fatalError() }
        
        func takeEditForm() {
            guard !controller.aetherHover.aetherView.aether.readOnly else { return }
            textField.text = controller.aetherHover.aetherView.aether.name
            editing = true
            addSubview(textField)
            textField.becomeFirstResponder()
            setNeedsDisplay()
        }
        func takeDisplayForm() {
            editing = false
            textField.removeFromSuperview()
            setNeedsDisplay()
        }
        
        // UIView ==================================================================================
        override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
            let view: UIView? = super.hitTest(point, with: event)
            if view !== self { return view }
            if path.contains(point) { return self }
            return nil
        }
        override func draw(_ rect: CGRect) {
            let sw: CGFloat = h-lw

            let x1: CGFloat = lw
            let x2: CGFloat = x1 + sw
            let x4: CGFloat = width - lw
            let x3: CGFloat = x4 - sw

            let y1: CGFloat = lw
            let y2: CGFloat = h - lw
            
            let p1: CGPoint = CGPoint(x: x2, y: y1)
            let p2: CGPoint = CGPoint(x: x4, y: y1)
            let p3: CGPoint = CGPoint(x: x3, y: y2)
            let p4: CGPoint = CGPoint(x: x1, y: y2)
            
            path = CGMutablePath()
            path.move(to: (p1+p4)/2)
            path.addArc(tangent1End: p1, tangent2End: (p1+p2)/2, radius: wr)
            path.addArc(tangent1End: p2, tangent2End: (p2+p3)/2, radius: nr)
            path.addArc(tangent1End: p3, tangent2End: (p3+p4)/2, radius: wr)
            path.addArc(tangent1End: p4, tangent2End: (p4+p1)/2, radius: nr)
            path.closeSubpath()

            Skin.skin.explorer(path: path)
            
            let name: String = controller.facade?.name ?? ""
            if !editing { Skin.skin.explorer(text: name, rect: CGRect(x: sw, y: 6*gS, width: width-2*sw, height: h)) }
        }
        override func layoutSubviews() {
            textField.center(width: 120*gS, height: h-6*gS)
        }
        
        // UITextFieldDelegate =====================================================================
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            controller.onAetherViewReturn()
            return true
        }
    }
    
    lazy var controller: AetherHoverController = { AetherHoverController(aetherHover: self) }()
    
    let aetherView: AetherView
    let hookView: HookView = HookView()
    lazy var aetherNameView: AetherNameView = { AetherNameView(controller: controller) }()
    
    init(aetherView: AetherView) {
        self.aetherView = aetherView
        
        super.init(frame: .zero)
        
        addSubview(hookView)
        addSubview(aetherNameView)
    }
    required init?(coder: NSCoder) { fatalError() }
    
// UIView ==========================================================================================
    override func layoutSubviews() {
        let hw: CGFloat = 54*gS
        let sw: CGFloat = hw
        hookView.left(width: hw, height: AetherHover.h)
        aetherNameView.left(dx: hookView.right - AetherHover.h + AetherHover.p, width: width - hw - sw - 2*AetherHover.p + 2*AetherHover.h, height: AetherHover.h)
    }
}
