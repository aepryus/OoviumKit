//
//  ExplorerController.swift
//  
//
//  Created by Joe Charlier on 8/22/22.
//

import OoviumEngine
import UIKit
import UniformTypeIdentifiers

public class ExplorerController: NSObject, UIDocumentPickerDelegate {
    unowned let explorer: AetherExplorer
    public var viewController: UIViewController?
    
    init(explorer: AetherExplorer) {
        self.explorer = explorer
    }
    
    func onNewFolder() {
        let inputModal: InputModal = InputModal(message: "What name would you like for your new folder?".localized)
        inputModal.invoke { (input: String?) in
            guard let input = input else { return }
            self.explorer.facade.createFolder(name: input) { (success: Bool) in
                self.explorer.facade.space.delegate?.onChanged(space: self.explorer.facade.space)
            }
        }
    }
    func onRenameFolder(facade: FolderFacade) {
        let inputModal: InputModal = InputModal(message: "What name would you like to use for this folder?".localized)
        inputModal.textField.text = facade.name
        inputModal.invoke { (input: String?) in
//            guard let input = input, let facade = self.explorer.facade as? FolderFacade else { return }
//            facade.renameFolder(name: input) { (success: Bool) in
//                guard success else { return }
//                self.explorer.facade.space.delegate?.onChanged(space: self.explorer.facade.space)
//                
//                let pivot: FolderFacade = self.explorer.navigator.facade
//                let parent: DirFacade = pivot.parent
//                guard let aetherFacade: AetherFacade = self.explorer.aetherView.facade,
//                      let clothesLine: String = aetherFacade.clothesLine(facade: pivot)
//                    else { return }
//                print("AA:[\(pivot.ooviumKey)]")
//                print("BB:[\(self.explorer.aetherView.facade!.ooviumKey)]")
//                print("QQ:[\(clothesLine)]")
//                let urlString: String = "\(parent.url)/\(input)"
//                guard let url: URL = URL(string: urlString) else { return }
//                let facade: DirFacade = Facade.create(url: url) as! DirFacade
//                self.explorer.facade = facade
//                print("PP:[\(facade.ooviumKey)\(clothesLine)]")
//            }
        }
    }
    func onNewAether() {
        let facade: DirFacade = explorer.facade
        facade.loadFacades { (facades: [Facade]) in
            let aether: Aether = Aether()
            var aetherNo: Int = 0
            var name: String = ""
            repeat {
                aetherNo += 1
                name = String(format: "%@%02d", "aether".localized, aetherNo)
            } while facades.first { $0.name == name } != nil
            aether.name = name
            let url: URL = facade.url.appendingPathComponent(aether.name).appendingPathExtension("oo")
            let aetherFacade: AetherFacade = Facade.create(url: url) as! AetherFacade
            aetherFacade.store(aether: aether) { (success: Bool) in
                guard success else { return }
                self.explorer.aetherView.swapToAether(facade: aetherFacade, aether: aether)
                self.explorer.aetherView.slideBack()
            }
        }
    }
    func onManage() {
    }
    func onImport() {
        guard let ooviumType: UTType = UTType("com.aepryus.oovium.oo") else { return }
        let controller: UIDocumentPickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: [ooviumType])
        controller.delegate = self
        viewController?.present(controller, animated: true) {}
    }
    
// UIDocumentPickerDelegate ========================================================================
    private func importAethers(urls: [URL]) {
        urls.forEach {
            guard let data: Data = FileManager.default.contents(atPath: $0.path),
                  let xmlAtts: [String:Any] = String(data: data, encoding: .utf8)?.xmlToAttributes()
                else { return }
            
            let name: String = $0.itemName
            let jsonAtts: [String:Any] = Migrate.migrateXMLtoJSON(xmlAtts)
            let aether: Aether = Aether(json: Migrate.migrateAether(json: jsonAtts.toJSON()))
            let facade: AetherFacade = Facade.create(url: explorer.facade.url.appendingPathComponent(name).appendingPathExtension("oo")) as! AetherFacade
            facade.store(aether: aether) { (success: Bool) in
                print("[\(name)] imported successfully")
            }
        }
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        importAethers(urls: [url])
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        importAethers(urls: urls)
    }
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) { }
}
