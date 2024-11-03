//
//  ObjectBub.swift
//  Oovium
//
//  Created by Joe Charlier on 4/9/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class ObjectBub: Bubble, Citable {
	let object: Object
	
	lazy var objectLeaf: ObjectLeaf = { ObjectLeaf(bubble: self) }()
	
	required init(_ object: Object, aetherView: AetherView) {
		self.object = object
        
		super.init(aetherView: aetherView, aexel: object, origin: CGPoint(x: self.object.x, y: self.object.y), size: .zero)
        
		add(leaf: objectLeaf)
		layoutLeaves()
        objectLeaf.render()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
    
    var isEmpty: Bool { object.chain.isEmpty && object.label.count == 0 }
	
// Events ==========================================================================================
	override func onCreate() { objectLeaf.makeFocus() }
    override func onRemove() {}
	override func onSelect() {}
	override func onUnselect() {}

    func onOK() {
        if isEmpty {
            aetherView.aether.remove(aexel: object)
            aetherView.remove(bubble: self)
        }
        aetherView.stretch()
        aetherView.dodo()
    }

// Bubble ==========================================================================================
	override var context: Context { orb.objectContext }
    override var uiColor: UIColor {
        if selected { return .yellow }
        if objectLeaf.focused { return .black.tint(0.8) }
        
        let token: VariableToken = aetherView.citadel.token(key: object.chain.key!) as! VariableToken
        if token.status == .ok {
            let tower = aetherView.citadel.tower(key: object.chain.key!)
            return tower!.obje.uiColor
        } else { return .red }
    }

// Citable =========================================================================================
    func tokenKey(at: CGPoint) -> TokenKey? { object.chain.key }
}
