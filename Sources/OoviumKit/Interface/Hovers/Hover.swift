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
	
	public init(aetherView: AetherView, anchor: Position, size: CGSize, offset: UIOffset, fixed: UIOffset = .zero) {
		self.aetherView = aetherView
		super.init(guideView: aetherView, anchor: anchor, size: size, offset: offset, fixed: fixed)
	}
	public required init?(coder: NSCoder) { fatalError() }
	
	var hs: CGFloat {
		return aetherView.hoverScale
	}

	public func reRender() {}
	open func rescale() {}
	open func retract() {}
	
// Gadget ==========================================================================================
	override public var size: CGSize {
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
	public func toggle(animated: Bool = true) {
		if aetherView.invoked(hover: self) { dismiss() }
		else { invoke() }
	}
}
