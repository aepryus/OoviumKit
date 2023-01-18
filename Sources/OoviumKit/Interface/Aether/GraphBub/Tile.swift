//
//  Tile.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/14/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

struct Tile: Comparable {
    let vertices: [Vertex]
    var center: V3
    let distanceSq: Double
    var color: UIColor = .white
    
    init(graph: Graph, vertices: [Vertex]) {
        self.vertices = vertices
        center = V3(0, 0, 0)
        for vertex in self.vertices { center = center + vertex.v }
        center = center / Double(self.vertices.count)
        distanceSq = (graph.view - center).lenSq()
        
        let toLight: V3 = center - graph.light
        let toOrth = (center - self.vertices[1].v).cross(center - self.vertices[2].v)
        
        let temp: Double = toLight.len() * toOrth.len()
        let exposure: Double = temp == 0 ? 1 : abs(toLight.dot(toOrth)/temp)
        color = (graph.surfaceColor + (graph.lightColor - graph.surfaceColor)*(exposure*exposure)).uiColor
    }
    
    func plot(context c: CGContext, graph: Graph) {
        let path: CGMutablePath = CGMutablePath()
        path.move(to: vertices[0].p!)
        path.addLine(to: vertices[1].p!)
        path.addLine(to: vertices[2].p!)
        path.addLine(to: vertices[3].p!)
        path.closeSubpath()
        c.addPath(path)
        c.setStrokeColor(graph.netColor.cgColor)
        c.setFillColor(color.cgColor)
        c.setLineWidth(1)
        c.drawPath(using: .fillStroke)
    }
    
// Comparable ======================================================================================
    static func < (lhs: Tile, rhs: Tile) -> Bool { lhs.distanceSq < rhs.distanceSq }
    static func == (lhs: Tile, rhs: Tile) -> Bool { lhs.distanceSq == rhs.distanceSq }
}
