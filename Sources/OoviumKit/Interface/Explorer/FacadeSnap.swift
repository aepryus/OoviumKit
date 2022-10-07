//
//  FacadeSnap.swift
//  Oovium
//
//  Created by Joe Charlier on 8/23/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit

class FacadeSnap: Snap {
    let controller: ExplorerController
    let facade: DirFacade

    init(controller: ExplorerController, facade: DirFacade) {
        self.controller = controller
        self.facade = facade
        super.init(text: facade.name, anchor: self.facade.parent == nil)
        addAction { controller.explorer.facade = facade }
    }
    required init?(coder: NSCoder) { fatalError() }
    
    func enableDoubleClick() {
        let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap))
        gesture.numberOfTapsRequired = 2
        addGestureRecognizer(gesture)
    }
    
// Events ==========================================================================================
    @objc func onDoubleTap() {
        let facade: FolderFacade = facade as! FolderFacade
        controller.onRenameFolder(facade: facade)
    }
}
