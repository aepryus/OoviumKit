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

public class CloudSpace: Space {
	let url: URL
	let query: NSMetadataQuery = NSMetadataQuery()
	private var metadata: [String:NSMetadataItem] = [:]
	private var documents: [String:AetherDocument] = [:]
	var cachedSpaces: [Space] = []
	var cachedNames: [String] = []
	let complete: (()->())?
	let operationQueue: OperationQueue = OperationQueue()
	let queue: DispatchQueue = DispatchQueue(label: "CloudSpace")

	init?(path: String, parent: Space, complete: (()->())? = nil) {
		self.complete = complete
		guard let rootURL: URL = FileManager.default.url(forUbiquityContainerIdentifier: nil) else { self.complete?(); return nil }
		query.operationQueue = operationQueue
		if path == "" {
			self.url = rootURL.appendingPathComponent("Documents")
			query.predicate = NSPredicate(format: "%K LIKE '*/Documents/*.oo'", NSMetadataItemPathKey)
		} else {
			self.url = rootURL.appendingPathComponent("Documents").appendingPathComponent(path)
			query.predicate = NSPredicate(format: "%K LIKE '*/Documents/\(path)/*.oo'", NSMetadataItemPathKey)
		}
		query.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
		query.enableUpdates()
		super.init(type: .cloud, path: path, name: path == "" ? "iCloud" : url.lastPathComponent, parent: parent)

		NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidUpdate, object: query, queue: query.operationQueue, using: queryDidUpdate)
		NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidStartGathering, object: query, queue: query.operationQueue, using: queryDidStartGathering)
		NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryDidFinishGathering, object: query, queue: query.operationQueue, using: queryDidFinishGathering)
		NotificationCenter.default.addObserver(forName: NSNotification.Name.NSMetadataQueryGatheringProgress, object: query, queue: query.operationQueue, using: queryGatheringProgress)

		_ = Screen.mac
		query.operationQueue?.addOperation {
			self.query.start()
		}
	}

	func path(name: String) -> String {
		return url.appendingPathComponent("\(name).oo").path
	}

	func processResults() {
		queue.sync { [unowned self] in
			let results: [NSMetadataItem] = query.results as! [NSMetadataItem]
			results.forEach { (metadata: NSMetadataItem) in
				guard var name: String = metadata.value(forAttribute: NSMetadataItemDisplayNameKey) as? String else { return }
				if Screen.mac { name = (name as NSString).deletingPathExtension } // because of a Catalyst bug
				self.metadata[name] = metadata
			}

			do {
				let contents: [URL] = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]).filter( { $0.hasDirectoryPath } )
				cachedSpaces = contents.map({
					let name: String = $0.deletingPathExtension().lastPathComponent
					let path: String = self.path == "" ? name : "\(self.path)/\(name)"
					return CloudSpace(path: path, parent: self)!
				}).sorted { $0.name.uppercased() < $1.name.uppercased() }
			} catch { print("\(error)") }

			cachedNames = metadata.keys.sorted { $0.uppercased() < $1.uppercased() }

			metadata.values.forEach { (metadata: NSMetadataItem) in
				guard let url: URL = metadata.value(forAttribute: NSMetadataItemURLKey) as? URL else { return }
				do { try FileManager.default.startDownloadingUbiquitousItem(at: url) }
				catch { print("\(error)") }
			}
		}
	}

// Events ==========================================================================================
	@objc func queryDidUpdate(_ notification: Notification) {
		query.disableUpdates()
		operationQueue.addOperation { [unowned self] in
			self.processResults()
			self.delegate?.onChanged(space: self)
			self.query.enableUpdates()
		}
	}
	@objc func queryDidStartGathering(_ notification: Notification) {}
	@objc func queryDidFinishGathering(_ notification: Notification) {
		query.disableUpdates()
		operationQueue.addOperation { [unowned self] in
			self.processResults()
			self.delegate?.onChanged(space: self)
			self.complete?()
			self.query.enableUpdates()
		}
	}
	@objc func queryGatheringProgress(_ notification: Notification) {}

// Space ===========================================================================================
	override public func loadSpaces(complete: @escaping ([Space]) -> ()) {
		complete(cachedSpaces)
	}
	override public func loadNames(complete: @escaping ([String]) -> ()) {
		complete(cachedNames)
	}
	override public func loadAether(name: String, complete: @escaping (String?) -> ()) {
		guard let url = metadata[name]?.value(forAttribute: NSMetadataItemURLKey) as? URL else { return }

		let aetherDocument: AetherDocument = documents[name] ?? {
			let document = AetherDocument(fileURL: url)
			documents[name] = document
			return document
		}()

		operationQueue.addOperation {
			aetherDocument.open { (success: Bool) in
				guard success else { return }
				DispatchQueue.main.async { complete(aetherDocument.json) }
			}
		}
	}
	override public func storeAether(_ aether: Aether, complete: @escaping (Bool) -> ()) {
		if let url = metadata[aether.name]?.value(forAttribute: NSMetadataItemURLKey) as? URL {
			let aetherDocument: AetherDocument = documents[aether.name] ?? {
				let document = AetherDocument(fileURL: url)
				documents[aether.name] = document
				return document
			}()

			aetherDocument.aether = aether
			print("Attempting to save to [\(url.absoluteString)]")
			operationQueue.addOperation {
				aetherDocument.save(to: url, for: .forOverwriting) { (success: Bool) in
					DispatchQueue.main.async { complete(success) }
				}
			}
		} else {
			let url = self.url.appendingPathComponent("\(aether.name).oo")
			let aetherDocument: AetherDocument = AetherDocument(fileURL: url)
			documents[aether.name] = aetherDocument
			aetherDocument.aether = aether
			print("Attempting to save to [\(url.absoluteString)]")
			operationQueue.addOperation {
				aetherDocument.save(to: url, for: .forCreating) { (success: Bool) in
					DispatchQueue.main.async { complete(success) }
				}
			}
		}
	}
	override public func removeAether(name: String, complete: @escaping (Bool) -> ()) {
		do {
			try FileManager.default.removeItem(atPath: path(name: name))
			complete(true)
		} catch {
			print("\(error)")
			complete(false)
		}
	}
}
