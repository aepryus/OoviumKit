//
//  String+Oovium.swift
//  Oovium
//
//  Created by Joe Charlier on 12/22/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Foundation

extension String {
	var localized: String {
		return NSLocalizedString(self, comment: "")
	}
}
