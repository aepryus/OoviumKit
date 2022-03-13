//
//  Orb.swift
//  Oovium
//
//  Created by Joe Charlier on 2/9/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

public class Orb {
	var orbits: [Orbit] = []
	
	func orb(it orbit: Orbit) {
		orbits = [orbit]
		orbit.orb = self
	}
	func deorbit() {
		orbits.forEach { $0.orb = nil}
		orbits = []
	}
	func add(orbit: Orbit) {
		orbits.append(orbit)
		orbit.orb = self
	}
	func remove(orbit: Orbit) {
		orbits.remove(object: orbit)
		orbit.orb = nil
	}
	func toggle(orbit: Orbit) {
		if !orbits.contains(orbit) { add(orbit: orbit) }
		else { remove(orbit: orbit) }
	}

	// Orbits
	let alsoEditor: AlsoEditor = AlsoEditor()
	let chainEditor: ChainEditor = ChainEditor()
	let colorEditor: ColorEditor = ColorEditor()
	let headerEditor: HeaderEditor = HeaderEditor()
	let lefterEditor: LefterEditor = LefterEditor()
	let ooviEditor: OoviEditor = OoviEditor()
	let signatureEditor: SignatureEditor = SignatureEditor()
	let textEditor: TextEditor = TextEditor()

	let multiContext: MultiContext = MultiContext()
	let objectContext: ObjectContext = ObjectContext()
	let typeContext: TypeContext = TypeContext()
	let textContext: TextContext = TextContext()
	let colorContext: ColorContext = ColorContext()
	let shapeContext: ShapeContext = ShapeContext()
	let extendedColorContext: ExtendedColorContext = ExtendedColorContext()
}

// ScreenOrb =======================================================================================
class ScreenOrb: Orb {
	var orbit: Orbit? = nil

// Orb =============================================================================================
	private func render(orbit: Orbit) {
		var x: CGFloat
		var y: CGFloat

		let hoverScale = Oo.s
		let offsetX: CGFloat = (orbit.offset.horizontal - 14) * hoverScale
		let offsetY: CGFloat = (orbit.offset.vertical - 14) * hoverScale

		x = Screen.width - hoverScale*orbit.size.width + offsetX
		y = Screen.height - hoverScale*orbit.size.height + offsetY

		orbit.frame = CGRect(x: x, y: y, width: hoverScale*orbit.size.width, height: hoverScale*orbit.size.height)
	}

	override func orb(it orbit: Orbit) {
		super.orb(it: orbit)
		guard orbit.superview == nil else { return }
		self.orbit = orbit
		render(orbit: orbit)
		Screen.keyWindow!.addSubview(orbit)
		orbit.alpha = 0
		UIView.animate(withDuration: 0.2) {
			orbit.alpha = 1
//		} completion: { (completed: Bool) in
//			orbit.onFadeIn()
		}
	}
	override func deorbit() {
		super.deorbit()
		UIView.animate(withDuration: 0.2) { [weak self] in
			self?.orbit?.alpha = 0
		} completion: { [weak self] (completed: Bool) in
			guard completed, let self = self else { return }
			self.orbit?.removeFromSuperview()
			self.orbit = nil
//			self.onFadeOut()
		}
	}
	override func add(orbit: Orbit) {
		super.add(orbit: orbit)
		orbit.onInvoke()
	}
	override func remove(orbit: Orbit) {
		super.remove(orbit: orbit)
		orbit.onDismiss()
	}
}

// AetherViewOrb ===================================================================================
class AetherViewOrb: Orb {
	let aetherView: AetherView
	
	init(aetherView: AetherView) {
		self.aetherView = aetherView
	}
	
// Orb =============================================================================================
	override func orb(it orbit: Orbit) {
		super.orb(it: orbit)
		aetherView.orb(it: orbit)
		orbit.onInvoke()
	}
	override func deorbit() {
		orbits.forEach {
			aetherView.deorb(it: $0)
			$0.onDismiss()
		}
		super.deorbit()
	}
	override func add(orbit: Orbit) {
		super.add(orbit: orbit)
		aetherView.orb(it: orbit)
		orbit.onInvoke()
	}
	override func remove(orbit: Orbit) {
		super.remove(orbit: orbit)
		aetherView.deorb(it: orbit)
		orbit.onDismiss()
	}
}

// FloatingOrb =====================================================================================
class FloatingOrb: Orb {
// Orb =============================================================================================
	override func orb(it orbit: Orbit) {
		super.orb(it: orbit)
	}
	override func deorbit() {
		super.deorbit()
	}
}
