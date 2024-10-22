//
//  Trapezoid.swift
//  Oovium
//
//  Created by Joe Charlier on 4/6/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

public class Trapezoid: UIControl {
    public enum Slant { case up, down, vertical }
    
    var title: String {
        didSet { setNeedsDisplay() }
    }
    let leftSlant: Slant
    let rightSlant: Slant

	private var path: CGPath = CGPath(rect: .zero, transform: nil)
    private var textRect: CGRect = .zero

	static let pen: Pen = Pen(font: UIFont(name: "ChicagoFLF", size: 19*Screen.s)!, color: UIColor.green.tint(0.7), alignment: .center)
	static let highlightPen: Pen = pen.clone(color: UIColor.green.tint(0.97))

    public init(title: String, leftSlant: Slant = .vertical, rightSlant: Slant = .vertical) {
		self.title = title
        self.leftSlant = leftSlant
        self.rightSlant = rightSlant
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
        let ar: CGFloat = (nr+wr)/2

		let x1: CGFloat = lw/2
		let x2: CGFloat = x1 + sw
		let x4: CGFloat = width - lw/2
        let x3: CGFloat = x4 - sw

		let y1: CGFloat = lw/2
		let y2: CGFloat = height - lw/2
        
        let p1: CGPoint = CGPoint(x: leftSlant == .up ? x2 : x1, y: y1)
        let p2: CGPoint = CGPoint(x: rightSlant == .down ? x3 : x4, y: y1)
        let p3: CGPoint = CGPoint(x: rightSlant == .up ? x3 : x4, y: y2)
        let p4: CGPoint = CGPoint(x: leftSlant == .down ? x2 : x1, y: y2)
        
        let r1: CGFloat
        let r2: CGFloat
        let r3: CGFloat
        let r4: CGFloat
        
        if leftSlant == .up { r1 = wr; r4 = nr }
        else if leftSlant == .down { r1 = nr; r4 = wr }
        else { r1 = ar; r4 = ar }

        if rightSlant == .up { r2 = nr; r3 = wr }
        else if rightSlant == .down { r2 = wr; r3 = nr }
        else { r2 = ar; r3 = ar }
        
        let lx: CGFloat = (p1.x + p4.x)/2
        let rx: CGFloat = (p2.x + p3.x)/2
        textRect = CGRect(x: lx, y: height/6, width: rx-lx, height: y2-y1)
            
        let path: CGMutablePath = CGMutablePath()
        path.move(to: (p1+p4)/2)
        path.addArc(tangent1End: p1, tangent2End: (p1+p2)/2, radius: r1)
        path.addArc(tangent1End: p2, tangent2End: (p2+p3)/2, radius: r2)
        path.addArc(tangent1End: p3, tangent2End: (p3+p4)/2, radius: r3)
        path.addArc(tangent1End: p4, tangent2End: (p1+p4)/2, radius: r4)
        path.closeSubpath()
        self.path = path
        setNeedsDisplay()
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

		title.draw(in: textRect, pen: pen)
	}
}
