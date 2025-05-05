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
    public class ShieldView: ColorView, GadgetDelegate {
        init() { super.init(.black.alpha(0.8)) }
        required init?(coder: NSCoder) { fatalError() }
        
        public func render() {
            frame = Screen.keyWindow!.bounds
        }
        
        // UIView ==================================================================================
        public override var frame: CGRect {
            didSet { Modal.current?.render() }
        }
        
        // GadgetDelegate ==========================================================================
        public var safeTop: CGFloat { 0 }
        public var safeBottom: CGFloat { 0 }
        public var safeLeft: CGFloat { 0 }
        public var safeRight: CGFloat { 0 }
    }
    public static var shieldView: ShieldView = {
        let view: ShieldView = ShieldView()
        view.render()
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
        Modal.shieldView.render()
        Screen.keyWindow!.addSubview(Modal.shieldView)
        Modal.current = self
    }
    override open func onDismiss() {
        Modal.shieldView.removeFromSuperview()
        Modal.current = nil
    }
    
// Static ==========================================================================================
    public static var current: Modal?    
}
