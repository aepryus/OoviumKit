//
//  DoubleTap.swift
//  Oovium
//
//  Created by Joe Charlier on 9/26/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import UIKit

protocol DoubleTappable: UIView {
	func onDoubleTap()
}

class DoubleTap: UITapGestureRecognizer {
	unowned let aetherView: AetherView
	weak var doubleTappable: DoubleTappable? = nil

	init(aetherView: AetherView) {
		self.aetherView = aetherView
		super.init(target: nil, action: nil)
		numberOfTapsRequired = 2
		addTarget(self, action: #selector(onDoubleTap))
	}
	
// Events ==========================================================================================
		@objc func onDoubleTap() {
			doubleTappable!.onDoubleTap()
		}
		
// UIGestureRecognizer =============================================================================
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		guard !aetherView.locked && !aetherView.readOnly && !aetherView.anchored else { state = .failed; return }
		guard event.allTouches?.count == 1 && touches.count == 1 && touches.first!.view != aetherView else {
			state = .failed
			return
		}

		var view: UIView? = touches.first!.view
		while view != nil && !(view is DoubleTappable) {
			view = view?.superview
		}
		
		guard let v = view, let doubleTappable = v as? DoubleTappable else { state = .failed; return }
		
		if let focus = aetherView.focus, focus !== doubleTappable && !(doubleTappable is HeaderCell && focus is HeaderCell) {
			state = .failed
			return
		}

		self.doubleTappable = doubleTappable
		
		super.touchesBegan(touches, with: event)
	}
	
	override func reset() {
		doubleTappable = nil
	}

}
