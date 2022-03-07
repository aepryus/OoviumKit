//
//  Bubble.swift
//  Oovium
//
//  Created by Joe Charlier on 4/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

public enum Position {
	case center, top, bottom, left, right, topLeft, topRight, bottomLeft, bottomRight
	
	func isRight() -> Bool {
		return self == .topRight || self == .right || self == .bottomRight
	}
	func isLeft() -> Bool {
		return self == .topLeft || self == .left || self == .bottomLeft
	}
	func isTop() -> Bool {
		return self == .topLeft || self == .top || self == .topRight
	}
	func isBottom() -> Bool {
		return self == .bottomLeft || self == .bottom || self == .bottomRight
	}
}

protocol Maker {
	func make (aetherView: AetherView, at: V2) -> Bubble
	func drawIcon()
}

public class Bubble: UIView, AnchorTappable, Colorable, UIGestureRecognizerDelegate, UIContextMenuInteractionDelegate {
	unowned var aetherView: AetherView
	var aexel: Aexel
	var hitch: Position
	var minSize: CGSize? = nil
	var padding: CGSize? = nil
	var leaves: [Leaf] = []
	var plasma: CGMutablePath? = nil
	
	var selected: Bool = false
	var startPoint: CGPoint? = nil
	
	var leafsNeedLayout: Bool = false
	var oldHitchPoint: CGPoint? = nil
	
	var uiColor: UIColor {
		return UIColor.white
	}
	var selectable: Bool {
		return true
	}
	
	init(aetherView: AetherView, aexel: Aexel, origin: CGPoint, hitch: Position, size: CGSize) {
		self.aetherView = aetherView
		self.aexel = aexel
		self.hitch = hitch
		
		super.init(frame: CGRect(x: origin.x, y: origin.y, width: size.width, height: size.height))

		backgroundColor = UIColor.clear

		let gesture = TouchGesture(target: self, action: #selector(onTouch))
		gesture.delegate = self
		addGestureRecognizer(gesture)
		
		if Screen.mac {
			addInteraction(UIContextMenuInteraction(delegate: self))
		}
	}
	public required init?(coder aDecoder: NSCoder) {fatalError()}

	var orb: Orb { aetherView.orb }
	var context: Context {
		return orb.multiContext
	}
	var multiContext: Context {
		return orb.multiContext
	}
	
	func add(leaf: Leaf) {
		guard !leaves.contains(leaf) else {return}
		leaves.append(leaf)
		addSubview(leaf)
	}
	func remove(leaf: Leaf) {
		leaves.remove(object: leaf)
		leaf.removeFromSuperview()
	}
	
	func calculateRect() -> CGRect {
		guard let first = leaves.first else {return CGRect(x: 0, y: 0, width: 36, height: 36)}
		
		var xL: CGFloat = first.xL
		var xR: CGFloat = first.xR
		var yT: CGFloat = first.yT
		var yB: CGFloat = first.yB
		
		for leaf in leaves {
			guard leaf !== first else {continue}
			if xL > leaf.xL {xL = leaf.xL}
			if xR < leaf.xR {xR = leaf.xR}
			if yT > leaf.yT {yT = leaf.yT}
			if yB < leaf.yB {yB = leaf.yB}
		}
		
		var width = xR-xL
		var height = yB-yT
		
		if let padding = padding {
			width += padding.width
			height += padding.height
		}
		
		if let minSize = minSize {
			width = max(width, minSize.width)
			height = max(height, minSize.height)
		}
		
		return CGRect(x: xL, y: yT, width: width, height: height)
	}
	func currentAnchor() -> CGPoint {
		return frame.origin + hitchPoint
	}
	var hitchPoint: CGPoint {
		let size = calculateRect().size
		let x: CGFloat = hitch.isRight() ? size.width : (!hitch.isLeft() ? size.width/2 : 0)
		let y: CGFloat = hitch.isBottom() ? size.height : (!hitch.isTop() ? size.height/2 : 0)
		return CGPoint(x: x, y: y)
	}
	func layoutLeaves() {
		let rect = calculateRect()
		if let oldHitchPoint = oldHitchPoint {
			let newHitchPoint = hitchPoint
			self.frame = CGRect(origin: frame.origin+oldHitchPoint-newHitchPoint, size: rect.size)
			self.oldHitchPoint = newHitchPoint
		} else {
			self.bounds = CGRect(origin: CGPoint.zero, size: rect.size)
			oldHitchPoint = hitchPoint
		}
		
		for leaf in leaves {
			leaf.frame = CGRect(x: (padding?.width ?? 0)+leaf.xL-rect.origin.x, y: (padding?.height ?? 0)+leaf.yT-rect.origin.y, width: leaf.size.width, height: leaf.size.height)
		}
		
		setNeedsDisplay()
	}
	func setLeavesNeedLayout() {
		leafsNeedLayout = true
	}
	func layoutLeavesIfNeeded() {
		guard leafsNeedLayout else {return}
		layoutLeaves()
		leafsNeedLayout = false
	}
	func setNeedsDisplayWithLeaves() {
		setNeedsDisplay()
		for leaf in leaves {
			leaf.setNeedsDisplay()
		}
	}
	func wire() {
		for leaf in leaves {
			leaf.wire()
		}
	}
	func positionMoorings() {
		leaves.forEach { $0.positionMoorings() }
	}
	func setStartPoint() {
		startPoint = center
	}
	func move(by: CGPoint) {
		guard let startPoint = startPoint else {fatalError()}
		center = startPoint + by
	}
	
// Events ==========================================================================================
	func onCreate() {}
	func onRemove() {}
	func onSelect() {}
	func onUnselect() {}
	func onMove() {}
	func onUnload() {}
	
	func onAnchorTap(point: CGPoint) {
		guard aetherView.focus == nil else {return}
		if !selected {
			aetherView.select(bubble: self)
		} else {
			aetherView.unselect(bubble: self)
		}
	}
	@objc func onTouch() {
		aetherView.bringSubviewToFront(self)
	}
	
// Actions =========================================================================================
	func create() {
		onCreate()
	}
	func select() {
		selected = true
		onSelect()
		setNeedsDisplay()
		for leaf in leaves {
			leaf.setNeedsDisplay()
		}
		positionMoorings()
	}
	func unselect() {
		selected = false
		onUnselect()
		setNeedsDisplay()
		for leaf in leaves {
			leaf.setNeedsDisplay()
		}
		positionMoorings()
	}
	
// UIView ==========================================================================================
	public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let view: UIView? = super.hitTest(point, with: event)
		if view !== self { return view }
		if let plasma = plasma, plasma.contains(point) { return self }
		return nil
	}
	public override var frame: CGRect {
		didSet { positionMoorings() }
	}
	public override var center: CGPoint {
		didSet { positionMoorings() }
	}
	public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		let area = self.bounds.insetBy(dx: -4*Oo.s, dy: -4*Oo.s)
		return area.contains(point)
	}
	
// UIGestureRecognizerDelegate =====================================================================
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

// UIContextMenuInteractionDelegate ================================================================
	public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
		if !selected { aetherView.select(bubble: self) }
		else { aetherView.unselect(bubble: self) }
		return nil
	}
}
