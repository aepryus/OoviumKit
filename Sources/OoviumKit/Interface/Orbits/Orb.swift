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
    let aetherView: AetherView
    private let view: UIView
    private let dx: CGFloat
    private let dy: CGFloat
    private var orbits: [Orbit] = []
    
    init(aetherView: AetherView, view: UIView, dx: CGFloat, dy: CGFloat) {
        self.aetherView = aetherView
        self.view = view
        self.dx = dx
        self.dy = dy
        
        colorContext.shapeContext = shapeContext
        shapeContext.colorContext = colorContext
    }
    
// Private =========================================================================================
    private func layout(orbit: Orbit) {
        orbit.bottomRight(dx: -aetherView.safeRight + orbit.offset.horizontal, dy: -aetherView.safeBottom + orbit.offset.vertical)
    }
    
// Public ==========================================================================================
    var current: Orbit? { orbits.first }
    var hasOrbits: Bool { orbits.count > 0 }
    var isContext: Bool { hasOrbits && orbits.first is Context }
    func add(orbit: Orbit) {
        orbits.append(orbit)
        view.addSubview(orbit)
        layout(orbit: orbit)
        orbit.alpha = 0
        UIView.animate(withDuration: 0.2) {
            orbit.alpha = 1
        }
        orbit.onInvoke()
    }
    func remove(orbit: Orbit) {
        orbits.remove(object: orbit)
        UIView.animate(withDuration: 0.2) {
            orbit.alpha = 0
        } completion: { (completed: Bool) in
            orbit.removeFromSuperview()
        }
    }
    func toggle(orbit: Orbit) {
        if !orbits.contains(orbit) { add(orbit: orbit) }
        else { remove(orbit: orbit) }
    }

    func launch(orbit: Orbit) {
        guard orbits.count == 0 else { fatalError() }
        add(orbit: orbit)
    }
    func deorbit() {
        let orbits: [Orbit] = orbits
        self.orbits = []
        UIView.animate(withDuration: 0.2) {
            orbits.forEach { $0.alpha = 0 }
        } completion: { (completed: Bool) in
            orbits.forEach { $0.removeFromSuperview() }
        }
    }
    func layout() { orbits.forEach { layout(orbit: $0) } }
    
// Orbits ==========================================================================================
    lazy var alsoEditor: AlsoEditor = { AlsoEditor(orb: self) }()
    public lazy var chainEditor: ChainEditor = { ChainEditor(orb: self) }()
    lazy var colorEditor: ColorEditor = { ColorEditor(orb: self) }()
    lazy var headerEditor: HeaderEditor = { HeaderEditor(orb: self) }()
    lazy var lefterEditor: LefterEditor = { LefterEditor(orb: self) }()
    lazy var ooviEditor: OoviEditor = { OoviEditor(orb: self) }()
    lazy var signatureEditor: SignatureEditor = { SignatureEditor(orb: self) }()
    lazy var textEditor: TextEditor = { TextEditor(orb: self) }()

    lazy var multiContext: MultiContext = { MultiContext(orb: self) }()
    lazy var objectContext: ObjectContext = { ObjectContext(orb: self) }()
    lazy var typeContext: TypeContext = { TypeContext(orb: self) }()
    lazy var textContext: TextContext = { TextContext(orb: self) }()
    lazy var textMultiContext: TextMultiContext = { TextMultiContext(orb: self) }()
    lazy var colorContext: ColorContext = { ColorContext(orb: self) }()
    lazy var shapeContext: ShapeContext = { ShapeContext(orb: self) }()
    lazy var extendedColorContext: ExtendedColorContext = { ExtendedColorContext(orb: self) }()
}

//public class Orb {
//    var guideView: UIView { fatalError() }
//	var orbits: [Orbit] = []
//
//	func launch(orbit: Orbit) {
//        guard orbits.count == 0 else { fatalError() }
//		orbits = [orbit]
//	}
//	func deorbit() {
//		orbits = []
//	}
//
//	func add(orbit: Orbit) {
//		orbits.append(orbit)
//	}
//	func remove(orbit: Orbit) {
//		orbits.remove(object: orbit)
//	}
//	func toggle(orbit: Orbit) {
//		if !orbits.contains(orbit) { add(orbit: orbit) }
//		else { remove(orbit: orbit) }
//	}
//
//	// Orbits
//    lazy var alsoEditor: AlsoEditor = { AlsoEditor(orb: self) }()
//    public lazy var chainEditor: ChainEditor = { ChainEditor(orb: self) }()
//    lazy var colorEditor: ColorEditor = { ColorEditor(orb: self) }()
//    lazy var headerEditor: HeaderEditor = { HeaderEditor(orb: self) }()
//    lazy var lefterEditor: LefterEditor = { LefterEditor(orb: self) }()
//    lazy var ooviEditor: OoviEditor = { OoviEditor(orb: self) }()
//    lazy var signatureEditor: SignatureEditor = { SignatureEditor(orb: self) }()
//    lazy var textEditor: TextEditor = { TextEditor(orb: self) }()
//
//    lazy var multiContext: MultiContext = { MultiContext(orb: self) }()
//    lazy var objectContext: ObjectContext = { ObjectContext(orb: self) }()
//    lazy var typeContext: TypeContext = { TypeContext(orb: self) }()
//    lazy var textContext: TextContext = { TextContext(orb: self) }()
//    lazy var textMultiContext: TextMultiContext = { TextMultiContext(orb: self) }()
//    lazy var colorContext: ColorContext = { ColorContext(orb: self) }()
//    lazy var shapeContext: ShapeContext = { ShapeContext(orb: self) }()
//    lazy var extendedColorContext: ExtendedColorContext = { ExtendedColorContext(orb: self) }()
//}
//
//// ScreenOrb =======================================================================================
//class ScreenOrb: Orb {
//	var orbit: Orbit? = nil
//
//// Orb =============================================================================================
//    override var guideView: UIView { Screen.keyWindow! }
//
//	private func render(orbit: Orbit) {
//		var x: CGFloat
//		var y: CGFloat
//
//		let hoverScale = Oo.s
//		let offsetX: CGFloat = (orbit.offset.horizontal - 14) * hoverScale
//		let offsetY: CGFloat = (orbit.offset.vertical - 14) * hoverScale
//
//		x = Screen.width - hoverScale*orbit.size.width + offsetX
//		y = Screen.height - hoverScale*orbit.size.height + offsetY
//
//		orbit.frame = CGRect(x: x, y: y, width: hoverScale*orbit.size.width, height: hoverScale*orbit.size.height)
//	}
//
//    private func invoke(orbit: Orbit) {
//        render(orbit: orbit)
//        Screen.keyWindow!.addSubview(orbit)
//        orbit.alpha = 0
//        UIView.animate(withDuration: 0.2) {
//            orbit.alpha = 1
////        } completion: { (completed: Bool) in
////            orbit.onFadeIn()
//        }
//    }
//	override func launch(orbit: Orbit) {
//		super.launch(orbit: orbit)
//		guard orbit.superview == nil else { return }
//		self.orbit = orbit
//        invoke(orbit: orbit)
//	}
//	override func deorbit() {
//		super.deorbit()
//		UIView.animate(withDuration: 0.2) { [weak self] in
//			self?.orbit?.alpha = 0
//		} completion: { [weak self] (completed: Bool) in
//			guard completed, let self = self else { return }
//			self.orbit?.removeFromSuperview()
//			self.orbit = nil
////			self.onFadeOut()
//		}
//	}
//	override func add(orbit: Orbit) {
//		super.add(orbit: orbit)
//        invoke(orbit: orbit)
//		orbit.onInvoke()
//	}
//	override func remove(orbit: Orbit) {
//		super.remove(orbit: orbit)
//        deorbit()
//		orbit.onDismiss()
//	}
//}
//
//// AetherViewOrb ===================================================================================
//class AetherViewOrb: Orb {
//	let aetherView: AetherView
//
//	init(aetherView: AetherView) {
//		self.aetherView = aetherView
//	}
//
//// Orb =============================================================================================
//    override var guideView: UIView { aetherView }
//
//	override func launch(orbit: Orbit) {
//		super.launch(orbit: orbit)
//		aetherView.orb(it: orbit)
//		orbit.onInvoke()
//	}
//	override func deorbit() {
//		orbits.forEach {
//			aetherView.deorb(it: $0)
//			$0.onDismiss()
//		}
//		super.deorbit()
//	}
//	override func add(orbit: Orbit) {
//		super.add(orbit: orbit)
//		aetherView.orb(it: orbit)
//		orbit.onInvoke()
//	}
//	override func remove(orbit: Orbit) {
//		super.remove(orbit: orbit)
//		aetherView.deorb(it: orbit)
//		orbit.onDismiss()
//	}
//}
//
//// FloatingOrb =====================================================================================
//class FloatingOrb: Orb {
//// Orb =============================================================================================
//	override func launch(orbit: Orbit) {
//		super.launch(orbit: orbit)
//	}
//	override func deorbit() {
//		super.deorbit()
//	}
//}
