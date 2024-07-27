//
//  SystemBub.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/10/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class SystemBub: Bubble, Editable {
    let system: System
    
    lazy var nameLeaf: NameLeaf = NameLeaf(bubble: self)
    lazy var constantsLeaves: [ValueLeaf] = [ValueLeaf(bubble: self)]
    lazy var variablesLeaves: [ValueLeaf] = [ValueLeaf(bubble: self)]
    
    var open: Bool = false
    
    init(_ system: System, aetherView: AetherView) {
        self.system = system
        super.init(aetherView: aetherView, aexel: system, origin: CGPoint(x: system.x, y: system.y), size: .zero)
        
        nameLeaf.anchor = CGPoint(x: 0, y: 0)
        add(leaf: nameLeaf)
        
        if let constantsLeaf = constantsLeaves.first {
            constantsLeaf.anchor = CGPoint(x: 15, y: -54)
            add(leaf: constantsLeaf)
            constantsLeaf.value = system.constants.first
        }
        
        if let variablesLeaf = variablesLeaves.first {
            variablesLeaf.anchor = CGPoint(x: 15, y: 54)
            add(leaf: variablesLeaf)
            variablesLeaf.value = system.variables.first
        }

        render()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override var hitchPoint: CGPoint { nameLeaf.center }
    
    func addConstant() {
        let value: SystemValue = SystemValue(parent: system)
        system.constants.append(value)
        let leaf: ValueLeaf = ValueLeaf(bubble: self)
        leaf.value = value
        leaf.anchor = CGPoint(x: 15, y: -54 - 39*CGFloat(constantsLeaves.count))

        constantsLeaves.append(leaf)
        add(leaf: leaf)
        render()
    }
    func deleteConstant() {
        guard let lastLeaf = constantsLeaves.last else { return }
        remove(leaf: lastLeaf)
        constantsLeaves.removeLast()
        system.constants.removeLast()
        render()
    }
    func addVariable() {
        let value: SystemValue = SystemValue(parent: system)
        system.variables.append(value)
        let leaf: ValueLeaf = ValueLeaf(bubble: self)
        leaf.value = value
        leaf.anchor = CGPoint(x: 15, y: 54 + 39*CGFloat(variablesLeaves.count))

        variablesLeaves.append(leaf)
        add(leaf: leaf)
        render()
    }
    func deleteVariable() {
        guard let lastLeaf = variablesLeaves.last else { return }
        remove(leaf: lastLeaf)
        variablesLeaves.removeLast()
        system.variables.removeLast()
        render()
    }
    
    func render() {
        layoutLeaves()

        plasma = CGMutablePath()
        guard let plasma = plasma else { return }
        
        let nq: CGFloat = 27
        let vq: CGFloat = 20
        let cq: CGFloat = 27
        
        let a: CGPoint = CGPoint(x: nameLeaf.center.x-nq, y: nameLeaf.center.y)
        let b: CGPoint = CGPoint(x: nameLeaf.center.x+nq, y: nameLeaf.center.y)
        if let constantLeaf = constantsLeaves.first {
            let c: CGPoint = CGPoint(x: constantLeaf.center.x-vq, y: constantLeaf.center.y)
            let d: CGPoint = CGPoint(x: constantLeaf.center.x+vq, y: constantLeaf.center.y)
            plasma.move(to: a)
            plasma.addQuadCurve(to: c, control: (a+c)/2+CGPoint(x: cq, y: 0))
            plasma.addLine(to: d)
            plasma.addQuadCurve(to: b, control: (b+d)/2+CGPoint(x: -cq, y: 0))
            plasma.closeSubpath()
        }
        if let variableLeaf = variablesLeaves.first {
            let e: CGPoint = CGPoint(x: variableLeaf.center.x-vq, y: variableLeaf.center.y)
            let f: CGPoint = CGPoint(x: variableLeaf.center.x+vq, y: variableLeaf.center.y)
            plasma.move(to: a)
            plasma.addQuadCurve(to: e, control: (a+e)/2+CGPoint(x: cq, y: 0))
            plasma.addLine(to: f)
            plasma.addQuadCurve(to: b, control: (b+f)/2+CGPoint(x: -cq, y: 0))
            plasma.closeSubpath()
        }
    }
    
// FocusTappable ===================================================================================
    func onFocusTap(aetherView: AetherView) {
        guard !open else { return }
        makeFocus()
    }

// Editable ========================================================================================
    var editor: Orbit { orb.systemEditor.edit(editable: self) }
    var overrides: [FocusTappable] = []
    func cedeFocusTo(other: FocusTappable) -> Bool { overrides.contains(where: { $0 === other}) }
    func onMakeFocus() {
        open = true
        nameLeaf.makeEditable()
        variablesLeaves.forEach { $0.makeEditable() }
        constantsLeaves.forEach { $0.makeEditable() }
        setNeedsDisplay()
    }
    func onReleaseFocus() {
        open = false
        nameLeaf.makeReadable()
        variablesLeaves.forEach { $0.makeReadable() }
        constantsLeaves.forEach { $0.makeReadable() }
        setNeedsDisplay()
    }
    func cite(_ citable: Citable, at: CGPoint) {}
            
// Bubble ==========================================================================================
    override var uiColor: UIColor { open ? .white : !selected ? OOColor.lime.uiColor : .yellow }

// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        guard let plasma = plasma else { return }
        Skin.plasma(path: plasma, uiColor: uiColor, stroke: 1)
    }
}
