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
    
    public let timer: AESync = AESync()
    
    var t: Double = 0
    let sT: Double = 0
    let eT: Double = 2 * .pi
    
    let fps: Int = 20
    let period: Double = 30
    lazy var nT: Double = Double(fps)*period
    lazy var dT: Double = (eT-sT)/nT
    var slices: SafeMap<UIImage> = SafeMap()
    
    var index: Int = 0

    public init(graph: Graph) {
        self.graph = graph
        super.init(frame: .zero)
        backgroundColor = .clear
        
//        let start: Date = .now
//        var n: Int = 0
        
//        timer.onFire = { (link: CADisplayLink, complete: ()->()) in
//            self.index = (self.index + 1) % Int(self.nT)
//            self.setNeedsDisplay()
//
//            n += 1
//            if n % 60 == 0 {
//                let seconds = Date.now.timeIntervalSince(start)
//                print("fps: \(Double(n)/seconds)")
//                print()
//            }
//            
//            complete()
//        }
        timer.onFire = { (link: CADisplayLink, complete: ()->()) in
            self.t += self.dT
            if self.t >= self.eT { self.t = self.sT }
            self.setNeedsDisplay()
            complete()
        }
        timer.link.preferredFramesPerSecond = Int(self.fps)
        self.timer.start()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }

    var image: UIImage? = nil
    var vertices: [Vertex] = []
    var tiles: [Tile] = []

    func generateVertices(t: Double) {
        graph.compileRecipes()
        graph.coordinate?.compileRecipes()
        
        let memory: UnsafeMutablePointer<Memory> = graph.aether.memory
        
        let uIndex: mnimi = graph.uTower.index
        let vIndex: mnimi = graph.vTower.index
        let tIndex: mnimi = graph.tTower.index

        let pIndex: mnimi = graph.coordinate?.toCart.dimensions[0].tower.index ?? 0
        let qIndex: mnimi = graph.coordinate?.toCart.dimensions[1].tower.index ?? 0
        let rIndex: mnimi = graph.coordinate?.toCart.dimensions[2].tower.index ?? 0

        graph.lens = width*6/Double.pi;

        graph.xAxis = graph.orient.cross(graph.look).unit()
        graph.yAxis = graph.look.unit()
        graph.zAxis = graph.orient.unit()

        if graph.dU.isNaN || graph.dU.isZero { graph.dU = 1 }
        if graph.dV.isNaN || graph.dV.isZero { graph.dV = 1 }
        graph.nU = Int((graph.eU-graph.sU)/graph.dU+1)
        graph.nV = Int((graph.eV-graph.sV)/graph.dV+1)
        vertices = [Vertex].init(repeating: Vertex(.zero), count: graph.nU*graph.nV)
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
    }
    func generateTiles() {
        tiles = []
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
    }

    static func QgenerateVertices(t: Double, graph: Graph) -> [Vertex] {
        let memory: UnsafeMutablePointer<Memory> = graph.aether.memory

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
    static func QgenerateTiles(vertices: [Vertex], graph: Graph) -> [Tile] {
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
            let vertices: [Vertex] = QgenerateVertices(t: t, graph: graph)
            var tiles: [Tile] = QgenerateTiles(vertices: vertices, graph: graph)
            tiles.sort(by: { $0.distanceSq > $1.distanceSq })
            tiles.forEach { $0.plot(context: c, graph: graph) }
        }
//        return UIImage(named: "Dolphin")!
    }
    func generateSlices(complete: @escaping ()->()) {
        
        let processors: Int = ProcessInfo.processInfo.activeProcessorCount
        let iterations: Int = processors*3
        let slicesPer: Int = Int(nT) / iterations
        let bonusSlices: Int = Int(nT) - slicesPer * iterations
        
        let size: CGSize = frame.size
        
        DispatchQueue.global(qos: .userInitiated).async {
            DispatchQueue.concurrentPerform(iterations: ProcessInfo.processInfo.activeProcessorCount*3, execute: { (i: Int) in
                let graph: Graph = GraphView.graphInstance()
                
                graph.compileRecipes()
                graph.coordinate?.compileRecipes()
                
                graph.lens = size.width*6/Double.pi;

                graph.xAxis = graph.orient.cross(graph.look).unit()
                graph.yAxis = graph.look.unit()
                graph.zAxis = graph.orient.unit()

                if graph.dU.isNaN || graph.dU.isZero { graph.dU = 1 }
                if graph.dV.isNaN || graph.dV.isZero { graph.dV = 1 }
                graph.nU = Int((graph.eU-graph.sU)/graph.dU+1)
                graph.nV = Int((graph.eV-graph.sV)/graph.dV+1)

                for j in 0..<slicesPer {
                    let index: Int = i*slicesPer + j
                    let t: Double = self.sT+Double(index)*self.dT
                    self.slices["\(index)"] = GraphView.generateSlice(t: t, graph: graph, size: size)
                }
                if i < bonusSlices {
                    let index: Int = iterations*slicesPer + i
                    let t: Double = self.sT+Double(index)*self.dT
                    self.slices["\(index)"] = GraphView.generateSlice(t: t, graph: graph, size: size)
                }
            })
            complete()
        }
    }
    
// UIView ==========================================================================================
//    override public func layoutSubviews() {
//        guard slices.count == 0 else { return }
//        generateSlices { print("Slices Generated") }
//    }
//    let dolphin = UIImage(named: "Dolphin")!
    let queue: DispatchQueue = DispatchQueue(label: "graphView")
    override public func draw(_ rect: CGRect) {
//        slices["\(index)"]?.draw(in: rect)
        queue.sync {
            graph.center = CGPoint(x: width/2, y: height/2)
            generateVertices(t: t)
            generateTiles()
            tiles.sort(by: { $0.distanceSq > $1.distanceSq })
        }
        let c: CGContext = UIGraphicsGetCurrentContext()!
        tiles.forEach { $0.plot(context: c, graph: graph) }
//        dolphin.draw(in: rect)
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
