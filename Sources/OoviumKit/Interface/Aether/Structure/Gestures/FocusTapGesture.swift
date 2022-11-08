//
//  FocusTapGesture.swift
//  Oovium
//
//  Created by Joe Charlier on 9/20/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

protocol FocusTappable: UIView {
	func onFocusTap(aetherView: AetherView)
	func cedeFocusTo(other: FocusTappable) -> Bool
    func onWillFocusTap()
}
extension FocusTappable {
	func cedeFocusTo(other: FocusTappable) -> Bool { false }
    func onWillFocusTap() {}
}

protocol NotTappable {}

class FocusTapGesture: UITapGestureRecognizer {
	unowned let aetherView: AetherView
	weak var tapped: FocusTappable?
    weak var release: Editable?
	
	init(aetherView: AetherView) {
		self.aetherView = aetherView
		super.init(target: nil, action: nil)
		addTarget(self, action: #selector(onTap))
	}
	
// Events ==========================================================================================
	@objc func onTap() {
        tapped!.onWillFocusTap()
		aetherView.unselectAll()
        if let release {
            release.releaseFocus(.administrative)
            self.release = nil
        }
        tapped!.onFocusTap(aetherView: aetherView)
	}
	
// UIGestureRecognizer =============================================================================
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		guard !aetherView.locked
                && !aetherView.readOnly
                && !aetherView.anchored
                && event.allTouches?.count == 1
                && touches.count == 1
                && touches.first!.view != aetherView
            else { state = .failed; return }

		var view: UIView? = touches.first!.view
		while view != nil && !(view is FocusTappable) {
			if view is NotTappable { view = nil }
			else { view = view?.superview }
		}
        
        guard let tapped: FocusTappable = view as? FocusTappable
            else { state = .failed; return }
		
        if let focused: Editable = aetherView.focus, focused !== tapped {
            if !focused.cedeFocusTo(other: tapped) {
                state = .failed; return
            } else {
                release = focused
            }
        }

		self.tapped = tapped
		super.touchesBegan(touches, with: event)
	}
	
	override func reset() {
        tapped = nil
	}
}
