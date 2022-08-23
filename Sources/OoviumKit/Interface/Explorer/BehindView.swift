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
	public let leftExplorer: AetherExplorer
	public let rightExplorer: AetherExplorer
    let newAetherTrap: Trapezoid = Trapezoid(title: "New Aether".localized, leftSlant: .up)
    let newFolderTrap: Trapezoid = Trapezoid(title: "New Folder", rightSlant: .up)
    let manageTrap: Trapezoid = Trapezoid(title: "Manage".localized, leftSlant: .down)

	public init(aetherView: AetherView) {
		leftExplorer = AetherExplorer(aetherView: aetherView)
		rightExplorer = AetherExplorer(aetherView: aetherView)

		super.init(frame: .zero)

		backgroundColor = UIColor(red: 32/255, green: 34/255, blue: 36/255, alpha: 1)

        addSubview(newFolderTrap)
		addSubview(newAetherTrap)
		addSubview(leftExplorer)
		addSubview(manageTrap)

        newAetherTrap.addAction { [unowned self] in
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
        let h: CGFloat = 36*s
		let y: CGFloat = 5*s + (Screen.mac ? Screen.safeTop : 0) + h + 4*s
		leftExplorer.frame = CGRect(x: 5*s, y: y, width: 355*s, height: Screen.height - Screen.safeBottom - y - h - 4*s - 5*s)
        newFolderTrap.frame = CGRect(x: 40*s, y: leftExplorer.top - 4*s-h, width: 156*s, height: h)
        newAetherTrap.frame = CGRect(x: leftExplorer.right - 156*s - 25*s, y: leftExplorer.top - 4*s-h, width: 156*s, height: h)
        manageTrap.frame = CGRect(x: leftExplorer.right - 172*s - 25*s, y: leftExplorer.bottom + 4*s, width: 172*s, height: h)
	}
}
