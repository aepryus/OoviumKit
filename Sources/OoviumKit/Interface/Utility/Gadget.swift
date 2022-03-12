//
//  Gadget.swift
//  Oovium
//
//  Created by Joe Charlier on 2/3/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import UIKit

open class Gadget: UIView {
	var size: CGSize = CGSize.zero
	
	public func invoke(animated: Bool = true) {}
	public func dismiss(animated: Bool = true) {}
	public func toggle(animated: Bool = true) {}
	
	public init(size: CGSize) {
		self.size = size
		super.init(frame: CGRect(x: 0, y: 0, width: size.width*Oo.s, height: size.height*Oo.s))
		backgroundColor = UIColor.clear
	}
	public required init?(coder: NSCoder) { fatalError() }
}
