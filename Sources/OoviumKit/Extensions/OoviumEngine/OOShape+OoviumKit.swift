//
//  OOShape+OoviumKit.swift
// 	OoviumKit
//
//  Created by Joe Charlier on 3/7/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine

extension OOShape {
	static let ellipseShape_ = EllipseShape()
	static let roundedShape_ = RoundedShape()
	static let rectangleShape_ = RectangleShape()
	static let diamondShape_ = DiamondShape()

	var shape: Shape {
		switch self {
			case .ellipse:
				return OOShape.ellipseShape_
			case .rounded:
				return OOShape.roundedShape_
			case .rectangle:
				return OOShape.rectangleShape_
			case .diamond:
				return OOShape.diamondShape_
		}
	}
}
