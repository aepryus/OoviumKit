//
//  SignatureLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 9/25/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

protocol SignatureLeafDelegate: AnyObject {
	var name: String {get}
	var params: [String] {get}
	func onNoOfParamsChanged(signatureLeaf: SignatureLeaf)
	func onOK(signatureLeaf: SignatureLeaf)
	var token: Token {get}
	var recipeToken: Token {get}
	var paramTokens: [Token] {get}
}

class SignatureLeaf: Leaf, Editable, Citable, UITextFieldDelegate {
	var noOfParams: Int
	
	var name: String = ""
	var params: [String] = []
	
	weak var delegate: SignatureLeafDelegate? = nil
	
	var open: Bool = false
	
	var path: CGMutablePath = CGMutablePath()
	
	var nameEdit: SignatureField? = nil
	var paramEdits: [SignatureField] = []
	
    lazy var recipeMooring: Mooring = Mooring(bubble: bubble, token: delegate!.recipeToken)
	var paramMoorings: [Mooring] = []
	
	init(bubble: Bubble & SignatureLeafDelegate, anchor: CGPoint, hitch: Position, size: CGSize) {
		delegate = bubble
		
		noOfParams = delegate!.params.count
		
		for i in 0..<noOfParams {
            let mooring = bubble.createMooring(token: delegate?.paramTokens[i])
			paramMoorings.append(mooring)
		}

		super.init(bubble: bubble, hitch: hitch, anchor: anchor, size: size)
		
		self.backgroundColor = UIColor.clear
		
		noOfParams = bubble.params.count
		
		render()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func render() {
		let p: CGFloat = 3						// padding
		let nw: CGFloat = 94					// name width
		let nh: CGFloat = 30					// name height
		let pw: CGFloat = 73					// param width
		let ph: CGFloat = 24					// param height
		let r: CGFloat = 15
		let cr: CGFloat = 5						// cap radius
		
		let x1 = p
		let x2 = p+(nw-pw)/2
		let x3 = x2+cr
		let x5 = x2+pw
		let x4 = x5-cr
		let x6 = 2*p+nw
		
		let y1 = p
		let y2 = y1+nh
		let y4 = y2+CGFloat(noOfParams)*ph
		let y3 = y4 - cr
		let y5 = 2*p+nh+CGFloat(noOfParams)*ph+cr
		
		path = CGMutablePath()
		path.addRoundedRect(in: CGRect(x: x1, y: p, width: nw, height: nh), cornerWidth: r, cornerHeight: r)
		
		if noOfParams > 0 {
			path.move(to: CGPoint(x: x2, y: y2))
			path.addLine(to: CGPoint(x: x2, y: y3))
			path.addQuadCurve(to: CGPoint(x: x3, y: y4), control: CGPoint(x: x2, y: y4))
			path.addLine(to: CGPoint(x: x4, y: y4))
			path.addQuadCurve(to: CGPoint(x: x5, y: y3), control: CGPoint(x: x5, y: y4))
			path.addLine(to: CGPoint(x: x5, y: y2))

			if noOfParams > 1 {
				for i in 1..<noOfParams {
					path.move(to: CGPoint(x: x2, y: y2+CGFloat(i)*ph))
					path.addLine(to: CGPoint(x: x5, y: y2+CGFloat(i)*ph))
				}
			}
		}
		hitPath = path

		self.size = CGSize(width: x6, height: y5)
	}

	func addInput() {
		noOfParams += 1

		let p: CGFloat = 3						// padding
		let nw: CGFloat = 94					// name width
		let nh: CGFloat = 30					// name height
		let pw: CGFloat = 73					// param width
		let ph: CGFloat = 24					// param height
		
		let x2 = p+(nw-pw)/2
		
		let y1 = p
		let y2 = y1+nh

		let paramEdit = SignatureField(frame: CGRect(x: x2, y: y2+CGFloat(noOfParams-1)*ph+1, width: pw, height: 20))
		paramEdit.delegate = self
		addSubview(paramEdit)
		paramEdits.append(paramEdit)
		
		render()

		delegate?.onNoOfParamsChanged(signatureLeaf: self)
		paramEdit.text = delegate?.params[noOfParams-1]
		paramEdit.textColor = Skin.color(.signatureText)

        let mooring = bubble.createMooring(token: delegate!.paramTokens[noOfParams-1])
		paramMoorings.append(mooring)

		setNeedsDisplay()
	}
	func removeInput() {
		guard noOfParams > 0 else { return }
		noOfParams -= 1
		
		let paramEdit = paramEdits.removeLast()
		paramEdit.removeFromSuperview()
		
		render()
		setNeedsDisplay()
		bubble.aetherView.moorings[delegate!.paramTokens[noOfParams]] = nil
		delegate?.onNoOfParamsChanged(signatureLeaf: self)

		paramMoorings.removeLast()
	}
	
// Events ==========================================================================================
	func onFocusTap(aetherView: AetherView) {
		guard !open else { return }
		makeFocus()
	}

// Editable ========================================================================================
	var editor: Orbit { orb.signatureEditor.edit(editable: self) }
	var overrides: [FocusTappable] = []
    func cedeFocusTo(other: FocusTappable) -> Bool { overrides.contains(where: { $0 === other}) }
	func onMakeFocus() {
		open = true
		let p: CGFloat = 3						// padding
		let nw: CGFloat = 94					// name width
		let nh: CGFloat = 30					// name height
		let pw: CGFloat = 73					// param width
		let ph: CGFloat = 24					// param height
		
		let x1 = p
		let x2 = p+(nw-pw)/2

        let y1 = p
		let y2 = y1+nh

		nameEdit = SignatureField(frame: CGRect(x: x1, y: y1+0.5, width: nw, height: 28))
		nameEdit?.delegate = self
		nameEdit?.text = delegate?.name
		nameEdit?.textColor = Skin.color(.signatureText)
		addSubview(nameEdit!)

		for i in 0..<noOfParams {
			let paramEdit = SignatureField(frame: CGRect(x: x2, y: y2+CGFloat(i)*ph+1, width: pw, height: 20))
			paramEdit.delegate = self
			paramEdit.text = delegate?.params[i]
			paramEdit.textColor = Skin.color(.signatureText)
			addSubview(paramEdit)
			paramEdits.append(paramEdit)
		}

		orb.signatureEditor.editable = self

		setNeedsDisplay()
	}
	func onReleaseFocus() {
		open = false
		nameEdit?.removeFromSuperview()
		paramEdits.forEach { $0.removeFromSuperview() }
		delegate?.onOK(signatureLeaf: self)
		nameEdit = nil
		paramEdits.removeAll()
		orb.chainEditor.customSchematic?.render(aether: bubble.aetherView.aether)
		
		setNeedsDisplay()
	}
	func cite(_ citable: Citable, at: CGPoint) {}
	
// Leaf ============================================================================================
	override func positionMoorings() {
		let x: CGFloat = frame.origin.x + frame.width/2
		
		recipeMooring.point = self.bubble.aetherView.scrollView.convert(CGPoint(x: x, y: 18), from: self.superview)
		for (i, mooring) in paramMoorings.enumerated() {
			mooring.point = self.bubble.aetherView.scrollView.convert(CGPoint(x: x, y: 45+24*CGFloat(i)), from: self.superview)
		}
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		Skin.bubble(path: path, uiColor: !open ? bubble.uiColor : UIColor.white, width: Oo.s)

		if !open, let delegate = delegate {
            Skin.bubble(text: delegate.name, rect: CGRect(x: 3, y: 3.5, width: rect.width-6, height: 30), uiColor: bubble.uiColor)
			var i = 0
			for param in delegate.params {
                Skin.bubble(text: param, rect: CGRect(x: 13, y: 33+CGFloat(i)*24, width: rect.width-26, height: 24), uiColor: bubble.uiColor)
				i += 1
			}
		}
	}
	
// UITextFieldDelegate =============================================================================
	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool { true }
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		var i = 0
		for c in string.unicodeScalars {
			if range.location == 0 && i == 0 && !NSCharacterSet.letters.contains(c) { return false }
			if !NSCharacterSet.alphanumerics.contains(c) { return false }
			i += 1
		}
		return true
	}
	
// Citable =========================================================================================
	func token(at: CGPoint) -> Token? {
		guard let delegate = delegate else { fatalError() }
		if at.y < 33 {
			if bubble.aetherView.anchored { return delegate.recipeToken }
            else { return delegate.token }
		} else {
			let i: Int = min(Int((at.y-33) / 24), delegate.paramTokens.count-1)
			return delegate.paramTokens[i]
		}
	}
}
