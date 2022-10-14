//
//  Anchoring.swift
//  Pangaea
//
//  Created by Joe Charlier on 2/17/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class Anchoring {
	lazy var anchorStart: AnchorStart = {
		return AnchorStart(anchoring: self)
	}()
	lazy var anchorStop: AnchorStop = {
		return AnchorStop(anchoring: self)
	}()
	unowned let aetherView: AetherView
	var anchorTouch: UITouch? = nil

	init(aetherView: AetherView) {
		self.aetherView = aetherView
	}
	
	func start() {
		anchorStart.delegate = aetherView
		anchorStop.delegate = aetherView
		aetherView.addGestureRecognizer(anchorStart)
		aetherView.addGestureRecognizer(anchorStop)
	}
	func reset() {
		anchorTouch = nil
	}
	
// Event ===========================================================================================
	func onAnchorStart() {
	}
	func onAnchorStop() {
		reset()
	}
}

class AnchorStart: UIGestureRecognizer {
	unowned let anchoring: Anchoring
	
	init(anchoring: Anchoring) {
		self.anchoring = anchoring
		super.init(target: nil, action: nil)
		self.addTarget(self, action: #selector(onTriggered))
	}
	
// Events ==========================================================================================
	@objc func onTriggered() {
		anchoring.onAnchorStart()
	}
	
// UIGestureRecognizer =============================================================================
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		guard !anchoring.aetherView.locked && !anchoring.aetherView.readOnly && !Screen.mac else { state = .failed; return }
		guard anchoring.anchorTouch == nil && touches.count == 1, let touch = touches.first, touch.view === anchoring.aetherView.scrollView else {
			state = .failed
			return
		}
		
		anchoring.anchorTouch = touch
		state = .recognized
	}
}

class AnchorStop: UIGestureRecognizer {
	unowned let anchoring: Anchoring
	
	init(anchoring: Anchoring) {
		self.anchoring = anchoring
		super.init(target: nil, action: nil)
		self.addTarget(self, action: #selector(onTriggered))
	}
	
// Events ==========================================================================================
	@objc func onTriggered() {
		anchoring.onAnchorStop()
	}
	
// UIGestureRecognizer =============================================================================
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
		guard anchoring.anchorTouch != nil else {
			state = .failed
			return
		}
		
		if let anchorTouch = anchoring.anchorTouch, touches.contains(anchorTouch) {
			state = .recognized
		}
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
		touchesEnded(touches, with: event)
	}
}
