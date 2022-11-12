//
//  Mooring.swift
//  Oovium
//
//  Created by Joe Charlier on 9/22/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

protocol Colorable: AnyObject {
	var uiColor: UIColor {get}
}

class Mooring {
    private unowned var bubble: Bubble
    weak var token: Token?
    
	var point: CGPoint = CGPoint.zero {
        didSet { doodles.forEach { $0.render() } }
	}
    var doodles: [LinkDoodle] = []
    
    init(bubble: Bubble, token: Token? = nil) {
        self.bubble = bubble
        self.token = token
    }
	
	var color: UIColor { bubble.uiColor }
	
//	func refreshDoodles() { doodles.forEach{ $0.render() } }
	func wakeDoodles() { doodles.forEach{ $0.wake() } }
	func sleepDoodles() { doodles.forEach{ $0.sleep() } }
//	func hideDoodles() { doodles.forEach{ $0.isHidden = true } }
//	func unhideDoodles() { doodles.forEach{ $0.isHidden = false } }
    
    func attach(_ mooring: Mooring, wake: Bool = true) {
        let doodle: LinkDoodle = LinkDoodle(from: mooring, to: self)
        doodles.append(doodle)
        mooring.doodles.append(doodle)
        if wake { doodle.wake() }
        bubble.aetherView.add(doodle: doodle)
    }
    func detach(_ mooring: Mooring) {
        let doodle: LinkDoodle = doodles.first(where: { $0.from === mooring && $0.to === self })!
        doodles.remove(object: doodle)
        mooring.doodles.remove(object: doodle)
        bubble.aetherView.remove(doodle: doodle)
    }
}
