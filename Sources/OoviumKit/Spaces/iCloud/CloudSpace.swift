//
//  CloudSpace.swift
//  Oovium
//
//  Created by Joe Charlier on 4/3/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import Foundation
import OoviumEngine

extension URL {
    var itemName: String { self.deletingPathExtension().lastPathComponent }
    var itemPath: String {
        let index: Int = pathComponents.firstIndex { $0 == "Documents" } ?? 0
        let paths: [String] = Array(pathComponents[index+1..<pathComponents.count-2])
        var sb: String = ""
        paths.forEach { sb += "\($0)/" }
        return sb
    }
}

extension NSMetadataItem {
    var url: URL { value(forAttribute: NSMetadataItemURLKey) as! URL }
    var name: String { url.deletingPathExtension().lastPathComponent }
    var path: String {
        var path: String = url.deletingLastPathComponent().absoluteString
        path.removeFirst(Space.cloud!.url.absoluteString.lengthOfBytes(using: .utf8))
        if path.last == "/" { path.removeLast() }
        return path
    }
    var key: String { "\(path)/\(name)" }
}

public class CloudSpace: Space {
    let opQueue: OperationQueue = OperationQueue()
    let query: NSMetadataQuery = NSMetadataQuery()

    var facades: [String:[Facade]] = [:]
    var folders: [String:Facade] = [:]
    var metadata: [String:NSMetadataItem] = [:]
    
    private var complete: (()->())?
    
    public init?(_ complete: (()->())? = nil) {
        self.complete = complete
        super.init(
            name: "iCloud".localized,
            url: FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents")
        )
        
        opQueue.maxConcurrentOperationCount = 1
        query.operationQueue = opQueue
        
        query.predicate = NSPredicate(format: "%K LIKE '*/Documents/*.oo'", NSMetadataItemPathKey, NSMetadataItemPathKey)
        query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        query.enableUpdates()

        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidUpdate, object: query, queue: query.operationQueue, using: queryDidUpdate)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidStartGathering, object: query, queue: query.operationQueue, using: queryDidStartGathering)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: query, queue: query.operationQueue, using: queryDidFinishGathering)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryGatheringProgress, object: query, queue: query.operationQueue, using: queryGatheringProgress)

        opQueue.addOperation { self.query.start() }
    }
    
    func loadFolders(for facade: Facade) {
        folders[facade.path] = facade
        facades[facade.path] = []
        do {
            let folderURLs: [URL] = try FileManager.default.contentsOfDirectory(at: facade.url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter( { $0.hasDirectoryPath } )
            folderURLs.forEach {
                let sub: Facade = Facade.create(url: $0)
                loadFolders(for: sub)
                facades[facade.path]!.append(sub)
            }
        } catch { print("loadFolders ERROR: [\(error)]") }
    }
    func loadFolders() { loadFolders(for: Facade.create(space: self)) }

    func load(metadataItems: [NSMetadataItem]) {
        loadFolders()
        metadataItems.forEach {
            metadata[$0.key] = $0
            facades[$0.path]?.append(Facade.create(url: $0.url))
        }
        var sorted: [String:[Facade]] = [:]
        facades.forEach {
            sorted[$0.key] = $0.value.sorted { (a: Facade, b:Facade) in
                if a.type != b.type { return a.type == .folder }
                return a.name.uppercased() < b.name.uppercased()
            }
        }
        facades = sorted
        delegate?.onChanged(space: self)
        complete?()
        complete = nil
    }
    
// Space ===========================================================================================
    override public func loadFacades(facade: Facade, _ complete: @escaping ([Facade]) -> ()) {
        complete(facades[facade.path] ?? [])
    }
    override public func loadAether(facade: Facade, _ complete: @escaping (String?) -> ()) {
        let url: URL = facade.url
        if facade.document == nil { facade.document = AetherDocument(fileURL: url) }
        let document: AetherDocument = facade.document as! AetherDocument
        opQueue.addOperation {
            document.open { (success: Bool) in
                guard success else { return }
                DispatchQueue.main.async { complete(document.json) }
            }
        }
    }
    override public func storeAether(facade: Facade, aether: Aether, _ complete: @escaping (Bool) -> ()) {
        let url: URL = facade.url
        if facade.document == nil { facade.document = AetherDocument(fileURL: url) }
        let document: AetherDocument = facade.document as! AetherDocument
        document.aether = aether
        opQueue.addOperation {
            document.save(to: url, for: .forOverwriting) { (success: Bool) in
                DispatchQueue.main.async { complete(success) }
            }
        }
    }
    override public func renameAether(facade: Facade, name: String, _ complete: @escaping (Bool) -> ()) {
        var url: URL = facade.url
        var rv = URLResourceValues()
        rv.name = "\(name).oo"
        do {
            try url.setResourceValues(rv)
            complete(true)
        } catch {
            print("renameAether ERROR:\(error)")
            complete(false)
        }
    }
    override public func removeAether(facade: Facade, _ complete: @escaping (Bool) -> ()) {
        let url: URL = facade.url
        do {
            try FileManager.default.removeItem(atPath: url.path)
            complete(true)
        } catch {
            print("removeAether ERROR: [\(error)]")
            complete(false)
        }
    }
    override public func createFolder(facade: Facade, name: String, _ complete: @escaping (Bool) -> ()) {
        let url: URL = facade.url
        do {
            try FileManager.default.createDirectory(at: url.appendingPathComponent(name, isDirectory: true), withIntermediateDirectories: true)
            complete(true)
            load(metadataItems: Array(metadata.values))
            delegate?.onChanged(space: facade.space)
        } catch {
            print("removeAether ERROR: [\(error)]")
            complete(false)
        }
    }

// Events ==========================================================================================
    @objc func queryDidUpdate(_ notification: Notification) {
//        print("== [ queryDidUpdate ]")
        query.disableUpdates()
        opQueue.addOperation { [unowned self] in
            self.load(metadataItems: query.results as! [NSMetadataItem])
            self.query.enableUpdates()
        }
    }
    @objc func queryDidStartGathering(_ notification: Notification) {
//        print("== [ queryDidStartGathering ]")

    }
    @objc func queryDidFinishGathering(_ notification: Notification) {
//        print("== [ queryDidFinishGathering ]")
        query.disableUpdates()
        opQueue.addOperation { [unowned self] in
            self.load(metadataItems: query.results as! [NSMetadataItem])
            self.query.enableUpdates()
        }
    }
    @objc func queryGatheringProgress(_ notification: Notification) {
//        print("== [ queryGatheringProgress ]")
    }
    
// Static ==========================================================================================
    public static func checkAvailability() -> Bool { FileManager.default.ubiquityIdentityToken != nil }
}
