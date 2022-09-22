//
//  ToolBar.swift
//  Oovium
//
//  Created by Joe Charlier on 8/4/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class ToolBar: Hover {
	var tools: [[Tool?]]
	var selected: Tool
	var expanded: Bool
	
	var onSelect: (Tool)->() = {(tool: Tool) in }
	
	let numberOfColumns: CGFloat
	let numberOfRows: CGFloat
	
	var contracting: Bool = false

	static let fixed: UIOffset = Screen.mac ? UIOffset(horizontal: -14, vertical: 5)
								: Screen.iPad ? UIOffset(horizontal: -4, vertical: Screen.safeTop)
								: UIOffset(horizontal: -5, vertical: Screen.safeTop - 3)

	init(aetherView: AetherView, toolBox: ToolBox, offset: UIOffset, fixed: UIOffset) {
		self.tools = toolBox.tools
		selected = self.tools[0][0]!
		expanded = false
		
		numberOfColumns = CGFloat(self.tools.count)
		numberOfRows = CGFloat(self.tools[0].count)
		
		super.init(aetherView: aetherView, anchor: .topRight, size: CGSize.zero, offset: offset, fixed: fixed)
		
		for column: [Tool?] in tools {
			for tool: Tool? in column {
				if let tool = tool {
					tool.toolBar = self
					tool.alpha = 0
				}
			}
		}
		
		size = CGSize(width: 40, height: 40)
		selected.frame = CGRect(x: 0, y: 0, width: 40*Oo.s, height: 40*Oo.s)
		selected.alpha = 1
		addSubview(selected)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}

	private func selectedOrigin() -> CGPoint {
		var c: CGFloat = 0
		var r: CGFloat = 0
		for column: [Tool?] in tools {
			for tool: Tool? in column {
				if let tool = tool, tool == selected {
					return CGPoint(x: (CGFloat(tools.count)-(c+1))*40*Oo.s, y: r*40*Oo.s)
				}
				r += 1
			}
			c += 1
			r = 0
		}
		return CGPoint.zero
	}
	
	func expand() {
		guard !expanded else { return }
		expanded = true
		onExpand()
		self.size = CGSize(width: self.numberOfColumns*40, height: self.numberOfRows*40)
		render()
		self.selected.frame = CGRect(x: (self.numberOfColumns-1)*40*Oo.s, y: 0, width: 40*Oo.s, height: 40*Oo.s)
		for column: [Tool?] in tools {
			for tool: Tool? in column {
				if let tool = tool, tool != selected {
					addSubview(tool)
				}
			}
		}
		let origin = selectedOrigin()
		UIView.animate(withDuration: 0.2) {
			self.selected.frame = CGRect(x: origin.x, y: origin.y, width: 40*Oo.s, height: 40*Oo.s)
			for column: [Tool?] in self.tools {
				for tool: Tool? in column {
					if let tool = tool, tool != self.selected {
						tool.alpha = 1
					}
				}
			}
		}
	}
	func contract() {
		guard expanded else { return }
		contracting = true
		expanded = false
		onContract()
		UIView.animate(withDuration: 0.2, animations: {
			self.selected.frame = CGRect(x: (self.numberOfColumns-1)*40*Oo.s, y: 0, width: 40*Oo.s, height: 40*Oo.s)
			for column: [Tool?] in self.tools {
				for tool: Tool? in column {
					if let tool = tool, tool != self.selected {
						tool.alpha = 0
					}
				}
			}
		}) { (cancelled: Bool) in
			for column: [Tool?] in self.tools {
				for tool: Tool? in column {
					if let tool = tool, tool != self.selected {
						tool.removeFromSuperview()
					}
				}
			}
			self.size = CGSize(width: 40, height: 40)
			self.contracting = false
			self.render()
			self.selected.frame = CGRect(x: 0, y: 0, width: 40*Oo.s, height: 40*Oo.s)
		}
	}
	
	func select(tool: Tool) {
		if expanded {
			selected.onDeselect()
			selected = tool
			selected.onSelect()
			onSelect(tool)
			contract()
		} else {
			expand()
		}
	}
	func recoilSelect(tool: Tool) {
		selected.onDeselect()
		selected.removeFromSuperview()
		let origin = selectedOrigin()
		selected.frame = CGRect(x: origin.x, y: origin.y, width: 40*Oo.s, height: 40*Oo.s)
		selected.alpha = 0
		
		selected = tool
		selected.frame = CGRect(x: 0, y: 0, width: 40*Oo.s, height: 40*Oo.s)
		selected.alpha = 1
		addSubview(selected)
		selected.onSelect()
		onSelect(tool)
	}
	
// Events ==========================================================================================
	func onExpand() {}
	func onContract() {}
	
// Hover ===========================================================================================
	override func render() {
		guard !contracting else { return }
		super.render()
		var c: CGFloat = 0
		var r: CGFloat = 0
		for column: [Tool?] in tools {
			for tool: Tool? in column {
				if let tool = tool {
					tool.frame = CGRect(x: (CGFloat(tools.count)-(c+1))*40*Oo.s, y: r*40*Oo.s, width: 40*Oo.s, height: 40*Oo.s)
					tool.render()
					tool.setNeedsDisplay()
				}
				r += 1
			}
			c += 1
			r = 0
		}
		if !expanded { selected.frame = CGRect(x: 0, y: 0, width: 40*Oo.s, height: 40*Oo.s) }
	}
	override func reRender() {
		tools.forEach { $0.forEach { if let tool = $0 { tool.setNeedsDisplay() } } }
	}
	override func rescale() {
		super.rescale()
		var c: CGFloat = 0
		var r: CGFloat = 0
		for column: [Tool?] in tools {
			for tool: Tool? in column {
				if let tool = tool {
					tool.frame = CGRect(x: (CGFloat(tools.count)-(c+1))*40*Oo.s, y: r*40*Oo.s, width: 40*Oo.s, height: 40*Oo.s)
					tool.rescale()
				}
				r += 1
			}
			c += 1
			r = 0
		}
		if !expanded {
			self.selected.frame = CGRect(x: 0, y: 0, width: 40*Oo.s, height: 40*Oo.s)
			self.selected.rescale()
		}
	}
	override func retract() {
		contract()
	}

// UIView ==========================================================================================
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let view = super.hitTest(point, with: event)
		return view != self ? view : nil
	}
}
