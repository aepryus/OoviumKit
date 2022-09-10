//
//  File.swift
//  
//
//  Created by Joe Charlier on 8/22/22.
//

import UIKit
import OoviumEngine

public class ExplorerController: NSObject, UIDocumentPickerDelegate {
    let behindView: BehindView
    public var viewController: UIViewController?
    
    init(behindView: BehindView) {
        self.behindView = behindView
    }
    
    func onNewFolder() {
        let inputModal: InputModal = InputModal(message: "What name would you like for your new folder?".localized)
        inputModal.invoke { (input: String?) in
            guard let input = input else { return }
            self.behindView.leftExplorer.facade.createFolder(name: input) { (success: Bool) in
                self.behindView.leftExplorer.facade.space.delegate?.onChanged(space: self.behindView.leftExplorer.facade.space)
            }
        }
    }
    func onNewAether() {
        let facade: Facade = behindView.leftExplorer.facade
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
            let aetherFacade: Facade = Facade.create(url: url)
            aetherFacade.store(aether: aether) { (success: Bool) in
                guard success else { return }
                self.behindView.leftExplorer.aetherView.swapToAether(facade: aetherFacade, aether: aether)
                self.behindView.leftExplorer.aetherView.slideBack()
            }
        }
    }
    func onManage() {
    }
    func onImport() {
        let controller = UIDocumentPickerViewController(documentTypes: ["public.folder", "com.aepryus.oovium.oo"], in: .import)
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
            let facade: Facade = Facade.create(url: behindView.leftExplorer.facade.url.appendingPathComponent(name).appendingPathExtension("oo"))
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
