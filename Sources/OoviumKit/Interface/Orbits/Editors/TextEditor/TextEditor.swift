//
//  TextEditor.swift
//  Oovium
//
//  Created by Joe Charlier on 9/19/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class TextEditor: Orbit {

	var inward: Bool = true {
		didSet {
			inputsButton.uiColor = inward ? textLeaf.text.color.uiColor : UIColor.white
			outputsButton.uiColor = inward ? UIColor.white : textLeaf.text.color.uiColor
		}
	}
	override var editable: Editable? {
		didSet {
			guard let textLeaf = editable as? TextLeaf, textLeaf !== oldValue else { return }
			inputsButton.uiColor = inward ? textLeaf.text.color.uiColor : UIColor.white
			outputsButton.uiColor = inward ? UIColor.white : textLeaf.text.color.uiColor
			inputsView.textBub = textLeaf.textBub
			outputsView.textBub = textLeaf.textBub
		}
	}
	var textLeaf: TextLeaf {
		return editable as! TextLeaf
	}

	
	let inputsView: EdgesView = EdgesView(input: true)
	var inputsMask: MaskView!
	let outputsView: EdgesView = EdgesView(input: false)
	var outputsMask: MaskView!
	var okButton: PathButton = PathButton(key: "OK")
	var inputsButton: PathButton = PathButton(key: "inputs")
	var outputsButton: PathButton = PathButton(key: "outputs")

    init(orb: Orb) {
        super.init(orb: orb, size: CGSize(width: 180, height: 220))
//		super.init(anchor: .bottomRight,offset: UIOffset.zero, size: CGSize(width: 180, height: 220), fixedOffset: UIOffset(horizontal: 0, vertical: 0))

		inputsButton.uiColor = UIColor.white
		addSubview(inputsButton)
		inputsButton.addAction(for: .touchUpInside) { [unowned self] in
			self.inward = true
		}
		
		outputsButton.uiColor = UIColor.white
		addSubview(outputsButton)
		outputsButton.addAction(for: .touchUpInside) { [unowned self] in
			self.inward = false
		}
		
		okButton.uiColor = UIColor.white
		addSubview(okButton)
		okButton.addAction(for: .touchUpInside) { [unowned self] in
			self.textLeaf.releaseFocus()
		}
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func refresh() {
		inputsView.reloadData()
		outputsView.reloadData()
	}
	
// UIView ==========================================================================================
	override func layoutSubviews() {
		let ir: CGFloat = 2*Oo.s
		let rr: CGFloat = 4*Oo.s
		let or: CGFloat = 8*Oo.s
		
		let p: CGFloat = 3
		let sp: CGFloat = 3*Oo.s
		let w: CGFloat = 180*Oo.s
		let th: CGFloat = 87*Oo.s
		let bh: CGFloat = 217*Oo.s-th
		let q: CGFloat = 12*Oo.s
		
		let sq: CGFloat = sp*sqrt(2)
		let r: CGFloat = q-sp/2
		let h: CGFloat = th+sp+bh
		let c: CGFloat = 1

		let x1 = p
		let x2 = x1+q
		let x3 = x2+q
		let x4 = w/2
		let x7 = w-p
		let x6 = x7-q
		let x5 = x6-q
		let x8 = x4-sp/2
		let x9 = x4+sp/2
		let x10 = (x1+x8)/2
		let x11 = (x7+x9)/2
		let x12 = x1+sq
		let x13 = x12+r
		let x14 = x13+r
		let x17 = x7-sq
		let x16 = x17-r
		let x15 = x16-r
		
//		let y1 = p
//		let y2 = y1+q
//		let y3 = y2+q
		let y5 = th-p
//		let y4 = (y1+y5)/2
		let y6 = y5+sp
		let y7 = y6+q
		let y8 = y7+q
		let y12 = h-p
		let y11 = y12-q
		let y10 = y11-q
		let y9 = (y7+y12)/2
//		let y13 = y1+r
//		let y14 = y13+r
		let y15 = y6+r
		let y16 = y15+r
		let y18 = y12-r
		let y17 = y18-r
		
		var path = CGMutablePath()
		
		path.move(to: CGPoint(x: x13, y: y15))
		path.addArc(tangent1End: CGPoint(x: x12, y: y6), tangent2End: CGPoint(x: x10, y: y6), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x8, y: y6), tangent2End: CGPoint(x: x8, y: y15), radius: rr)
		path.addArc(tangent1End: CGPoint(x: x8, y: y16), tangent2End: CGPoint(x: x10, y: y16), radius: rr)
		path.addArc(tangent1End: CGPoint(x: x14, y: y16), tangent2End: CGPoint(x: x13, y: y15), radius: or)
		path.closeSubpath()
		inputsButton.path = path
		inputsButton.offset = UIOffset(horizontal: 6, vertical: 4)

		path = CGMutablePath()														// outputs
		path.move(to: CGPoint(x: x9, y: y15))
		path.addArc(tangent1End: CGPoint(x: x9, y: y6), tangent2End: CGPoint(x: x11, y: y6), radius: rr)
		path.addArc(tangent1End: CGPoint(x: x17, y: y6), tangent2End: CGPoint(x: x16, y: y15), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x15, y: y16), tangent2End: CGPoint(x: x11, y: y16), radius: or)
		path.addArc(tangent1End: CGPoint(x: x9, y: y16), tangent2End: CGPoint(x: x9, y: y15), radius: rr)
		path.closeSubpath()
		outputsButton.path = path
		outputsButton.offset = UIOffset(horizontal: -6, vertical: 4)
	
		path = CGMutablePath()														// ok
		path.move(to: CGPoint(x: x13, y: y18))
		path.addArc(tangent1End: CGPoint(x: x14, y: y17), tangent2End: CGPoint(x: x4, y: y17), radius: or)
		path.addArc(tangent1End: CGPoint(x: x15, y: y17), tangent2End: CGPoint(x: x16, y: y18), radius: or)
		path.addArc(tangent1End: CGPoint(x: x17, y: y12), tangent2End: CGPoint(x: x4, y: y12), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x12, y: y12), tangent2End: CGPoint(x: x13, y: y18), radius: ir)
		path.closeSubpath()
		okButton.path = path
		okButton.offset = UIOffset(horizontal: 0, vertical: 5)

		path = CGMutablePath()														// bottom left outline
		path.move(to: CGPoint(x: x1+c, y: y9))
		path.addArc(tangent1End: CGPoint(x: x1+c, y: y6+c), tangent2End: CGPoint(x: x2-c, y: y7+c), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x3-c, y: y8+c), tangent2End: CGPoint(x: x10, y: y8+c), radius: or)
		path.addArc(tangent1End: CGPoint(x: x8-c, y: y8+c), tangent2End: CGPoint(x: x8-c, y: y9), radius: rr)
		path.addArc(tangent1End: CGPoint(x: x8-c, y: y10-c), tangent2End: CGPoint(x: x10, y: y10-c), radius: rr)
		path.addArc(tangent1End: CGPoint(x: x3-c, y: y10-c), tangent2End: CGPoint(x: x2-c, y: y11-c), radius: or)
		path.addArc(tangent1End: CGPoint(x: x1+c, y: y12-c), tangent2End: CGPoint(x: x1+c, y: y9), radius: ir)
		path.closeSubpath()
		inputsMask = MaskView(frame: bounds, content: inputsView, path: path)
		inputsView.frame = CGRect(x: x1, y: y6, width: x8-x1, height: y12-y6)
		inputsView.contentInset = UIEdgeInsets(top: y8-y6, left: 0, bottom: y12-y10, right: 0)
		addSubview(inputsMask)
		
		path = CGMutablePath()														// bottom right outline
		path.move(to: CGPoint(x: x7-c, y: y9))
		path.addArc(tangent1End: CGPoint(x: x7-c, y: y6+c), tangent2End: CGPoint(x: x6+c, y: y7+c), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x5+c, y: y8+c), tangent2End: CGPoint(x: x11, y: y8+c), radius: or)
		path.addArc(tangent1End: CGPoint(x: x9+c, y: y8+c), tangent2End: CGPoint(x: x9+c, y: y9), radius: rr)
		path.addArc(tangent1End: CGPoint(x: x9+c, y: y10-c), tangent2End: CGPoint(x: x11, y: y10-c), radius: rr)
		path.addArc(tangent1End: CGPoint(x: x5+c, y: y10-c), tangent2End: CGPoint(x: x6+c, y: y11-c), radius: or)
		path.addArc(tangent1End: CGPoint(x: x7-c, y: y12-c), tangent2End: CGPoint(x: x7-c, y: y9), radius: ir)
		path.closeSubpath()
		outputsMask = MaskView(frame: bounds, content: outputsView, path: path)
		outputsView.frame = CGRect(x: x9, y: y6, width: x7-x9, height: y12-y6)
		outputsView.contentInset = UIEdgeInsets(top: y8-y6, left: 0, bottom: y12-y10, right: 0)
		addSubview(outputsMask)
	}
	override func draw(_ rect: CGRect) {
		let ir: CGFloat = 2*Oo.s
		let rr: CGFloat = 4*Oo.s
		let or: CGFloat = 8*Oo.s
		
		let p: CGFloat = 3
		let sp: CGFloat = 3*Oo.s
		let w: CGFloat = 180*Oo.s
		let th: CGFloat = 87*Oo.s
		let bh: CGFloat = 217*Oo.s-th
		let q: CGFloat = 12*Oo.s
		
		let sq: CGFloat = sp*sqrt(2)
		let r: CGFloat = q-sp/2
		let h: CGFloat = th+sp+bh

		let x1 = p
		let x2 = x1+q
		let x3 = x2+q
		let x4 = w/2
		let x7 = w-p
		let x6 = x7-q
		let x5 = x6-q
		let x8 = x4-sp/2
		let x9 = x4+sp/2
		let x10 = (x1+x8)/2
		let x11 = (x7+x9)/2
		let x12 = x1+sq
		let x13 = x12+r
		let x14 = x13+r
		let x17 = x7-sq
		let x16 = x17-r
		let x15 = x16-r
		
		let y1 = p
		let y2 = y1+q
		let y3 = y2+q
		let y5 = th-p
		let y4 = (y1+y5)/2
		let y6 = y5+sp
		let y7 = y6+q
		let y8 = y7+q
		let y12 = h-p
		let y11 = y12-q
		let y10 = y11-q
		let y9 = (y7+y12)/2
		let y13 = y1+r
		let y14 = y13+r
//		let y15 = y6+r
//		let y16 = y15+r
//		let y18 = y12-r
//		let y17 = y18-r
		
		var path = CGMutablePath()													// top outline
		path.move(to: CGPoint(x: x1, y: y4))
		path.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x2, y: y2), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x3, y: y3), tangent2End: CGPoint(x: x4, y: y3), radius: or)
		path.addArc(tangent1End: CGPoint(x: x5, y: y3), tangent2End: CGPoint(x: x6, y: y2), radius: or)
		path.addArc(tangent1End: CGPoint(x: x7, y: y1), tangent2End: CGPoint(x: x7, y: y4), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x7, y: y5), tangent2End: CGPoint(x: x4, y: y5), radius: rr)
		path.addArc(tangent1End: CGPoint(x: x1, y: y5), tangent2End: CGPoint(x: x1, y: y4), radius: rr)
		path.closeSubpath()
		Skin.bubble(path: path, uiColor: UIColor.lightGray, width: 2)
		
		path = CGMutablePath()														// bottom left outline
		path.move(to: CGPoint(x: x1, y: y9))
		path.addArc(tangent1End: CGPoint(x: x1, y: y6), tangent2End: CGPoint(x: x2, y: y7), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x3, y: y8), tangent2End: CGPoint(x: x10, y: y8), radius: or)
		path.addArc(tangent1End: CGPoint(x: x8, y: y8), tangent2End: CGPoint(x: x8, y: y9), radius: rr)
		path.addArc(tangent1End: CGPoint(x: x8, y: y10), tangent2End: CGPoint(x: x10, y: y10), radius: rr)
		path.addArc(tangent1End: CGPoint(x: x3, y: y10), tangent2End: CGPoint(x: x2, y: y11), radius: or)
		path.addArc(tangent1End: CGPoint(x: x1, y: y12), tangent2End: CGPoint(x: x1, y: y9), radius: ir)
		path.closeSubpath()
		
		path.move(to: CGPoint(x: x7, y: y9))										// bottom right outline
		path.addArc(tangent1End: CGPoint(x: x7, y: y6), tangent2End: CGPoint(x: x6, y: y7), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x5, y: y8), tangent2End: CGPoint(x: x11, y: y8), radius: or)
		path.addArc(tangent1End: CGPoint(x: x9, y: y8), tangent2End: CGPoint(x: x9, y: y9), radius: rr)
		path.addArc(tangent1End: CGPoint(x: x9, y: y10), tangent2End: CGPoint(x: x11, y: y10), radius: rr)
		path.addArc(tangent1End: CGPoint(x: x5, y: y10), tangent2End: CGPoint(x: x6, y: y11), radius: or)
		path.addArc(tangent1End: CGPoint(x: x7, y: y12), tangent2End: CGPoint(x: x7, y: y9), radius: ir)
		path.closeSubpath()
		Skin.bubble(path: path, uiColor: UIColor.gray, width: 2)
		
		path = CGMutablePath()														// name
		path.move(to: CGPoint(x: x13, y: y13))
		path.addArc(tangent1End: CGPoint(x: x12, y: y1), tangent2End: CGPoint(x: x4, y: y1), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x17, y: y1), tangent2End: CGPoint(x: x16, y: y13), radius: ir)
		path.addArc(tangent1End: CGPoint(x: x15, y: y14), tangent2End: CGPoint(x: x4, y: y14), radius: or)
		path.addArc(tangent1End: CGPoint(x: x14, y: y14), tangent2End: CGPoint(x: x13, y: y13), radius: or)
		path.closeSubpath()
		Skin.bubble(path: path, uiColor: textLeaf.text.color.uiColor, width: 2)
		
		// Text ==============================
		Skin.text(textLeaf.text.name, rect: CGRect(x: x13, y: y1+4/3*Oo.s, width: x16-x13, height: y14-y1), uiColor: textLeaf.text.color.uiColor, font: UIFont(name: "HelveticaNeue", size: 14*Oo.s)!, align: .center)
	}
}
