//
//  HeaderCell.swift
//  Oovium
//
//  Created by Joe Charlier on 3/2/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class HeaderCell: UICollectionViewCell, Editable, Citable, DoubleTappable, AnchorPannable, UITextFieldDelegate {
	var column: Column! {
		didSet {setNeedsDisplay()}
	}
	unowned var gridLeaf: GridLeaf!
	var leftMost: Bool = false
	
	var textField: UITextField? = nil
	var editingName: Bool {
		return textField != nil
	}
	var gridBub: GridBub {
		return gridLeaf.gridBub
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		backgroundColor = .clear
	}
	required init?(coder: NSCoder) {fatalError()}
	
	var isFocus: Bool {
		return self === gridLeaf.aetherView.focus
	}
	
	func openLabel() {
		gridBub.aetherView.locked = true
		textField = UITextField()
		textField!.delegate = self
		textField!.text = column.name
		textField!.textAlignment = column.alignment
		textField!.font = UIFont(name: "Verdana-Bold", size: 15)!
		textField!.textColor = UIColor.white
		textField!.autocorrectionType = .no
		textField!.keyboardAppearance = .dark
		textField!.inputAssistantItem.leadingBarButtonGroups.removeAll()
		textField!.inputAssistantItem.trailingBarButtonGroups.removeAll()
		addSubview(textField!)
		let p: CGFloat = 6
		textField!.frame = CGRect(x: p, y: 1.5, width: width-2*p, height: height-2)
		setNeedsDisplay()
		textField!.becomeFirstResponder()
	}
	func closeLabel() {
//		column._width = nil
//		column._headerWidth = nil
		gridBub.aetherView.locked = false
		column.name = textField!.text!
		textField?.removeFromSuperview()
		textField = nil
		setNeedsDisplay()
		gridLeaf.render()
		gridBub.render()
	}
	func renderColumn() {
		setNeedsDisplay()
		gridLeaf.render()
		gridBub.render()
	}

// Events ==========================================================================================
	@objc func onDoubleTap() {
		guard !aetherView.readOnly else {return}
		if focused {releaseFocus()}
		openLabel()
	}

// UIView ==========================================================================================
	override var frame: CGRect {
		didSet {
			guard frame != oldValue else { return }
			setNeedsDisplay()
		}
	}
	override func draw(_ rect: CGRect) {
		let p: CGFloat = 1
		let path: CGMutablePath = CGMutablePath()

		if isFocus {
			Skin.gridCalc(path: CGPath(rect: rect, transform: nil), uiColor: UIColor.cyan.shade(0.5))
		} else {
			Skin.gridFill(path: CGPath(rect: rect, transform: nil), uiColor: UIColor.black)
		}
		
		path.move(to: CGPoint(x: 0, y: p))
		path.addLine(to: CGPoint(x: width-(leftMost ? p : 0), y: p))
		
		if !leftMost {path.move(to: CGPoint(x: width-p, y: p))}
		path.addLine(to: CGPoint(x: width-p, y: height))
		
		path.move(to: CGPoint(x: 0, y: height-p))
		path.addLine(to: CGPoint(x: width-(leftMost ? p : 0), y: height-p))
		
		Skin.gridDraw(path: path, uiColor: gridLeaf.uiColor)
		
		if !editingName {
			if isFocus {
				Skin.text("\(column.name)", rect: rect.insetBy(dx: 6, dy: 5), uiColor: UIColor.cyan.shade(0.5), font: UIFont(name: "Verdana-Bold", size: 15)!, align: column.alignment)
			} else {
				Skin.text("\(column.name)", rect: rect.insetBy(dx: 6, dy: 5), uiColor: gridLeaf.uiColor, font: UIFont(name: "Verdana-Bold", size: 15)!, align: column.alignment)
			}
		}
	}

// Tappable ========================================================================================
	func onTap(aetherView: AetherView) {
		if aetherView.focus !== self {
			makeFocus()
		} else {
			releaseFocus()
		}
	}

// Editable ========================================================================================
	var aetherView: AetherView { gridLeaf.aetherView }
	var editor: Orbit {
		return orb.headerEditor.edit(editable: self)
	}
	func cedeFocusTo(other: FocusTappable) -> Bool {
		if other === gridBub.chainLeaf {return true}
		guard let headerCell = other as? HeaderCell else {return false}
		return gridLeaf === headerCell.gridLeaf
	}
	func onMakeFocus() {
		gridBub.suppressChainLeafRemoval = false
		gridBub.attachChainLeaf(to: self)
		setNeedsDisplay()
	}
	func onReleaseFocus() {
		if !gridBub.suppressChainLeafRemoval {gridBub.removeChainLeaf()}
		setNeedsDisplay()
	}
	func cite(_ citable: Citable, at: CGPoint) {}

// Citable =========================================================================================
	func relevant(editable: Editable) -> Bool {
		guard let chainLeaf: ChainLeaf = editable as? ChainLeaf else {return false}
		return chainLeaf.bubble === gridBub
	}
	func token(at: CGPoint) -> Token? {
		return column.token
	}

// AnchorPannable ==================================================================================
	func onPan(offset: CGPoint) {
		gridLeaf.slide(column: column, dx: offset.x)
	}
	func onReleased(offset: CGPoint) {
		let to: Int = gridLeaf.gridView.colNo(cx: center.x+offset.x)-1
		gridLeaf.move(column: column, to: to)
	}

// UITextFieldDelegate =============================================================================
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		closeLabel()
		return true
	}
}
