//
//  Mooring.swift
//  Oovium
//
//  Created by Joe Charlier on 9/22/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

protocol Colorable: AnyObject {
	var uiColor: UIColor {get}
}

class Mooring {
	weak var colorable: Colorable? = nil
	var point: CGPoint = CGPoint.zero {
		didSet {
			positionDoodles()
		}
	}
	var doodles = [LinkDoodle]()
	
	var color: UIColor {
		return colorable?.uiColor ?? UIColor.red
	}
	
	func refreshDoodles() { doodles.forEach{ $0.render() } }
	func wakeDoodles() { doodles.forEach{ $0.wake() } }
	func sleepDoodles() { doodles.forEach{ $0.sleep() } }
	func hideDoodles() { doodles.forEach{ $0.isHidden = true } }
	func unhideDoodles() { doodles.forEach{ $0.isHidden = false } }
	
	private func clear(doodle: LinkDoodle) {
		doodle.from.doodles.remove(object: doodle)
		doodle.to.doodles.remove(object: doodle)
		doodle.removeFromSuperlayer()
	}
	
	func link(mooring: Mooring, wake: Bool) -> LinkDoodle {
		let doodle = LinkDoodle(from: self, to: mooring)
		doodles.append(doodle)
		mooring.doodles.append(doodle)
		if wake {
			doodle.wake()
		}
		return doodle
	}
	func link(mooring: Mooring) -> LinkDoodle { link(mooring: mooring, wake: true) }
	func unlink(mooring: Mooring) {
		for doodle in doodles {
			if doodle.from === self && doodle.to === mooring {
				clear(doodle: doodle)
				break;
			}
		}
	}
	func clearLinks() { doodles.forEach{clear(doodle: $0)} }
	func clearFrom() {
		doodles.forEach{
			if $0.from === self {
				clear(doodle: $0)
			}
		}
	}
	func clearTo() {
		doodles.forEach{
			if $0.to === self {
				clear(doodle: $0)
			}
		}
	}
	
	func positionDoodles() {
		for doodle in doodles {
			doodle.render()
		}
	}
}
