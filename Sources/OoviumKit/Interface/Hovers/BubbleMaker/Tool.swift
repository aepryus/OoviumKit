//
//  Tool.swift
//  Oovium
//
//  Created by Joe Charlier on 8/4/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

public class ToolBox {
	let tools: [[Tool?]]
	
	public init(_ tools: [[Tool?]]) {
		self.tools = tools
	}
	
	func contains(_ tool: Tool) -> Bool {
		for column in tools {
			for cell in column {
				guard let cell = cell else {continue}
				if tool === cell {return true}
			}
		}
		return false
	}	
}

public class Tool: UIView {
	var toolBar: ToolBar!
	
	init() {
		super.init(frame: CGRect.zero)
		backgroundColor = UIColor.clear
		
		let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
		addGestureRecognizer(gesture)
	}
	public required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func render() {}
	func rescale() {}
	
// Events ==========================================================================================
	@objc func onTap() {
		toolBar.select(tool: self)
	}
	func onSelect() {}
	func onDeselect() {}
	
// UIView ==========================================================================================
	public override func draw(_ rect: CGRect) {
		let path = CGPath(roundedRect: rect.insetBy(dx: 2*Oo.s, dy: 2*Oo.s), cornerWidth: 6*Oo.s, cornerHeight: 6*Oo.s, transform: nil)
		Skin.tool(path: path)
	}
}
