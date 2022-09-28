//
//  LassoDoodle.swift
//  Oovium
//
//  Created by Joe Charlier on 9/22/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

struct Range {
	var left: CGFloat
	var right: CGFloat
	var top: CGFloat
	var bottom: CGFloat
	
	init(point: CGPoint) {
		left = round(point.x)
		right = round(point.x)
		top = round(point.y)
		bottom = round(point.y)
	}
	
	var width: CGFloat {
		return right-left
	}
	var height: CGFloat {
		return bottom-top
	}
	
	mutating func add(point: CGPoint) {
		left = min(left, round(point.x))
		right = max(right, round(point.x))
		top = min(top, round(point.y))
		bottom = max(bottom, round(point.y))
	}
	mutating func envelop(range: Range, by: CGFloat) {
		left = range.left - by
		right = range.right + by
		top = range.top - by
		bottom = range.bottom + by
	}
}

class LassoDoodle: Doodle, CAAnimationDelegate {
	unowned let aetherView: AetherView
	
	var path: CGMutablePath
	var image: UIImage
	var range: Range
	var current: Range
	var next: CGPoint
	var last: CGPoint
	let p: CGFloat = 2

	init(aetherView: AetherView, touch: UITouch) {
		self.aetherView = aetherView
		last = touch.location(in: aetherView.scrollView)
		next = last
		range = Range(point: last)
		current = Range(point: CGPoint.zero)
		current.envelop(range: range, by: p)
		
		path = CGMutablePath()
		path.move(to: last)
		image = UIImage()
		
		super.init()
		
		frame = CGRect(x: range.left-p, y: range.top-p, width: range.width+2*p, height: range.height+2*p)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func add(touch: UITouch) {
		next = touch.location(in: aetherView.scrollView)
		path.addLine(to: next)
		range.add(point: next)
		frame = CGRect(x: range.left-p, y: range.top-p, width: range.width+2*p, height: range.height+2*p)
		setNeedsDisplay()
	}
	
	func fadeOut() {
		opacity = 0
		let fade = CAKeyframeAnimation(keyPath: "opacity")
		fade.values = [1, 0]
		fade.duration = 1
		fade.delegate = self
		add(fade, forKey: "fade")
	}
	
// CAAnimationDelegate =============================================================================
	func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
		aetherView.remove(doodle: self)
	}
	
// CALayer =========================================================================================
	override func draw(in ctx: CGContext) {

		UIGraphicsBeginImageContextWithOptions(CGSize(width: range.width+2*p, height: range.height+2*p), false, 0)
		
		let box = CGRect(x: current.left-(range.left-p), y: current.top-(range.top-p), width: current.width, height: current.height)
		image.draw(in: box)
		
		let path = CGMutablePath()
		path.move(to: CGPoint(x: last.x-(range.left-p), y: last.y-(range.top-p)))
		path.addLine(to: CGPoint(x: next.x-(range.left-p), y: next.y-(range.top-p)))
		Skin.lasso(path: path)
		
		image = UIGraphicsGetImageFromCurrentImageContext()!
		
		UIGraphicsEndImageContext()
		
		ctx.translateBy(x: 0, y: image.size.height)
		ctx.scaleBy(x: 1, y: -1)
		if let cgImage = image.cgImage {
			ctx.draw(cgImage, in: bounds)
		}

		current.envelop(range: range, by: p)
		
		last = next
	}
}
