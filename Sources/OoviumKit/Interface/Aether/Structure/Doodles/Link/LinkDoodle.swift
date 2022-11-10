//
//  LinkDoodle.swift
//  Oovium
//
//  Created by Joe Charlier on 9/22/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class LinkDoodle: Doodle, CAAnimationDelegate {
	unowned let from: Mooring
	unowned let to: Mooring
	
	var asleep: Bool = true
	let pulse = Pulse()
	
	var path = CGMutablePath()
	var period: Double = 0
	
	let LW: CGFloat = 2
	
	init(from: Mooring, to: Mooring) {
		self.from = from
		self.to = to
		super.init()
		
		pulse.position = to.point
		render()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	private func startPulse() {
		pulse.color = to.color
		let flow = CAKeyframeAnimation(keyPath: "position")
		flow.path = path
		flow.duration = period
		flow.delegate = self
		addSublayer(pulse)
		pulse.add(flow, forKey: "flowPulse")
	}
	
	func sleep() {
		asleep = true
		setNeedsDisplay()
        pulse.isHidden = true
		pulse.removeAnimation(forKey: "flowPulse")
	}
	func wake() {
		asleep = false
		setNeedsDisplay()
        pulse.isHidden = false
		startPulse()
	}
	
// Doodle ==========================================================================================
	override func render() {
		let fX = from.point.x
		let fY = from.point.y
		let tX = to.point.x
		let tY = to.point.y
		
		let x = min(fX, tX)
		let y = min(fY, tY)
		let width = abs(fX-tX)+LW
		let height = abs(fY-tY)+LW
		
		frame = CGRect(x: x, y: y, width: width, height: height)
		
		path = CGMutablePath()
		
		var sX, sY, eX, eY, mX, mY, aX, aY, bX, bY: CGFloat
		
		if fX < tX {
			sX = LW
			eX = width-LW
		} else {
			sX = width-LW
			eX = LW
		}
		
		if fY < tY {
			sY = LW
			eY = height-LW
		} else {
			sY = height-LW
			eY = LW
		}
		
		mX = width/2
		mY = height/2
		
		if width > height {
			aX = mX
			aY = sY
			bX = mX
			bY = eY
		} else {
			aX = sX
			aY = mY
			bX = eX
			bY = mY
		}

		path.move(to: CGPoint(x: eX, y: eY))
		path.addQuadCurve(to: CGPoint(x: mX, y: mY), control: CGPoint(x: bX, y: bY))
		path.addQuadCurve(to: CGPoint(x: sX, y: sY), control: CGPoint(x: aX, y: aY))
		
		period = Double(sqrt((sX-eX)*(sX-eX)+(sY-eY)*(sY-eY))/20)

		setNeedsDisplay()
	}
	
// CALayer =========================================================================================
	override func draw(in ctx: CGContext) {
		Skin.doodle(c: ctx, path: path, color: to.color, asleep: asleep)
	}
	
// CAAnimationDelegate =============================================================================
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		pulse.removeFromSuperlayer()
		if flag {
			startPulse()
		}
	}
}
