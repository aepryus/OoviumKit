//
//  MiruBub.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class MiruBub: Bubble {
	let miru: Miru
	
	init(_ miru: Miru, aetherView: AetherView) {
		self.miru = miru
		super.init(aetherView: aetherView, aexel: miru, origin: CGPoint(x: self.miru.x, y: self.miru.y), size: CGSize(width: 36, height: 36))
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
}
