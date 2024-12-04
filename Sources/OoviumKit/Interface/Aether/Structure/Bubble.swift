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
	
    var isRight: Bool { self == .topRight || self == .right || self == .bottomRight }
    var isLeft: Bool { self == .topLeft || self == .left || self == .bottomLeft }
	var isTop: Bool { self == .topLeft || self == .top || self == .topRight }
	var isBottom: Bool { self == .bottomLeft || self == .bottom || self == .bottomRight }
}

protocol Maker {
	func make (aetherView: AetherView, at: V2) -> Bubble
	func drawIcon()
}

public class Bubble: UIView, AnchorTappable, Colorable, UIGestureRecognizerDelegate, UIContextMenuInteractionDelegate {
	unowned let aetherView: AetherView
	let aexel: Aexel

    private var leaves: [Leaf] = []
    var plasma: CGMutablePath? = nil
//    var moorings: [Mooring] = []

    var selected: Bool = false
    
    private var oldOrigin: CGPoint
    private var oldHitchPoint: CGPoint = .zero
    
	init(aetherView: AetherView, aexel: Aexel, origin: CGPoint, size: CGSize) {
		self.aetherView = aetherView
		self.aexel = aexel
        oldOrigin = origin
		
		super.init(frame: CGRect(origin: origin, size: size))

		backgroundColor = .clear

		let gesture = TouchGesture(target: self, action: #selector(onTouch))
		gesture.delegate = self
		addGestureRecognizer(gesture)
		
		if Screen.mac { addInteraction(UIContextMenuInteraction(delegate: self)) }
	}
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) { fatalError() }

    var uiColor: UIColor { .white }
    var hitch: Position { .center }
    var selectable: Bool { true }
    
	var orb: Orb { aetherView.orb }
	var context: Context { orb.multiContext }
	var multiContext: Context { orb.multiContext }
	
    func add(leaf: Leaf) {
        guard !leaves.contains(leaf) else { return }
        leaves.append(leaf)
        addSubview(leaf)
    }
    func remove(leaf: Leaf) {
        leaves.remove(object: leaf)
        leaf.removeFromSuperview()
    }
    
    func calculateRect() -> CGRect {
        guard leaves.count > 0 else { return CGRect(x: 0, y: 0, width: 36, height: 36) }
        
        let xL: CGFloat = leaves.min { $0.xL }
        let xR: CGFloat = leaves.max { $0.xR }
        let yT: CGFloat = leaves.min { $0.yT }
        let yB: CGFloat = leaves.max { $0.yB }
		
		return CGRect(x: xL, y: yT, width: xR-xL, height: yB-yT)
	}
    var hitchPoint: CGPoint {
		let size = calculateRect().size
        let x: CGFloat = hitch.isLeft ? 0 : hitch.isRight ? size.width : size.width/2
        let y: CGFloat = hitch.isTop ? 0 : hitch.isBottom ? size.height : size.height/2
		return CGPoint(x: x, y: y)
	}

    func layoutLeaves() {
		let rect = calculateRect()
        leaves.forEach { $0.frame = CGRect(origin: CGPoint(x: $0.xL-rect.origin.x, y: $0.yT-rect.origin.y), size: $0.size) }
        
        frame = CGRect(origin: oldOrigin+oldHitchPoint-hitchPoint, size: rect.size)
        
        oldOrigin = frame.origin
        oldHitchPoint = hitchPoint

        positionMoorings()
		setNeedsDisplay()
	}

    private var leavesNeedLayout: Bool = false
    func setLeavesNeedLayout() { leavesNeedLayout = true }
	func layoutLeavesIfNeeded() {
		guard leavesNeedLayout else { return }
		layoutLeaves()
        leavesNeedLayout = false
	}
    func setNeedsDisplayWithLeaves() {
        setNeedsDisplay()
        leaves.forEach { $0.setNeedsDisplay() }
    }

    private var startPoint: CGPoint? = nil
	func setStartPoint() { startPoint = center }
    func move(by: CGPoint) {
		guard let startPoint = startPoint else { fatalError() }
		center = startPoint + by
	}
    
// Moorings ========================================================================================
    func createMooring(key: TokenKey) -> Mooring { aetherView.createMooring(key: key, colorable: self) }
    func wireMoorings() { leaves.forEach { $0.wireMoorings() } }
    func positionMoorings() { leaves.forEach { $0.positionMoorings() } }

// Events ==========================================================================================
	func onCreate() {}
	func onRemove() {}
	func onSelect() {}
	func onUnselect() {}
	func onMove() {}
	func onUnload() {}
	
	func onAnchorTap(point: CGPoint) {
		guard aetherView.focus == nil else { return }
		if !selected { aetherView.select(bubble: self) }
        else { aetherView.unselect(bubble: self) }
	}
	@objc func onTouch() {
        aetherView.scrollView.bringSubviewToFront(self)
	}
	
// Actions =========================================================================================
	func create() {
		onCreate()
	}
	func select() {
		selected = true
		positionMoorings()
        setNeedsDisplayWithLeaves()
        onSelect()
	}
	func unselect() {
		selected = false
		positionMoorings()
        setNeedsDisplayWithLeaves()
        onUnselect()
	}
	
// UIView ==========================================================================================
    public override var frame: CGRect {
        didSet {
            oldOrigin = frame.origin
            positionMoorings()
        }
    }
    public override var center: CGPoint {
        didSet { positionMoorings() }
    }
	public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let view: UIView? = super.hitTest(point, with: event)
		if view !== self { return view }
		if let plasma = plasma, plasma.contains(point) { return self }
		return nil
	}
	public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		let area = self.bounds.insetBy(dx: -4*Oo.s, dy: -4*Oo.s)
		return area.contains(point)
	}
	
// UIGestureRecognizerDelegate =====================================================================
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { true }

// UIContextMenuInteractionDelegate ================================================================
	public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard !aetherView.readOnly else { return nil }
		if !selected { aetherView.select(bubble: self) }
		else { aetherView.unselect(bubble: self) }
		return nil
	}
}
