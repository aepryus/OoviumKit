//
//  MechBub.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class MechBub: Bubble, SignatureLeafDelegate, ChainLeafDelegate {
	let mech: Mech

	var signatureLeaf: SignatureLeaf!
	var resultLeaf: ChainLeaf!

	init(_ mech: Mech, aetherView: AetherView) {
		self.mech = mech
		
		super.init(aetherView: aetherView, aexel: mech, origin: CGPoint(x: self.mech.x, y: self.mech.y), size: CGSize.zero)
		
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
	override func onCreate() { signatureLeaf.makeFocus() }

// Bubble ==========================================================================================
	override var uiColor: UIColor { !selected ? UIColor.blue : UIColor.yellow }
    override var hitch: Position { .top }

// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        guard let plasma = plasma else { return }
        Skin.plasma(path: plasma, uiColor: uiColor, stroke: 1)
    }

// SignatureLeafDelegate ===========================================================================
	var name: String { mech.name }
	var params: [String] { mech.inputs.map { $0.name } }
	func onNoOfParamsChanged(signatureLeaf: SignatureLeaf) {
		while signatureLeaf.noOfParams > mech.inputs.count { mech.addInput() }
		while mech.inputs.count > signatureLeaf.noOfParams { mech.removeInput() }
		render()
	}
	func onOK(signatureLeaf: SignatureLeaf) {
		aetherView.stretch()
		mech.name = signatureLeaf.nameEdit?.text ?? ""
		for (i, input) in mech.inputs.enumerated() { input.name = signatureLeaf.paramEdits[i].text ?? "" }
        mech.aether.state.buildMemory()
	}
	var token: Token { mech.mechlikeToken }
	var recipeToken: Token { mech.variableToken }
	var paramTokens: [Token] { mech.inputs.map { $0.tower.variableToken } }

// ChainLeafDelegate ===============================================================================
	func onChange() { render() }
	func onEdit() { render() }
	func onOK(leaf: ChainLeaf) { render() }
	func onCalculate() {}
}
