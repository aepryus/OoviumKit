//
//  AetherTap.swift
//  Oovium
//
//  Created by Joe Charlier on 9/26/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import UIKit

//class Gesture {
//	static func toString(_ state: UIGestureRecognizer.State) -> String {
//		switch state {
//			case .possible:		return "possible"
//			case .began:		return "began"
//			case .cancelled:	return "cancelled"
//			case .ended:		return "ended"
//			case .changed:		return "changed"
//			case .failed:		return "failed"
//			@unknown default:	return "unknown"
//		}
//	}
//}
//
//extension UITapGestureRecognizer {
//	override public var state: UIGestureRecognizer.State {
//		didSet { print("\(String(describing: type(of: self))).state [\(Gesture.toString(state))]") }
//	}
//}
//extension UIPanGestureRecognizer {
//	override public var state: UIGestureRecognizer.State {
//		didSet { print("\(String(describing: type(of: self))).state [\(Gesture.toString(state))]") }
//	}
//}

class AetherTap: UITapGestureRecognizer {
	unowned let aetherView: AetherView
	
	init(aetherView: AetherView) {
		self.aetherView = aetherView
		super.init(target: self.aetherView, action: #selector(AetherView.onTap))
	}
	
// UIGestureRecognizer =============================================================================
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		guard event.allTouches?.count == 1 && touches.count == 1 && touches.first!.view === aetherView.scrollView else {
			state = .failed
			return
		}
		
		super.touchesBegan(touches, with: event)
	}
}
