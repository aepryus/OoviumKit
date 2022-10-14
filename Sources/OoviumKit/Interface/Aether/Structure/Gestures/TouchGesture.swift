//
//  AETouchGesture.swift
//  Oovium
//
//  Created by Joe Charlier on 8/4/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

public class TouchGesture: UIGestureRecognizer {

// UIGestureRecognizer =============================================================================
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		if state == .possible {
			state = .recognized
		}
	}
	public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
		state = .failed
	}
	public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
		state = .failed
	}
}
