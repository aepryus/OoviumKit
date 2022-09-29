//
//  ChainLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 4/16/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

protocol ChainLeafDelegate: AnyObject {
	func onChange()
	func onWillEdit()
	func onEdit()
	func onOK(leaf: ChainLeaf)
	func onCalculate()
	func accept(citable: Citable) -> Bool
}
extension ChainLeafDelegate {
	func onWillEdit() {}
	func accept(citable: Citable) -> Bool {return true}
}

class ChainLeaf: Leaf, ChainViewDelegate, Editable {
    lazy var chainView: ChainView = { ChainView(responder: aetherView.responder) }()
	weak var delegate: ChainLeafDelegate?
	var placeholder: String = "" {
		didSet { setNeedsDisplay() }
	}
	var minWidth: CGFloat = 36 {
		didSet {self.size = CGSize(width: calcWidth(), height: 36)}
	}
	var radius: CGFloat = 10 {
		didSet {setNeedsDisplay()}
	}
	var colorable: Colorable? = nil
	
	var chain: Chain {
		set {
			chainView.chain = newValue
//			chainView.chain.tower.listener = self
		}
		get {return chainView.chain}
	}
	var uiColor: UIColor {
		if chain.editing { return UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) }
		else if let colorable = colorable { return colorable.uiColor }
		else { return bubble.uiColor }
	}
	
	let mooring: Mooring = Mooring()
	
	override init(bubble: Bubble, hitch: Position, anchor: CGPoint, size: CGSize) {
		super.init(bubble: bubble, hitch: hitch, anchor: anchor, size: size)
		
		self.backgroundColor = UIColor.clear
		chainView.delegate = self
		addSubview(chainView)
	}
	init(bubble: Bubble, hitch: Position, anchor: CGPoint, size: CGSize, delegate: ChainLeafDelegate) {
		self.delegate = delegate
		
		super.init(bubble: bubble, hitch: hitch, anchor: anchor, size: size)
		
		self.backgroundColor = UIColor.clear
		chainView.delegate = self
		addSubview(chainView)
	}
	init(bubble: Bubble, delegate: ChainLeafDelegate) {
		self.delegate = delegate
		
		super.init(bubble: bubble, hitch: .center, anchor: CGPoint.zero, size: CGSize.zero)
		
		self.backgroundColor = UIColor.clear
		chainView.delegate = self
		addSubview(chainView)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func calcWidth() -> CGFloat { max(chainView.width+36, minWidth) }
	func render() {
		let cvw = chainView.width
		let cvwp = cvw+36
		let w = max(cvwp + (!chainView.chain.editing ? -6 : 0), minWidth)
		self.size = CGSize(width: w, height: 36)
		let adj: CGFloat = (w != minWidth && !chain.editing) ? 1 : 0
		chainView.frame = CGRect(x: (w-cvw)/2 + 1 + adj, y: 7.5, width: cvw, height: 21)
		setNeedsDisplay()
	}
	
	func hideLinks() {
		mooring.doodles.forEach {$0.removeFromSuperlayer()}
	}
	func showLinks() {
		mooring.doodles.forEach {bubble.aetherView.layer.addSublayer($0)}
	}
	
// FocusTappable ===================================================================================
	func onTap(aetherView: AetherView) {
		if chainView.chain.editing {
			releaseFocus()
		} else {
			delegate?.onWillEdit()
			makeFocus()
		}
	}
	
// Leaf ============================================================================================
	override func wire() {
		for token in chain.tokens {
			if let mooring = bubble.aetherView.moorings[token] {
				bubble.aetherView.link(from: self.mooring, to: mooring, wake: false)
			}
		}
	}
	override func positionMoorings() {
		mooring.point = self.bubble.aetherView.scrollView.convert(self.center, from: self.superview)
		mooring.positionDoodles()
	}

// UIView ==========================================================================================
	override var frame: CGRect {
		didSet {
			guard frame != oldValue else { return }
			hitPath = CGPath(roundedRect: bounds.insetBy(dx: 3, dy: 3), cornerWidth: radius, cornerHeight: radius, transform: nil)
		}
	}
	override func layoutSubviews() { render() }
	override func setNeedsDisplay() {
		super.setNeedsDisplay()
		chainView.setNeedsDisplay()
	}
	override func draw(_ rect: CGRect) {
		Skin.bubble(path: hitPath!, uiColor: uiColor, width: 4.0/3.0*Oo.s)
		if chainView.blank {
			Skin.placeholder(placeholder, rect: CGRect(x: 0, y: 7.5, width: rect.size.width, height: 24), uiColor: colorable?.uiColor ?? bubble.uiColor, align: .center)
		}
	}

// Editable ========================================================================================
	var editor: Orbit {
		orb.chainEditor.chainView = chainView
		return orb.chainEditor
	}
	func onMakeFocus() {
		chainView.edit()
		render()
		mooring.wakeDoodles()
		delegate?.onEdit()
	}
	func onReleaseFocus() {
		chainView.ok()
		render()
		mooring.sleepDoodles()
		delegate?.onOK(leaf: self)
	}
	func cite(_ citable: Citable, at: CGPoint) {
		guard let token = citable.token(at: at) else { return }
		guard delegate?.accept(citable: citable) ?? false else { return }
		guard chainView.attemptToPost(token: token) else { return }
		guard let mooring = bubble.aetherView.mooring(token: token) else { return }
		bubble.aetherView.link(from: self.mooring, to: mooring)
	}
	
	func onEdit() {}
	func onOK() { releaseFocus() }

// ChainViewDelegate ===============================================================================
    var color: UIColor { bubble.selected ? UIColor.yellow : uiColor }

    func onEditStart() {}
    func onEditStop() { releaseFocus() }

    func onTokenAdded(_ token: Token) {
        guard let mooring = bubble.aetherView.mooring(token: token) else { return }
        bubble.aetherView.link(from: self.mooring, to: mooring)
    }
    func onTokenRemoved(_ token: Token) {
        guard let mooring = bubble.aetherView.mooring(token: token) else { return }
        bubble.aetherView.unlink(from: self.mooring, to: mooring)
    }

    func onWidthChanged(oldWidth: CGFloat?, newWidth: CGFloat) { render() }
    func onChanged() { delegate?.onChange() }
}
