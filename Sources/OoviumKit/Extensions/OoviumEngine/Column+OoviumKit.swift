//
//  Column+OoviumKit.swift
// 	OoviumKit
//
//  Created by Joe Charlier on 3/7/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

extension Column {
	var alignment: NSTextAlignment {
		switch justify {
			case .left: return .left
			case .center: return .center
			case .right: return .right
		}
	}
}
