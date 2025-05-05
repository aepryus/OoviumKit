//
//  Orbit.swift
//  Oovium
//
//  Created by Joe Charlier on 2/3/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import UIKit

public class Orbit: Gadget {
    unowned let orb: Orb
	weak var editable: Editable? = nil
	
    init(orb: Orb, size: CGSize, offset: UIOffset = .zero) {
        self.orb = orb
        super.init(delegate: nil, anchor: .bottomRight, size: size, offset: offset)
	}
	public required init?(coder: NSCoder) { fatalError() }

	func edit(editable: Editable) -> Orbit {
		self.editable = editable
		return self
	}

    func add(orbit: Orbit) { orb.add(orbit: orbit) }
    func remove(orbit: Orbit) { orb.remove(orbit: orbit) }
    func toggle(orbit: Orbit) { orb.toggle(orbit: orbit) }

// Events ==========================================================================================
//	func render() {}
	func reRender() {}
	func rescale() {}
//	func retract() {}
	
// Gadget ==========================================================================================
	public override var size: CGSize {
		didSet {}
	}
}
