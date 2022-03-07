//
//  AnchorPan.swift
//  Pangaea
//
//  Created by Joe Charlier on 2/1/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

protocol AnchorPannable: AnyObject {
	func onPan(offset: CGPoint)
	func onReleased(offset: CGPoint)
}

class AnchorPan: UIPanGestureRecognizer {
	unowned let aetherView: AetherView

	var anchorTouch: UITouch? = nil
	var panTouch: UITouch? = nil
	weak var bubble: Bubble? = nil
	var panStart: CGPoint? = nil
	var bubbleStart: CGPoint? = nil
	var lassoDoodle: LassoDoodle? = nil
	var anchorPannable: AnchorPannable? = nil

	init(aetherView: AetherView) {
		self.aetherView = aetherView
		super.init(target: nil, action: nil)
		self.addTarget(self, action: #selector(onPan))
		if !Screen.mac {
			minimumNumberOfTouches = 2
			aetherView.scrollView.panGestureRecognizer.maximumNumberOfTouches = 1
		}
	}
	
// Events ==========================================================================================
	@objc func onPan() {
		guard let panStart = panStart, let panTouch = panTouch else {return}
		let s = panTouch.location(in: aetherView.scrollView)
		let t = CGPoint(x: s.x-panStart.x, y: s.y-panStart.y)
		if let bubble = bubble, let bubbleStart = bubbleStart, !bubble.selected {
			bubble.center = CGPoint(x: bubbleStart.x+t.x, y: bubbleStart.y+t.y)
		} else if let anchorPanable = anchorPannable {
			anchorPanable.onPan(offset: t)
		} else {
			aetherView.moveSelected(by: t)
		}
	}
	
// UIGestureRecognizer =============================================================================
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		guard !aetherView.locked && !aetherView.readOnly && aetherView.focus == nil else { state = .failed; return }
		guard touches.count == 1, let touch = touches.first else { state = .failed; return }
		
		if anchorTouch == nil && !Screen.mac {
			if touch.view == aetherView.scrollView {
				anchorTouch = touch
			} else {
				state = .failed
				return
			}
		} else if panTouch == nil && (!Screen.mac || !aetherView.scrollView.isTracking) {
			panTouch = touch
			
			var view: UIView? = touch.view
			while !(view is Bubble) && !(view is AnchorPannable) && !(view is AetherView) {
				view = view?.superview
			}
			
			if view is Bubble {
				bubble = view as? Bubble
				if !bubble!.selected {
					bubbleStart = bubble?.center
				} else {
					aetherView.setSelectedsStartPoint()
				}
				panStart = panTouch?.location(in: aetherView.scrollView)
			} else if view is AetherView {
				lassoDoodle = LassoDoodle(aetherView: aetherView, touch: panTouch!)
				aetherView.add(doodle: lassoDoodle!)
			} else if let anchorPannable = view as? AnchorPannable {
				self.anchorPannable = anchorPannable
				panStart = panTouch?.location(in: aetherView.scrollView)
			}
		
			if Screen.mac && panStart != nil { state = .began }
			
		} else {
			state = .failed
			return
		}

		super.touchesBegan(touches, with: event)
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesMoved(touches, with: event)

		if let lassoDoodle = lassoDoodle {
			lassoDoodle.add(touch: panTouch!)
		}
		if let panLoc = panTouch?.location(in: aetherView.scrollView), let panStart = panStart {
			if (panLoc - panStart).length() > 3 {
				aetherView.focusTapGesture.state = .failed
				aetherView.anchorTap.state = .failed
			}
		}
	}
	private func handleEnd(_ touches: Set<UITouch>, with event: UIEvent) {
		if let pt = panTouch, pt.phase == .cancelled || pt.phase == .ended {
			if let pannable = anchorPannable, let panStart = panStart {
				let s = pt.location(in: aetherView.scrollView)
				let t = CGPoint(x: s.x-panStart.x, y: s.y-panStart.y)
				pannable.onReleased(offset: t)
			}

			panTouch = nil
			bubble = nil
			panStart = nil
			bubbleStart = nil
			anchorPannable = nil
			if let path = lassoDoodle?.path {
				aetherView.select(path: path)
			}
			lassoDoodle?.fadeOut()
			lassoDoodle = nil
			aetherView.stretch()
		}
		if let at = anchorTouch, at.phase == .cancelled || at.phase == .ended {
			anchorTouch = nil
			if let allTouches = event.allTouches {
				for touch in allTouches {
					if touch.phase == .stationary {
						if aetherView === aetherView.scrollView.hitTest(touch.location(in: aetherView.scrollView), with: event) {
							anchorTouch = touch
							break;
						}
					}
				}
			}
		}
		if anchorTouch == nil && panTouch == nil {
			state = .ended
		}
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesEnded(touches, with: event)
		handleEnd(touches, with: event)
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
		super.touchesEnded(touches, with: event)
		handleEnd(touches, with: event)
	}
	override func reset() {
		anchorTouch = nil
		panTouch = nil
		bubble = nil
		panStart = nil
		bubbleStart = nil
		lassoDoodle?.fadeOut()
		lassoDoodle = nil
		anchorPannable = nil
	}
}
