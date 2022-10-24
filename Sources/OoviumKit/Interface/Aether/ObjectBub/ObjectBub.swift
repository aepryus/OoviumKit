//
//  ObjectBub.swift
//  Oovium
//
//  Created by Joe Charlier on 4/9/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class ObjectMaker: Maker {
// Maker ===========================================================================================
	func make(aetherView: AetherView, at: V2) -> Bubble {
        let object: Object = aetherView.aether.create(at: at)
		return ObjectBub(object, aetherView: aetherView)
	}
	func drawIcon() {
		let bw = 20*Oo.s
		let bh = 20*Oo.s
		let r: CGFloat = 6*Oo.s

		let x1 = bw-10*Oo.s
		let x2 = bw
		let x3 = bw+10*Oo.s
		
		let y1 = bh-8*Oo.s
		let y2 = bh
		let y3 = bh+8*Oo.s
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x1, y: y2))
		path.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x2, y: y1), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y1), tangent2End: CGPoint(x: x3, y: y2), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y3), tangent2End: CGPoint(x: x2, y: y3), radius: r)
		path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x1, y: y2), radius: r)
		path.closeSubpath()
		
		Skin.bubble(path: path, uiColor: UIColor.green, width: 4.0/3.0*Oo.s)
	}
}

class ObjectBub: Bubble, Citable {
	let object: Object
	
	lazy var objectLeaf: ObjectLeaf = { ObjectLeaf(bubble: self) }()
	
	required init(_ object: Object, aetherView: AetherView) {
		self.object = object
		
		super.init(aetherView: aetherView, aexel: object, origin: CGPoint(x: self.object.x, y: self.object.y), size: .zero)
        
		add(leaf: objectLeaf)
		objectLeaf.render()
		
		layoutLeaves()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
    
    var isEmpty: Bool { object.chain.tokens.count == 0 && object.label.count == 0 }
	
// Events ==========================================================================================
	override func onCreate() { objectLeaf.makeFocus(dismissEditor: false) }
    override func onRemove() { objectLeaf.deinitMoorings() }
	override func onSelect() {}
	override func onUnselect() {}

    func onOK() {
        if isEmpty {
            aetherView.aether.removeAexel(object)
            aetherView.remove(bubble: self)
            aetherView.aether.buildMemory()
        }
        aetherView.stretch()
    }

// Bubble ==========================================================================================
	override var context: Context { orb.objectContext }
	
// Citable =========================================================================================
	func token(at: CGPoint) -> Token? { object.token }
}
