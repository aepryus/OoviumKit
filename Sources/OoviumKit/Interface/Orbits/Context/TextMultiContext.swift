//
//  TextMultiContext.swift
//  Oovium
//
//  Created by Joe Charlier on 9/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class TextMultiContext: Context {
	let colorContext: ColorContext
	let shapeContext: ShapeContext

    init(orb: Orb) {
        colorContext = ColorContext(orb: orb)
        shapeContext = ShapeContext(orb: orb)
        
        super.init(orb: orb, size: CGSize(width: 84, height: 174), uiColor: UIColor.yellow, schematic: Schematic(rows: 2, cols: 1))
		
		colorContext.shapeContext = shapeContext
		shapeContext.colorContext = colorContext
		
		self.schematic.add(row: 0, col: 0, key: Key(text: NSLocalizedString("color", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.7, green: 0.8, blue: 0.9, alpha: 1), { [unowned self] in
			self.orb.toggle(orbit: self.colorContext)
		}))
		self.schematic.add(row: 1, col: 0, key: Key(text: NSLocalizedString("shape", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.6, green: 0.7, blue: 0.8, alpha: 1), { [unowned self] in
			self.orb.toggle(orbit: self.shapeContext)
		}))

		self.schematic = schematic
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }	
}
