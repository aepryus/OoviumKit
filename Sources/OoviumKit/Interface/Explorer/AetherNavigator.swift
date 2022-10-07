//
//  AetherNavigator.swift
//  Oovium
//
//  Created by Joe Charlier on 3/28/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import UIKit

class AetherNavigator: UIView {
	unowned var controller: ExplorerController
	var facade: DirFacade {
		didSet {
			subviews.forEach { $0.removeFromSuperview() }
			snaps = []
            
            if !(facade.space is AnchorSpace) { snaps.append(NewSnap(controller: controller)) }

            var facade: DirFacade? = facade
			while facade != nil {
                snaps.append(FacadeSnap(controller: controller, facade: facade!))
                facade = facade!.parent
			}

            if self.facade is FolderFacade, let facadeSnap = snaps[1] as? FacadeSnap { facadeSnap.enableDoubleClick() }

			snaps.forEach { addSubview($0) }
            
            render()
		}
	}

	var snaps: [Snap] = []

    init(controller: ExplorerController, facade: DirFacade) {
		self.controller = controller
        self.facade = facade

		super.init(frame: .zero)

//        defer { self.facade = facade }
	}
	required init?(coder: NSCoder) { fatalError() }

	func render() {
		var x: CGFloat = 0*s
		snaps.forEach {
			let w: CGFloat = $0.calcWidth()
			x += w - 16*s
		}
		frame = CGRect(x: 0, y: 0, width: x + 16*s, height: height)
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		var x: CGFloat = 0*s
		snaps.forEach {
			let w: CGFloat = $0.calcWidth()
			$0.frame = CGRect(x: x, y: 0, width: w, height: height)
			x += w - 16*s
		}
	}
}
