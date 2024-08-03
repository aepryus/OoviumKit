//
//  VarView.swift
//  Oovium
//
//  Created by Joe Charlier on 10/27/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class VarView: UIView, Citable {
	let token: Token
    lazy var mooring: Mooring = Mooring(bubble: bubble, key: token.key)
	
	unowned let bubble: Bubble
	
	init(bubble: Bubble, token: Token) {
		self.bubble = bubble
		self.token = token
		super.init(frame: CGRect.zero)
		self.backgroundColor = UIColor.clear
        self.bubble.aetherView.moorings[self.token.key] = self.mooring
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
// UIView ==========================================================================================
	override var frame: CGRect {
		didSet {mooring.point = self.bubble.aetherView.scrollView.convert(self.center, from: self.superview)}
	}
	override func draw(_ rect: CGRect) {
		Skin.text(token.display, rect: rect, uiColor: bubble.uiColor, font: UIFont.systemFont(ofSize: 14), align: .center)
	}
	
// Citable =========================================================================================
    func tokenKey(at: CGPoint) -> TokenKey? { token.key }
}
