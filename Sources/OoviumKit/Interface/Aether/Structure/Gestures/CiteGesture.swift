//
//  ReferenceGesture.swift
//  Oovium
//
//  Created by Joe Charlier on 9/21/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

protocol Citable: UIView {
//    var mooring: Mooring { get }
	func relevant(editable: Editable) -> Bool
	func tokenKey(at: CGPoint) -> TokenKey?
//    func positionMooring()
}
extension Citable {
	func relevant(editable: Editable) -> Bool { true }
//    func positionMooring() { mooring.point = center }
}

class CiteGesture: UITapGestureRecognizer {
	unowned let aetherView: AetherView
	weak var citable: Citable!
	var at: CGPoint? = nil
	
	init(aetherView: AetherView) {
		self.aetherView = aetherView
		super.init(target: nil, action: nil)
		addTarget(self, action: #selector(onTap))
	}
	
// Events =================referenceable=========================================================================
	@objc func onTap() {
		guard let focus = aetherView.focus else { return }
		guard citable.relevant(editable: focus) else { return }
		focus.cite(citable, at: at!)
	}

// UIGestureRecognizer =============================================================================
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
		guard !aetherView.locked && !aetherView.readOnly else {state = .failed;return}
		guard aetherView.focus != nil && touches.count == 1, let touch = touches.first else {
			state = .failed
			return
		}
		
		var view: UIView? = touches.first?.view
		while view != nil && !(view is Citable) {
			view = view?.superview
		}
		guard let citable = view as? Citable else {
			state = .failed
			return
		}
		
		self.citable = citable
		self.at = touch.location(in: view)
		
		super.touchesBegan(touches, with: event)
	}
	
	override func reset() {
		citable = nil
	}
}
