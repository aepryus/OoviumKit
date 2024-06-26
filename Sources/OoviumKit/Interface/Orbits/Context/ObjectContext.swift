//
//  ObjectContext.swift
//  Oovium
//
//  Created by Joe Charlier on 9/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class ObjectContext: Context {
    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 84, height: 154), uiColor: .yellow, schematic: Schematic(rows: 2, cols: 1))
		
		unowned let me = self
		self.schematic.add(row: 0, col: 0, key: Key(text: NSLocalizedString("label", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.7, green: 0.8, blue: 0.9, alpha: 1), {
            guard self.aetherView.selected.count == 1, let objectBub = self.aetherView.selected.first as? ObjectBub else { fatalError() }
			objectBub.objectLeaf.openLabel()
		}))
		self.schematic.add(row: 1, col: 0, key: Key(text: NSLocalizedString("delete", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1), {
			self.aetherView.invokeConfirmModal(NSLocalizedString("deleteOneConfirm", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), {
				me.dismiss()
				me.aetherView.deleteSelected()
			})
		}))
		
		self.schematic = schematic
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
}
