//
//  GraphView.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/27/24.
//  Copyright © 2024 Aepryus Software. All rights reserved.
//

import Acheron
import Aegean
import OoviumEngine
import UIKit

public class GraphView: UIView {
    var graph: Graph
    
    let queue: DispatchQueue = DispatchQueue(label: "GraphView")
    lazy var timer: DispatchSourceTimer = DispatchSource.makeTimerSource(queue: queue)
    var running: Bool = false
    
    var t: Double = 0
    let sT: Double = 0
    let eT: Double = 2 * .pi
    
    let fps: Int = 20
    let period: Double = 30
    lazy var nT: Double = Double(fps)*period
    lazy var dT: Double = (eT-sT)/nT
    
    var size: CGSize = .zero

    public init(graph: Graph) {
        self.graph = graph
        super.init(frame: .zero)
        backgroundColor = .clear
        
        timer.schedule(deadline: .now(), repeating: dT)
        timer.setEventHandler { [unowned self] in
            self.t += self.dT
            if self.t >= self.eT { self.t = self.sT }
            self.image = GraphView.generateSlice(t: self.t, graph: self.graph, size: self.size)
            DispatchQueue.main.async { self.setNeedsDisplay() }
        }
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    public func start() {
        guard !running else { return }
        timer.resume()
        running = true
    }
    public func stop() {
        guard running else { return }
        timer.suspend()
        running = false
    }

    var image: UIImage? = nil
    var vertices: [Vertex] = []
    var tiles: [Tile] = []

    static func generateVertices(t: Double, graph: Graph) -> [Vertex] {
        let memory: UnsafeMutablePointer<Memory> = graph.aether.state.memory

        let uIndex: mnimi = graph.uTower.index
        let vIndex: mnimi = graph.vTower.index
        let tIndex: mnimi = graph.tTower.index

        let pIndex: mnimi = graph.coordinate?.toCart.dimensions[0].tower.index ?? 0
        let qIndex: mnimi = graph.coordinate?.toCart.dimensions[1].tower.index ?? 0
        let rIndex: mnimi = graph.coordinate?.toCart.dimensions[2].tower.index ?? 0

        var vertices: [Vertex] = [Vertex].init(repeating: Vertex(.zero), count: graph.nU*graph.nV)
        var n: Int = 0
        var u: Double = graph.sU
        for _ in 0..<graph.nU {
            var v: Double = graph.sV
            for _ in 0..<graph.nV {
                AEMemorySetValue(memory, uIndex, u)
                AEMemorySetValue(memory, vIndex, v)
                AEMemorySetValue(memory, tIndex, t)

                AERecipeExecute(graph.xRecipe, memory)
                let p: Double = AEMemoryValue(memory, graph.fXChain.tower.index)
                AERecipeExecute(graph.yRecipe, memory)
                let q: Double = AEMemoryValue(memory, graph.fYChain.tower.index)
                AERecipeExecute(graph.zRecipe, memory)
                let r: Double = AEMemoryValue(memory, graph.fZChain.tower.index)

                AEMemorySetValue(memory, pIndex, p)
                AEMemorySetValue(memory, qIndex, q)
                AEMemorySetValue(memory, rIndex, r)

                let x: Double, y: Double, z: Double
                if let coordinate = graph.coordinate {
                    AERecipeExecute(coordinate.toCart.recipes[0], memory)
                    x = AEMemoryValue(memory, graph.coordinate!.toCart.dimensions[0].chain.tower.index)
                    AERecipeExecute(coordinate.toCart.recipes[1], memory)
                    y = AEMemoryValue(memory, graph.coordinate!.toCart.dimensions[1].chain.tower.index)
                    AERecipeExecute(coordinate.toCart.recipes[2], memory)
                    z = AEMemoryValue(memory, graph.coordinate!.toCart.dimensions[2].chain.tower.index)
                } else {
                    x = p
                    y = q
                    z = r
                }

                vertices[n] = Vertex(V3(x, y, z))
                vertices[n].calc(graph: graph)
                v += graph.dV
                n += 1
            }
            u += graph.dU
        }
        return vertices
    }
    static func generateTiles(vertices: [Vertex], graph: Graph) -> [Tile] {
        var tiles: [Tile] = []
        for i in 0..<graph.nU-1 {
            for j in 0..<graph.nV-1 {
                tiles.append(Tile(graph: graph, vertices: [
                    vertices[i*graph.nV+j],
                    vertices[i*graph.nV+j+1],
                    vertices[i*graph.nV+j+graph.nV+1],
                    vertices[i*graph.nV+j+graph.nV]
                ]))
            }
        }
        return tiles
    }
    static func generateSlice(t: Double, graph: Graph, size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context: UIGraphicsImageRendererContext) in
            let c: CGContext = context.cgContext
            graph.center = CGPoint(x: size.width/2, y: size.height/2)
            let vertices: [Vertex] = generateVertices(t: t, graph: graph)
            var tiles: [Tile] = generateTiles(vertices: vertices, graph: graph)
            tiles.sort(by: { $0.distanceSq > $1.distanceSq })
            tiles.forEach { $0.plot(context: c, graph: graph) }
        }
    }
    
// UIView ==========================================================================================
    override public func layoutSubviews() {
        size = frame.size
        
        graph.compileRecipes()
        graph.coordinate?.compileRecipes()
        
        graph.lens = frame.size.width / CGFloat.pi * 6;

        graph.xAxis = graph.orient.cross(graph.look).unit()
        graph.yAxis = graph.look.unit()
        graph.zAxis = graph.orient.unit()

        if graph.dU.isNaN || graph.dU.isZero { graph.dU = 1 }
        if graph.dV.isNaN || graph.dV.isZero { graph.dV = 1 }
        graph.nU = Int((graph.eU-graph.sU)/graph.dU+1)
        graph.nV = Int((graph.eV-graph.sV)/graph.dV+1)

        graph.center = CGPoint(x: width/2, y: height/2)
    }
    override public func draw(_ rect: CGRect) {
        image?.draw(in: rect)
    }
    
// Static ==========================================================================================
    static var aethers: [Aether] = []
    public static func graphInstance() -> Graph {
        let aether: Aether = Aether()
        let graph: Graph  = aether.create(at: .zero)
        aethers.append(aether)
        
        graph.surfaceOn = true
        graph.fXChain = Chain("va:Gp1.u")
        graph.fYChain = Chain("va:Gp1.v")
        graph.fZChain = Chain("fn:sin;va:Gp1.u;op:×;va:Gp1.v;op:+;va:Gp1.t;sp:);op:÷;dg:3")
        graph.sUChain = Chain(natural: "-4")
        graph.eUChain = Chain(natural: "4")
        graph.dUChain = Chain(natural: "40")
        graph.sVChain = Chain(natural: "-4")
        graph.eVChain = Chain(natural: "4")
        graph.dVChain = Chain(natural: "40")
        graph.onLoad()
        aether.onLoad()

        let net: CGFloat = 0.0
        let light: CGFloat = 0.8
        let surface: CGFloat = 0.2
        graph.netColor = RGB(r: net, g: net, b: net)
        graph.lightColor = RGB(r: light, g: light, b: light)
        graph.surfaceColor = RGB(r: surface, g: surface, b: surface)
        graph.surfaceOn = true
        graph.sU = graph.sUChain.tower.value
        graph.eU = graph.eUChain.tower.value
        let stepsU: Double = graph.dUChain.tower.value
        graph.dU = (graph.eU-graph.sU)/stepsU
        graph.sV = graph.sVChain.tower.value
        graph.eV = graph.eVChain.tower.value
        let stepsV: Double = graph.dVChain.tower.value
        graph.dV = (graph.eV-graph.sV)/stepsV
        graph.t = graph.tChain.tower.value
        graph.surfaceOn = true
        
        return graph
    }
}
