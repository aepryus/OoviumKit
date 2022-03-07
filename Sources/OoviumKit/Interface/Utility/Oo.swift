//
//  Oo.swift
//  Oovium
//
//  Created by Joe Charlier on 1/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class Oo {
	static var iPhone: Bool {
		return UIDevice.current.userInterfaceIdiom == .phone
	}
	static var iPad: Bool {
		return UIDevice.current.userInterfaceIdiom == .pad
	}
	
	static var s: CGFloat = Oo.iPhone ? 1 : 1.5
}
