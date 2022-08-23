//
//  MultiContext.swift
//  Oovium
//
//  Created by Joe Charlier on 9/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class MultiContext: Context {
	init() {
		super.init(size: CGSize(width: 84, height: 154), uiColor: UIColor.yellow, schematic: Schematic(rows: 1, cols: 1))
		
		self.schematic.add(row: 0, col: 0, key: Key(text: NSLocalizedString("delete", comment: ""), uiColor: UIColor(red: 0.6, green: 0.7, blue: 0.8, alpha: 1), {
			self.aetherView!.invokeConfirmModal(NSLocalizedString("deleteManyConfirm", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: "")) { [weak self] in
				guard let me = self else {return}
				me.dismiss()
				me.aetherView!.deleteSelected()
				me.aetherView!.unselectAll()
			}
		}))

		self.schematic = schematic
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
}
