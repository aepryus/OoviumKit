//
//  TypeLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 8/29/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class TypeLeaf: Leaf, Colorable {
	var type: Type
	
	var fieldMoorings: [Mooring] = []

	var x1: CGFloat = 0, x2: CGFloat = 0, x3: CGFloat = 0, x4: CGFloat = 0, x6: CGFloat = 0, x7: CGFloat = 0
	var y1: CGFloat = 0, y2: CGFloat = 0, y3: CGFloat = 0, y4: CGFloat = 0
	var r: CGFloat = 0, or: CGFloat = 0, lh: CGFloat = 0, n: Int = 0

	override init(bubble: Bubble, hitch: Position, anchor: CGPoint, size: CGSize) {
		type = (bubble as! TypeBub).type
	
		super.init(bubble: bubble, hitch: hitch, anchor: anchor, size: size)
		
		backgroundColor = UIColor.clear
//        mooring = bubble.createMooring()
		
//        type.fields.forEach { _ in fieldMoorings.append(bubble.createMooring()) }
		
		render()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	var uiColor: UIColor {
		return type.color.uiColor
	}
	
	func render() {
		let s: CGFloat = 1.5						// scale
		var w: CGFloat = isFocused ? 0 : 130		// width
		let p: CGFloat = 3*s						// padding
		or = 10*s									// outer radius
		r = 5*s										// inner radius
		lh = 16*s									// line height
		n = type.fields.count						// number of fields
		let q: CGFloat = 7*s
		
		let pen: Pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!)
		w = max(w, type.name.size(pen: pen).width+32)
		
		if !isFocused {
			for field in type.fields {
				w = max(w, field.name.size(pen: pen).width+46)
			}
		} else {
			for field in type.fields {
				w = max(w, field.type.size(pen: pen).width+120+30+10)
			}
		}
		
		x1 = p
		x2 = x1+q
		x4 = w/2
		x7 = w-p
		x6 = x7-q
		x3 = w-120-15-5+6
	
		y1 = p
		y2 = y1+or
		y3 = y2+or
		y4 = y3+CGFloat(n)*lh
		
		size = CGSize(width: x7+p, height: y4+p)
		
		reMoor()
	}
	
	func reMoor() {
		let w: CGFloat = width
		mooring.point = CGPoint(x: bubble.left+w/2, y: bubble.top+y2)
		fieldMoorings.enumerated().forEach { (i: Int, mooring: Mooring) in mooring.point = CGPoint(x: bubble.left+w/2, y: bubble.top+y3+(CGFloat(i)+0.5)*lh) }
	}
	
// Leaf ============================================================================================
	override func wireMoorings() {
//		type.fields.enumerated().forEach { (i: Int, field: Field) in
//			guard let typeBub: TypeBub = bubble.aetherView.typeBub(name: field.typeName) else { return }
//			bubble.aetherView.link(from: fieldMoorings[i], to: typeBub.typeLeaf.mooring, wake: false)
//		}
	}
	override func positionMoorings() {
//		reMoor()
//		mooring.positionDoodles()
//		fieldMoorings.forEach {$0.positionDoodles()}
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		var path: CGMutablePath = CGMutablePath()
		
		path.move(to: CGPoint(x: x6, y: y3))
		path.addArc(tangent1End: CGPoint(x: x6, y: y4), tangent2End: CGPoint(x: x4, y: y4), radius: r)
		path.addArc(tangent1End: CGPoint(x: x2, y: y4), tangent2End: CGPoint(x: x2, y: y3), radius: r)
		path.addLine(to: CGPoint(x: x2, y: y3))
		path.closeSubpath()
		
		for i in 1..<n {
			path.move(to: CGPoint(x: x2, y: y3+CGFloat(i)*lh))
			path.addLine(to: CGPoint(x: x6, y: y3+CGFloat(i)*lh))
		}
		
		Skin.tray(path: path, uiColor: UIColor.lightGray, width: 1)
		
		path = CGMutablePath()
		path.move(to: CGPoint(x: x4, y: y1))
		path.addArc(tangent1End: CGPoint(x: x7, y: y1), tangent2End: CGPoint(x: x7, y: y2), radius: or)
		path.addArc(tangent1End: CGPoint(x: x7, y: y3), tangent2End: CGPoint(x: x4, y: y3), radius: or)
		path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x1, y: y2), radius: or)
		path.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x4, y: y1), radius: or)
		path.closeSubpath()
		
		Skin.tray(path: path, uiColor: uiColor, width: 1)
		
		var pen: Pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!, color: uiColor)
		if !isFocused {
			let size: CGSize = type.name.size(pen: pen)
			Skin.panel(text: type.name, rect: CGRect(x: (rect.size.width-size.width)/2, y: 9, width: size.width, height: size.height), pen: pen)
			
			pen = pen.clone(color: .white)
			for i in 0..<n {
				let field: Field = type.fields[i]
				let size: CGSize = field.name.size(pen: pen)
				Skin.panel(text: field.name, rect: CGRect(x: (rect.size.width-size.width)/2, y: 11+lh*(CGFloat(i)+1), width: size.width, height: size.height), pen: pen)
			}
		} else {
		}
	}
}
