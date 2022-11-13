//
//  TypeBub.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine
import UIKit

class TypeBub: Bubble {
	let type: Type
	
	var typeLeaf: TypeLeaf!
	
	init(_ type: Type, aetherView: AetherView) {
		self.type = type
		
		super.init(aetherView: aetherView, aexel: type, origin: CGPoint(x: self.type.x, y: self.type.y), size: CGSize.zero)
		
		typeLeaf = TypeLeaf(bubble: self, hitch: .center, anchor: CGPoint.zero, size: CGSize.zero)
		add(leaf: typeLeaf)
		
		layoutLeaves()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }

// Bubble ==========================================================================================
    override var context: Context { orb.typeContext }
	
}
