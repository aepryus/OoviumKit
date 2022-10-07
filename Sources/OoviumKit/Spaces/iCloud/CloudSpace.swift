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
    var pathStripingPrivate: String { path.replacingOccurrences(of: "/private/var/", with: "/var/") }
    var itemName: String {
        let url: URL = deletingPathExtension()
        let index: Int = url.pathComponents.firstIndex { $0 == space.documentsRoot } ?? 0
        let paths: [String] = Array(url.pathComponents[index+1..<url.pathComponents.count])
        return paths.last ?? ""
    }
    var itemPath: String {
        let url: URL = self
        let index: Int = url.pathComponents.firstIndex { $0 == space.documentsRoot } ?? 0
        let paths: [String]
        if !url.hasDirectoryPath { paths = Array(url.pathComponents[index+1..<url.pathComponents.count-1]) }
        else if index == url.pathComponents.count - 1 { paths = [] }
        else { paths = Array(url.pathComponents[index+1..<url.pathComponents.count-1]) }
        var sb: String = ""
        paths.forEach { sb += "\($0)/" }
        return sb
    }
    var space: Space {
        var spaces: [Space] = [Space.local]
        if let cloud = Space.cloud { spaces.append(cloud) }
        guard let space: Space = spaces.first(where: { (space: Space) in
            pathStripingPrivate.starts(with: space.url.pathStripingPrivate)
        }) else { return Space.anchor }
        return space
    }
    var ooviumKey: String {
        var sb: String = space.name
        guard itemName.count != 0 else { return sb }
        sb += "::"
        if itemPath.count != 0 { sb += itemPath }
        sb += itemName
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
    var ooviumKey: String { "iCloud::\(path)" }
    var key: String { "\(path)/\(name)" }
}

public class CloudSpace: Space {
    let opQueue: OperationQueue = OperationQueue()
    let query: NSMetadataQuery = NSMetadataQuery()
    let queue: DispatchQueue = DispatchQueue(label: "CloudSpace")

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
        folders[facade.ooviumKey] = facade
        facades[facade.ooviumKey] = []
        do {
            let folderURLs: [URL] = try FileManager.default.contentsOfDirectory(at: facade.url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter( { $0.hasDirectoryPath } )
            folderURLs.forEach {
                let sub: Facade = Facade.create(url: $0)
                loadFolders(for: sub)
                facades[facade.ooviumKey]!.append(sub)
            }
        } catch { print("loadFolders ERROR: [\(error)]") }
    }
    func loadFolders() { loadFolders(for: Facade.create(space: self)) }

    func load(metadataItems: [NSMetadataItem]) {
        queue.sync {
            loadFolders()
            metadataItems.forEach {
                metadata[$0.key] = $0
                self.facades[$0.ooviumKey]?.append(Facade.create(url: $0.url))
            }
            var sorted: [String:[Facade]] = [:]
            self.facades.forEach {
                sorted[$0.key] = $0.value.sorted { (a: Facade, b:Facade) in
                    if type(of: a) != type(of: b) { return a is FolderFacade }
                    return a.name.uppercased() < b.name.uppercased()
                }
            }
            self.facades = sorted
            delegate?.onChanged(space: self)
            complete?()
            complete = nil
        }
    }
    
// Space ===========================================================================================
    override public func loadFacades(facade: Facade, _ complete: @escaping ([Facade]) -> ()) {
        queue.sync { complete(facades[facade.ooviumKey] ?? []) }
    }
    override public func loadAether(facade: Facade, _ complete: @escaping (String?) -> ()) {
        let facade: AetherFacade = facade as! AetherFacade
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
        let facade: AetherFacade = facade as! AetherFacade
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
    override public func renameFolder(facade: Facade, name: String, _ complete: @escaping (Bool) -> ()) {
        print("renameFolder [\(facade.name)] to [\(name)]")
        var url: URL = facade.url
        var rv = URLResourceValues()
        rv.name = name
        do {
            try url.setResourceValues(rv)
            complete(true)
        } catch {
            print("renameFolder ERROR:\(error)")
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
