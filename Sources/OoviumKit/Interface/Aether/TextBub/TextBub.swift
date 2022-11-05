//
//  TextBub.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class TextMaker: Maker {
	
// Maker ===========================================================================================
	func make(aetherView: AetherView, at: V2) -> Bubble {
        let text: Text = aetherView.aether.create(at: at)
		text.shape = aetherView.shape
		text.color = aetherView.color
		return TextBub(text, aetherView: aetherView)
	}
	func drawIcon() {
		OOShape.ellipse.shape.drawIcon(color: UIColor.orange)
	}
}

class TextBub: Bubble, NSCopying {
	let text: Text
	var textLeaf: TextLeaf!
	
	var color: OOColor {
		get {return text.color}
		set {
			text.color = newValue
			render()
		}
	}
	var shape: OOShape {
		get {return text.shape}
		set {
			text.shape = newValue
			render()
		}
	}
	
	init(_ text: Text, aetherView: AetherView) {
		self.text = text
		
		super.init(aetherView: aetherView, aexel: text, origin: CGPoint(x: self.text.x, y: self.text.y), size: CGSize.zero)
		
		textLeaf = TextLeaf(bubble: self)
		
		textLeaf.frame = CGRect(x: 0, y: 0, width: 36, height: 36)
		add(leaf: textLeaf)
		
		render()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func render() {
		textLeaf.render()
		bounds = textLeaf.frame
	}
	
	func delete() {
        aetherView.aether.remove(aexel: text)
		aetherView.remove(bubble: self)
	}
	
// Events ==========================================================================================
	override func onCreate() {
		alpha = 0
		UIView.animate(withDuration: 0.1) {
			self.alpha = 1
		}
		textLeaf.editMode()
	}
	func onOK() {}

// Bubble ==========================================================================================
	override var uiColor: UIColor {
		return !selected ? text.color.uiColor : UIColor.yellow
	}
	override var context: Context { orb.textContext }
	override var multiContext: Context { orb.textMultiContext }
	
// UIView ==========================================================================================
	override var frame: CGRect {
		didSet {textLeaf?.mooring.point = center}
	}
	
// NSCopying =======================================================================================
	func copy(with zone: NSZone? = nil) -> Any {
		let copy: Text = text.copy() as! Text
		return TextBub(copy, aetherView: aetherView)
	}
}
