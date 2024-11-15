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
    private unowned let aetherView: AetherView
    private unowned let colorable: Colorable
    var tokenKey: TokenKey
    
	var point: CGPoint = CGPoint.zero {
        didSet { doodles.forEach { $0.render() } }
	}
    var doodles: [LinkDoodle] = []
    
    init(aetherView: AetherView, key: TokenKey, colorable: Colorable) {
        self.aetherView = aetherView
        self.tokenKey = key
        self.colorable = colorable
    }
	
	var color: UIColor { colorable.uiColor }
	
	func wakeDoodles() { doodles.forEach{ $0.wake() } }
	func sleepDoodles() { doodles.forEach{ $0.sleep() } }
    
    func attach(_ mooring: Mooring, wake: Bool = true) {
        let doodle: LinkDoodle = LinkDoodle(from: mooring, to: self)
        doodles.append(doodle)
        mooring.doodles.append(doodle)
        if wake { doodle.wake() }
        aetherView.add(doodle: doodle)
    }
    func detach(_ mooring: Mooring) {
        // TODO: This allows for nils, but ideally this shouldn't be called if there is no doodle.  The usesMooring mechanism doesn't seem to be used
        // any more.  I think I decided to allow GridBub header ChainLeafs to link to other non GridBib moorings.  Perhaps the whole thing needs to be
        // revamped.  -- jjc 10/20/24
        guard let doodle: LinkDoodle = doodles.first(where: { $0.from === mooring && $0.to === self }) else { return }
        doodles.remove(object: doodle)
        mooring.doodles.remove(object: doodle)
        aetherView.remove(doodle: doodle)
    }
}
