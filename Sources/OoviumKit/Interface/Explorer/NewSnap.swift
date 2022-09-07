//
//  NewSnap.swift
//  Oovium
//
//  Created by Joe Charlier on 8/23/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

class NewSnap: Snap {
    
    init(controller: ExplorerController) {
        super.init(text: "\u{FF0B}")
        addAction { controller.onNewFolder() }
    }
    required init?(coder: NSCoder) { fatalError() }
}
