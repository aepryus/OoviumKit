//
//  OoviumKit.swift
//  Oovium
//
//  Created by Joe Charlier on 3/13/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Foundation

public let fontBundle = Bundle.module

public enum SelectionMode: CaseIterable {
    case lasso, rectangle
}

public protocol OoviumKitDelegate: AnyObject {
    var selectionMode: SelectionMode { get }
}

public class OoviumQit {
    public static weak var delegate: OoviumKitDelegate? = nil
}
