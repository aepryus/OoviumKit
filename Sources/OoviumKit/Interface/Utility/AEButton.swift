//
//  AEButton.swift
//  Oovium
//
//  Created by Joe Charlier on 2/19/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import UIKit

class AEButton: UIButton, NotTappable {

// UIView ==========================================================================================
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		let inside = super.point(inside: point, with: event)
		if inside && !isHighlighted && event?.type == .touches {
			isHighlighted = true
		}
		return inside
	}
	override var isHighlighted: Bool {
		didSet {setNeedsDisplay()}
	}
}
