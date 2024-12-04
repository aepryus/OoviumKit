//
//  SelectionDoodle.swift
//  OoviumKit
//
//  Created by Joe Charlier on 11/2/24.
//

import UIKit

struct Range {
    var left: CGFloat
    var right: CGFloat
    var top: CGFloat
    var bottom: CGFloat
    
    init(point: CGPoint) {
        left = round(point.x)
        right = round(point.x)
        top = round(point.y)
        bottom = round(point.y)
    }
    
    var width: CGFloat { right-left }
    var height: CGFloat { bottom-top }
    
    mutating func add(point: CGPoint) {
        left = min(left, round(point.x))
        right = max(right, round(point.x))
        top = min(top, round(point.y))
        bottom = max(bottom, round(point.y))
    }
    mutating func envelop(range: Range, by: CGFloat) {
        left = range.left - by
        right = range.right + by
        top = range.top - by
        bottom = range.bottom + by
    }
}

class SelectionDoodle: Doodle, CAAnimationDelegate {
    unowned let aetherView: AetherView
    
    init(aetherView: AetherView, touch: UITouch) {
        self.aetherView = aetherView
        super.init()
    }

    var selectionPath: CGPath { fatalError() }
    func add(touch: UITouch) {}
    
    func fadeOut() {
        opacity = 0
        let fade = CAKeyframeAnimation(keyPath: "opacity")
        fade.values = [1, 0]
        fade.duration = 1
        fade.delegate = self
        add(fade, forKey: "fade")
    }    

// CAAnimationDelegate =============================================================================
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) { aetherView.remove(doodle: self) }
}
