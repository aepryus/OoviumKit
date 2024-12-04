//
//  StaticsSpace.swift
//  OoviumKit
//
//  Created by Joe Charlier on 11/15/24.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Foundation

public class StaticsSpace: Space {

    public init() { super.init(name: "◎", url: URL(string: "oovium.com")!) }

// Space ===========================================================================================
    public override func loadFacades(facade: Facade, _ complete: @escaping ([Facade]) -> ()) { complete([]) }
}
