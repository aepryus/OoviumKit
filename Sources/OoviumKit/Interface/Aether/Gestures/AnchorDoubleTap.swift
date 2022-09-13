//
//  AnchorDoubleTap.swift
//  OoviumKit
//
//  Created by Joe Charlier on 9/13/22.
//  Copyright © 2012 Aepryus Software. All rights reserved.
//

import UIKit

protocol AnchorDoubleTappable: AnyObject {
    func onAnchorDoubleTap(point: CGPoint)
}

class AnchorDoubleTap: UITapGestureRecognizer {
    unowned let aetherView: AetherView
    weak var anchorDoubleTappable: AnchorDoubleTappable? = nil
    var tapPoint: CGPoint? = nil
    var begun: Bool = false

    init(aetherView: AetherView) {
        self.aetherView = aetherView
        super.init(target: nil, action: nil)
        numberOfTapsRequired = 2
        self.addTarget(self, action: #selector(onDoubleTap))
    }

// Events ==========================================================================================
    @objc func onDoubleTap() {
        anchorDoubleTappable!.onAnchorDoubleTap(point: tapPoint!)
    }
    
// UIGestureRecognizer =============================================================================
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        guard !begun else { super.touchesBegan(touches, with: event); return }
        
        begun = true
        
        guard !aetherView.locked && !aetherView.readOnly && aetherView.anchored,
              let touch = touches.first, touch !== aetherView.anchoring.anchorTouch
        else {
            state = .failed
            return
        }

        var view: UIView? = touch.view
        while view != nil && !(view is AnchorDoubleTappable) { view = view?.superview }

        guard view != nil else {
            state = .failed
            return
        }
        
        state = .possible

        anchorDoubleTappable = view as? AnchorDoubleTappable
        tapPoint = touch.location(in: aetherView.scrollView)
        
        super.touchesBegan(touches, with: event)
    }
    override func reset() {
        anchorDoubleTappable = nil
        tapPoint = nil
        begun = false
    }
}
