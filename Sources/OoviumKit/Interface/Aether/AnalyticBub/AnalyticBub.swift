//
//  AnalyticBub.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/12/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class AnalyticBub: Bubble, Citable {
    let analytic: Analytic
    
    lazy var analyticLeaf: AnalyticLeaf = { AnalyticLeaf(bubble: self) }()
    
    required init(_ analytic: Analytic, aetherView: AetherView) {
        self.analytic = analytic
        
        super.init(aetherView: aetherView, aexel: analytic, origin: CGPoint(x: self.analytic.x, y: self.analytic.y), size: .zero)
        
        add(leaf: analyticLeaf)

        layoutLeaves()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    var isEmpty: Bool { analytic.anain.tokens.count == 0 && analytic.label.count == 0 }
    
// Events ==========================================================================================
    override func onCreate() { analyticLeaf.makeFocus() }
    override func onRemove() {}
    override func onSelect() {}
    override func onUnselect() {}

    func onOK() {
        if isEmpty {
            aetherView.aether.remove(aexel: analytic)
            aetherView.remove(bubble: self)
        }
        aetherView.stretch()
    }

// Bubble ==========================================================================================
//    override var context: Context { orb.analyticContext }
    override var uiColor: UIColor { selected ? .yellow : (analyticLeaf.focused ? .black.tint(0.8) : (analytic.token.status == .ok ? analytic.anain.tower.obje.uiColor : .red)) }

// Citable =========================================================================================
    func token(at: CGPoint) -> Token? { analytic.token }
}
