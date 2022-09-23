//
//  MakeGesture.swift
//  Oovium
//
//  Created by Joe Charlier on 11/9/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class MakeGesture: UITapGestureRecognizer {
	unowned let aetherView: AetherView
	
	init(aetherView: AetherView) {
		self.aetherView = aetherView
		super.init(target: nil, action: nil)
		numberOfTapsRequired = 2
		addTarget(self, action: #selector(onDoubleTap))
	}
	
	// Events ==========================================================================================
	@objc func onDoubleTap() {
		let origin = location(in: aetherView.scrollView)
		let at = V2(Double(origin.x),Double(origin.y))
        
#if os(macOS)
        let commandKeyPressed: Bool = CGEventSource.keyState(.combinedSessionState, key: 0x37)
        if !commandKeyPressed {
            aetherView.triggerMaker(at: at)
        } else {
            aetherView.pasteBubbles(at: CGPoint(x: at.x, y: at.y))
        }
#else
        aetherView.triggerMaker(at: at)
#endif
	}
	
	// UIGestureRecognizer =============================================================================
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		guard !aetherView.locked && !aetherView.readOnly else {state = .failed;return}
		guard !aetherView.anchored || aetherView.anchoring.anchorTouch === touches.first, let view = touches.first?.view, view === aetherView.scrollView && touches.count == 1 else {
			state = .failed
			return
		}
		
		super.touchesBegan(touches, with: event)
	}
}
