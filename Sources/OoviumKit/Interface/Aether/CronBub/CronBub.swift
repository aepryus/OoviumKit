//
//  CronBub.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class CronMaker: Maker {
	
	// Maker ===========================================================================================
	func make(aetherView: AetherView, at: V2) -> Bubble {
		let cron = aetherView.aether.createCron(at: at)
		return CronBub(cron, aetherView: aetherView)
	}
	func drawIcon() {
		
		let p: CGFloat = 2*Oo.s
		let sw: CGFloat = 5.0/1.5*Oo.s
		let cw: CGFloat = 6.0/1.5*Oo.s
		let ah: CGFloat = 7.0/1.5*Oo.s
		let bh: CGFloat = 7.0/1.5*Oo.s
		let ch: CGFloat = 7.0/1.5*Oo.s
		
		let bl: CGFloat = 2.0/1.5*Oo.s
		let ml: CGFloat = 2.0/1.5*Oo.s
		let qw: CGFloat = 2.0/1.5*Oo.s
		let qh: CGFloat = 2.0/1.5*Oo.s
		let ps: CGFloat = 1.0/1.5*Oo.s
		let pw: CGFloat = qw*ps/1.5
		let ph: CGFloat = qh*ps/1.5
		
		let w: CGFloat = 8.0/1.5*Oo.s
		let h: CGFloat = 4.0/1.5*Oo.s
		let r: CGFloat = 4.0/1.5*Oo.s
		
		let x1 = p+11.0/1.5*Oo.s
		let x2 = x1+sw
		let x3 = x2+sw
		let x4 = x3+cw
		let x5 = x4+cw
		let x6 = x5+sw
		let x7 = x6+sw
		let x8 = x4-w
		let x9 = x4+w
		
		let y1 = p+6.0/1.5*Oo.s
		let y2 = y1+ah
		let y3 = y2+bh
		let y4 = y3+ch
		let y5 = y4+ch
		let y6 = y5+bh
		let y7 = y6+ah
		let y8 = y1+5.0/1.5*Oo.s
		let y9 = y8+h
		let y10 = y9+h
		
		let glass = CGMutablePath()
		glass.move(to: CGPoint(x: x1, y: y2))
		glass.addQuadCurve(to: CGPoint(x: x4, y: y1), control: CGPoint(x: x1, y: y1))
		glass.addQuadCurve(to: CGPoint(x: x7, y: y2), control: CGPoint(x: x7, y: y1))
		glass.addCurve(to: CGPoint(x: x6, y: y3), control1: CGPoint(x: x7,		y: y2+bl), control2: CGPoint(x: x6+qw,	y: y3-qh))
		glass.addCurve(to: CGPoint(x: x5, y: y4), control1: CGPoint(x: x6-pw,	y: y3+ph), control2: CGPoint(x: x5,		y: y4-ml))
		glass.addCurve(to: CGPoint(x: x6, y: y5), control1: CGPoint(x: x5,		y: y4+ml), control2: CGPoint(x: x6-pw,	y: y5-ph))
		glass.addCurve(to: CGPoint(x: x7, y: y6), control1: CGPoint(x: x6+qw,	y: y5+qh), control2: CGPoint(x: x7,		y: y6-bl))
		glass.addQuadCurve(to: CGPoint(x: x4, y: y7), control: CGPoint(x: x7, y: y7))
		glass.addQuadCurve(to: CGPoint(x: x1, y: y6), control: CGPoint(x: x1, y: y7))
		glass.addCurve(to: CGPoint(x: x2, y: y5), control1: CGPoint(x: x1,		y: y6-bl), control2: CGPoint(x: x2-qw,	y: y5+qh))
		glass.addCurve(to: CGPoint(x: x3, y: y4), control1: CGPoint(x: x2+pw,	y: y5-ph), control2: CGPoint(x: x3,		y: y4+ml))
		glass.addCurve(to: CGPoint(x: x2, y: y3), control1: CGPoint(x: x3,		y: y4-ml), control2: CGPoint(x: x2+pw,	y: y3+ph))
		glass.addCurve(to: CGPoint(x: x1, y: y2), control1: CGPoint(x: x2-qw,	y: y3-qh), control2: CGPoint(x: x1,		y: y2+bl))
		glass.closeSubpath()
		
		Skin.bubble(path: glass, uiColor: OOColor.cobolt.uiColor, width: 4.0/3.0*Oo.s)
		
		var path = CGMutablePath()
		path.move(to: CGPoint(x: x8, y: y9))
		path.addArc(tangent1End: CGPoint(x: x8, y: y8), tangent2End: CGPoint(x: x4, y: y8), radius: r)
		path.addArc(tangent1End: CGPoint(x: x9, y: y8), tangent2End: CGPoint(x: x9, y: y9), radius: r)
		path.addArc(tangent1End: CGPoint(x: x9, y: y10), tangent2End: CGPoint(x: x4, y: y10), radius: r)
		path.addArc(tangent1End: CGPoint(x: x8, y: y10), tangent2End: CGPoint(x: x8, y: y9), radius: r)
		path.closeSubpath()
		
		Skin.bubble(path: path, uiColor: OOColor.cobolt.uiColor, width: 4.0/3.0*Oo.s)
		
		let ir: CGFloat = 5.0/1.5*Oo.s
		
		let ix1 = x4-ir
		
		let iy1 = y1+26.5/1.5*Oo.s
		
		path = CGMutablePath()
		path.addEllipse(in: CGRect(x: ix1, y: iy1, width: 2*ir, height: 2*ir))
		
		Skin.bubble(path: path, uiColor: OOColor.cobolt.uiColor, width: 4.0/3.0*Oo.s)
	}
}

class CronBub: Bubble, ChainLeafDelegate {
	let cron: Cron
	
	let timer: AETimer = AETimer()
	
	var overrideHitchPoint: CGPoint = CGPoint.zero
	
	lazy var faceLeaf: FaceLeaf =  {
		FaceLeaf(bubble: self)
	}()
	lazy var playLeaf: PlayLeaf = {
		PlayLeaf(bubble: self)
	}()
	lazy var endLeaf: EndLeaf =  {
		EndLeaf(bubble: self)
	}()

	lazy var startLeaf: ChainLeaf = {
		ChainLeaf(bubble: self, hitch: .topRight, anchor: CGPoint(x: 60, y: 70), size: CGSize(width: 100, height: 30))
	}()
	lazy var stopLeaf: ChainLeaf = {
		ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint(x: 120, y: 70), size: CGSize(width: 100, height: 30))
	}()
	lazy var stepsLeaf: ChainLeaf = {
		ChainLeaf(bubble: self, hitch: .topRight, anchor: CGPoint(x: 60, y: 120), size: CGSize(width: 100, height: 30))
	}()
	lazy var rateLeaf: ChainLeaf = {
		ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint(x: 120, y: 120), size: CGSize(width: 100, height: 30))
	}()
	lazy var deltaLeaf: ChainLeaf = {
		ChainLeaf(bubble: self, hitch: .topRight, anchor: CGPoint(x: 60, y: 120), size: CGSize(width: 100, height: 30))
	}()
	lazy var whileLeaf: ChainLeaf = {
		ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint(x: 120, y: 70), size: CGSize(width: 100, height: 30))
	}()

	init(_ cron: Cron, aetherView: AetherView) {
		self.cron = cron
		super.init(aetherView: aetherView, aexel: cron, origin: CGPoint(x: self.cron.x, y: self.cron.y), hitch: .top, size: CGSize.zero)
		
		cron.tower.listener = faceLeaf
		add(leaf: faceLeaf)
		
		playLeaf.playButton.onPlay = { [weak self] in
			guard let me = self else {return}
			me.timer.configure(interval: 1/cron.rateTower.value, {
				DispatchQueue.main.async { [weak self] in
					guard let me = self else {return}
					let stop = me.cron.increment()
					if stop {
						me.playLeaf.playButton.stop()
					}
				}
			})
			me.timer.start()
		}
//		playLeaf.playButton.onPlay = { [unowned self] in
//			self.timer.configure(interval: 1/cron.rateTower.value) {
//				DispatchQueue.main.async { [weak self] in
//					guard let self = self else { return }
//					let stop = self.cron.increment()
//					if stop { self.playLeaf.playButton.stop() }
//				}
//			}
//		}
		playLeaf.playButton.onStop = { [weak self] in
			guard let me = self else {return}
			me.timer.stop()
		}
		playLeaf.resetButton.onReset = { [weak self] in
			guard let me = self else {return}
			me.playLeaf.playButton.stop()
			me.cron.reset()
			me.cron.tower.trigger()
		}
		playLeaf.stepButton.onStep =  { [weak self] in
			guard let me = self else {return}
			me.cron.sealed = false
			_ = me.cron.increment()
		}
		add(leaf: playLeaf)
		
		startLeaf.delegate = self
		startLeaf.chain = cron.startChain
		startLeaf.placeholder = "start"
		startLeaf.minWidth = 66
		startLeaf.radius = 15

		stopLeaf.delegate = self
		stopLeaf.chain = cron.stopChain
		stopLeaf.placeholder = "stop"
		stopLeaf.minWidth = 66
		stopLeaf.radius = 15
		
		stepsLeaf.delegate = self
		stepsLeaf.chain = cron.stepsChain
		stepsLeaf.placeholder = "steps"
		stepsLeaf.minWidth = 66
		stepsLeaf.radius = 15
		
		rateLeaf.delegate = self
		rateLeaf.chain = cron.rateChain
		rateLeaf.placeholder = "S/s"
		rateLeaf.minWidth = 66
		rateLeaf.radius = 15
		
		deltaLeaf.delegate = self
		deltaLeaf.chain = cron.deltaChain
		deltaLeaf.placeholder = "\u{0394}t"
		deltaLeaf.minWidth = 66
		deltaLeaf.radius = 15

		whileLeaf.delegate = self
		whileLeaf.chain = cron.whileChain
		whileLeaf.placeholder = "while"
		whileLeaf.minWidth = 66
		whileLeaf.radius = 15
		
		selectLeaves()
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	func morph() {
		cron.exposed = !cron.exposed
		selectLeaves()
	}
	
	func selectLeaves() {
		var removing: [ChainLeaf] = []
		var adding: [ChainLeaf] = []
		
		if !cron.exposed {
			removing.append(startLeaf)
			removing.append(stopLeaf)
			removing.append(stepsLeaf)
			removing.append(rateLeaf)
			removing.append(deltaLeaf)
			removing.append(whileLeaf)
			remove(leaf: endLeaf)
		} else {
			adding.append(startLeaf)
			adding.append(rateLeaf)
			add(leaf: endLeaf)

			if cron.endMode == .stop || cron.endMode == .repeat || cron.endMode == .bounce {adding.append(stopLeaf)}
			else {removing.append(stopLeaf)}
				
			if cron.endMode == .stop || cron.endMode == .repeat || cron.endMode == .bounce {adding.append(stepsLeaf)}
			else {removing.append(stepsLeaf)}

			if cron.endMode == .endless || cron.endMode == .while {adding.append(deltaLeaf)}
			else {removing.append(deltaLeaf)}
			
			if cron.endMode == .while {adding.append(whileLeaf)}
			else {removing.append(whileLeaf)}
		}
		
		adding.forEach {
			add(leaf: $0)
			$0.showLinks()
		}
		removing.forEach {
			remove(leaf: $0)
			$0.hideLinks()
		}
		
		render()
	}
	
	private func render() {
		let mw: CGFloat = 96
		let q = cron.exposed ? max(startLeaf.size.width, stepsLeaf.size.width) : max(playLeaf.size.width, faceLeaf.size.width)/2 - mw/2
		
		overrideHitchPoint = CGPoint(x: q+mw/2, y: cron.exposed ? 68.5 : 0)
		
		endLeaf.anchor = CGPoint(x: q+mw/2, y: 0)
		faceLeaf.anchor = CGPoint(x: q+mw/2, y: cron.exposed ? 68.5 : 0)
		playLeaf.anchor = CGPoint(x: q+mw/2, y: cron.exposed ? 150 : 150-68.5)
		
		startLeaf.anchor = CGPoint(x: q, y: 36)
		stopLeaf.anchor = CGPoint(x: q+mw, y: 36)
		stepsLeaf.anchor = CGPoint(x: q, y: 101)
		rateLeaf.anchor = CGPoint(x: q+mw, y: 101)
		deltaLeaf.anchor = CGPoint(x: q, y: 101)
		whileLeaf.anchor = CGPoint(x: q+mw, y: 36)

		layoutLeaves()
		positionMoorings()
		
		plasma = CGMutablePath()
		guard let plasma = plasma else {return}

		var a: CGPoint = CGPoint(x: faceLeaf.center.x-20, y: faceLeaf.center.y)						// PlayLeaf
		var b: CGPoint = CGPoint(x: playLeaf.center.x-30, y: playLeaf.center.y)
		var c: CGPoint = CGPoint(x: playLeaf.center.x+30, y: playLeaf.center.y)
		let d: CGPoint = CGPoint(x: faceLeaf.center.x+20, y: faceLeaf.center.y)
		plasma.move(to: a)
		plasma.addQuadCurve(to: b, control: (a+b)/2+CGPoint(x: 30, y: 0))
		plasma.addLine(to: c)
		plasma.addQuadCurve(to: d, control: (c+d)/2+CGPoint(x: -30, y: 0))
		plasma.closeSubpath()

		guard cron.exposed else {return}
		
		a = CGPoint(x: faceLeaf.center.x-20, y: faceLeaf.center.y)									// startLeaf
		b = CGPoint(x: startLeaf.right-33, y: startLeaf.center.y)
		c = CGPoint(x: faceLeaf.center.x, y: faceLeaf.center.y)
		plasma.move(to: a)
		plasma.addQuadCurve(to: b, control: (a+b)/2+CGPoint(x: 10, y: -10))
		plasma.addQuadCurve(to: c, control: (b+c)/2+CGPoint(x: 10, y: -10))
		plasma.closeSubpath()
		
		a = CGPoint(x: faceLeaf.center.x-20, y: faceLeaf.center.y)									// stepsLeaf
		b = CGPoint(x: q-33, y: rateLeaf.center.y) // in case stepsLeaf isn't active
		c = CGPoint(x: faceLeaf.center.x, y: faceLeaf.center.y)
		plasma.move(to: a)
		plasma.addQuadCurve(to: b, control: (a+b)/2+CGPoint(x: 10, y: 10))
		plasma.addQuadCurve(to: c, control: (b+c)/2+CGPoint(x: 10, y: 10))
		plasma.closeSubpath()
		
		if cron.endMode != .endless {
			a = CGPoint(x: faceLeaf.center.x+20, y: faceLeaf.center.y)								// stopLeaf
			b = CGPoint(x: q+mw+33, y: startLeaf.center.y) // in case stopLeaf isn't active
			c = CGPoint(x: faceLeaf.center.x, y: faceLeaf.center.y)
			plasma.move(to: c)
			plasma.addQuadCurve(to: b, control: (b+c)/2+CGPoint(x: -10, y: -10))
			plasma.addQuadCurve(to: a, control: (a+b)/2+CGPoint(x: -10, y: -10))
			plasma.closeSubpath()
		}

		a = CGPoint(x: faceLeaf.center.x+20, y: faceLeaf.center.y)									// rateLeaf
		b = CGPoint(x: rateLeaf.left+33, y: rateLeaf.center.y)
		c = CGPoint(x: faceLeaf.center.x, y: faceLeaf.center.y)
		plasma.move(to: c)
		plasma.addQuadCurve(to: b, control: (b+c)/2+CGPoint(x: -10, y: 10))
		plasma.addQuadCurve(to: a, control: (a+b)/2+CGPoint(x: -10, y: 10))
		plasma.closeSubpath()

		a = CGPoint(x: faceLeaf.center.x+20, y: faceLeaf.center.y)									// endLeaf
		b = CGPoint(x: endLeaf.center.x, y: endLeaf.center.y)
		c = CGPoint(x: faceLeaf.center.x-20, y: faceLeaf.center.y)
		plasma.move(to: c)
		plasma.addQuadCurve(to: b, control: (b+c)/2+CGPoint(x: 12, y: 0))
		plasma.addQuadCurve(to: a, control: (a+b)/2+CGPoint(x: -12, y: 0))
		plasma.closeSubpath()
	}
	
// Events ==========================================================================================
	override func onRemove() {
		faceLeaf.deinitMoorings()
	}

// Bubble ==========================================================================================
	override var uiColor: UIColor {
		return !selected ? OOColor.cobolt.uiColor : UIColor.yellow
	}
	override var hitchPoint: CGPoint {
		return overrideHitchPoint
	}
	override func wire() {
		startLeaf.wire()
		stopLeaf.wire()
		stepsLeaf.wire()
		rateLeaf.wire()
		deltaLeaf.wire()
		whileLeaf.wire()
		cron.reset()
		cron.tower.trigger()
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		guard let plasma = plasma else {return}
		
		let c = UIGraphicsGetCurrentContext()!
		c.addPath(plasma)
		
		uiColor.alpha(0.4).setFill()
		uiColor.alpha(1).setStroke()
		
		c.drawPath(using: .fillStroke)
	}
	
// ChainLeafDelegate ===============================================================================
	func onChange() {
		render()
		aetherView.stretch()
	}
	func onEdit() {
		render()
		aetherView.stretch()
	}
	func onOK(leaf: ChainLeaf) {
		render()
		aetherView.stretch()
		if leaf !== rateLeaf {
			playLeaf.playButton.stop()
			cron.reset()
			cron.tower.trigger()
		} else if playLeaf.playButton.playing {
			playLeaf.playButton.stop()
			playLeaf.playButton.play()
		}
	}
	func onCalculate() {}
}
