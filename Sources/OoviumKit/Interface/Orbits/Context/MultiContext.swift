//
//  MultiContext.swift
//  Oovium
//
//  Created by Joe Charlier on 9/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class MultiContext: Context {
    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 84, height: 154), uiColor: UIColor.yellow, schematic: Schematic(rows: 1, cols: 1))
        
        schematic.add(row: 0, col: 0, key: Key(text: "delete".localized, uiColor: UIColor(red: 0.6, green: 0.7, blue: 0.8, alpha: 1), {
            if self.aetherView.selectedDeletable() {
                self.aetherView.invokeConfirmModal("deleteManyConfirm".localized) {
                    if self.aetherView.deleteSelected() {
                        self.dismiss()
                    }
                }
            } else {
                self.aetherView.invokeInfoModal("One or more of the selected bubbles is still depended upon.  These selected bubbles can not be deleted.", {})
            }
        }))
        
        renderSchematic()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
}
