//
//  File.swift
//  
//
//  Created by Joe Charlier on 1/25/23.
//

import UIKit
import OoviumEngine

class CoordinateLeaf: Leaf, Editable {
    
    var graphBub: GraphBub { bubble as! GraphBub }
    
// UIView ==========================================================================================
    override func draw(_ rect: CGRect) {
        let color: UIColor = !focused ? bubble.uiColor : .white
        let path = CGPath(roundedRect: rect.insetBy(dx: 3, dy: 3), cornerWidth: 10, cornerHeight: 10, transform: nil)
        hitPath = path
        Skin.bubble(path: path, uiColor: color, width: 4.0/3.0*Oo.s)
        Skin.text(graphBub.graph.coordinate?.name ?? "Cartesian", rect: CGRect(x: 0, y: 10.5, width: rect.size.width-12, height: 21), uiColor: color, font: .ooAether(size: 16), align: .right)    }

// Editable ========================================================================================
    var editor: Orbit { orb.alsoEditor }
    
    func onMakeFocus() {
        setNeedsDisplay()
    }
    func onReleaseFocus() {
        setNeedsDisplay()
    }
    func cite(_ citable: Citable, at: CGPoint) {
        guard let headerLeaf: HeaderLeaf = citable as? HeaderLeaf else { return }
        guard let coordinateBub: CoordinateBub = headerLeaf.bubble as? CoordinateBub else { fatalError() }
        let coordinate: Coordinate = coordinateBub.coordinate
        print(":: \(coordinateBub.coordinate.name)")
        graphBub.graph.coordinateNo = coordinate.no
        graphBub.graph.coordinate = coordinate
        setNeedsDisplay()
    }
}
