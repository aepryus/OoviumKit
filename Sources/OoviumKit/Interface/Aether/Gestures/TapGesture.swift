//
//  TapGesture.swift
//  Oovium
//
//  Created by Joe Charlier on 12/16/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import UIKit

protocol Tappable: AnyObject {
	func onTap()
}

class TapGesture: UITapGestureRecognizer {
	weak var tappable: Tappable? = nil
	
	init() {
		super.init(target: nil, action: nil)
		addTarget(self, action: #selector(onTap))
	}
	
// Events ==========================================================================================
	@objc func onTap() {
		tappable!.onTap()
	}
	
// UIGestureRecognizer =============================================================================
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		guard event.allTouches?.count == 1 && touches.count == 1 else {
			state = .failed
			return
		}

		var view: UIView? = touches.first!.view
		while view != nil && !(view is Tappable) {
			view = view?.superview
		}
		
		guard let tappable = view as? Tappable else { state = .failed; return }

		self.tappable = tappable
		super.touchesBegan(touches, with: event)
	}
	
	override func reset() {
		tappable = nil
	}
}
