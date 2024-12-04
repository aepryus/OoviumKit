//
//  Doodle.swift
//  Oovium
//
//  Created by Joe Charlier on 9/22/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class Doodle: CALayer {

    override init() { super.init() }
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) { fatalError() }

	func render() {}
	
// CALayer =========================================================================================
	override func action(forKey event: String) -> CAAction? { nil }
}
