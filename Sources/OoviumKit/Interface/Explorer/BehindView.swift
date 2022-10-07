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
    let aetherView: AetherView
    lazy public var leftExplorer: AetherExplorer = { AetherExplorer(aetherView: aetherView) }()
	lazy public var rightExplorer: AetherExplorer = { AetherExplorer(aetherView: aetherView) }()
    let newAetherTrap: Trapezoid = Trapezoid(title: "New Aether".localized, leftSlant: .up)
    let importTrap: Trapezoid = Trapezoid(title: "Import".localized, leftSlant: .down)

	public init(aetherView: AetherView) {
        self.aetherView = aetherView

		super.init(frame: .zero)

		backgroundColor = UIColor(red: 32/255, green: 34/255, blue: 36/255, alpha: 1)

        addSubview(newAetherTrap)
		addSubview(leftExplorer)
        if Screen.mac { addSubview(importTrap) }
        
        newAetherTrap.addAction { [unowned self] in leftExplorer.controller.onNewAether() }
        importTrap.addAction { [unowned self] in leftExplorer.controller.onImport() }
	}
	required init?(coder: NSCoder) { fatalError() }
    
// UIView ==========================================================================================
    override public var frame: CGRect {
        didSet { setNeedsLayout() }
    }
	override public func layoutSubviews() {
        let h: CGFloat = 36*s
        let p: CGFloat = 4*s

        let y1: CGFloat = Screen.safeTop + 5*s
        let y2: CGFloat = y1 + h + p
        let y4: CGFloat = height - (Screen.safeBottom + 5*s)
        let y3: CGFloat = y4 - p - (Screen.mac ? h : 0)
        
        let x1: CGFloat = 5*s
        let x3: CGFloat = x1 + 355*s
        let x2: CGFloat = x3 - 172*s - 25*s
        
        newAetherTrap.frame = CGRect(x: x2, y: y1, width: 172*s, height: h)
		leftExplorer.frame = CGRect(x: x1, y: y2, width: x3-x1, height: y3-y2-p)
        importTrap.frame = CGRect(x: x2, y: y3, width: 172*s, height: h)
	}
}
