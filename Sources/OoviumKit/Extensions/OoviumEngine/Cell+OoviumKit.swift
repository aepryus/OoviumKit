//
//  Cell+OoviumKit.swift
// 	OoviumKit
//
//  Created by Joe Charlier on 3/9/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

extension Cell {
	var width: CGFloat {
		get {
			if _width == nil { renderWidth() }
			return _width!
		}
	}
	func renderWidth() { _width = ChainView.calcWidth(chain: chain)+6 }
}
