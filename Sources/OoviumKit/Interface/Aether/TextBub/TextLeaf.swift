//
//  TextLeaf.swift
//  Oovium
//
//  Created by Joe Charlier on 8/28/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class TextLeaf: Leaf, Editable, DoubleTappable, Citable, UITextFieldDelegate {
    enum Mode { case read, focus, edit }
    
	let text: Text
	
	var textField: OOTextField? = nil
    var mode: Mode = .read {
        didSet {
            guard mode != oldValue else { return }
            switch mode {
                case .read:     readMode()
                case .focus:    break
                case .edit:     editMode()
            }
        }
    }
	
	init(bubble: Bubble) {
		self.text = (bubble as! TextBub).text
		super.init(bubble: bubble, hitch: .center, anchor: CGPoint.zero, size: CGSize.zero)
		self.backgroundColor = UIColor.clear
        mooring = bubble.createMooring()
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	var textBub: TextBub { bubble as! TextBub }
	
	var uiColor: UIColor {
		if focused { return UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) }
		else if bubble.selected { return .yellow }
		else { return text.color.uiColor }
	}
	
	func render() {
        var pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!, alignment: .center)
        let style: NSMutableParagraphStyle = pen.style.mutableCopy() as! NSMutableParagraphStyle
        style.lineBreakMode = .byWordWrapping
        pen = pen.clone(style: style)
        
		var size: CGSize = CGSize.zero
		
		if textField != nil {
			size = CGSize(width: max(80, self.size.width+24), height: 28)
			
		} else {
			size = (text.name as NSString).size(withAttributes: pen.attributes)
			if text.name.components(separatedBy: " ").count > 1 {
				while size.width > size.height*4 {
					size = (text.name as NSString).boundingRect(with: CGSize(width: size.width*0.9, height: 2000), options: [.usesLineFragmentOrigin], attributes: pen.attributes, context: nil).size
				}
			}
			if size.width > aetherView.width - 40 {
				size = (text.name as NSString).boundingRect(with: CGSize(width: aetherView.width - 40, height: 2000), options: [.usesLineFragmentOrigin], attributes: pen.attributes, context: nil).size
			}
			self.size = size
		}
		frame = text.shape.shape.bounds(size: size)
		textBub.bounds = bounds
		setNeedsDisplay()
	}
	
	func linkTo(other: TextLeaf) {
		text.linkTo(other.text)
        mooring.attach(other.mooring)
	}
	func unlinkTo(other: TextLeaf) {
		text.unlinkTo(other.text)
        mooring.detach(other.mooring)
	}
	
	private func readMode() {
		guard let name = textField?.text else { return }
		if name.count > 0 {
			text.name = textField!.text!
			textField?.resignFirstResponder()
			textField?.removeFromSuperview()
			textField = nil
			render()
			setNeedsDisplay()
		} else {
			textBub.delete()
		}
		bubble.aetherView.currentTextLeaf = nil
	}
	private func editMode() {
		bubble.aetherView.currentTextLeaf = self
		let w: CGFloat = max(80, size.width+24)
		let h: CGFloat = 28
        self.textField = OOTextField(
			frame: CGRect(x: (bounds.size.width-w)/2, y: (bounds.size.height-h)/2, width: w, height: h),
			backColor: Skin.color(.ovalBack),
			foreColor: Skin.color(.ovalFore),
			textColor: Skin.color(.ovalText)
		)
        guard let textField else { return }
		textField.delegate = self
		textField.text = text.name
		addSubview(textField)
		textField.becomeFirstResponder()
		render()
		textField.frame = CGRect(x: (bounds.size.width-w)/2, y: (bounds.size.height-h)/2, width: w, height: h)
		textField.setNeedsDisplay()
	}
	
// Leaf ============================================================================================
	override func wireMoorings() {
		for edge in text.edges {
            guard let text: Text = edge.other
                else { continue }
			let textBub: TextBub = bubble.aetherView.bubble(aexel: text) as! TextBub
            mooring.attach(textBub.textLeaf.mooring, wake: false)
		}
	}
	
// Editable ========================================================================================
	var editor: Orbit { orb.textEditor.edit(editable: self) }
	func onMakeFocus() {
		render()
		mooring.wakeDoodles()
	}
	func onReleaseFocus() {
		render()
		mooring.sleepDoodles()
		textBub.onOK()
	}
	func cite(_ citable: Citable, at: CGPoint) {
		guard let other = citable as? TextLeaf else { return }
		
		let inward: Bool = orb.textEditor.inward
		let from: TextLeaf = inward ? other : self
		let to: TextLeaf = inward ? self : other
		
		if !to.text.isLinkedTo(from.text) {
			to.linkTo(other: from)
		} else {
			to.unlinkTo(other: from)
		}
	}

// Events ==========================================================================================
	func onFocusTap(aetherView: AetherView) {
        guard textField == nil else { return }
		if !focused { makeFocus() }
        else { releaseFocus(.focusTap) }
	}
	@objc func onDoubleTap() {
		guard (focused || textBub.aetherView.focus == nil) && !aetherView.readOnly else { return }
        if focused { releaseFocus(.administrative) }
        mode = .edit
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		text.shape.shape.draw(rect: rect, uiColor: uiColor)
		if textField == nil {
			Skin.shape(text: text.name, rect: rect, uiColor: uiColor, maxWidth: aetherView.width-40)
		}
	}
	
// UITextFieldDelegate =============================================================================
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        mode = .read
		return true
	}
	func textFieldDidEndEditing(_ textField: UITextField) {
        mode = .read
	}
	
// Citable =========================================================================================
    func token(at: CGPoint) -> Token? { nil }
}
