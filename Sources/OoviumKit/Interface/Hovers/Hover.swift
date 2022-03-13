//
//  Hover.swift
//  Oovium
//
//  Created by Joe Charlier on 2/3/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import UIKit

open class Hover: Gadget {
	public unowned let aetherView: AetherView
	let anchor: Position
	let offset: UIOffset
	var fixed: UIOffset
	
	public init(aetherView: AetherView, anchor: Position, size: CGSize, offset: UIOffset, fixed: UIOffset = .zero) {
		self.aetherView = aetherView
		self.anchor = anchor
		self.offset = offset
		self.fixed = fixed
		super.init(size: size)
	}
	public required init?(coder: NSCoder) { fatalError() }
	
	var hs: CGFloat {
		return aetherView.hoverScale
	}

	func render() {
		var x: CGFloat
		var y: CGFloat

		let offsetX: CGFloat = fixed.horizontal + hs*offset.horizontal
		let offsetY: CGFloat = fixed.vertical + hs*offset.vertical
		
		if anchor.isLeft() { x = offsetX }
		else if anchor.isRight() { x = aetherView.width - hs*size.width + offsetX }
		else { x = (aetherView.width - hs*size.width) / 2 + offsetX}
		
		if anchor.isTop() { y = offsetY }
		else if anchor.isBottom() { y = aetherView.height - hs*size.height + offsetY }
		else { y = (aetherView.height - hs*size.height) / 2 + offsetY }

		frame = CGRect(x: x, y: y, width: hs*size.width, height: hs*size.height)
	}
	func reRender() {}
	func rescale() {}
	func retract() {}
	
// Events ==========================================================================================
	public func onFadeIn() {}
	public func onFadeOut() {}
	public func onInvoke() {}
	public func onDismiss() {}

// Gadget ==========================================================================================
	override var size: CGSize {
		didSet { render() }
	}
	public override func invoke(animated: Bool = true) {
		guard !aetherView.invoked(hover: self) else { return }
		render()
		self.alpha = 0
		aetherView.add(hover: self)
		self.onInvoke()
		if animated {
			UIView.animate(withDuration: 0.2) {
				self.alpha = 1
			} completion: { (completed: Bool) in
				self.onFadeIn()
			}
		} else {
			alpha = 1
			onFadeIn()
		}
	}
	public override func dismiss(animated: Bool = true) {
		guard aetherView.invoked(hover: self) else { return }
		self.onDismiss()
		if animated {
			UIView.animate(withDuration: 0.2) {
				self.alpha = 0
			} completion: { (completed: Bool) in
				guard completed else { return }
				self.aetherView.remove(hover: self)
				self.onFadeOut()
			}
		} else {
			alpha = 0
			self.aetherView.remove(hover: self)
			onFadeOut()
		}
	}
	public override func toggle(animated: Bool = true) {
		if aetherView.invoked(hover: self) { dismiss() }
		else { invoke() }
	}
}
