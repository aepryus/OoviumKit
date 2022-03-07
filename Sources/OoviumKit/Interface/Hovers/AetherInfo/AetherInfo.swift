//
//  AetherInfo.swift
//  Oovium
//
//  Created by Joe Charlier on 8/30/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class AetherInfo: Hover, UITextFieldDelegate {
	private let nameField: UITextField
	private let cancelButton: AetherInfoButton
	private let okButton: AetherInfoButton
	
	private var x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15, x16, x17, x18, x19, x20, x21, x22, x23, x24, x25, x26, x27, x28, x29, x30, x31, x32, x33, x34, x35, x36, x37, x38, x39, x40, x41: CGFloat
	private var y1, y2, y3, y4, y5, y6, y7, y8, y9, y10, y11: CGFloat
	
	init(aetherView: AetherView) {
		let s: CGFloat = Oo.s
		let p: CGFloat = 3
		let sp: CGFloat = 4 * s
		let sq: CGFloat = sp * CGFloat(2).squareRoot()
		
		let lw: CGFloat = 200 * s
		let w: CGFloat = lw
		
		let h: CGFloat = 180 * s
		let q: CGFloat = 14 * s
		let r: CGFloat = q - sp/2
		let br: CGFloat = s * 2
		let cr: CGFloat = s * 8

		x1 = p
		x2 = x1 + q
		x3 = x2 + q
		x4 = lw/2
		x7 = lw - p
		x6 = x7 - q
		x5 = x6 - q
		
		x8 = x7 + sp
		x9 = x8 + q
		x10 = x9 + q
		x11 = (w+lw+sp)/2
		x14 = w - p
		x13 = x14 - q
		x12 = x13 - q
		
		x15 = x1 + sq
		x16 = x15 + r
		x17 = x16 + r
		x19 = x4 - sq/2
		x18 = x19 + r
		x20 = x19 - r
		x21 = x18 + sq
		x22 = x21 - r
		x23 = x22 - r
		x24 = x7 - sq
		x25 = x24 - r
		x26 = x25 - r
		x27 = x8 + sq
		x28 = x27 + r
		x29 = x28 + r
		x30 = x14 - sq
		x31 = x30 - r
		x32 = x31 - r
		x36 = x27 + 108*s
		x37 = x36 - r
		x38 = x37 - r
		x39 = x36 + sq
		x40 = x39 - r
		x41 = x40 - r
		
		x33 = (x16+x19)/2
		x34 = (x22+x25)/2
		x35 = x32 - 8*s
		
		y1 = p
		y2 = y1 + q
		y3 = y2 + q
		y4 = h/2
		y7 = h - p
		y6 = y7 - q
		y5 = y6 - q
		y8 = y1 + r
		y9 = y8 + r
		y11 = y7 - r
		y10 = y11 - r

		nameField = AETextField(frame: CGRect(x: x17, y: 5*s-4, width: x26-x17, height: y9-y1))
		nameField.backgroundColor = UIColor.clear
		nameField.autocapitalizationType = .none
		nameField.autocorrectionType = .no
		nameField.textAlignment = .center
		nameField.font = UIFont.systemFont(ofSize: 14*Oo.s)
		nameField.textColor = RGB(uiColor: UIColor.cyan).shade(0.7).uiColor
		
		var path = CGMutablePath()													// Cancel
		path.move(to: CGPoint(x: x16-(x15-p), y: y11-(y10-p)))
		path.addArc(tangent1End: CGPoint(x: x17-(x15-p), y: y10-(y10-p)), tangent2End: CGPoint(x: x33-(x15-p), y: y10-(y10-p)), radius: cr)
		path.addArc(tangent1End: CGPoint(x: x18-(x15-p), y: y10-(y10-p)), tangent2End: CGPoint(x: x19-(x15-p), y: y11-(y10-p)), radius: br)
		path.addArc(tangent1End: CGPoint(x: x20-(x15-p), y: y7-(y10-p)), tangent2End: CGPoint(x: x33-(x15-p), y: y7-(y10-p)), radius: cr)
		path.addArc(tangent1End: CGPoint(x: x15-(x15-p), y: y7-(y10-p)), tangent2End: CGPoint(x: x16-(x15-p), y: y11-(y10-p)), radius: br)
		path.closeSubpath()
		
		cancelButton = AetherInfoButton(frame: CGRect(x: x15-p, y: y10-p, width: x18-x15+2*p, height: y7-y10+2*p), path: path, uiColor: UIColor.cyan, key: "cancel", textRect: CGRect(x: x15-2*s-(x15-p), y: y10+3*s-(y10-p), width: x18-x15, height: y7-10))
		
		path = CGMutablePath()														// OK
		path.move(to: CGPoint(x: x22-(x23-p), y: y11-(y10-p)))
		path.addArc(tangent1End: CGPoint(x: x21-(x23-p), y: y10-(y10-p)), tangent2End: CGPoint(x: x34-(x23-p), y: y10-(y10-p)), radius: cr)
		path.addArc(tangent1End: CGPoint(x: x26-(x23-p), y: y10-(y10-p)), tangent2End: CGPoint(x: x25-(x23-p), y: y11-(y10-p)), radius: cr)
		path.addArc(tangent1End: CGPoint(x: x24-(x23-p), y: y7-(y10-p)), tangent2End: CGPoint(x: x34-(x23-p), y: y7-(y10-p)), radius: br)
		path.addArc(tangent1End: CGPoint(x: x23-(x23-p), y: y7-(y10-p)), tangent2End: CGPoint(x: x22-(x23-p), y: y11-(y10-p)), radius: br)
		path.closeSubpath()
		
		okButton = AetherInfoButton(frame: CGRect(x: x23-p, y: y10-p, width: x24-x23+2*p, height: y7-y10+2*p), path: path, uiColor: UIColor.cyan, key: "OK", textRect: CGRect(x: x22-(x23-p), y: y10+3*s-(y10-p), width: x25-x22, height: y7-y10))
		
		super.init(aetherView: aetherView, anchor: .center, size: CGSize(width: w/Oo.s, height: h/Oo.s), offset: UIOffset(horizontal: 0, vertical: 0))
		
		nameField.text = aetherView.aether.name
		
		nameField.delegate = self
		addSubview(nameField)
		
		cancelButton.addAction(for: .touchUpInside) {[weak self] in
			self?.dismiss()
		}
		addSubview(cancelButton)
		
		okButton.addAction(for: .touchUpInside) { [unowned self] in
			let aether: Aether = aetherView.aether
			guard var name = nameField.text, name != aether.name else { return }
			Space.local.loadNames { (names: [String]) in
				if names.contains(name) {
					var aetherNo: Int = 0
					var test = name
					repeat {
						aetherNo += 1
						test = String(format: "%@%02d", name, aetherNo)
					} while names.contains(test)
					name = test
				}
				Space.local.removeAether(name: aether.name) { (success: Bool) in
					aether.name = name
					Space.local.storeAether(aether) { (success: Bool) in
						DispatchQueue.main.async {
							aetherView.aetherPicker?.loadAetherNames()
						}
					}
				}
			}
			dismiss()
		}
		addSubview(okButton)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		let s: CGFloat = Oo.s
		let br: CGFloat = s * 2
		let cr: CGFloat = s * 8
		

		var path: CGMutablePath = CGMutablePath()									// Left Outline
		path.move(to: CGPoint(x: x1, y: y4))
		path.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x2, y: y2), radius: br)
		path.addArc(tangent1End: CGPoint(x: x3, y: y3), tangent2End: CGPoint(x: x4, y: y3), radius: cr)
		path.addArc(tangent1End: CGPoint(x: x5, y: y3), tangent2End: CGPoint(x: x6, y: y2), radius: cr)
		path.addArc(tangent1End: CGPoint(x: x7, y: y1), tangent2End: CGPoint(x: x7, y: y4), radius: br)
		path.addArc(tangent1End: CGPoint(x: x7, y: y7), tangent2End: CGPoint(x: x6, y: y6), radius: br)
		path.addArc(tangent1End: CGPoint(x: x5, y: y5), tangent2End: CGPoint(x: x4, y: y5), radius: cr)
		path.addArc(tangent1End: CGPoint(x: x3, y: y5), tangent2End: CGPoint(x: x2, y: y6), radius: cr)
		path.addArc(tangent1End: CGPoint(x: x1, y: y7), tangent2End: CGPoint(x: x1, y: y4), radius: br)
		path.closeSubpath()
		
		Skin.panel(path: path, uiColor: UIColor.purple)

		path = CGMutablePath()														// Name
		path.move(to: CGPoint(x: x16, y: y8))
		path.addArc(tangent1End: CGPoint(x: x15, y: y1), tangent2End: CGPoint(x: x4, y: y1), radius: br)
		path.addArc(tangent1End: CGPoint(x: x24, y: y1), tangent2End: CGPoint(x: x25, y: y8), radius: br)
		path.addArc(tangent1End: CGPoint(x: x26, y: y9), tangent2End: CGPoint(x: x4, y: y9), radius: cr)
		path.addArc(tangent1End: CGPoint(x: x17, y: y9), tangent2End: CGPoint(x: x16, y: y8), radius: cr)
		path.closeSubpath()
		
		Skin.key(path: path, uiColor: UIColor.cyan)
	}

// UITextFieldDelegate =============================================================================
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		guard !string.contains(".") || !string.contains("/") else {return false}
		return true
	}
}
