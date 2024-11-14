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
            guard let input = input else { return }
            facade.renameFolder(name: input) { (success: Bool) in
                guard success else { return }
                facade.space.delegate?.onChanged(space: facade.space)
                self.explorer.facade = facade
            }
        }
    }
    public func onNewAether() {
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
        controller.allowsMultipleSelection = true
        controller.delegate = self
        viewController?.present(controller, animated: true) {}
    }
    
// UIDocumentPickerDelegate ========================================================================
    private func importAethers(urls: [URL]) throws {
        try urls.forEach {
            guard let data: Data = FileManager.default.contents(atPath: $0.path),
                  let dataString = String(data: data, encoding: .utf8)
                else { return }
            
            let name: String = $0.itemName
            let xmlAtts: [String:Any] = dataString.xmlToAttributes()
            let jsonAtts: [String:Any] = xmlAtts.count == 0 ? dataString.toAttributes() : Migrate.migrateXMLtoJSON(xmlAtts)
            let aether: Aether = Aether(json: try Migrate.migrateAether(json: jsonAtts.toJSON()))
            let facade: AetherFacade = Facade.create(url: explorer.facade.url.appendingPathComponent(name).appendingPathExtension("oo")) as! AetherFacade
            facade.store(aether: aether) { (success: Bool) in
                print("[\(name)] imported successfully")
            }
        }
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        do {
            try importAethers(urls: [url])
        } catch {
            print("\(error)")
        }
    }
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        do {
            try importAethers(urls: urls)
        } catch {
            print("\(error)")
        }
    }
    public func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) { }
}
