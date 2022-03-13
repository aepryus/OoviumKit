//
//  BehindView.swift
//  Oovium
//
//  Created by Joe Charlier on 4/7/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

public class BehindView: UIView {
	let leftExplorer: AetherExplorer
	let rightExplorer: AetherExplorer
	let newTrapezoid: Trapezoid = Trapezoid(title: "New Aether".localized)
	let expandTrapezoid: Trapezoid = Trapezoid(title: "Manage".localized, flipped: true)

	public init(aetherView: AetherView) {
		leftExplorer = AetherExplorer(aetherView: aetherView)
		rightExplorer = AetherExplorer(aetherView: aetherView)

		super.init(frame: .zero)

		backgroundColor = UIColor(red: 32/255, green: 34/255, blue: 36/255, alpha: 1)

		addSubview(newTrapezoid)
		addSubview(leftExplorer)
		addSubview(expandTrapezoid)

		newTrapezoid.addAction { [unowned self] in
			self.leftExplorer.space.newAether { (aether: Aether?) in
				guard let aether = aether else { return }
				self.leftExplorer.aetherView.swapToAether(space: self.leftExplorer.space, aether: aether)
				self.leftExplorer.aetherView.slideBack()
			}
		}
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	override public func layoutSubviews() {
		leftExplorer.frame = CGRect(x: 5*s, y: 100*s, width: 355*s, height: Screen.height-Screen.safeBottom-110*s-50*s)
		newTrapezoid.frame = CGRect(x: leftExplorer.right - 172*s - 25*s, y: leftExplorer.top - 4*s-40*s, width: 172*s, height: 40*s)
		expandTrapezoid.frame = CGRect(x: leftExplorer.right - 172*s - 25*s, y: leftExplorer.bottom + 4*s, width: 172*s, height: 40*s)
	}
}
