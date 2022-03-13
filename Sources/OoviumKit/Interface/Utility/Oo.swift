//
//  Oo.swift
//  Oovium
//
//  Created by Joe Charlier on 1/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

public class Oo {
	public static var iPhone: Bool {
		return UIDevice.current.userInterfaceIdiom == .phone
	}
	public static var iPad: Bool {
		return UIDevice.current.userInterfaceIdiom == .pad
	}
	
	public static var s: CGFloat = Oo.iPhone ? 1 : 1.5
}
