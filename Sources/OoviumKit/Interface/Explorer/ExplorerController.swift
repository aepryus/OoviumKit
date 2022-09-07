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
        let inputModal: InputModal = InputModal(message: "What name would you like for your new folder?".localized)
        inputModal.invoke { (input: String?) in
            guard let input = input else { return }
            self.aetherExplorer.facade.createFolder(name: input) { (success: Bool) in
                self.aetherExplorer.facade.space.delegate?.onChanged(space: self.aetherExplorer.facade.space)
            }
        }
    }
    func onNewAether() {
    }
    func onManage() {
    }
}
