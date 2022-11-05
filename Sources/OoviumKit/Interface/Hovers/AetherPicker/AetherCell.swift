//
//  AetherCell.swift
//  Oovium
//
//  Created by Joe Charlier on 8/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class AetherCell: UITableViewCell, UIContextMenuInteractionDelegate {
	var aetherName: String = "" {
		didSet { nameLabel.text = aetherName }
	}
	unowned var aetherPicker: AetherPicker! = nil

	private let nameSplitter: SplitterView = SplitterView(contentView: Box(), split: .horizontal, radius: 17)
	private let nameLabel: Label = Label()
	private let deleteBox: Box = Box(uiColor: .red)
	private let deleteLabel: Label = Label(text: "Delete".localized, uiColor: .red)

	private lazy var panGesture = { UIPanGestureRecognizer(target: self, action: #selector(onPan(_:))) }()

	static var shippedAethers: [String] = ["Day & Night", "Demons", "Game of Life", "Move", "Sweetness", "WalledCities"]

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.backgroundColor = UIColor.clear

		addSubview(nameSplitter)
		addSubview(nameLabel)
		addSubview(deleteBox)
		addSubview(deleteLabel)

		nameLabel.addAction { [unowned self] in
			switch self.state {
				case .normal:
                    break
//					Space.digest(space: .local, name: self.aetherName) { (aether: Aether?) in
//						guard let aether = aether else { return }
//						self.aetherPicker.aetherView.swapToAether(space: Space.local, aether: aether)
//					}
				case .deletable:
					self.state = .normal
					self.animateTransitionIfNeeded(state: self.state, duration: 0.3)
			}
			self.aetherPicker.makeDeletable(cell: nil)
		}

		deleteLabel.isUserInteractionEnabled = false
		deleteBox.addAction(for: [.touchDown, .touchDragEnter]) { [unowned self] in
			self.deleteBox.uiColor = .white
			self.deleteLabel.uiColor = .white
		}
		deleteBox.addAction(for: [.touchUpInside, .touchDragExit, .touchCancel]) { [unowned self] in
			self.deleteBox.uiColor = .red
			self.deleteLabel.uiColor = .red
		}
		deleteBox.addAction { [unowned self] in
			self.aetherPicker.retract()

			if self.aetherName == self.aetherPicker.aetherView.aether.name {
//				Space.local.loadNames { (names: [String]) in
//					if names.count == 0 {
//						Space.local.newAether { (aether: Aether?) in
//							guard let aether = aether else { return }
//							self.aetherPicker.aetherView.swapToAether(space: Space.local, aether: aether)
//							Space.local.removeAether(name: self.aetherName) { (success: Bool) in
//								DispatchQueue.main.async { self.aetherPicker.loadAetherNames() }
//							}
//						}
//					} else {
//						Space.digest(space: .local, name: names[names[0] != self.aetherName ? 0 : 1]) { (aether: Aether?) in
//							guard let aether = aether else { return }
//							self.aetherPicker.aetherView.swapToAether(space: Space.local, aether: aether)
//							Space.local.removeAether(name: self.aetherName) { (success: Bool) in
//								DispatchQueue.main.async { self.aetherPicker.loadAetherNames() }
//							}
//						}
//					}
//				}
			} else {
//				Space.local.removeAether(name: self.aetherName) { (success: Bool) in
//					DispatchQueue.main.async { self.aetherPicker.loadAetherNames() }
//				}
			}
		}

		panGesture.delegate = self
		addGestureRecognizer(panGesture)

		addInteraction(UIContextMenuInteraction(delegate: self))

		deleteBox.alpha = 0
		deleteLabel.alpha = 0

		contentView.isUserInteractionEnabled = false
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }

	func hideDeleteButton() {
		state = .normal
		animateTransitionIfNeeded(state: state, duration: 0.3)
	}

// States and Animation ============================================================================
	enum State { case normal, deletable }
	var state: State = .normal
	var animators: [UIViewPropertyAnimator] = []

	func animateTransitionIfNeeded(state: State, duration: TimeInterval) {
		guard animators.isEmpty else { return }

		let animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
			UIView.animateKeyframes(withDuration: duration, delay: 0, options: []) {
				switch state {
					case .normal:
						UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
							self.nameSplitter.left(width: self.width, height: self.height)
							self.nameLabel.left(width: self.width, height: self.height)
						}
					case .deletable:
						UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.7) {
							self.nameSplitter.left(width: self.width-72*self.s, height: self.height)
							self.nameLabel.left(dx: -72*self.s/2)
						}
				}
			}
		}

		animator.addCompletion { (position: UIViewAnimatingPosition) in self.animators.remove(object: animator) }
		animator.startAnimation()
		animators.append(animator)

		let aB = UIViewPropertyAnimator(duration: duration, curve: .linear) {
			UIView.animateKeyframes(withDuration: duration, delay: 0, options: []) {
				switch state {
					case .normal:
						UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
							self.deleteBox.alpha = 0
							self.deleteLabel.alpha = 0
						}
					case .deletable:
						UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3) {
							self.deleteBox.alpha = 1
							self.deleteLabel.alpha = 1
						}
				}
			}
		}

		aB.addCompletion { (position: UIViewAnimatingPosition) in self.animators.remove(object: aB) }
		aB.startAnimation()
		animators.append(aB)
	}
	func startInteractiveTransition(state: State, duration: TimeInterval) {
		animateTransitionIfNeeded(state: state, duration: duration)
		animators.forEach { $0.pauseAnimation() }

	}
	func updateInteractiveTransition(fractionComplete: CGFloat) {
		animators.forEach { $0.fractionComplete = fractionComplete }
	}
	func continueInteractiveTransition(cancel: Bool) {
		if !cancel { state = state == .normal ? .deletable : .normal }
		else { animators.forEach { $0.isReversed = true } }
		animators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
	}
	
// Events ==========================================================================================
	@objc func onPan(_ gesture: UIPanGestureRecognizer) {
		guard !AetherCell.shippedAethers.contains(aetherName) else { return }
		switch gesture.state {
			case .began:
				startInteractiveTransition(state: state == .normal ? .deletable : .normal, duration: 0.3)
				if aetherPicker.deletableCell != self { aetherPicker.makeDeletable(cell: nil) }
			case .changed:
				let fractionComplete: CGFloat = ((state == .normal ? -1 : 1)*gesture.translation(in: self).x / (72*s)).clamped(to: 0...1)
				updateInteractiveTransition(fractionComplete: fractionComplete)
			case .ended:
				let cancel: Bool
				let v = gesture.velocity(in: self).x
				if abs(v) > 100 {
					cancel = (state == .normal && v > 0) || (state == .deletable && v < 0)
				} else {
					let fractionComplete: CGFloat = ((state == .normal ? -1 : 1)*gesture.translation(in: self).x / (72*s)).clamped(to: 0...1)
					cancel = fractionComplete < 0.5
				}
				continueInteractiveTransition(cancel: cancel)
				aetherPicker.makeDeletable(cell: state == .normal ? nil : self)
			default: print("unxepected state: \(gesture.state)")
		}
	}

// UIView ==========================================================================================
	var layedOut: Bool = false
	override func layoutSubviews() {
		if !layedOut {
			nameSplitter.left(width: min(width, width), height: height)
			nameLabel.left(width: min(width, width), height: height)
			deleteBox.right(width: 72*s+7*Oo.s, height: height)
			deleteLabel.right(width: 72*s+7*Oo.s, height: height)
			layedOut = true
		}
	}

// UIGestureRecognizerDelegate =====================================================================
	override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
		guard let gesture = gestureRecognizer as? UIPanGestureRecognizer else { return super.gestureRecognizerShouldBegin(gestureRecognizer) }
		let v = gesture.velocity(in: self)
		return abs(v.x) > abs(v.y)
	}
	override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
// UIContextMenuInteractionDelegate ================================================================
	public func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
		guard Screen.mac && !AetherCell.shippedAethers.contains(aetherName) else { return nil }
		state = state == .normal ? .deletable : .normal
		animateTransitionIfNeeded(state: state, duration: 0.3)
		aetherPicker.makeDeletable(cell: state == .normal ? nil : self)
		return nil
	}

// Box =============================================================================================
	private class Box: UIControl {
		var uiColor: UIColor? {
			didSet { setNeedsDisplay() }
		}

		init(uiColor: UIColor? = nil) {
			self.uiColor = uiColor
			super.init(frame: .zero)
			backgroundColor = .clear
		}
		required init?(coder: NSCoder) { fatalError() }

		// UIView ==================================================================================
		override func draw(_ rect: CGRect) {
			let p: CGFloat = 5.0/3.0*Oo.s
			let q: CGFloat = 13*Oo.s-p
			let w: CGFloat = rect.width
			let ir: CGFloat = 3*Oo.s
			let or: CGFloat = 3*Oo.s

			let x1 = p+4*Oo.s
			let x2 = x1
			let x3 = x2
			let x4 = w/2
			let x7 = w-p-4*Oo.s
			let x6 = x7
			let x5 = x6

			let y1 = p
			let y2 = y1+q
			let y3 = y2+q

			let path = CGMutablePath()
			path.move(to: CGPoint(x: x2, y: y2))
			path.addArc(tangent1End: CGPoint(x: x3, y: y1), tangent2End: CGPoint(x: x4, y: y1), radius: or)
			path.addArc(tangent1End: CGPoint(x: x7, y: y1), tangent2End: CGPoint(x: x6, y: y2), radius: ir)
			path.addArc(tangent1End: CGPoint(x: x5, y: y3), tangent2End: CGPoint(x: x4, y: y3), radius: or)
			path.addArc(tangent1End: CGPoint(x: x3, y: y3), tangent2End: CGPoint(x: x2, y: y2), radius: ir)
			path.closeSubpath()

			Skin.aetherCell(path: path, uiColor: uiColor)
		}
	}

// Label ===========================================================================================
	private class Label: UIControl {
		var text: String {
			didSet { setNeedsDisplay() }
		}
		var uiColor: UIColor? {
			didSet { setNeedsDisplay() }
		}

		init(text: String = "", uiColor: UIColor? = nil) {
			self.text = text
			self.uiColor = uiColor
			super.init(frame: .zero)
			backgroundColor = .clear
		}
		required init?(coder: NSCoder) { fatalError() }

		// UIView ==================================================================================
		override func draw(_ rect: CGRect) {
			let p: CGFloat = 5.0/3.0*Oo.s
			let q: CGFloat = 13*Oo.s-p
			let w: CGFloat = rect.width

			let x1 = p+4*Oo.s
			let x2 = x1
			let x7 = w-p-4*Oo.s
			let x6 = x7

			let y1 = p
			let y2 = y1+q
			let y3 = y2+q

			Skin.aetherCell(text: text, rect: CGRect(x: x2, y: 4*Oo.s+0.5, width: x6-x2, height: y3-y1), uiColor: uiColor)
		}
	}
}
