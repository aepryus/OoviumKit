//
//  StepButton.swift
//  Oovium
//
//  Created by Joe Charlier on 2/21/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import UIKit

class StepButton: UIView {
	unowned let playLeaf: PlayLeaf
	
	var onStep:()->() = {}
	
	private var uiColor: UIColor {
		return playLeaf.bubble.uiColor
	}
	
	init(playLeaf: PlayLeaf) {
		self.playLeaf = playLeaf
		
		super.init(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
		
		backgroundColor = UIColor.clear
		
		let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
		addGestureRecognizer(gesture)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
// Events ==========================================================================================
	@objc func onTap() {
		onStep()
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let h: CGFloat = 16				// height
		let bw: CGFloat = 3				// bar width
		let mw: CGFloat = 3				// margin width
		
		let x1: CGFloat = 20
		let x3 = x1+bw
		let x2 = (x1+x3)/2
		let x4 = x3+mw
		
		let y1: CGFloat = 6.5
		let y3 = y1+h
		let y2 = (y1+y3)/2

		let path = CGMutablePath()
		path.move(to: CGPoint(x: x1, y: y2))
		path.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x2, y: y1), radius: 1)
		path.addArc(tangent1End: CGPoint(x: x3, y: y1), tangent2End: CGPoint(x: x3, y: y2), radius: 1)
		path.addArc(tangent1End: CGPoint(x: x3, y: y3), tangent2End: CGPoint(x: x2, y: y3), radius: 1)
		path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x1, y: y2), radius: 1)
		path.closeSubpath()
		
		let q: CGFloat = -0.05
		path.move(to: CGPoint(x: x4, y: y3))
		path.addLine(to: CGPoint(x: x4, y: y1))
		path.addArc(center: CGPoint(x: x4, y: y2), radius: h/2, startAngle: CGFloat.pi/2+q, endAngle: -CGFloat.pi/2+q, clockwise: true)

		let stroke = uiColor
		let fill = stroke.shade(0.5)
		let c = UIGraphicsGetCurrentContext()!
		c.addPath(path)
		c.setFillColor(fill.cgColor)
		c.setStrokeColor(stroke.cgColor)
		c.setLineWidth(1.5)
		c.drawPath(using: .fillStroke)
	}
}
