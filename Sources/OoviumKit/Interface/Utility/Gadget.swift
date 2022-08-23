//
//  Gadget.swift
//  Oovium
//
//  Created by Joe Charlier on 2/3/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import UIKit

open class Gadget: UIView {
    let guideView: UIView
    let anchor: Position
	var size: CGSize
    var offset: UIOffset
    var fixed: UIOffset

	public func invoke(animated: Bool = true) {}
	public func dismiss(animated: Bool = true) {}
	public func toggle(animated: Bool = true) {}
	
    public init(guideView: UIView, anchor: Position, size: CGSize, offset: UIOffset, fixed: UIOffset = .zero) {
        self.guideView = guideView
        self.anchor = anchor
		self.size = size
        self.offset = offset
        self.fixed = fixed
		super.init(frame: CGRect(x: 0, y: 0, width: size.width*Oo.s, height: size.height*Oo.s))
		backgroundColor = UIColor.clear
	}
	public required init?(coder: NSCoder) { fatalError() }
    
    public func render() {
        var x: CGFloat
        var y: CGFloat

        let offsetX: CGFloat = fixed.horizontal + gS*offset.horizontal
        let offsetY: CGFloat = fixed.vertical + gS*offset.vertical
        
        if anchor.isLeft() { x = offsetX }
        else if anchor.isRight() { x = guideView.width - gS*size.width + offsetX }
        else { x = (guideView.width - gS*size.width) / 2 + offsetX}
        
        if anchor.isTop() { y = offsetY }
        else if anchor.isBottom() { y = guideView.height - gS*size.height + offsetY }
        else { y = (guideView.height - gS*size.height) / 2 + offsetY }

        frame = CGRect(x: x, y: y, width: gS*size.width, height: gS*size.height)
    }
}
