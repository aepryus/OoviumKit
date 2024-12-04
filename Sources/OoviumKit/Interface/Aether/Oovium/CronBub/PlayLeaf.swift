//
//  PlayLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 2/18/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class PlayLeaf: Leaf {
	var path: CGMutablePath!
	
	lazy var playButton: PlayButton = {
		PlayButton(playLeaf: self)
	}()
	lazy var resetButton: ResetButton = {
		ResetButton(playLeaf: self)
	}()
	lazy var stepButton: StepButton = {
		StepButton(playLeaf: self)
	}()

	init(bubble: Bubble) {
		super.init(bubble: bubble, hitch: .top, anchor: CGPoint.zero, size: CGSize.zero)
		renderPath()
		
		addSubview(resetButton)
		addSubview(stepButton)
		addSubview(playButton)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func renderPath() {
		let p: CGFloat = 3						// padding
		let cr: CGFloat = 24					// center radius
		let sr: CGFloat = 21					// side radius
		let ol: CGFloat = 12					// overlap
		
		let d: CGFloat = sr+cr-ol
		let aA = acos((d*d+sr*sr-cr*cr)/(2*d*sr))
		let aB = acos((d*d-sr*sr+cr*cr)/(2*d*cr))
		
		path = CGMutablePath()
		path.addArc(center: CGPoint(x: p+sr, y: p+cr), radius: sr, startAngle: aA, endAngle: -aA, clockwise: false)
		path.addArc(center: CGPoint(x: p+sr*2+cr-ol, y: p+cr), radius: cr, startAngle: aB+CGFloat.pi, endAngle: -aB, clockwise: false)
		path.addArc(center: CGPoint(x: p+sr*3+cr*2-2*ol, y: p+cr), radius: sr, startAngle: aA+CGFloat.pi, endAngle: -aA+CGFloat.pi, clockwise: false)
		path.addArc(center: CGPoint(x: p+sr*2+cr-ol, y: p+cr), radius: cr, startAngle: aB, endAngle: -(aB+CGFloat.pi), clockwise: false)
		
		hitPath = path
		
		size = CGSize(width: 2*p+4*sr+2*cr-2*ol, height: 2*p+2*cr)
	}
	
// UIView ==========================================================================================
	override func setNeedsDisplay() {
		super.setNeedsDisplay()
		playButton.setNeedsDisplay()
		resetButton.setNeedsDisplay()
		stepButton.setNeedsDisplay()
	}
	override func layoutSubviews() {
		playButton.center(size: playButton.bounds.size)
		resetButton.center(dx: -33, size: resetButton.bounds.size)
		stepButton.center(dx: 33, size: stepButton.bounds.size)
	}
	override func draw(_ rect: CGRect) {
		Skin.bubble(path: path, uiColor: bubble.uiColor, width: Oo.s)
	}
}
