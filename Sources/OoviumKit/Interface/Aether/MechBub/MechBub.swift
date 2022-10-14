//
//  MechBub.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class MechMaker: Maker {
	// Maker ===========================================================================================
	func make(aetherView: AetherView, at: V2) -> Bubble {
		let mech = aetherView.aether.createMech(at: at)
		return MechBub(mech, aetherView: aetherView)
	}
	func drawIcon() {
		let w: CGFloat = 27.0*Oo.s
		let p: CGFloat = 3.0*Oo.s
		let or: CGFloat = 4.0*Oo.s
		let r: CGFloat = 1.0*Oo.s
		let lh: CGFloat = 7.0*Oo.s
		let n: CGFloat = 1.0
		
		let x1: CGFloat = 8.0*Oo.s
		let x2 = x1+r
		let x3 = x1+2*r
		let x4 = x1+w/2
		let x5 = x1+w-p-2*r
		let x6 = x1+w-p-r
		let x7 = x1+w-p
		
		let y1 = p+6.0*Oo.s
		let y2 = y1+lh/2.0
		let y3 = y1+lh
		let y4 = y3+r+n*lh/2
		let y5 = y3+2*r+n*lh
		let y6 = y5+lh/2
		let y7 = y5+lh
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x4, y: y1))
		path.addArc(tangent1End: CGPoint(x: x7, y: y1), tangent2End: CGPoint(x: x7, y: y2), radius: or)
		path.addArc(tangent1End: CGPoint(x: x7, y: y3), tangent2End: CGPoint(x: x6, y: y3), radius: r)
		path.addArc(tangent1End: CGPoint(x: x5, y: y3), tangent2End: CGPoint(x: x5, y: y4), radius: r)
		path.addArc(tangent1End: CGPoint(x: x5, y: y5), tangent2End: CGPoint(x: x6, y: y5), radius: r)
		path.addArc(tangent1End: CGPoint(x: x7, y: y5), tangent2End: CGPoint(x: x7, y: y6), radius: r)
		path.addArc(tangent1End: CGPoint(x: x7, y: y7), tangent2End: CGPoint(x: x4, y: y7), radius: or)
		path.addArc(tangent1End: CGPoint(x: x1, y: y7), tangent2End: CGPoint(x: x1, y: y6), radius: or)
		path.addArc(tangent1End: CGPoint(x: x1, y: y5), tangent2End: CGPoint(x: x2, y: y5), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y5), tangent2End: CGPoint(x: x3, y: y4), radius: r)
		path.addArc(tangent1End: CGPoint(x: x3, y: y3), tangent2End: CGPoint(x: x2, y: y3), radius: r)
		path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x1, y: y2), radius: r)
		path.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x4, y: y1), radius: or)
		path.closeSubpath()

		for i in 0..<Int(n+1) {
			path.move(to: CGPoint(x: x3, y: y3+r+CGFloat(i)*lh))
			path.addLine(to: CGPoint(x: x5, y: y3+r+CGFloat(i)*lh))
		}
		
		Skin.bubble(path: path, uiColor: UIColor.blue, width: 4.0/3.0*Oo.s)
	}
}

class MechBub: Bubble, SignatureLeafDelegate, ChainLeafDelegate {
	let mech: Mech

	var signatureLeaf: SignatureLeaf!
	var resultLeaf: ChainLeaf!

	init(_ mech: Mech, aetherView: AetherView) {
		self.mech = mech
		
		super.init(aetherView: aetherView, aexel: mech, hitch: .top, origin: CGPoint(x: self.mech.x, y: self.mech.y), size: CGSize.zero)
		
		signatureLeaf = SignatureLeaf(bubble: self, anchor: CGPoint(x: 60, y: 0), hitch: .top, size: CGSize(width: 100, height: 90))
		add(leaf: signatureLeaf)
		
		aetherView.moorings[mech.variableToken] = signatureLeaf.recipeMooring
		for (i, input) in mech.inputs.enumerated() {
			aetherView.moorings[input.tower.variableToken] = signatureLeaf.paramMoorings[i]
		}
		
		resultLeaf = ChainLeaf(bubble: self, hitch: .top, anchor: CGPoint(x: 60, y: 70), size: CGSize(width: 100, height: 30))
		resultLeaf.delegate = self
		resultLeaf.chain = mech.resultChain
		resultLeaf.placeholder = "result"
		resultLeaf.minWidth = 100
		resultLeaf.radius = 15
		signatureLeaf.overrides.append(resultLeaf)
		add(leaf: resultLeaf)

		render()		
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func render() {
		let p: CGFloat = 3
		let nh: CGFloat = 15
		let sh: CGFloat = 16+CGFloat(mech.inputs.count)*24
		let sw: CGFloat = signatureLeaf.size.width-2*p
		
		let x3 = calculateRect().width/2
		let x1 = x3 - sw/2
		let x5 = x3 + sw/2
		let x2 = x1 + p
		let x4 = x5 - p
		
		let y1: CGFloat = 0
		let y2 = y1 + nh
		let y3 = y2 + nh
		let y4 = y3 + sh
		let y5 = y4 + nh

		signatureLeaf.anchor = CGPoint(x: x3, y: y1)
		resultLeaf.anchor = CGPoint(x: x3, y: y4)

		plasma = CGMutablePath()
		guard let plasma = plasma else { return }
		plasma.move(to: CGPoint(x: x2, y: y2+p))
		plasma.addQuadCurve(to: CGPoint(x: x3, y: y5), control: CGPoint(x: x3-15, y: y3))
		plasma.addQuadCurve(to: CGPoint(x: x4, y: y2+p), control: CGPoint(x: x3+15, y: y3))
		plasma.closeSubpath()
		
		layoutLeaves()
	}
	
// Events ==========================================================================================
	override func onCreate() {
		signatureLeaf.makeFocus()
	}

// Bubble ==========================================================================================
	override var uiColor: UIColor {
		return !selected ? UIColor.blue : UIColor.yellow
	}

// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        guard let plasma = plasma else { return }
        Skin.plasma(path: plasma, uiColor: uiColor, stroke: 1)
    }

// SignatureLeafDelegate ===========================================================================
	var name: String {
		return mech.name
	}
	var params: [String] {
		var params: [String] = []
		for input in mech.inputs {
			params.append(input.name)
		}
		return params
	}
	func onNoOfParamsChanged(signatureLeaf: SignatureLeaf) {
		while signatureLeaf.noOfParams > mech.inputs.count {
			mech.addInput()
		}
		while mech.inputs.count > signatureLeaf.noOfParams {
			mech.removeInput()
		}
		render()
	}
	func onOK(signatureLeaf: SignatureLeaf) {
		aetherView.stretch()

		mech.name = signatureLeaf.nameEdit?.text ?? ""
		for (i, input) in mech.inputs.enumerated() {
			input.name = signatureLeaf.paramEdits[i].text ?? ""
		}
		mech.aether.buildMemory()
		mech.resultTower.buildTask()
		mech.tower.buildTask()
	}
	var token: Token {
		return mech.functionToken
	}
	var recipeToken: Token {
		return mech.variableToken
	}
	var paramTokens: [Token] {
		var tokens: [Token] = []
		for input in mech.inputs {
			tokens.append(input.tower.variableToken)
		}
		return tokens
	}

// ChainLeafDelegate ===============================================================================
	func onChange() {
		render()
	}
	func onEdit() {
		render()
	}
	func onOK(leaf: ChainLeaf) {
		render()
	}
	func onCalculate() {}
}
