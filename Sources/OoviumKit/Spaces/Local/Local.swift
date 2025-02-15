//
//  Local.swift
//  Oovium
//
//  Created by Joe Charlier on 8/23/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

public class Local {
	public static func installAetherFromBundle(name: String) {
		let atPath: String = Bundle.main.path(forResource: "\(name) iP", ofType: "oo")!
//        let atPath: String = Bundle.main.path(forResource: (Oo.iPhone ? "\(name) iP" : name), ofType: "oo")!
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        
        let toURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("aethers")
        if !FileManager.default.fileExists(atPath: toURL.absoluteString) {
            do  {
                try FileManager.default.createDirectory(at: toURL, withIntermediateDirectories: true)
            } catch {
                print("LocalSpace.init ERROR [\(error)]")
            }
        }

		let toPath: String = (path as NSString).appendingPathComponent("aethers/\(name).oo")
		do {
			try? FileManager.default.removeItem(atPath: toPath)
			try FileManager.default.copyItem(atPath: atPath, toPath: toPath)
		} catch {
			print("\(error)")
		}
	}
	public static func aetherJSONFromBundle(name: String) -> String {
		let atPath: String = Bundle.main.path(forResource: name + (Oo.iPhone ? "S" : "L"), ofType: "oo") ??  Bundle.main.path(forResource: name, ofType: "oo")!
		guard let data = FileManager.default.contents(atPath: atPath) else {return ""}
		return String(data: data, encoding: .utf8) ?? ""
	}
	
	public static func wipeSplashBoard() {
		do {
			try FileManager.default.removeItem(atPath: NSHomeDirectory()+"/Library/SplashBoard")
		} catch {
			print("Failed to delete launch screen cache: \(error)")
		}
	}
	public static func archiveXML() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        var aetherNames: [String] = []
        do {
            let contents: [URL] = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).filter({$0.pathExtension == "oo"})
            aetherNames = contents.map({$0.deletingPathExtension().lastPathComponent}).sorted(by: { (left: String, right: String) -> Bool in
                return left.uppercased() < right.uppercased()
            })
        } catch { print("\(error)") }

        for name in aetherNames {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let atPath: String = (path as NSString).appendingPathComponent("\(name).oo")
            let toPath: String = (path as NSString).appendingPathComponent("\(name).xml")
            guard !FileManager.default.fileExists(atPath: toPath) else { continue }
            do {
                try FileManager.default.copyItem(atPath: atPath, toPath: toPath)
                try FileManager.default.removeItem(atPath: atPath)
            } catch { print("\(error)") }
        }
	}
	public static func migrateXML() {
		guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
		var aetherNames: [String] = []
		do {
			let contents: [URL] = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).filter({$0.pathExtension == "xml"})
			aetherNames = contents.map({$0.deletingPathExtension().lastPathComponent})
		} catch { print("\(error)") }
		for name in aetherNames {
			let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
			let atPath: String = (path as NSString).appendingPathComponent("\(name).xml")
			let toPath: String = (path as NSString).appendingPathComponent("\(name).oo")
			guard !FileManager.default.fileExists(atPath: toPath) else {continue}
			if	let data = FileManager.default.contents(atPath: atPath),
				let xmlAtts = String(data: data, encoding: .utf8)?.xmlToAttributes() {
				let jsonAtts: [String:Any] = Migrate.migrateXMLtoJSON(xmlAtts)
				FileManager.default.createFile(atPath: toPath, contents: jsonAtts.toJSON().data(using: .utf8), attributes: nil)
			}
		}
	}
    public static func moveAetherFor30() {
        guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        var toURL: URL
        if CloudSpace.checkAvailability() {
            toURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)!.appendingPathComponent("Documents").appendingPathComponent(UIDevice.current.name)
        } else {
            toURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("aethers")
        }
        if !FileManager.default.fileExists(atPath: toURL.absoluteString) {
            do  {
                try FileManager.default.createDirectory(at: toURL, withIntermediateDirectories: true)
            } catch {
                print("LocalSpace.init ERROR [\(error)]")
            }
        }

        var aetherNames: [String] = []
        do {
            let contents: [URL] = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []).filter({$0.pathExtension == "oo"})
            aetherNames = contents.map({$0.deletingPathExtension().lastPathComponent})
        } catch { print("\(error)") }
        aetherNames.forEach { (name: String) in
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            let atPath: String = (path as NSString).appendingPathComponent("\(name).oo")
            let toPath: String = toURL.appendingPathComponent("\(name).oo").path
            guard !FileManager.default.fileExists(atPath: toPath) else { return }
            guard let data = FileManager.default.contents(atPath: atPath) else { return }
            FileManager.default.createFile(atPath: toPath, contents: data, attributes: nil)
        }
    }
}
