//
//  Trapezoid.swift
//  Oovium
//
//  Created by Joe Charlier on 4/6/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

class Trapezoid: UIControl {
	let title: String
	let flipped: Bool

	private var path: CGPath = CGPath(rect: .zero, transform: nil)

	static let pen: Pen = Pen(font: UIFont(name: "ChicagoFLF", size: 19*Screen.s)!, color: UIColor.green.tint(0.7), alignment: .center)
	static let highlightPen: Pen = pen.clone(color: UIColor.green.tint(0.97))

	init(title: String, flipped: Bool = false) {
		self.title = title
		self.flipped = flipped
		super.init(frame: .zero)
		backgroundColor = .clear

		addAction(for: [.touchDragEnter]) { [unowned self] in self.touch() }
		addAction(for: [.touchDragExit]) { [unowned self] in self.untouch() }
	}
	required init?(coder: NSCoder) { fatalError() }

	var pen: Pen { touched ? Trapezoid.highlightPen : Trapezoid.pen }

	var touched: Bool = false

	private func touch() {
		touched = true
		setNeedsDisplay()
	}
	private func untouch() {
		touched = false
		setNeedsDisplay()
	}

	func calcWidth() -> CGFloat {
		return (title as NSString).boundingRect(with: .zero, options: [], attributes: pen.attributes, context: nil).width + 30*s
	}

	let lw: CGFloat = 2*Screen.s
	private func render() {
		let sw: CGFloat = (height-lw)*2/3
		let wr: CGFloat = 9*s
		let	nr: CGFloat = 3*s

		let x1: CGFloat = lw/2
		let x2: CGFloat = x1 + sw
		let x4: CGFloat = width - lw/2

		let y1: CGFloat = lw/2
		let y2: CGFloat = height - lw

		let path: CGMutablePath = CGMutablePath()
		if flipped {
			let p1: CGPoint = CGPoint(x: x1, y: y1)
			let p2: CGPoint = CGPoint(x: x4, y: y1)
			let p3: CGPoint = CGPoint(x: x4, y: y2)
			let p4: CGPoint = CGPoint(x: x2, y: y2)

			path.move(to: (p1+p4)/2)
			path.addArc(tangent1End: p1, tangent2End: (p1+p2)/2, radius: nr)
			path.addArc(tangent1End: p2, tangent2End: (p2+p3)/2, radius: (nr+wr)/2)
			path.addArc(tangent1End: p3, tangent2End: (p3+p4)/2, radius: (nr+wr)/2)
			path.addArc(tangent1End: p4, tangent2End: (p1+p4)/2, radius: wr)
		} else {
			let p1: CGPoint = CGPoint(x: x2, y: y1)
			let p2: CGPoint = CGPoint(x: x4, y: y1)
			let p3: CGPoint = CGPoint(x: x4, y: y2)
			let p4: CGPoint = CGPoint(x: x1, y: y2)

			path.move(to: (p1+p4)/2)
			path.addArc(tangent1End: p1, tangent2End: (p1+p2)/2, radius: wr)
			path.addArc(tangent1End: p2, tangent2End: (p2+p3)/2, radius: (nr+wr)/2)
			path.addArc(tangent1End: p3, tangent2End: (p3+p4)/2, radius: (nr+wr)/2)
			path.addArc(tangent1End: p4, tangent2End: (p1+p4)/2, radius: nr)
		}
		path.closeSubpath()
		self.path = path
		setNeedsDisplay()
	}

// UIControl =======================================================================================
		override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
			touch()
			super.touchesBegan(touches, with: event)
		}
		override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
			untouch()
			super.touchesEnded(touches, with: event)
		}
		override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
			untouch()
			super.touchesCancelled(touches, with: event)
		}

// UIView ==========================================================================================
	override var frame: CGRect {
		didSet { render() }
	}
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let view = super.hitTest(point, with: event)
		guard view == self else { return view }
		return path.contains(point) ? self : nil
	}
	override func draw(_ rect: CGRect) {
		let c: CGContext = UIGraphicsGetCurrentContext()!
		c.addPath(path)
		c.setStrokeColor(UIColor.green.tint(touched ? 0.93 : 0.8).cgColor)
		c.setFillColor(UIColor.green.shade(0.9).cgColor)
		c.setLineWidth(lw)
		c.drawPath(using: .fillStroke)

		let ds: CGFloat = height/5
		(title as NSString).draw(in: rect.offsetBy(dx: ds, dy: ds), pen: pen)
	}
}
