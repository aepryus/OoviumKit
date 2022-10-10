//
//  Modal.swift
//  Oovium
//
//  Created by Joe Charlier on 2/3/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

public enum Orientations {
	case portrait, landscape, both
}

open class Modal: Gadget {
    class ShieldView: ColorView, GadgetDelegate {
        init() { super.init(.black.alpha(0.8)) }
        required init?(coder: NSCoder) { fatalError() }
        
        // GadgetDelegate ==========================================================================
        var safeTop: CGFloat { 0 }
        var safeBottom: CGFloat { 0 }
        var safeLeft: CGFloat { 0 }
        var safeRight: CGFloat { 0 }
    }
    static var shieldView: ShieldView = {
        let view: ShieldView = ShieldView()
        view.frame = Screen.keyWindow!.bounds
        return view
    }()
    
	public var forcedOrientation: UIInterfaceOrientationMask = .all
	let orientations: Orientations

	public init(anchor: Position, size: CGSize = .zero, offset: UIOffset = .zero, fixed: UIOffset = .zero, orientations: Orientations = .both) {
		self.orientations = orientations
        super.init(delegate: Modal.shieldView, anchor: anchor, size: size, offset: offset)
	}
	public required init?(coder: NSCoder) { fatalError() }
    
// Gadget ==========================================================================================
    override open func onInvoke() {
        Modal.shieldView.frame = Screen.keyWindow!.bounds
        Screen.keyWindow!.addSubview(Modal.shieldView)
    }
    override open func onDismiss() {
        Modal.shieldView.removeFromSuperview()
    }
}
