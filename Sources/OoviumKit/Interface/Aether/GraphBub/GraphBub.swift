//
//  GraphBub.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/14/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class GraphBub: Bubble, ChainLeafDelegate {
    let graph: Graph

    lazy var headerLeaf: HeaderLeaf = HeaderLeaf(bubble: self, anchor: .zero, hitch: .top, size: .zero)
    lazy var uStartChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var uStopChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var uStepsChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var vStartChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var vStopChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var vStepsChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var tChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var xChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var yChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var zChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var graphLeaf: GraphLeaf = GraphLeaf(bubble: self)
    
    lazy var plotLeaf: PlotLeaf = PlotLeaf(bubble: self)
    
    var overrideHitchPoint: CGPoint = .zero
    
    required init(_ graph: Graph, aetherView: AetherView) {
        self.graph = graph

        super.init(aetherView: aetherView, aexel: graph, origin: CGPoint(x: graph.x, y: graph.y), size: .zero)
        
        add(leaf: headerLeaf)
        
        uStartChainLeaf.delegate = self
        uStartChainLeaf.chain = graph.sUChain
        uStartChainLeaf.placeholder = "start"
        uStartChainLeaf.minWidth = 50
        uStartChainLeaf.radius = 15
        add(leaf: uStartChainLeaf)

        uStopChainLeaf.delegate = self
        uStopChainLeaf.chain = graph.eUChain
        uStopChainLeaf.placeholder = "stop"
        uStopChainLeaf.minWidth = 50
        uStopChainLeaf.radius = 15
        add(leaf: uStopChainLeaf)

        uStepsChainLeaf.delegate = self
        uStepsChainLeaf.chain = graph.dUChain
        uStepsChainLeaf.placeholder = "steps"
        uStepsChainLeaf.minWidth = 50
        uStepsChainLeaf.radius = 15
        add(leaf: uStepsChainLeaf)

        vStartChainLeaf.delegate = self
        vStartChainLeaf.chain = graph.sVChain
        vStartChainLeaf.placeholder = "start"
        vStartChainLeaf.minWidth = 50
        vStartChainLeaf.radius = 15
        add(leaf: vStartChainLeaf)

        vStopChainLeaf.delegate = self
        vStopChainLeaf.chain = graph.eVChain
        vStopChainLeaf.placeholder = "stop"
        vStopChainLeaf.minWidth = 50
        vStopChainLeaf.radius = 15
        add(leaf: vStopChainLeaf)

        vStepsChainLeaf.delegate = self
        vStepsChainLeaf.chain = graph.dVChain
        vStepsChainLeaf.placeholder = "steps"
        vStepsChainLeaf.minWidth = 50
        vStepsChainLeaf.radius = 15
        add(leaf: vStepsChainLeaf)
        
        tChainLeaf.delegate = self
        tChainLeaf.chain = graph.tChain
        tChainLeaf.placeholder = "t"
        tChainLeaf.minWidth = 60
        tChainLeaf.radius = 15
        add(leaf: tChainLeaf)
        
        xChainLeaf.delegate = self
        xChainLeaf.chain = graph.fX
        xChainLeaf.placeholder = "x"
        xChainLeaf.minWidth = 60
        xChainLeaf.radius = 15
        add(leaf: xChainLeaf)

        yChainLeaf.delegate = self
        yChainLeaf.chain = graph.fY
        yChainLeaf.placeholder = "y"
        yChainLeaf.minWidth = 60
        yChainLeaf.radius = 15
        add(leaf: yChainLeaf)

        zChainLeaf.delegate = self
        zChainLeaf.chain = graph.fZ
        zChainLeaf.placeholder = "z"
        zChainLeaf.minWidth = 60
        zChainLeaf.radius = 15
        add(leaf: zChainLeaf)

        add(leaf: graphLeaf)
        
        add(leaf: plotLeaf)
        
        render()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override var hitchPoint: CGPoint { overrideHitchPoint }
    
    func render() {
        let s: CGFloat = Oo.aS
        let p: CGFloat = 3*s
        
        let x1: CGFloat = [xChainLeaf.size.width, yChainLeaf.size.width, zChainLeaf.size.width, 150*s].max()! + 28*s
        
        overrideHitchPoint = CGPoint(x: x1, y: 200*s)
        
        headerLeaf.anchor = CGPoint(x: x1-150*s-8*s, y: 100*s)
        
        uStartChainLeaf.anchor = CGPoint(x: x1-120*s, y: 110*s)
        uStopChainLeaf.anchor = CGPoint(x: x1-86*s, y: 110*s)
        uStepsChainLeaf.anchor = CGPoint(x: x1-52*s, y: 110*s)

        vStartChainLeaf.anchor = CGPoint(x: x1-120*s, y: 135*s)
        vStopChainLeaf.anchor = CGPoint(x: x1-86*s, y: 135*s)
        vStepsChainLeaf.anchor = CGPoint(x: x1-52*s, y: 135*s)

        tChainLeaf.anchor = CGPoint(x: x1-tChainLeaf.size.width-8*s, y: 160*s)
        
        xChainLeaf.anchor = CGPoint(x: x1-xChainLeaf.size.width-8*s, y: 200*s)
        yChainLeaf.anchor = CGPoint(x: x1-yChainLeaf.size.width-8*s, y: 224*s)
        zChainLeaf.anchor = CGPoint(x: x1-zChainLeaf.size.width-8*s, y: 248*s)

        graphLeaf.anchor = CGPoint(x: x1, y: p)
        
        plotLeaf.anchor = CGPoint(x: x1-80*s, y: 300*s)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTap))
        plotLeaf.addGestureRecognizer(gesture)
        
        layoutLeaves()
    }
    
    @objc func onTap() {
        graph.sU = graph.sUChain.tower.value
        graph.eU = graph.eUChain.tower.value
        let stepsU: Double = graph.dUChain.tower.value
        graph.dU = (graph.eU-graph.sU)/stepsU

        graph.sV = graph.sVChain.tower.value
        graph.eV = graph.eVChain.tower.value
        let stepsV: Double = graph.dVChain.tower.value
        graph.dV = (graph.eV-graph.sV)/stepsV
        
        graph.t = graph.tChain.tower.value
        
        print("sU: \(graph.sU)")
        print("eU: \(graph.eU)")
        print("dU: \(graph.dU)")

        print("sV: \(graph.sV)")
        print("eV: \(graph.eV)")
        print("dV: \(graph.dV)")

        graphLeaf.setNeedsDisplay()
    }
    
// SignatureLeafDelegate ===========================================================================
    var name: String = "Waves"
    var params: [String] = ["u", "v", "t"]
    var token: Token = .abs
    var recipeToken: Token = .abs
    var paramTokens: [Token] { [graph.uTower.variableToken, graph.vTower.variableToken, graph.tTower.variableToken] }

    func onNoOfParamsChanged(signatureLeaf: SignatureLeaf) {
    }
    func onOK(signatureLeaf: SignatureLeaf) {
    }

// Bubble ==========================================================================================
    override var uiColor: UIColor { !selected ? OOColor.cobolt.uiColor : .yellow }
    
// ChainLeafDelegate ===============================================================================
    func onChange() { render() }
    func onEdit() { render() }
    func onOK(leaf: ChainLeaf) { render() }
    func onCalculate() { onTap() }
}
