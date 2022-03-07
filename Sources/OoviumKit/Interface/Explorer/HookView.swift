//
//  HookView.swift
//  Oovium
//
//  Created by Joe Charlier on 3/27/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class HookView: UIControl {
//	static let backColor: UIColor = UIColor(red: 32/255, green: 34/255, blue: 36/255, alpha: 1)
//	static let lineColor: UIColor = UIColor(red: 200/255, green: 255/255, blue: 240/255, alpha: 1)
	static let backColor: UIColor = UIColor.green.shade(0.3)
	static let lineColor: UIColor = UIColor.green.tint(0.8)

	var name: String = "" {
		didSet { setNeedsDisplay() }
	}
	let pen: Pen = Pen(font: UIFont(name: "ChicagoFLF", size: Screen.mac ? 20*Screen.s : 15*Screen.s) ?? UIFont.systemFont(ofSize: Screen.mac ? 20*Screen.s : 15*Screen.s), color: lineColor, alignment: .center)

	init() {
		super.init(frame: .zero)
		backgroundColor = .clear
	}
	required init?(coder: NSCoder) { fatalError() }

// UIView ==========================================================================================
	let lw: CGFloat = 2*Screen.s
	override func draw(_ rect: CGRect) {
		let sw: CGFloat = 20*s
		let wr: CGFloat = 9*s
		let	nr: CGFloat = 3*s

		let x1: CGFloat = lw/2
		let x2: CGFloat = x1 + sw
		let x4: CGFloat = width - lw/2
		let x3: CGFloat = x4 - sw

		let y1: CGFloat = lw/2
		let y2: CGFloat = height - lw

		let p1: CGPoint = CGPoint(x: x2, y: y1)
		let p2: CGPoint = CGPoint(x: x4, y: y1)
		let p3: CGPoint = CGPoint(x: x3, y: y2)
		let p4: CGPoint = CGPoint(x: x1, y: y2)

		let path: CGMutablePath = CGMutablePath()
		path.move(to: (p1+p4)/2)
		path.addArc(tangent1End: p1, tangent2End: (p1+p2)/2, radius: wr)
		path.addArc(tangent1End: p2, tangent2End: (p2+p3)/2, radius: nr)
		path.addArc(tangent1End: p3, tangent2End: (p3+p4)/2, radius: wr)
		path.addArc(tangent1End: p4, tangent2End: (p1+p4)/2, radius: nr)
		path.closeSubpath()

		let c: CGContext = UIGraphicsGetCurrentContext()!
		c.addPath(path)
		c.setStrokeColor(UIColor.green.tint(0.8).cgColor)
		c.setFillColor(UIColor.green.shade(0.9).cgColor)
		c.setLineWidth(lw)
		c.drawPath(using: .fillStroke)

		(name as NSString).draw(in: rect.offsetBy(dx: 0*s, dy: 7*s), pen: pen)
	}
}
