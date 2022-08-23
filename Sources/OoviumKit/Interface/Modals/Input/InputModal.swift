//
//  File.swift
//  
//
//  Created by Joe Charlier on 8/23/22.
//

import UIKit

class InputModal: Modal {

    init(aetherView: AetherView) {
        super.init(aetherView: aetherView, anchor: .left, size: CGSize(width: 189, height: 189), offset: .zero)
    }
    required init?(coder aDecoder: NSCoder) {fatalError()}

// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        Skin.bubble(path: CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 10, cornerHeight: 10, transform: nil), uiColor: .green, width: 4.0/3.0*Oo.s)
    }
}
