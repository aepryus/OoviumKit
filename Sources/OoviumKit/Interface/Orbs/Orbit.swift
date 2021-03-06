//
//  Orbit.swift
//  Oovium
//
//  Created by Joe Charlier on 2/3/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import UIKit

public class Orbit: Gadget {
	weak var orb: Orb? = nil
	let offset: UIOffset
	weak var editable: Editable? = nil
	
	init(size: CGSize, offset: UIOffset = .zero) {
		self.offset = offset
		super.init(size: size)
	}
	public required init?(coder: NSCoder) { fatalError() }

	func edit(editable: Editable) -> Orbit {
		self.editable = editable
		return self
	}

// Events ==========================================================================================
//	func render() {}
	func reRender() {}
	func rescale() {}
//	func retract() {}
	func onInvoke() {}
	func onDismiss() {}
	
// Gadget ==========================================================================================
	override public var size: CGSize {
		didSet {}
	}
}
