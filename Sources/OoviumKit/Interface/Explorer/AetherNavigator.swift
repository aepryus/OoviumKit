//
//  AetherNavigator.swift
//  Oovium
//
//  Created by Joe Charlier on 3/28/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import UIKit

class AetherNavigator: UIView {
	unowned var explorer: AetherExplorer
	var space: Space {
		didSet {
			subviews.forEach { $0.removeFromSuperview() }
			snaps = []

			var space: Space? = self.space
			while space != nil {
				snaps.append(AetherSnap(space: space!, navigator: self))
				space = space!.parent
			}

			snaps.forEach { addSubview($0) }

			render()
		}
	}

	var snaps: [AetherSnap] = []

	init(explorer: AetherExplorer) {
		self.explorer = explorer
		self.space = explorer.space

		super.init(frame: .zero)

		defer { space = explorer.space }
	}
	required init?(coder: NSCoder) { fatalError() }

	func render() {
		var x: CGFloat = 0*s
		snaps.forEach {
			let w: CGFloat = $0.calcWidth()
			x += w - 16*s
		}
		frame = CGRect(x: 0, y: 0, width: x + 16*s, height: height)
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		var x: CGFloat = 0*s
		snaps.forEach {
			let w: CGFloat = $0.calcWidth()
			$0.frame = CGRect(x: x, y: 0, width: w, height: height)
			x += w - 16*s
		}
	}
}
