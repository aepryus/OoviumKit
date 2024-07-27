//
//  AnCustomSchematic.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/13/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

public class AnCustomSchematic: AnainSchematic {
    init() {
        super.init(rows: 5, cols: 1, cyanKey: "cus", imageNamed: "Custom")
    }
    
    public func render(aether: Aether) {
        let cherry = UIColor(red: 1, green: 0.77, blue: 0.68, alpha: 1)
        
        wipe()

        aether.functions.enumerated().forEach { (i: Int, mechlike: Mechlike) in
            add(row: CGFloat(i), col: 0, w: 1, h: 1, key: Key(text: mechlike.name, uiColor: cherry, font: UIFont.systemFont(ofSize: 16*Oo.s), { [unowned self] in
                guard let token: MechlikeToken = aether.state.mechlikeToken(tag: mechlike.mechlikeToken.tag) else { return }
                self.anainEditor.anainView.post(token: token)
                self.anainEditor.presentFirstSchematic()
            }))
        }
    }
}
