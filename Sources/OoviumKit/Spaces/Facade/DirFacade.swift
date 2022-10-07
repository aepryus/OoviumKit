//
//  DirFacade.swift
//  OoviumKit
//
//  Created by Joe Charlier on 10/7/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

public class DirFacade: Facade {
    
// Facade ==========================================================================================
    override var description: String { "\(name)/" }

// Convenience =====================================================================================
    public func loadFacades(_ complete: @escaping ([Facade])->()) { space.loadFacades(facade: self, complete) }
    public func createFolder(name: String, _ complete: @escaping (Bool)->()) { space.createFolder(facade: self, name: name, complete) }
}
