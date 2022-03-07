//
//  AlsoLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 4/19/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class AlsoLeaf: Leaf, Editable, DoubleTappable {
	private let also: Also
	
	static private let pen: Pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!)
	
	init(bubble: Bubble) {
		also = (bubble as! AlsoBub).also
		super.init(bubble: bubble)
		
//		let gesture = DoubleTap(target: self, action: #selector(onDoubleTap), aetherView: bubble.aetherView)
//		gesture.delegate = bubble.aetherView
//		addGestureRecognizer(gesture)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	var alsoBub: AlsoBub {
		return bubble as! AlsoBub
	}

	var aetherName: String {
		set {
			also.aetherPath = "local::\(newValue)"
			alsoBub.render()
			alsoBub.functionsLeaf.setNeedsDisplay()
//			aetherView.saveAether()
//			aetherView.swapToAether(name: also.aether.name)
//			let space: Space = Space.spaces[also.spaceKey]
//			let aether: Aether = space.loadAether(name: space.aetherNames[space.aetherNames[0] != aetherName ? 0 : 1])
//			Oovium.aetherView.swapToAether(space: space, aether: aether)
		}
		get { Space.split(aetherPath: also.aetherPath).1 }
	}
	
	var uiColor: UIColor {
		return focused ? UIColor.white : bubble.uiColor
	}
	
	func render() {
		let tw: CGFloat = (also.aetherName as NSString).size(pen: AlsoLeaf.pen).width
		size = CGSize(width: max(130*s, tw+24*s), height: 40*s)
	}
	
// Events ==========================================================================================
	@objc func onDoubleTap() {
		aetherView.saveAether()
		Space.digest(aetherPath: also.aetherPath) { (spaceAether: (Space, Aether)?) in
			guard let spaceAether = spaceAether else { return }
			self.aetherView.swapToAether(spaceAether)
		}
	}

// Editable ========================================================================================
	var editor: Orbit {
		return orb.alsoEditor.edit(editable: self)
	}
	
	func onMakeFocus() {
		setNeedsDisplay()
	}
	func onReleaseFocus() {
		alsoBub.onOK()
		setNeedsDisplay()
	}
	func cite(_ citable: Citable, at: CGPoint) {
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let path = CGPath(roundedRect: rect.insetBy(dx: 2, dy: 2), cornerWidth: 18, cornerHeight: 18, transform: nil)
		Skin.bubble(path: path, uiColor: uiColor, width: 4.0/3.0*Oo.s)
		Skin.text(also.aetherName, rect: CGRect(x: 0, y: 11, width: width, height: 21), uiColor: uiColor, font: UIFont(name: "HelveticaNeue", size: 16)!, align: .center)
	}
}
