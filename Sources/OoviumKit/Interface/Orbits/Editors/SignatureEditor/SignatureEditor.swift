//
//  SignatureEditor.swift
//  Pangaea
//
//  Created by Joe Charlier on 2/18/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import UIKit

class SignatureEditor: KeyOrbit {
	var signatureLeaf: SignatureLeaf {
		return editable as! SignatureLeaf
	}
	
    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 134, height: 174), uiColor: UIColor.orange, schematic: Schematic(rows: 4, cols: 1))

		schematic.add(row: 0, col: 0, key: Key(text: NSLocalizedString("addParam", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.8, green: 1, blue: 0.8, alpha: 1), {
			self.signatureLeaf.addInput()
		}))
		schematic.add(row: 1, col: 0, key: Key(text: NSLocalizedString("removeParam", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 1, green: 0.8, blue: 0.8, alpha: 1), {
			self.signatureLeaf.removeInput()
		}))
		schematic.add(row: 2, col: 0, w: 1, h: 2, key: Key(text: NSLocalizedString("OK", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.95, green: 0.85, blue: 0.55, alpha: 1), {
			self.signatureLeaf.releaseFocus()
		}))
		
		renderSchematic()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
}
