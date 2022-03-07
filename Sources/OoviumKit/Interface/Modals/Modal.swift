//
//  Modal.swift
//  Oovium
//
//  Created by Joe Charlier on 2/3/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import UIKit

enum Orientations {
	case portrait, landscape, both
}

class Modal: Hover {
	var forcedOrientation: UIInterfaceOrientationMask = .all
	let orientations: Orientations

	init(aetherView: AetherView, anchor: Position, size: CGSize = .zero, offset: UIOffset = .zero, fixed: UIOffset = .zero, orientations: Orientations = .both) {
		self.orientations = orientations
		super.init(aetherView: aetherView, anchor: anchor, size: size, offset: offset)
	}
	required init?(coder: NSCoder) { fatalError() }
}
