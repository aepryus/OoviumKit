//
//  File.swift
//  
//
//  Created by Joe Charlier on 8/22/22.
//

import Foundation

class ExplorerController {
    let aetherExplorer: AetherExplorer
    
    init(aetherExplorer: AetherExplorer) {
        self.aetherExplorer = aetherExplorer
    }
    
    func onNewFolder() {
        
    }
    func onNewAether() {
        let inputModal: InputModal = InputModal(aetherView: aetherExplorer.aetherView)
        inputModal.invoke()
    }
    func onManage() {
    }
}
