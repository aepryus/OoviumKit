//
//  ColorLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 6/27/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class ColorLeaf: Leaf {
    public var no: Int = 0
    public var uiColor: UIColor = .white
	
	override init(bubble: Bubble, hitch: Position, anchor: CGPoint, size: CGSize) {
		super.init(bubble: bubble, hitch: hitch, anchor: anchor, size: size)
		backgroundColor = UIColor.clear
		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
    
    public func load(state: State) {
        no = state.no
        uiColor = Text.Color(rawValue: state.color)?.uiColor ?? .white
    }
	
// Events ==========================================================================================
	@objc func onTap() {
//		aetherView.orb.colorEditor.state = state
		aetherView.orb.colorEditor.colorLeaf = self
        guard !aetherView.orb.hasOrbits else { return }
		aetherView.orb.launch(orbit: aetherView.orb.colorEditor)
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
//		guard let uiColor = Text.Color(rawValue: state.color)?.uiColor else { return }
		let rgb = RGB(uiColor: uiColor)
		let field = rgb.tint(0.5)
		let c = UIGraphicsGetCurrentContext()!
		field.uiColor.setFill()
		c.setLineWidth(1.5)
		let path = CGPath(roundedRect: rect, cornerWidth: 5, cornerHeight: 5, transform: nil)
		hitPath = path
		c.addPath(path)
		c.drawPath(using: .fill)
		Skin.shape(text: "\(no)", rect: rect, uiColor: uiColor)
	}
}
