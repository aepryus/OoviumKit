//
//  PasteGesture.swift
//  Oovium
//
//  Created by Joe Charlier on 2/8/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class PasteGesture: UITapGestureRecognizer {
	unowned let aetherView: AetherView
	
	init(aetherView: AetherView) {
		self.aetherView = aetherView
		super.init(target: nil, action: nil)
		numberOfTapsRequired = 2
		addTarget(self, action: #selector(onDoubleTap))
	}
	
// Events ==========================================================================================
	@objc func onDoubleTap() { // Positional Paste via iOS
        let origin: CGPoint = location(in: aetherView)
        aetherView.onPaste(at: V2(origin.x, origin.y))
	}
	
// UIGestureRecognizer =============================================================================
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		guard !aetherView.locked && !aetherView.readOnly else {state = .failed;return}
		guard aetherView.anchored && aetherView.anchoring.anchorTouch !== touches.first, let view = touches.first?.view, view === aetherView && touches.count == 1 else {
			state = .failed
			return
		}

		super.touchesBegan(touches, with: event)
	}
}
