//
//  FocusTapGesture.swift
//  Oovium
//
//  Created by Joe Charlier on 9/20/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

protocol FocusTappable: UIView {
	func onTap(aetherView: AetherView)
	func cedeFocusTo(other: FocusTappable) -> Bool
}
extension FocusTappable {
	func cedeFocusTo(other: FocusTappable) -> Bool {return false}
}

protocol NotTappable {}

class FocusTapGesture: UITapGestureRecognizer {
	unowned let aetherView: AetherView
	weak var tappable: FocusTappable? = nil
	
	init(aetherView: AetherView) {
		self.aetherView = aetherView
		super.init(target: nil, action: nil)
		addTarget(self, action: #selector(onTap))
	}
	
// Events ==========================================================================================
	@objc func onTap() {
		aetherView.unselectAll()
		tappable!.onTap(aetherView: aetherView)
	}
	
// UIGestureRecognizer =============================================================================
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		guard !aetherView.locked && !aetherView.readOnly && !aetherView.anchored else {state = .failed;return}
		guard event.allTouches?.count == 1 && touches.count == 1 && touches.first!.view != aetherView else {
			state = .failed
			return
		}

		var view: UIView? = touches.first!.view
		while view != nil && !(view is FocusTappable) {
			if view is NotTappable {view = nil}
			else {view = view?.superview}
		}
		
		guard let v = view, let tappable = v as? FocusTappable else {state = .failed;return}

		if let focus = aetherView.focus, focus !== tappable && !focus.cedeFocusTo(other: tappable) {
			state = .failed
			return
		}

		self.tappable = tappable
		super.touchesBegan(touches, with: event)
	}
	
	override func reset() {
		tappable = nil
	}
}
