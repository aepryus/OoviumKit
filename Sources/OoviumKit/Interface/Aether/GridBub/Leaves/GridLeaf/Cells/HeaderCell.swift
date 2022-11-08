//
//  HeaderCell.swift
//  Oovium
//
//  Created by Joe Charlier on 3/2/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class HeaderCell: UICollectionViewCell, Sizable, Editable, Citable, DoubleTappable, AnchorPannable, UITextFieldDelegate {
    let controller: GridController
	let column: Column
    
	var leftMost: Bool = false
	
	var textField: UITextField? = nil
	var editingName: Bool { textField != nil }

    var gridBub: GridBub { controller.gridBub }
    var gridLeaf: GridLeaf { gridBub.gridLeaf }
    
    static let pen: Pen = Pen(font: UIFont(name: "Verdana-Bold", size: 15)!)
    var pen: Pen { HeaderCell.pen }
	
    init(controller: GridController, column: Column) {
        self.controller = controller
        self.column = column
        
        super.init(frame: .zero)
		backgroundColor = .clear
	}
	required init?(coder: NSCoder) { fatalError() }
	
    var isFocus: Bool { self === gridLeaf.aetherView.focus }
	
	func openLabel() {
		gridBub.aetherView.locked = true
		textField = UITextField()
		textField!.delegate = self
		textField!.text = column.name
		textField!.textAlignment = column.alignment
        textField!.font = pen.font
        textField!.textColor = Skin.color(.headerText)
		textField!.autocorrectionType = .no
		textField!.keyboardAppearance = .dark
		textField!.inputAssistantItem.leadingBarButtonGroups.removeAll()
		textField!.inputAssistantItem.trailingBarButtonGroups.removeAll()
		addSubview(textField!)
		let p: CGFloat = 6
		textField!.frame = CGRect(x: p, y: 0, width: width-2*p, height: height-2)
		setNeedsDisplay()
		textField!.becomeFirstResponder()
	}
	func closeLabel() {
		gridBub.aetherView.locked = false
		column.name = textField!.text!
		textField?.removeFromSuperview()
		textField = nil
        setNeedsResize()
        controller.resizeEverything()
	}
	func renderColumn() {
		setNeedsDisplay()
		gridLeaf.resize()
		gridBub.render()
	}

// Events ==========================================================================================
	@objc func onDoubleTap() {
		guard !aetherView.readOnly else { return }
        if focused { releaseFocus(.administrative) }
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

		if isFocus { Skin.gridCalc(path: CGPath(rect: rect, transform: nil), uiColor: UIColor.cyan.shade(0.5)) }
        else {       Skin.gridFill(path: CGPath(rect: rect, transform: nil), uiColor: UIColor.black) }
		
		path.move(to: CGPoint(x: 0, y: p))
		path.addLine(to: CGPoint(x: width-(leftMost ? p : 0), y: p))
		
		if !leftMost { path.move(to: CGPoint(x: width-p, y: p)) }
		path.addLine(to: CGPoint(x: width-p, y: height))
		
		path.move(to: CGPoint(x: 0, y: height-p))
		path.addLine(to: CGPoint(x: width-(leftMost ? p : 0), y: height-p))
		
		Skin.gridDraw(path: path, uiColor: gridLeaf.uiColor)
        
		if !editingName {
            if isFocus { Skin.text("\(column.name)", rect: rect.insetBy(dx: Screen.snapToPixel(Oo.aS*4), dy: 5), uiColor: UIColor.cyan.shade(0.5), font: pen.font, align: column.alignment) }
            else {       Skin.text("\(column.name)", rect: rect.insetBy(dx: Screen.snapToPixel(Oo.aS*4), dy: 5), uiColor: gridLeaf.uiColor,        font: pen.font, align: column.alignment) }
		}
	}

// Sizable =========================================================================================
    var widthNeeded: CGFloat = 0
    
    func resize() {
        let needed: CGFloat = Screen.snapToPixel(column.name.size(pen: pen.clone(alignment: column.alignment)).width)
        let padding: CGFloat = Screen.snapToPixel(Oo.aS*4)*2
        widthNeeded = needed+padding
        
    }
    func setNeedsResize() { controller.needsResizing.append(self) }
    
// Tappable ========================================================================================
	func onFocusTap(aetherView: AetherView) {
		if aetherView.focus !== self { makeFocus() }
        else { releaseFocus(.focusTap) }
	}

// Editable ========================================================================================
	var aetherView: AetherView { gridLeaf.aetherView }
	var editor: Orbit { orb.headerEditor.edit(editable: self) }
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
		if !gridBub.suppressChainLeafRemoval { gridBub.removeChainLeaf() }
		setNeedsDisplay()
	}
	func cite(_ citable: Citable, at: CGPoint) {}

// Citable =========================================================================================
	func relevant(editable: Editable) -> Bool {
		guard let chainLeaf: ChainLeaf = editable as? ChainLeaf else {return false}
		return chainLeaf.bubble === gridBub
	}
    func token(at: CGPoint) -> Token? { column.tower.variableToken }

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
        setNeedsDisplay()
		return true
	}
}
