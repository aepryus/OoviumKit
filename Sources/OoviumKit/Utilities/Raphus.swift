//
//  Undo.swift
//  OoviumKit
//
//  Created by Joe Charlier on 11/3/24.
//  Copyright © 2024 Aepryus Software. All rights reserved.
//

class Raphus {
    var undos: [String] = []
    var redos: [String] = []
    
    func dodo(json: String) {
        undos.append(json)
        redos.removeAll()
    }
    func undo() -> String? {
        guard undos.count > 1 else { return nil }
        let json: String = undos.removeLast()
        redos.append(json)
        return undos.last
    }
    func redo() -> String? {
        guard redos.count > 1 else { return nil }
        let json: String = redos.removeLast()
        undos.append(json)
        return json
    }
    func wipe() {
        undos = []
        redos = []
    }
}
