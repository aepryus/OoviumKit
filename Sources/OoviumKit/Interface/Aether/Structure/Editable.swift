//
//  Editable.swift
//  Oovium
//
//  Created by Joe Charlier on 11/7/22.
//  Copyright © 2012 Aepryus Software. All rights reserved.
//

import Foundation

enum Release {
    enum Arrow { case left, right, up, down }
    case focusTap, okEqualReturn, arrow(Arrow), administrative
}

protocol Editable: FocusTappable {
    var aetherView: AetherView { get }
    var orb: Orb { get }
    var editor: Orbit { get }
    func onMakeFocus()
    func onReleaseFocus()
    func cite(_ citable: Citable, at: CGPoint)
    func nextFocus(release: Release) -> Editable?
}
extension Editable {
    
    var focused: Bool { aetherView.focus === self }
    func makeFocus() { aetherView.makeFocus(editable: self) }
    func releaseFocus(_ release: Release) { aetherView.clearFocus(release: release) }
    
// Editable ========================================================================================
    var orb: Orb { aetherView.orb }
    func nextFocus(release: Release) -> Editable? { nil }
    
// FocusTappable ===================================================================================
    func onFocusTap(aetherView: AetherView) {
        if aetherView.focus == nil { makeFocus() }
        else if aetherView.focus === self { releaseFocus(.focusTap) }
    }
}
