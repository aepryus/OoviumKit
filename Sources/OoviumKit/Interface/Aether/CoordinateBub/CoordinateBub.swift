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

class CoordinateBub: Bubble, HeaderLeafDelegate, ChainLeafDelegate {
    let coordinate: Coordinate
    
    lazy var signatureLeaf: HeaderLeaf = HeaderLeaf(bubble: self, anchor: .zero, hitch: .top, size: .zero)
    lazy var cartesianLeaf: HeaderLeaf = HeaderLeaf(bubble: self, anchor: .zero, hitch: .top, size: .zero)
    
    var toChainLeaves: [ChainLeaf] = []
    var fromChainLeaves: [ChainLeaf] = []
    
    required init(_ coordinate: Coordinate, aetherView: AetherView) {
        self.coordinate = coordinate
        
        if self.coordinate.name == "" {
            self.coordinate.name = "Spherical"
            
            let dimA = Dimension(web: coordinate.toCart, name: "θ", no: 1)
            let dimB = Dimension(web: coordinate.toCart, name: "ϕ", no: 2)
            let dimC = Dimension(web: coordinate.toCart, name: "r", no: 3)
            
            self.coordinate.toCart.dimensions = [dimA, dimB, dimC]
            
            let dimD = Dimension(web: coordinate.fromCart, name: "x", no: 1)
            let dimE = Dimension(web: coordinate.fromCart, name: "y", no: 2)
            let dimF = Dimension(web: coordinate.fromCart, name: "z", no: 3)
            
            self.coordinate.fromCart.dimensions = [dimD, dimE, dimF]
        }
        
        super.init(aetherView: aetherView, aexel: coordinate, origin: CGPoint(x: coordinate.x, y: coordinate.y), size: .zero)
        
        add(leaf: signatureLeaf)
        
        for i in 0...2 {
            let chainLeaf: ChainLeaf = ChainLeaf(bubble: self)
            chainLeaf.delegate = self
            chainLeaf.chain = coordinate.toCart.dimensions[i].chain
            chainLeaf.minWidth = 90
            chainLeaf.radius = 15
            add(leaf: chainLeaf)
            toChainLeaves.append(chainLeaf)
        }
        
        add(leaf: cartesianLeaf)
        
        for i in 0...2 {
            let chainLeaf: ChainLeaf = ChainLeaf(bubble: self)
            chainLeaf.delegate = self
            chainLeaf.chain = coordinate.fromCart.dimensions[i].chain
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
    func name(for headerLeaf: HeaderLeaf) -> String {
        if headerLeaf === signatureLeaf { return coordinate.name }
        else if headerLeaf === cartesianLeaf { return "Cartesian" }
        fatalError()
    }
    func isNameEditable(for headerLeaf: HeaderLeaf) -> Bool {
        if headerLeaf === signatureLeaf { return true }
        else if headerLeaf === cartesianLeaf { return false }
        fatalError()
    }
    func numberOfParams(for headerLeaf: HeaderLeaf) -> Int { 3 }
    func headerLeaf(_ headerLeaf: HeaderLeaf, nameForParamNo paramNo: Int) -> String {
        if headerLeaf === signatureLeaf { return coordinate.toCart.dimensions[paramNo].name }
        else if headerLeaf === cartesianLeaf { return coordinate.fromCart.dimensions[paramNo].name }
        fatalError()
    }
    func areParamsEditable(for headerLeaf: HeaderLeaf) -> Bool {
        if headerLeaf === signatureLeaf { return true }
        else if headerLeaf === cartesianLeaf { return false }
        fatalError()
    }
    func token(for headerLeaf: HeaderLeaf) -> Token {
        if headerLeaf === signatureLeaf { return coordinate.toCart.token }
        else if headerLeaf === cartesianLeaf { return coordinate.fromCart.token }
        fatalError()
    }
    func recipeToken(for headerLeaf: HeaderLeaf) -> Token {
        if headerLeaf === signatureLeaf { return coordinate.toCart.recipeToken }
        else if headerLeaf === cartesianLeaf { return coordinate.fromCart.recipeToken }
        fatalError()
    }
    func headerLeaf(_ headerLeaf: HeaderLeaf, tokenForParamNo paramNo: Int) -> Token {
        if headerLeaf === signatureLeaf { return coordinate.toCart.dimensions[paramNo].tower.variableToken }
        else if headerLeaf === cartesianLeaf { return coordinate.fromCart.dimensions[paramNo].tower.variableToken }
        fatalError()
    }
    
// ChainLeafDelegate ===============================================================================
    func onChange() {}
    func onEdit() {}
    func onOK(leaf: ChainLeaf) {}
    func onCalculate() {}
}
