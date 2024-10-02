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

    lazy var headerLeaf: GraphBub.HeaderLeaf = GraphBub.HeaderLeaf(bubble: self, anchor: .zero, hitch: .top, size: .zero)
    lazy var uStartChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var uStopChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var uStepsChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var vStartChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var vStopChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var vStepsChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var tChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .topLeft)
    lazy var xChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .top)
    lazy var yChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .top)
    lazy var zChainLeaf: ChainLeaf = ChainLeaf(bubble: self, hitch: .top)
    
    lazy var coordinateLeaf: CoordinateLeaf = CoordinateLeaf(bubble: self, hitch: .top)
    
    lazy var colorLeaf: ColorLeaf = ColorLeaf(bubble: self, hitch: .top)
    
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
        uStartChainLeaf.minWidth = 60
        uStartChainLeaf.radius = 15
        add(leaf: uStartChainLeaf)

        uStopChainLeaf.delegate = self
        uStopChainLeaf.chain = graph.eUChain
        uStopChainLeaf.placeholder = "stop"
        uStopChainLeaf.minWidth = 60
        uStopChainLeaf.radius = 15
        add(leaf: uStopChainLeaf)

        uStepsChainLeaf.delegate = self
        uStepsChainLeaf.chain = graph.dUChain
        uStepsChainLeaf.placeholder = "steps"
        uStepsChainLeaf.minWidth = 60
        uStepsChainLeaf.radius = 15
        add(leaf: uStepsChainLeaf)

        vStartChainLeaf.delegate = self
        vStartChainLeaf.chain = graph.sVChain
        vStartChainLeaf.placeholder = "start"
        vStartChainLeaf.minWidth = 60
        vStartChainLeaf.radius = 15
        add(leaf: vStartChainLeaf)

        vStopChainLeaf.delegate = self
        vStopChainLeaf.chain = graph.eVChain
        vStopChainLeaf.placeholder = "stop"
        vStopChainLeaf.minWidth = 60
        vStopChainLeaf.radius = 15
        add(leaf: vStopChainLeaf)

        vStepsChainLeaf.delegate = self
        vStepsChainLeaf.chain = graph.dVChain
        vStepsChainLeaf.placeholder = "steps"
        vStepsChainLeaf.minWidth = 60
        vStepsChainLeaf.radius = 15
        add(leaf: vStepsChainLeaf)
        
        tChainLeaf.delegate = self
        tChainLeaf.chain = graph.tChain
        tChainLeaf.placeholder = "t"
        tChainLeaf.minWidth = 60
        tChainLeaf.radius = 15
        add(leaf: tChainLeaf)
        
        xChainLeaf.delegate = self
        xChainLeaf.chain = graph.fXChain
        xChainLeaf.placeholder = "x"
        xChainLeaf.minWidth = 100
        xChainLeaf.radius = 15
        add(leaf: xChainLeaf)

        yChainLeaf.delegate = self
        yChainLeaf.chain = graph.fYChain
        yChainLeaf.placeholder = "y"
        yChainLeaf.minWidth = 100
        yChainLeaf.radius = 15
        add(leaf: yChainLeaf)

        zChainLeaf.delegate = self
        zChainLeaf.chain = graph.fZChain
        zChainLeaf.placeholder = "z"
        zChainLeaf.minWidth = 100
        zChainLeaf.radius = 15
        add(leaf: zChainLeaf)
        
        add(leaf: coordinateLeaf)
        add(leaf: colorLeaf)

        add(leaf: graphLeaf)

        render()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    override var hitchPoint: CGPoint { overrideHitchPoint }
    
    func render() {
        let s: CGFloat = Oo.aS
        let p: CGFloat = 3*s
        
        let x1: CGFloat = [xChainLeaf.size.width, yChainLeaf.size.width, zChainLeaf.size.width, 150*s].max()! + 28*s
        
        overrideHitchPoint = CGPoint(x: x1, y: 200*s)
        
        let x2: CGFloat = x1-50*s-8*s
        let y1: CGFloat = 100
        headerLeaf.anchor = CGPoint(x: x2, y: y1)
        
        let q: CGFloat = 220*s
        let cw: CGFloat = 40*s
        uStartChainLeaf.anchor = CGPoint(x: x1-q, y: 75*s)
        uStopChainLeaf.anchor = CGPoint(x: x1-q+cw, y: 75*s)
        uStepsChainLeaf.anchor = CGPoint(x: x1-q+2*cw, y: 75*s)

        vStartChainLeaf.anchor = CGPoint(x: x1-q, y: 100*s)
        vStopChainLeaf.anchor = CGPoint(x: x1-q+cw, y: 100*s)
        vStepsChainLeaf.anchor = CGPoint(x: x1-q+2*cw, y: 100*s)

        tChainLeaf.anchor = CGPoint(x: x1-tChainLeaf.size.width-108*s, y: 130*s)
        
        xChainLeaf.anchor = CGPoint(x: x2, y: y1+118)
        yChainLeaf.anchor = CGPoint(x: x2, y: y1+118+36)
        zChainLeaf.anchor = CGPoint(x: x2, y: y1+118+36*2)
        
        coordinateLeaf.anchor = CGPoint(x: x2, y: y1+300)
        colorLeaf.anchor = CGPoint(x: x2, y: y1+360)

        graphLeaf.anchor = CGPoint(x: x1, y: p)
        
        layoutLeaves()

        plasma = CGMutablePath()
        guard let plasma else { return }
        let a: CGPoint = CGPoint(x: headerLeaf.center.x-20, y: headerLeaf.top+15)                        // PlayLeaf
        let b: CGPoint = CGPoint(x: zChainLeaf.center.x-30, y: zChainLeaf.center.y)
        let c: CGPoint = CGPoint(x: zChainLeaf.center.x+30, y: zChainLeaf.center.y)
        let d: CGPoint = CGPoint(x: headerLeaf.center.x+20, y: headerLeaf.top+15)
        plasma.move(to: a)
        plasma.addQuadCurve(to: b, control: (a+b)/2+CGPoint(x: 30, y: 0))
        plasma.addLine(to: c)
        plasma.addQuadCurve(to: d, control: (c+d)/2+CGPoint(x: -30, y: 0))
        plasma.closeSubpath()
    }
    
    @objc func onTap() {
//        graph.sU = graph.sUChain.tower.value
//        graph.eU = graph.eUChain.tower.value
//        let stepsU: Double = graph.dUChain.tower.value
//        graph.dU = (graph.eU-graph.sU)/stepsU
//
//        graph.sV = graph.sVChain.tower.value
//        graph.eV = graph.eVChain.tower.value
//        let stepsV: Double = graph.dVChain.tower.value
//        graph.dV = (graph.eV-graph.sV)/stepsV
//        
//        graph.t = graph.tChain.tower.value
//        
//        graphLeaf.setNeedsDisplay()
    }
    
// SignatureLeafDelegate ===========================================================================
    var params: [String] = ["u", "v", "t"]
//    var paramTokens: [Token] { [graph.uTower.variableToken, graph.vTower.variableToken, graph.tTower.variableToken] }

// Bubble ==========================================================================================
    override var uiColor: UIColor { !selected ? OOColor.cobolt.uiColor : .yellow }
    
// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        guard let plasma = plasma else { return }
        Skin.plasma(path: plasma, uiColor: uiColor, stroke: 1)
    }

// ChainLeafDelegate ===============================================================================
    func onChange() { render() }
    func onEdit() { render() }
    func onOK(leaf: ChainLeaf) { render() }
    func onCalculate() { onTap() }
}
