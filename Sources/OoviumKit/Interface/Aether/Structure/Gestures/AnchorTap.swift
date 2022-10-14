//
//  AnchorTap.swift
//  Oovium
//
//  Created by Joe Charlier on 9/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

protocol AnchorTappable: AnyObject {
	func onAnchorTap(point: CGPoint)
}

class AnchorTap: UITapGestureRecognizer {
	unowned let aetherView: AetherView
	weak var anchorTappable: AnchorTappable? = nil
	var tapPoint: CGPoint? = nil

	init(aetherView: AetherView) {
		self.aetherView = aetherView
		super.init(target: nil, action: nil)
		self.addTarget(self, action: #selector(onTap))
	}

// Events ==========================================================================================
	@objc func onTap() {
		anchorTappable!.onAnchorTap(point: tapPoint!)
	}
	
// UIGestureRecognizer =============================================================================
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		guard !aetherView.locked && !aetherView.readOnly else {state = .failed;return}
		guard aetherView.anchored && touches.count == 1, let touch = touches.first else {
			state = .failed
			return
		}

		var view: UIView? = touch.view
		while view != nil && !(view is AnchorTappable) {
			view = view?.superview
		}

		guard view != nil else {
			state = .failed
			return
		}

		anchorTappable = view as? AnchorTappable
		tapPoint = touch.location(in: view)
		super.touchesBegan(touches, with: event)
	}
	override func reset() {
		anchorTappable = nil
		tapPoint = nil
	}
}
