//
//  File.swift
//  
//
//  Created by Joe Charlier on 1/25/23.
//

import Acheron
import OoviumEngine
import UIKit

extension GraphBub {
    class ColorLeaf: Leaf, Editable, UIColorPickerViewControllerDelegate {
    // Editable ====================================================================================
        var editor: Orbit { orb.colorContext }
        
        func onMakeFocus() {
            let colorPicker = UIColorPickerViewController()
            colorPicker.delegate = self
            UIApplication.shared.windows.first?.rootViewController?.present(colorPicker, animated: true)
        }
        func onReleaseFocus() {
        }
        func cite(_ citable: Citable, at: CGPoint) {}
        
    // UIColorPickerViewControllerDelegate =========================================================
        func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
            print("colorPickerViewController:didSelect")
//            (bubble as! GraphBub).graph.surfaceColor = RGB(uiColor: color)
            
            let graph: Graph = (bubble as! GraphBub).graph
            
            graph.surfaceColor = RGB(r: 0, g: 72, b: 18)
            graph.lightColor = RGB(r: 0, g: 255, b: 64)
            graph.netColor = RGB(r: 128, g: 128, b: 128)
            
            graph.view = V3(2.92894437351064, 9.68485335250422, 7.48806974595454)
            graph.look = V3(-0.263952194392344, -0.852968600890806, -0.653431117971027)
            graph.orient = V3(0.316144636421787, 0.513353944157569, -0.797822221349847)
        }
        func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
            print("colorPickerViewControllerDidFinish")
        }
    }
}
