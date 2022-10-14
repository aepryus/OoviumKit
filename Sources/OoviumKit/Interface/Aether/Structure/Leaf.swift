//
//  Leaf.swift
//  Oovium
//
//  Created by Joe Charlier on 4/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

protocol Editable: FocusTappable {
	var aetherView: AetherView { get }
	var orb: Orb { get }
	var editor: Orbit { get }
	func onMakeFocus()
	func onReleaseFocus()
	func cite(_ citable: Citable, at: CGPoint)
	
}
extension Editable {
	var orb: Orb { aetherView.orb }
	var focused: Bool {
		return aetherView.focus === self
	}
	func makeFocus(dismissEditor: Bool = true) {
		aetherView.makeFocus(editable: self, dismissEditor: dismissEditor)
	}
	func releaseFocus(dismissEditor: Bool = true) {
		aetherView.clearFocus(dismissEditor: dismissEditor)
	}
	func onWillMakeFocus() {}
	func onTap(aetherView: AetherView) {
		if aetherView.focus == nil {
			makeFocus()
		} else if aetherView.focus === self {
			releaseFocus()
		}
	}
}

class Leaf: UIView {
	unowned var bubble: Bubble
	var hitch: Position {
		didSet{ bubble.setLeavesNeedLayout() }
	}
	var anchor: CGPoint {
		didSet{ bubble.setLeavesNeedLayout() }
	}
	var size: CGSize {
		didSet{ bubble.setLeavesNeedLayout() }
	}
	var hitPath: CGPath? = nil
	
	init(bubble: Bubble, hitch: Position = .topLeft, anchor: CGPoint = CGPoint.zero, size: CGSize = CGSize.zero) {
		self.bubble = bubble
		self.hitch = hitch
		self.anchor = anchor
		self.size = size
		super.init(frame: CGRect.zero)
		backgroundColor = UIColor.clear
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	var aetherView: AetherView { bubble.aetherView }
	var xL: CGFloat { hitch.isLeft ? anchor.x : (hitch.isRight ? anchor.x-size.width : anchor.x-size.width/2) }
    var xR: CGFloat { xL+size.width }
    var yT: CGFloat { hitch.isTop ? anchor.y : (hitch.isBottom ? anchor.y-size.height : anchor.y-size.height/2) }
	var yB: CGFloat { yT+size.height }
	func wireMoorings() {}
	func positionMoorings() {}
	
	func removeFromBubble() {
		bubble.remove(leaf: self)
	}
	
// UIView ==========================================================================================
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		if let hitPath = hitPath, !hitPath.contains(point) { return nil }
		return super.hitTest(point, with: event)
	}
	public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		guard !Screen.mac else { return super.point(inside: point, with: event) }
		let area = self.bounds.insetBy(dx: -4*Oo.s, dy: -4*Oo.s)
		return area.contains(point)
	}
}
