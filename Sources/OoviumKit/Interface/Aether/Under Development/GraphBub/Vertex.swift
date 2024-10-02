//
//  Vertex.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/14/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import Foundation
import OoviumEngine

struct Vertex {
    let v: V3
    var p: CGPoint?
    
    init(_ v: V3) { self.v = v }
    
    mutating func calc(graph: Graph) {
        let to: V3 = v - graph.view
        
        let t1: Double = to.dot(graph.xAxis)
        let t2: Double = to.dot(graph.yAxis)
        let t3: Double = to.dot(graph.zAxis)
        
        guard t2 != 0 else { return }
        
        p = CGPoint(
            x: graph.center.x - graph.lens*atan2(t1, t2),
            y: graph.center.y - graph.lens*atan2(t3, t2)
        )
    }
}
