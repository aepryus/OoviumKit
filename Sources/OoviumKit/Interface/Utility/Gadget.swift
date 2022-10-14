//
//  Gadget.swift
//  Oovium
//
//  Created by Joe Charlier on 2/3/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

public protocol GadgetDelegate: UIView {
    var width: CGFloat { get }
    var height: CGFloat { get }
    var safeTop: CGFloat { get }
    var safeBottom: CGFloat { get }
    var safeLeft: CGFloat { get }
    var safeRight: CGFloat { get }
}

open class Gadget: UIView {
    unowned let delegate: GadgetDelegate?
    let anchor: Position
    var offset: UIOffset
    var fixed: UIOffset

    public init(delegate: GadgetDelegate?, anchor: Position, size: CGSize, offset: UIOffset, fixed: UIOffset = .zero) {
        self.delegate = delegate
        self.anchor = anchor
		self.size = size
        self.offset = offset
        self.fixed = fixed
		super.init(frame: CGRect(x: 0, y: 0, width: size.width*Oo.s, height: size.height*Oo.s))
		backgroundColor = UIColor.clear
	}
	public required init?(coder: NSCoder) { fatalError() }
    
// Events ==========================================================================================
    open func onFadeIn() {}
    open func onFadeOut() {}
    open func onInvoke() {}
    open func onDismiss() {}

// =================================================================================================
    public func render() {
        guard let delegate else { return }
        var x: CGFloat
        var y: CGFloat

        let offsetX: CGFloat = fixed.horizontal + gS*offset.horizontal
        let offsetY: CGFloat = fixed.vertical + gS*offset.vertical
        
        if anchor.isLeft { x = delegate.safeLeft + offsetX }
        else if anchor.isRight { x = -delegate.safeRight + delegate.width - gS*size.width + offsetX }
        else { x = (delegate.width - gS*size.width) / 2 + offsetX}
        
        if anchor.isTop { y = delegate.safeTop + offsetY }
        else if anchor.isBottom { y = -delegate.safeBottom + delegate.height - gS*size.height + offsetY }
        else { y = (delegate.height - gS*size.height) / 2 + offsetY }
        
        frame = CGRect(x: x, y: y, width: gS*size.width, height: gS*size.height)
    }
    
    public var size: CGSize {
        didSet { render() }
    }
    public func invoke(animated: Bool = true) {
        guard let delegate else { return }
//        guard !guideView.invoked(hover: self) else { return }
        render()
        self.alpha = 0
        delegate.addSubview(self)
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
    public func dismiss(animated: Bool = true) {
//        guard aetherView.invoked(hover: self) else { return }
        self.onDismiss()
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 0
            } completion: { (completed: Bool) in
                guard completed else { return }
                self.removeFromSuperview()
                self.onFadeOut()
            }
        } else {
            alpha = 0
            removeFromSuperview()
            onFadeOut()
        }
    }
}
