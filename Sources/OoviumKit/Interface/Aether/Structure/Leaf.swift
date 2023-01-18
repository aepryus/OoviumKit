//
//  Leaf.swift
//  Oovium
//
//  Created by Joe Charlier on 4/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

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
	var hitPath: CGPath?
    var mooring: Mooring!
	
	init(bubble: Bubble, hitch: Position = .topLeft, anchor: CGPoint = CGPoint.zero, size: CGSize = CGSize(width: 36, height: 36)) {
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
	func positionMoorings() { mooring?.point = self.bubble.aetherView.scrollView.convert(self.center, from: self.superview) }
	
    func removeFromBubble() { bubble.remove(leaf: self) }
	
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
    override func draw(_ rect: CGRect) {
        let path = CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 15, cornerHeight: 15, transform: nil)
        hitPath = path
        Skin.bubble(path: path, uiColor: bubble.uiColor, width: 4.0/3.0*Oo.s)
    }
}
