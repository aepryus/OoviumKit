//
//  TailBub.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class TailBub: Bubble, SignatureLeafDelegate, ChainLeafDelegate {
	let tail: Tail

	lazy var signatureLeaf: SignatureLeaf = SignatureLeaf(bubble: self, anchor: CGPoint(x: 60, y: 0), hitch: .top, size: CGSize(width: 100, height: 90))
	lazy var whileLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topRight, anchor: CGPoint(x: 60, y: 70), size: CGSize(width: 100, height: 30))
	lazy var resultLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .top, anchor: CGPoint(x: 60, y: 70), size: CGSize(width: 100, height: 30))
	var vertebraLeaves: [ChainLeaf] = []
	
	var overrideHitchPoint: CGPoint = CGPoint.zero

	init(_ tail: Tail, aetherView: AetherView) {
		self.tail = tail
		
        super.init(aetherView: aetherView, aexel: tail, origin: CGPoint(x: self.tail.x, y: self.tail.y), size: CGSize(width: 36, height: 36))

		signatureLeaf = SignatureLeaf(bubble: self, anchor: CGPoint(x: 60, y: 0), hitch: .top, size: CGSize(width: 100, height: 90))
		add(leaf: signatureLeaf)
		
		whileLeaf.delegate = self
		whileLeaf.chain = tail.whileChain
		whileLeaf.placeholder = "while"
		whileLeaf.minWidth = 100
		whileLeaf.radius = 15
		signatureLeaf.overrides.append(whileLeaf)
		add(leaf: whileLeaf)

		resultLeaf.delegate = self
		resultLeaf.chain = tail.resultChain
		resultLeaf.placeholder = "result"
		resultLeaf.minWidth = 100
		resultLeaf.radius = 15
		signatureLeaf.overrides.append(resultLeaf)
		add(leaf: resultLeaf)
		
		aetherView.moorings[tail.variableToken] = signatureLeaf.recipeMooring
		for (i, vertebra) in tail.vertebras.enumerated() {
			aetherView.moorings[vertebra.tower.variableToken] = signatureLeaf.paramMoorings[i]
			let vertebraLeaf = ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint.zero, size: CGSize(width: 100, height: 30))
			vertebraLeaf.delegate = self
			vertebraLeaf.chain = vertebra.chain
			vertebraLeaf.placeholder = "next \(vertebra.name)"
			vertebraLeaf.minWidth = 100
			vertebraLeaf.radius = 15
			signatureLeaf.overrides.append(vertebraLeaf)
			add(leaf: vertebraLeaf)
			vertebraLeaves.append(vertebraLeaf)
		}

        render()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func render() {
		let n: CGFloat = CGFloat(tail.vertebras.count-1)
		let adh = n*24
		let bdh = n*36
		let ww = max(whileLeaf.size.width, resultLeaf.size.width/2-40)
	
		overrideHitchPoint = CGPoint(x: ww, y: 0)

		signatureLeaf.anchor = CGPoint(x: ww, y: 0)
		whileLeaf.anchor = CGPoint(x: ww, y: 104+adh)
		resultLeaf.anchor = CGPoint(x: ww+40, y: 200+adh+bdh)
		
		var y: CGFloat = 120+adh
		for vertebraLeaf in vertebraLeaves {
			vertebraLeaf.anchor = CGPoint(x: ww+40, y: y)
			y += 36
		}
		
		layoutLeaves()

		plasma = CGMutablePath()
		guard let plasma = plasma else { return }
		
		var a: CGPoint = CGPoint(x: signatureLeaf.left+10, y: signatureLeaf.top+30)
		var b: CGPoint = CGPoint(x: whileLeaf.right-50, y: whileLeaf.center.y)
		var c: CGPoint = CGPoint(x: signatureLeaf.center.x, y: signatureLeaf.bottom-10)
		plasma.move(to: a)
		plasma.addQuadCurve(to: b, control: (a+b)/2+CGPoint(x: -20, y: -20))
		plasma.addQuadCurve(to: c, control: (b+c)/2+CGPoint(x: -20, y: -20))
		plasma.closeSubpath()
		
		var vertebraLeaf = vertebraLeaves.last!
		a = CGPoint(x: whileLeaf.right-80, y: whileLeaf.center.y)
		b = CGPoint(x: vertebraLeaf.left+50, y: vertebraLeaf.center.y)
		c = CGPoint(x: whileLeaf.right-20, y: whileLeaf.center.y)
		plasma.move(to: a)
		plasma.addQuadCurve(to: b, control: (a+b)/2+CGPoint(x: -30, y: 60))
		plasma.addQuadCurve(to: c, control: (b+c)/2+CGPoint(x: -40, y: 40))
		plasma.closeSubpath()

		vertebraLeaf = vertebraLeaves.first!
		a = CGPoint(x: vertebraLeaf.left+20, y: vertebraLeaf.center.y)
		b = CGPoint(x: whileLeaf.right-50, y: whileLeaf.center.y)
		c = CGPoint(x: vertebraLeaf.left+80, y: vertebraLeaf.center.y)
		plasma.move(to: a)
		plasma.addQuadCurve(to: b, control: (a+b)/2+CGPoint(x: 40, y: -40))
		plasma.addQuadCurve(to: c, control: (b+c)/2+CGPoint(x: 30, y: -60))
		plasma.closeSubpath()
		
		a = CGPoint(x: whileLeaf.right-80, y: whileLeaf.center.y)
		b = CGPoint(x: resultLeaf.center.x, y: resultLeaf.center.y)
		c = CGPoint(x: whileLeaf.right-20, y: whileLeaf.center.y)
		plasma.move(to: a)
		plasma.addQuadCurve(to: b, control: (a+b)/2+CGPoint(x: 20, y: -20))
		plasma.addQuadCurve(to: c, control: (b+c)/2+CGPoint(x: 20, y: -20))
		plasma.closeSubpath()
	}

// Events ==========================================================================================
	override func onCreate() { signatureLeaf.makeFocus() }

// Bubble ==========================================================================================
	override var uiColor: UIColor { !selected ? UIColor.blue : UIColor.yellow }
	override var hitchPoint: CGPoint { overrideHitchPoint }

// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        guard let plasma = plasma else { return }
        Skin.plasma(path: plasma, uiColor: uiColor, stroke: 1)
    }

// SignatureLeafDelegate ===========================================================================
	var name: String { tail.name }
    var params: [String] { tail.vertebras.map { $0.name } }
	func onNoOfParamsChanged(signatureLeaf: SignatureLeaf) {
		while signatureLeaf.noOfParams > tail.vertebras.count {
			let vertebra = tail.addVertebra()
			let vertebraLeaf = ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint.zero, size: CGSize(width: 100, height: 30))
			vertebraLeaf.delegate = self
			vertebraLeaf.chain = vertebra.chain
			vertebraLeaf.placeholder = "next \(vertebra.name)"
			vertebraLeaf.minWidth = 100
			vertebraLeaf.radius = 15
			signatureLeaf.overrides.append(vertebraLeaf)
			add(leaf: vertebraLeaf)
			vertebraLeaves.append(vertebraLeaf)
		}
		while tail.vertebras.count > signatureLeaf.noOfParams {
			tail.removeVertebra()
			let vertebraLeaf = vertebraLeaves.removeLast()
            if let i: Int = signatureLeaf.overrides.firstIndex(where: { $0 === vertebraLeaf }) {
                signatureLeaf.overrides.remove(at: i)
            }
			vertebraLeaf.removeFromBubble()
		}
		render()
	}
	func onOK(signatureLeaf: SignatureLeaf) {
		aetherView.stretch()
		tail.name = signatureLeaf.nameEdit?.text ?? ""
		for (i, vertebra) in tail.vertebras.enumerated() {
			vertebra.name = signatureLeaf.paramEdits[i].text ?? ""
			vertebraLeaves[i].placeholder = "next \(vertebra.name)"
		}
        tail.aether.buildMemory()
        Tower.evaluate(towers: tail.towers)
	}
	var token: Token { tail.mechlikeToken }
	var recipeToken: Token { tail.variableToken }
    var paramTokens: [Token] { tail.vertebras.map { $0.tower.variableToken } }
	
// ChainLeafDelegate ===============================================================================
	func onChange() { render() }
	func onEdit() { render() }
	func onOK(leaf: ChainLeaf) { render() }
	func onCalculate() {}
}
