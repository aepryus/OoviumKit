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
	static let ellipseShape = EllipseShape()
	static let roundedShape = RoundedShape()
	static let rectangleShape = RectangleShape()
	static let diamondShape = DiamondShape()

	var shape: Shape {
		switch self {
			case .ellipse:      return OOShape.ellipseShape
			case .rounded:      return OOShape.roundedShape
			case .rectangle:    return OOShape.rectangleShape
			case .diamond:      return OOShape.diamondShape
		}
	}
}
