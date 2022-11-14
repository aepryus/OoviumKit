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

class CronBub: Bubble, ChainLeafDelegate {
	let cron: Cron
	
	let timer: AETimer = AETimer()
	
	var overrideHitchPoint: CGPoint = CGPoint.zero
	
	lazy var faceLeaf: FaceLeaf = FaceLeaf(bubble: self)
    lazy var playLeaf: PlayLeaf = PlayLeaf(bubble: self)
    lazy var endLeaf: EndLeaf = EndLeaf(bubble: self)
    
	lazy var startLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topRight, anchor: CGPoint(x: 60, y: 70), size: CGSize(width: 100, height: 30))
	lazy var stopLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint(x: 120, y: 70), size: CGSize(width: 100, height: 30))
	lazy var stepsLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topRight, anchor: CGPoint(x: 60, y: 120), size: CGSize(width: 100, height: 30))
	lazy var rateLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint(x: 120, y: 120), size: CGSize(width: 100, height: 30))
	lazy var deltaLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topRight, anchor: CGPoint(x: 60, y: 120), size: CGSize(width: 100, height: 30))
	lazy var whileLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft, anchor: CGPoint(x: 120, y: 70), size: CGSize(width: 100, height: 30))

	init(_ cron: Cron, aetherView: AetherView) {
		self.cron = cron
        super.init(aetherView: aetherView, aexel: cron, origin: CGPoint(x: self.cron.x, y: self.cron.y), size: CGSize.zero)
		
		cron.tower.listener = faceLeaf
		add(leaf: faceLeaf)
		
		playLeaf.playButton.onPlay = { [weak self] in
            guard let self else { return }
            self.timer.configure(interval: 1/cron.rateTower.value, { [weak self] in
				DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
					let stop = self.cron.increment()
					if stop { self.playLeaf.playButton.stop() }
				}
			})
            self.timer.start()
		}
		playLeaf.playButton.onStop = { [unowned self] in
            self.timer.stop()
		}
		playLeaf.resetButton.onReset = { [unowned self] in
            self.playLeaf.playButton.stop()
            self.cron.reset()
            self.cron.tower.trigger()
		}
		playLeaf.stepButton.onStep =  { [unowned self] in
            self.cron.sealed = false
			_ = self.cron.increment()
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
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
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
		
		plasma = CGMutablePath()
		guard let plasma = plasma else { return }

		var a: CGPoint = CGPoint(x: faceLeaf.center.x-20, y: faceLeaf.center.y)						// PlayLeaf
		var b: CGPoint = CGPoint(x: playLeaf.center.x-30, y: playLeaf.center.y)
		var c: CGPoint = CGPoint(x: playLeaf.center.x+30, y: playLeaf.center.y)
		let d: CGPoint = CGPoint(x: faceLeaf.center.x+20, y: faceLeaf.center.y)
		plasma.move(to: a)
		plasma.addQuadCurve(to: b, control: (a+b)/2+CGPoint(x: 30, y: 0))
		plasma.addLine(to: c)
		plasma.addQuadCurve(to: d, control: (c+d)/2+CGPoint(x: -30, y: 0))
		plasma.closeSubpath()

		guard cron.exposed else { return }
		
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
	
// Bubble ==========================================================================================
	override var uiColor: UIColor { !selected ? OOColor.cobolt.uiColor : UIColor.yellow }
    override var hitch: Position { .top }
	override var hitchPoint: CGPoint { overrideHitchPoint }
	override func wireMoorings() {
		startLeaf.wireMoorings()
		stopLeaf.wireMoorings()
		stepsLeaf.wireMoorings()
		rateLeaf.wireMoorings()
		deltaLeaf.wireMoorings()
		whileLeaf.wireMoorings()
		cron.reset()
		cron.tower.trigger()
	}
	
// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        guard let plasma = plasma else { return }
        Skin.plasma(path: plasma, uiColor: uiColor, stroke: 1)
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
