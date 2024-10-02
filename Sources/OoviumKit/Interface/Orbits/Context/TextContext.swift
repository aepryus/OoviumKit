//
//  TextContext.swift
//  Oovium
//
//  Created by Joe Charlier on 9/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class TextContext: Context {
    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 84, height: 174), uiColor: UIColor.yellow, schematic: Schematic(rows: 3, cols: 1))
		
		schematic.add(row: 0, col: 0, key: Key(text: NSLocalizedString("color", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.7, green: 0.8, blue: 0.9, alpha: 1), { [unowned self] in
            toggle(orbit: orb.colorContext)
		}))
		schematic.add(row: 1, col: 0, key: Key(text: NSLocalizedString("shape", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.6, green: 0.7, blue: 0.8, alpha: 1), { [unowned self] in
            toggle(orbit: orb.shapeContext)
		}))
		schematic.add(row: 2, col: 0, key: Key(text: NSLocalizedString("delete", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1), {
			self.aetherView.invokeConfirmModal(NSLocalizedString("deleteOneConfirm", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: "")) { [unowned self] in
				var edges: Set<Edge> = Set<Edge>()
				
                for bubble in aetherView.selected {
					guard let textBub = bubble as? TextBub else { fatalError() }
					edges.formUnion(textBub.text.edges)
					edges.formUnion(textBub.text.outputEdges)
				}
				
				for edge in edges {
                    guard let parentText: Text = edge.text,
                          let childText: Text = edge.other
                        else { continue }
                    let parentLeaf: TextLeaf = (aetherView.bubble(aexel: parentText) as! TextBub).textLeaf
                    let childLeaf: TextLeaf = (aetherView.bubble(aexel: childText) as! TextBub).textLeaf
					parentLeaf.unlinkTo(other: childLeaf)
				}
				
                self.dismiss()
                self.aetherView.deleteSelected()
			}
		}))
        
        renderSchematic()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
//// Context =========================================================================================
//	override var aetherView: AetherView? {
//		didSet {
//			colorContext.aetherView = aetherView
//			shapeContext.aetherView = aetherView
//		}
//	}
//
//// Gadget ==========================================================================================
//	override func onDismiss() {
//        remove(orbit: shapeContext)
//        remove(orbit: colorContext)
//	}
}
