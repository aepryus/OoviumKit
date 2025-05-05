//
//  Text.Shape+OoviumKit.swift
// 	OoviumKit
//
//  Created by Joe Charlier on 3/7/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine

extension Text.Shape {
	static let ellipseShape = EllipseShape()
	static let roundedShape = RoundedShape()
	static let rectangleShape = RectangleShape()
	static let diamondShape = DiamondShape()

	var shape: Shape {
		switch self {
            case .ellipse:      return Text.Shape.ellipseShape
            case .rounded:      return Text.Shape.roundedShape
            case .rectangle:    return Text.Shape.rectangleShape
            case .diamond:      return Text.Shape.diamondShape
		}
	}
}
