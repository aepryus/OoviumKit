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
        let inputModal: InputModal = InputModal(message: "What name would you like for your new folder?".localized)
        inputModal.invoke { (input: String?) in
            guard let input = input else { return }
            self.aetherExplorer.space.newSpace(name: input) {
                print("new space [\(input)]")
            }
        }
    }
    func onManage() {
    }
}
