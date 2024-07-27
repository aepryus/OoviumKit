//
//  GraphLeaf.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/14/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import Aegean
import OoviumEngine
import UIKit

class GraphLeaf: Leaf {
    let graph: Graph
    
    init(bubble: Bubble) {
        graph = (bubble as! GraphBub).graph
        super.init(bubble: bubble)
        size = CGSize(width: 300*3, height: 400*3)
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }

    var color: UIColor { bubble.uiColor }
    var image: UIImage? = nil
    var vertices: [Vertex] = []
    var tiles: [Tile] = []
    
    func generateVertices(t: Double) {
        graph.compileRecipes()
        graph.coordinate?.compileRecipes()
        
        let memory: UnsafeMutablePointer<Memory> = aetherView.aether.state.memory
        
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
    
// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        let path = CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 15, cornerHeight: 15, transform: nil)
        hitPath = path
        Skin.bubble(path: path, uiColor: color, width: 4.0/3.0*Oo.s)
        
//        centerX = x+width/2;
//        centerY = y+height/2;
        
//        g.setColor(getBackgroundColor().getColor());
//        g.fillRect(0,0,getWidth(),getHeight());

//        loadTimeIndependent();
        
        let t: Double = graph.t
//        double time = getTime(frame);
        
//        function = new R3toR3(new R3toR1(fX),new R3toR1(fY),new R3toR1(fZ));
//        setTime(time);
        graph.center = CGPoint(x: width/2, y: height/2)
        generateVertices(t: t)
        generateTiles()
        tiles.sort(by: { $0.distanceSq > $1.distanceSq })
        
        let c: CGContext = UIGraphicsGetCurrentContext()!
        tiles.forEach { $0.plot(context: c, graph: graph) }
    }
}
