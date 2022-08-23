//
//  TextMultiContext.swift
//  Oovium
//
//  Created by Joe Charlier on 9/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class TextMultiContext: Context {
	let colorContext: ColorContext = ColorContext()
	let shapeContext: ShapeContext = ShapeContext()

	init() {
		super.init(size: CGSize(width: 84, height: 174), uiColor: UIColor.yellow, schematic: Schematic(rows: 4, cols: 1))
		
		colorContext.shapeContext = shapeContext
		shapeContext.colorContext = colorContext
		
		self.schematic.add(row: 0, col: 0, key: Key(text: NSLocalizedString("copy", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.8, green: 0.9, blue: 1.0, alpha: 1), { [weak self] in
			guard let me = self, let aetherView = me.aetherView else {return}
			me.dismiss()
			aetherView.copyBubbles()
		}))
		self.schematic.add(row: 1, col: 0, key: Key(text: NSLocalizedString("color", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.7, green: 0.8, blue: 0.9, alpha: 1), { [unowned self] in
			self.orb?.toggle(orbit: self.colorContext)
		}))
		self.schematic.add(row: 2, col: 0, key: Key(text: NSLocalizedString("shape", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.6, green: 0.7, blue: 0.8, alpha: 1), { [unowned self] in
			self.orb?.toggle(orbit: self.shapeContext)
		}))
		self.schematic.add(row: 3, col: 0, key: Key(text: NSLocalizedString("delete", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: ""), uiColor: UIColor(red: 0.5, green: 0.6, blue: 0.7, alpha: 1), {
			self.aetherView!.invokeConfirmModal(NSLocalizedString("deleteManyConfirm", tableName: nil, bundle: Bundle(for: type(of: self)), value: "", comment: "")) { [weak self] in
				guard let me = self, let aetherView = me.aetherView else {return}
				
				var edges: Set<Edge> = Set<Edge>()
				
				for bubble in aetherView.selected {
					guard let textBub = bubble as? TextBub else {fatalError()}
					edges.formUnion(textBub.text.edges)
					edges.formUnion(textBub.text.outputEdges)
				}
				
				for edge in edges {
					let parentLeaf: TextLeaf = (aetherView.bubble(aexel: edge.text) as! TextBub).textLeaf
					let childLeaf: TextLeaf = (aetherView.bubble(aexel: edge.other) as! TextBub).textLeaf
					parentLeaf.unlinkTo(other: childLeaf)
				}
				
				me.dismiss()
				me.aetherView!.deleteSelected()
				me.aetherView!.unselectAll()
			}
		}))

		self.schematic = schematic
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
// Context =========================================================================================
	override var aetherView: AetherView? {
		didSet {
			colorContext.aetherView = aetherView
			shapeContext.aetherView = aetherView
		}
	}
	
// Gadget ==========================================================================================
	override func onDismiss() {
		self.orb?.remove(orbit: self.shapeContext)
		self.orb?.remove(orbit: self.colorContext)
	}
}
