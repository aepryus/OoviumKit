//
//  Snap.swift
//  Oovium
//
//  Created by Joe Charlier on 3/28/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

public class Snap: UIControl {
    private let text: String
    private let anchor: Bool
	private var path: CGPath = CGPath(rect: .zero, transform: nil)

	static let pen: Pen = Pen(font: UIFont(name: "ChicagoFLF", size: 19*Screen.s)!, color: UIColor.green.tint(0.7), alignment: .right)
	static let highlightPen: Pen = pen.clone(color: UIColor.green.tint(0.97))

    public init(text: String, anchor: Bool = false) {
        self.text = text
        self.anchor = anchor
		super.init(frame: .zero)
		backgroundColor = .clear

		addAction(for: [.touchDragEnter]) { [unowned self] in self.touch() }
		addAction(for: [.touchDragExit]) { [unowned self] in self.untouch() }
	}
	required init?(coder: NSCoder) { fatalError() }

	var pen: Pen { touched ? Snap.highlightPen : Snap.pen }

	var touched: Bool = false

	private func touch() {
		touched = true
		setNeedsDisplay()
	}
	private func untouch() {
		touched = false
		setNeedsDisplay()
	}

	public func calcWidth() -> CGFloat { (text as NSString).boundingRect(with: .zero, options: [], attributes: pen.attributes, context: nil).width + (anchor ? 30*s : 64*s) }

	let lw: CGFloat = 2*Screen.s
	private func render() {
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
		let p3b: CGPoint = CGPoint(x: x4, y: y2)
		let p4: CGPoint = CGPoint(x: x1, y: y2)

		let path: CGMutablePath = CGMutablePath()
		path.move(to: (p1+p4)/2)
		path.addArc(tangent1End: p1, tangent2End: (p1+p2)/2, radius: wr)
		if !anchor {
			path.addArc(tangent1End: p2, tangent2End: (p2+p3)/2, radius: nr)
			path.addArc(tangent1End: p3, tangent2End: (p3+p4)/2, radius: wr)
		} else {
			path.addArc(tangent1End: p2, tangent2End: (p2+p3b)/2, radius: (nr+wr)/2)
			path.addArc(tangent1End: p3b, tangent2End: (p3b+p4)/2, radius: (nr+wr)/2)
		}
		path.addArc(tangent1End: p4, tangent2End: (p1+p4)/2, radius: nr)
		path.closeSubpath()
		self.path = path
	}

// UIControl =======================================================================================
		public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
			touch()
			super.touchesBegan(touches, with: event)
		}
		public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
			untouch()
			super.touchesEnded(touches, with: event)
		}
		public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
			untouch()
			super.touchesCancelled(touches, with: event)
		}

// UIView ==========================================================================================
	public override var frame: CGRect {
		didSet { render() }
	}
	public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		let view = super.hitTest(point, with: event)
		guard view == self else { return view }
		return path.contains(point) ? self : nil
	}
	public override func draw(_ rect: CGRect) {
		let c: CGContext = UIGraphicsGetCurrentContext()!
		c.addPath(path)
		c.setStrokeColor(UIColor.green.tint(touched ? 0.93 : 0.8).cgColor)
		c.setFillColor(UIColor.green.shade(0.9).cgColor)
		c.setLineWidth(lw)
		c.drawPath(using: .fillStroke)

		text.draw(in: rect.offsetBy(dx: anchor ? -8*s : -31*s, dy: 4*s), pen: pen)
	}
}
