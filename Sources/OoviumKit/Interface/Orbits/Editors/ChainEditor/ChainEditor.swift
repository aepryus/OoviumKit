//
//  SheathHover.swift
//  Oovium
//
//  Created by Joe Charlier on 4/9/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

public class ChainEditor: Orbit {
	var cyanOn: Bool = false
	var schematics: [ChainSchematic] = [] {
		didSet { schematics.forEach {$0.chainEditor = self} }
	}
	
	lazy private var cyanKeyPad: CyanKeyPad = {CyanKeyPad(chainEditor: self)}()
	let keyView: KeyView
	public let customSchematic: CustomSchematic?

	unowned var chainView: ChainView!

    public init(orb: Orb, schematics: [ChainSchematic], customSchematic: CustomSchematic? = nil) {
		self.schematics = schematics
		if let customSchematic = customSchematic { self.schematics.append(customSchematic) }
		self.customSchematic = customSchematic
		self.keyView = KeyView(size: CGSize(width: 174, height: 214), uiColor: .orange, schematic: schematics[0])

        super.init(orb: orb, size: CGSize(width: 174+54+3, height: 214))
		
		addSubview(keyView)
		keyView.frame = CGRect(x: (54+3)*Oo.s, y: 0, width: keyView.width, height: keyView.height)

		schematics.forEach { $0.chainEditor = self }
		keyView.schematic = self.schematics[0]
	}
    convenience init(orb: Orb) {
        self.init(orb: orb, schematics: [
			NumberSchematic(),
			ScientificSchematic(),
			MiscellaneousSchematic(),
			LexiconSchematic()
		], customSchematic: CustomSchematic())
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	func toggleCyanKeyPad() {
		cyanOn = !cyanOn
		cyanKeyPad.toggle()
	}
	func presentFirstSchematic() {
		keyView.schematic = schematics[0]
		for j in 0..<cyanKeyPad.schematic.keySlots.count {
			if let key: Key = cyanKeyPad.schematic.keySlots[j].key as? Key {
				key.active = false
			} else if let key: ImageKey = cyanKeyPad.schematic.keySlots[j].key as? ImageKey {
				key.active = false
			}
		}
		(cyanKeyPad.schematic.keySlots[0].key as! ImageKey).active = true
	}

// Hover ===========================================================================================
	override open func onInvoke() {
		if cyanOn {cyanKeyPad.invoke()}
	}
	override open func onDismiss() {
		cyanKeyPad.dismiss()
	}
	override func reRender() {
		cyanKeyPad.setNeedsDisplay()
		schematics.forEach { $0.keySlots.forEach { $0.key.setNeedsDisplay() } }
	}
}
