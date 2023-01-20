//
//  CoordinateBub.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/14/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class CoordinateBub: Bubble, SignatureLeafDelegate {
    let coordinate: Coordinate
    
    lazy var signatureLeaf: SignatureLeaf = SignatureLeaf(bubble: self, anchor: .zero, hitch: .top, size: .zero)
    lazy var cartesianLeaf: SignatureLeaf = SignatureLeaf(bubble: self, anchor: .zero, hitch: .top, size: .zero)
    
    var toChainLeaves: [ChainLeaf] = []
    var fromChainLeaves: [ChainLeaf] = []
    
    required init(_ coordinate: Coordinate, aetherView: AetherView) {
        self.coordinate = coordinate
        
        self.coordinate.name = "Spherical"
        
        let dimA = Dimension()
        dimA.name = "θ"
        
        let dimB = Dimension()
        dimB.name = "ϕ"
        
        let dimC = Dimension()
        dimC.name = "r"
        
        self.coordinate.dimensions = [dimA, dimB, dimC]
        
        super.init(aetherView: aetherView, aexel: coordinate, origin: CGPoint(x: coordinate.x, y: coordinate.y), size: .zero)
        
        add(leaf: signatureLeaf)
        
        for _ in 0...2 {
            let chainLeaf: ChainLeaf = ChainLeaf(bubble: self)
            chainLeaf.minWidth = 90
            chainLeaf.radius = 15
            add(leaf: chainLeaf)
            toChainLeaves.append(chainLeaf)
        }
        
        add(leaf: cartesianLeaf)
        
        for _ in 0...2 {
            let chainLeaf: ChainLeaf = ChainLeaf(bubble: self)
            chainLeaf.minWidth = 90
            chainLeaf.radius = 15
            add(leaf: chainLeaf)
            fromChainLeaves.append(chainLeaf)
        }
        
        render()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    func render() {
        
        signatureLeaf.anchor = CGPoint(x: 0, y: 0)
        
        toChainLeaves.enumerated().forEach {
            $1.anchor = CGPoint(x: 48, y: 200 + CGFloat($0)*36)
        }
        
        cartesianLeaf.anchor = CGPoint(x: 200, y: 180)

        fromChainLeaves.enumerated().forEach {
            $1.anchor = CGPoint(x: 152, y: 20 + CGFloat($0)*36)
        }

        layoutLeaves()
    }

// Bubble ==========================================================================================
    override var uiColor: UIColor { !selected ? OOColor.marine.uiColor : .yellow }

// SignatureLeafDelegate ===========================================================================
    var name: String { coordinate.name }
    var params: [String] { coordinate.dimensions.map { $0.name } }
    var token: OoviumEngine.Token = .add
    var recipeToken: OoviumEngine.Token = .add
    var paramTokens: [OoviumEngine.Token] = [.add, .add, .add]

    func onNoOfParamsChanged(signatureLeaf: SignatureLeaf) {}
    func onOK(signatureLeaf: SignatureLeaf) {}
}
