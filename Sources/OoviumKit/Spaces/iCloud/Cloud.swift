//
//  Cloud.swift
//  Oovium
//
//  Created by Joe Charlier on 8/26/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine

extension NSMetadataItem {
    var url: URL { value(forAttribute: NSMetadataItemURLKey) as! URL }
    var name: String { url.deletingPathExtension().lastPathComponent }
    var path: String {
        var path: String = url.deletingLastPathComponent().absoluteString
        path.removeFirst(Cloud.cloud.url!.absoluteString.lengthOfBytes(using: .utf8))
        return path
    }
    var key: String { path+name }
}

public class Cloud {
    class ItemSlot: CustomStringConvertible {
        var item: NSMetadataItem
        var document: AetherDocument?
        
        var url: URL { item.url }
        var name: String { item.name }
        var path: String { item.path }
        var key: String { item.key }
        
        init(item: NSMetadataItem) {
            self.item = item
        }
        
    // CustomStringConvertible =========================================================================
        var description: String {
            var sb: String = ""
            sb += "[ \(item.key) ] =======================\n"
            sb += "\tname: \(item.name)\n"
            sb += "\tpath: \(item.path)\n"
            sb += "\turl: \(item.url)\n"
            return sb
        }
    }
    
    var url: URL?
    
    let opQueue: OperationQueue = OperationQueue()
    let query: NSMetadataQuery = NSMetadataQuery()
    
    let space: CloudSpace = CloudSpace(path: "", parent: Space.anchor)
    var spaces: [String:CloudSpace] = [:]
    var slots: [String:ItemSlot] = [:]

    func checkAvailability() -> Bool { FileManager.default.url(forUbiquityContainerIdentifier: nil) != nil }
    
    func start() {
        Space.cloud = space

        url = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents")
        guard url != nil else { return }
        
        opQueue.maxConcurrentOperationCount = 1
        query.operationQueue = opQueue
        
        query.predicate = NSPredicate(format: "%K LIKE '*/Documents/*.oo'", NSMetadataItemPathKey, NSMetadataItemPathKey)
        query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
        query.enableUpdates()

        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidUpdate, object: query, queue: query.operationQueue, using: queryDidUpdate)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidStartGathering, object: query, queue: query.operationQueue, using: queryDidStartGathering)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: query, queue: query.operationQueue, using: queryDidFinishGathering)
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryGatheringProgress, object: query, queue: query.operationQueue, using: queryGatheringProgress)

        opQueue.addOperation {
            self.query.start()
        }

    }
    
    private static func add(space: CloudSpace, to spaces: inout [String:CloudSpace]) {
        spaces[space.path] = space
        
        do {
            let contents: [URL] = try FileManager.default.contentsOfDirectory(at: space.url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter( { $0.hasDirectoryPath } )
            space.spaces = contents.map {
                let name: String = $0.deletingPathExtension().lastPathComponent+"/"
                let path: String = space.path == "" ? name : "\(space.path)\(name)"
                return CloudSpace(path: path, parent: space)
            }.sorted { $0.name.uppercased() < $1.name.uppercased() }
            space.spaces.forEach { Cloud.add(space: $0, to: &spaces) }
        } catch { print("\(error)") }
    }
    private func buildSpaces() {
        var spaces: [String:CloudSpace] = [:]
        Cloud.add(space: space, to: &spaces)
        self.spaces = spaces
    }
    
    func processResults() {
        space.wipeAll()
        buildSpaces()
        
        var paths: [String:[NSMetadataItem]] = [:]
        
        (query.results as! [NSMetadataItem]).forEach {
            do { try FileManager.default.startDownloadingUbiquitousItem(at: $0.url) }
            catch { print("\(error)") }

            if let slot: ItemSlot = self.slots[$0.key] {
                slot.item = $0
            } else {
                self.slots[$0.key] = ItemSlot(item: $0)
            }
            
            if paths[$0.path] == nil {
                paths[$0.path] = [$0]
            } else {
                paths[$0.path]!.append($0)
            }
        }
        
        paths.keys.forEach { spaces[$0]!.load(metadataItems: paths[$0]!) }

    }
    
    func loadAether(key: String, complete: @escaping (String?) -> ()) {
        guard let slot: ItemSlot = slots[key] else { complete(nil); return }
        slot.document = slot.document ?? AetherDocument(fileURL: slot.url)
        opQueue.addOperation {
            guard let document: AetherDocument = slot.document else { return }
            document.open { (success: Bool) in
                print("Loaded [\(document.n)][\(success)]")
                guard success else { return }
                DispatchQueue.main.async { complete(document.json) }
            }
        }
    }
    func storeAether(_ aether: Aether, key: String, complete: @escaping (Bool) -> ()) {
        if let slot: ItemSlot = slots[key] {
            slot.document?.aether = aether
            opQueue.addOperation {
                slot.document?.save(to: slot.url, for: .forOverwriting) { (success: Bool) in
                    DispatchQueue.main.async { complete(success) }
                }
            }
        } else {
            let url = self.url!.appendingPathComponent("\(key).oo")
            let document: AetherDocument = AetherDocument(fileURL: url)
            document.aether = aether
            print("Attempting to save to [\(url.absoluteString)]")
            opQueue.addOperation {
                document.save(to: url, for: .forCreating) { (success: Bool) in
                    DispatchQueue.main.async { complete(success) }
                }
            }
        }
    }
    func removeAether(name: String, complete: @escaping (Bool) -> ()) {
//        do {
//            try FileManager.default.removeItem(atPath: path(name: name))
            complete(true)
//        } catch {
//            print("\(error)")
//            complete(false)
//        }
    }

// Events ==========================================================================================
    @objc func queryDidUpdate(_ notification: Notification) {
        print("== [ queryDidUpdate ]")
        query.disableUpdates()
        opQueue.addOperation { [unowned self] in
            self.processResults()
//            self.delegate?.onChanged(space: self)
            self.query.enableUpdates()
        }
    }
    @objc func queryDidStartGathering(_ notification: Notification) {
        print("== [ queryDidStartGathering ]")

    }
    @objc func queryDidFinishGathering(_ notification: Notification) {
        print("== [ queryDidFinishGathering ]")
        query.disableUpdates()
        opQueue.addOperation { [unowned self] in
            self.processResults()
//            self.delegate?.onChanged(space: self)
//            self.complete?()
            self.query.enableUpdates()
        }
    }
    @objc func queryGatheringProgress(_ notification: Notification) {
        print("== [ queryGatheringProgress ]")
    }
    
// Static ==========================================================================================
    static let cloud: Cloud = Cloud()
    
    public static func checkAvailability() -> Bool { cloud.checkAvailability() }
    public static func start() { cloud.start() }
    public static func loadAether(key: String, complete: @escaping (String?) -> ()) { cloud.loadAether(key: key, complete: complete) }
    public static func storeAether(_ aether: Aether, key: String, complete: @escaping (Bool) -> ()) { cloud.storeAether(aether, key: key, complete: complete) }
    public static func removeAether(name: String, complete: @escaping (Bool) -> ()) { cloud.removeAether(name: name, complete: complete) }
}
