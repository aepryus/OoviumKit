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
    public lazy var controller: ExplorerController = { ExplorerController(behindView: self) }()
    let aetherView: AetherView
    lazy public var leftExplorer: AetherExplorer = { AetherExplorer(controller: controller, aetherView: aetherView) }()
	lazy public var rightExplorer: AetherExplorer = { AetherExplorer(controller: controller, aetherView: aetherView) }()
    let newAetherTrap: Trapezoid = Trapezoid(title: "New Aether".localized, leftSlant: .up)
    let importTrap: Trapezoid = Trapezoid(title: "Import".localized, leftSlant: .down)

	public init(aetherView: AetherView) {
        self.aetherView = aetherView

		super.init(frame: .zero)

		backgroundColor = UIColor(red: 32/255, green: 34/255, blue: 36/255, alpha: 1)

        addSubview(newAetherTrap)
		addSubview(leftExplorer)
        if Screen.mac { addSubview(importTrap) }
        
        newAetherTrap.addAction { [unowned self] in controller.onNewAether() }
        importTrap.addAction { [unowned self] in controller.onImport() }
	}
	required init?(coder: NSCoder) { fatalError() }
    
// UIView ==========================================================================================
    override public var frame: CGRect {
        didSet { setNeedsLayout() }
    }
	override public func layoutSubviews() {
        let h: CGFloat = 36*s
		let y: CGFloat = 5*s + (Screen.mac ? Screen.safeTop : 0) + h + 4*s
		leftExplorer.frame = CGRect(x: 5*s, y: y, width: 355*s, height: height - Screen.safeBottom - y - h - 4*s - 5*s)
        newAetherTrap.frame = CGRect(x: leftExplorer.right - 156*s - 25*s, y: leftExplorer.top - 4*s-h, width: 156*s, height: h)
        importTrap.frame = CGRect(x: leftExplorer.right - 172*s - 25*s, y: leftExplorer.bottom + 4*s, width: 172*s, height: h)
	}
}
