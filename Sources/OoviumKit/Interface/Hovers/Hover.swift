//
//  Hover.swift
//  Oovium
//
//  Created by Joe Charlier on 2/3/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import UIKit

public class Hover: Gadget {
	unowned let aetherView: AetherView
	let anchor: Position
	let offset: UIOffset
	var fixed: UIOffset
	
	init(aetherView: AetherView, anchor: Position, size: CGSize, offset: UIOffset, fixed: UIOffset = .zero) {
		self.aetherView = aetherView
		self.anchor = anchor
		self.offset = offset
		self.fixed = fixed
		super.init(size: size)
	}
	required init?(coder: NSCoder) { fatalError() }
	
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
	func onFadeIn() {}
	func onFadeOut() {}
	func onInvoke() {}
	func onDismiss() {}

// Gadget ==========================================================================================
	override var size: CGSize {
		didSet { render() }
	}
	override func invoke(animated: Bool = true) {
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
	override func dismiss(animated: Bool = true) {
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
	override func toggle(animated: Bool = true) {
		if aetherView.invoked(hover: self) { dismiss() }
		else { invoke() }
	}
}
