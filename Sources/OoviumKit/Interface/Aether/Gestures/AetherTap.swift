//
//  AetherTap.swift
//  Oovium
//
//  Created by Joe Charlier on 9/26/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import UIKit

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
