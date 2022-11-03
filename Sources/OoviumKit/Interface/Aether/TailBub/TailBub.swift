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

class TailMaker: Maker {
	
	// Maker ===========================================================================================
	func make(aetherView: AetherView, at: V2) -> Bubble {
        let tail: Tail = aetherView.aether.create(at: at)
		return TailBub(tail, aetherView: aetherView)
	}
	func drawIcon() {
		let r: CGFloat = 4.0/1.5*Oo.s
		let p: CGFloat = 3.0/1.5*Oo.s
		let n = 1.0
		
		let or: CGFloat = 4.5/1.5*Oo.s
		
		let rw: CGFloat = 16.0/1.5*Oo.s
		let tw: CGFloat = 12.0/1.5*Oo.s
		let cw: CGFloat = 12.0/1.5*Oo.s
		let sh: CGFloat = 6.0/1.5*Oo.s
		
		let low: CGFloat = 80.0/4/1.5*Oo.s
		let liw:CGFloat = 16.0/1.5*Oo.s
		let row: CGFloat = 80.0/4/1.5*Oo.s
		let riw: CGFloat = 65.0/4/1.5*Oo.s
		
		let vo: CGFloat = 35.0/4/1.5*Oo.s
		let ro: CGFloat = -4.0/1.5*Oo.s
		
		let x3 = p+max(tw,max(cw,low))+7.0/1.5*Oo.s
		let x6 = x3-cw
		let x7 = x3+cw
		let x8 = x3-low
		let x9 = x3-liw
		let x10 = x3+riw
		let x11 = x3+row
		let x12 = x3+ro
		let x14 = x12+rw
		let x13 = (x12+x14)/2
		let x15 = x3-vo
		let x16 = x15+50.0/4/1.5*Oo.s
		var x17 = x15+60.0/4/1.5*Oo.s

		let y4: CGFloat = p+7.0/1.5*Oo.s
		let y5 = y4+or
		let y6 = y5+or
		let y7 = y6+sh
		let y8 = y7+or
		let y9 = y8+or
		let y10 = y9+sh
		let y11 = y10+or
		let y12 = y11+or
		let y13 = (y4+y8)/2
		let y14 = (y6+y8)/2
		let y15 = (y4+y11)/2
		let y16 = (y6+y11)/2
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: x3, y: y4))
		path.addArc(tangent1End: CGPoint(x: x7, y: y4), tangent2End: CGPoint(x: x7, y: y5), radius: r)
		path.addArc(tangent1End: CGPoint(x: x7, y: y6), tangent2End: CGPoint(x: x3, y: y6), radius: r)
		path.addArc(tangent1End: CGPoint(x: x6, y: y6), tangent2End: CGPoint(x: x6, y: y5), radius: r)
		path.addArc(tangent1End: CGPoint(x: x6, y: y4), tangent2End: CGPoint(x: x3, y: y4), radius: r)
		path.closeSubpath()
		
		// Result ======================================
		path.move(to: CGPoint(x: x12, y: y8))
		path.addArc(tangent1End: CGPoint(x: x12, y: y7), tangent2End: CGPoint(x: x13, y: y7), radius: r)
		path.addArc(tangent1End: CGPoint(x: x14, y: y7), tangent2End: CGPoint(x: x14, y: y8), radius: r)
		path.addArc(tangent1End: CGPoint(x: x14, y: y9), tangent2End: CGPoint(x: x13, y: y9), radius: r)
		path.addArc(tangent1End: CGPoint(x: x12, y: y9), tangent2End: CGPoint(x: x12, y: y8), radius: r)
		path.closeSubpath()
		
		// Vertebrae ===================================
		
		for i in 0..<Int(n) {
			let i: CGFloat = CGFloat(i)
			x17 = x15 + (30.0*Oo.s-2*p)/1.5
			path.move(to: CGPoint(x: x15, y: y11+2*or*i))
			path.addArc(tangent1End: CGPoint(x: x15, y: y10+2*or*i), tangent2End: CGPoint(x: x16, y: y10+2*or*i), radius: r)
			path.addArc(tangent1End: CGPoint(x: x17, y: y10+2*or*i), tangent2End: CGPoint(x: x17, y: y11+2*or*i), radius: r)
			path.addArc(tangent1End: CGPoint(x: x17, y: y12+2*or*i), tangent2End: CGPoint(x: x16, y: y12+2*or*i), radius: r)
			path.addArc(tangent1End: CGPoint(x: x15, y: y12+2*or*i), tangent2End: CGPoint(x: x15, y: y11+2*or*i), radius: r)
			path.closeSubpath()
		}
		
		let arrow = CGMutablePath()
		arrow.move(to: CGPoint(x: x3, y: y4))
		arrow.addQuadCurve(to: CGPoint(x: x8, y: y15), control: CGPoint(x: x8, y: y4))
		arrow.addQuadCurve(to: CGPoint(x: x16, y: y11), control: CGPoint(x: x8, y: y11))
		arrow.addQuadCurve(to: CGPoint(x: x9, y: y16), control: CGPoint(x: x9, y: y11))
		arrow.addQuadCurve(to: CGPoint(x: x3, y: y6), control: CGPoint(x: x9, y: y6))
		arrow.addQuadCurve(to: CGPoint(x: x10, y: y14), control: CGPoint(x: x10, y: y6))
		arrow.addQuadCurve(to: CGPoint(x: x12+9*Oo.s, y: y8), control: CGPoint(x: x10, y: y8))
		arrow.addQuadCurve(to: CGPoint(x: x11, y: y13), control: CGPoint(x: x11, y: y8))
		arrow.addQuadCurve(to: CGPoint(x: x3, y: y4), control: CGPoint(x: x11, y: y4))
		arrow.closeSubpath()
		
		let color = RGB.tint(color: UIColor.blue, percent: 0.5)
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(color.alpha(0.4).cgColor)
		c.setStrokeColor(color.alpha(0.9).cgColor)
		c.addPath(arrow)
		c.drawPath(using: .fillStroke)
		
		Skin.bubble(path: path, uiColor: UIColor.blue, width: 4.0/3.0*Oo.s)
	}
}

class TailBub: Bubble, SignatureLeafDelegate, ChainLeafDelegate {
	let tail: Tail

	lazy var signatureLeaf: SignatureLeaf = {
		SignatureLeaf(bubble: self, anchor: CGPoint(x: 60, y: 0), hitch: .top, size: CGSize(width: 100, height: 90))
	}()
	lazy var whileLeaf: ChainLeaf = {
		ChainLeaf(bubble: self, hitch: .topRight, anchor: CGPoint(x: 60, y: 70), size: CGSize(width: 100, height: 30))
	}()
	lazy var resultLeaf: ChainLeaf = {
		return ChainLeaf(bubble: self, hitch: .top, anchor: CGPoint(x: 60, y: 70), size: CGSize(width: 100, height: 30))
	}()
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
		
		self.backgroundColor = UIColor.clear
		
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
	override func onCreate() {
		signatureLeaf.makeFocus()
	}

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
	var params: [String] {
		var params: [String] = []
		for vertebra in tail.vertebras {
			params.append(vertebra.name)
		}
		return params
	}
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
		tail.resultTower.buildTask()
		tail.tower.buildTask()
	}
	var token: Token { tail.mechlikeToken }
	var recipeToken: Token { tail.variableToken }
	var paramTokens: [Token] {
		var tokens: [Token] = []
		for input in tail.vertebras {
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
