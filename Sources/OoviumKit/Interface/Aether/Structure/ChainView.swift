//
//  ChainView.swift
//  Oovium
//
//  Created by Joe Charlier on 4/10/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

protocol ChainViewDelegate: AnyObject {
    var chainView: ChainView { get }
    var color: UIColor { get }
    
    func onEditStart()
    func onEditStop()
    func onTokenAdded(_ token: Token)
    func onTokenRemoved(_ token: Token)

    func onChanged()
    func onWidthChanged(oldWidth: CGFloat?, newWidth: CGFloat)
}
extension ChainViewDelegate {
    func onEditStart() {}
    func onTokenAdded(_ token: Token) {}
    func onTokenRemoved(_ token: Token) {}
    func onEditStop() {}

    func onChanged(oldWidth: CGFloat?, newWidth: CGFloat) {}
}

protocol ChainViewKeyDelegate: AnyObject {
    func onArrowUp()
    func onArrowDown()
    func onArrowLeft()
    func onArrowRight()
    func onTab()
}
extension ChainViewKeyDelegate {
    func onArrowUp() {}
    func onArrowDown() {}
	func onArrowLeft() {}
	func onArrowRight() {}
	func onTab() {}
}

class ChainView: UIView, UITextInput, UITextInputTraits, AnchorTappable, TowerListener {
    var chain: Chain = Chain() {
        didSet {
            chain.tower.listener = self
            resize()
        }
    }
    weak var delegate: ChainViewDelegate?
    weak var keyDelegate: ChainViewKeyDelegate?
    unowned let responder: ChainResponder?
    
    var oldWidth: CGFloat?
    
    static let pen: Pen = Pen(font: .ooAether(size: 16))
    
    init(responder: ChainResponder?) {
        self.responder = responder
        super.init(frame: .zero)
        
        backgroundColor = UIColor.clear
        
        inputAssistantItem.leadingBarButtonGroups.removeAll()
        inputAssistantItem.trailingBarButtonGroups.removeAll()
    }
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    var blank: Bool { chain.tokens.count == 0 && !chain.editing }
        
    private func resize() {
        var widthNeeded: CGFloat
        if !chain.editing {
            widthNeeded = "\(chain)".size(pen: ChainView.pen).width + 3
        } else {
            widthNeeded = 3
            var sb: String = ""
            var token: Token
            let to = chain.tokens.count
            
            var i: Int = 0
            while i < to {
                repeat {
                    token = chain.tokens[i]
                    if ChainView.usesWafer(token: token) { break }
                    sb.append(token.display)
                    i += 1
                } while (i < to)
                if sb.count > 0 {
                    widthNeeded += sb.size(pen: ChainView.pen).width
                    sb = ""
                }
                if ChainView.usesWafer(token: token) {
                    widthNeeded += max(9, token.display.size(pen: ChainView.pen).width)+12
                    i += 1
                }
            }
        }
        widthNeeded = Screen.snapToPixel(widthNeeded)
        
        setNeedsDisplay()
        
        guard widthNeeded != oldWidth else { return }
        frame = CGRect(origin: frame.origin, size: CGSize(width: widthNeeded, height: height))
        delegate?.onWidthChanged(oldWidth: oldWidth, newWidth: widthNeeded)
        oldWidth = widthNeeded
    }
    
    func moveCursor(to nx: CGFloat) {
        var x: CGFloat = 3
        var lx: CGFloat = 0
        var pos: Int = 0
        
        for token in chain.tokens {
            x += token.display.size(pen: ChainView.pen).width
            if ChainView.usesWafer(token: token) {x += 9}
            if nx < lx+(x-lx)/2 {break}
            lx = x
            pos += 1
        }
        chain.cursor = pos
        resize()
    }
    
// Chain ===========================================================================================
    func attemptToPost(token: Token) -> Bool {
        guard chain.attemptToPost(token: token) else { return false }
        resize()
        delegate?.onChanged()
        delegate?.onTokenAdded(token)
        return true
    }
    func post(token: Token) {
        _ = attemptToPost(token: token)
    }
    func minusSign() {
        chain.minusSign()
        resize()
        delegate?.onChanged()
    }
    func parenthesis() {
        chain.parenthesis()
        resize()
        delegate?.onChanged()
    }
    func braket() {
        chain.braket()
        resize()
        delegate?.onChanged()
    }
    func delete() {
        guard let token = chain.delete() else { return }
        resize()
        delegate?.onChanged()
        delegate?.onTokenRemoved(token)
    }
       
    @objc func rightDelete() {
        print("rightDelete")
    }
    func edit() {
        chain.edit()
        delegate?.onEditStart()
        isUserInteractionEnabled = true
        resize()
        delegate?.onChanged()
    }
    func ok() {
        isUserInteractionEnabled = false
        chain.ok()
        resize()
        delegate?.onChanged()
    }
    public func okDelegate() {
        delegate?.onEditStop()
    }
    
// UIResponder =====================================================================================
    override var canBecomeFirstResponder: Bool { true }
    override var canResignFirstResponder: Bool { true }
            
// UIView ==========================================================================================
    private func drawTokens(at x: CGFloat, from: Int, to: Int) -> CGFloat {
        var x: CGFloat = x
        var sb: String = ""
        var pos: Int = from
        var token: Token
        while (pos < to) {
            repeat {
                token = chain.tokens[pos]
                if ChainView.usesWafer(token: token) {break}
                sb.append(token.display)
                pos += 1
            } while (pos < to)
            if sb.count > 0 {
                Skin.bubble(text: sb as String, x: x, y: Screen.mac ? 1 : 0, uiColor: delegate?.color ?? UIColor.green)
                x += sb.size(pen: ChainView.pen).width
                sb = ""
            }
            if ChainView.usesWafer(token: token) {
                let uiColor: UIColor = {
                    if token.status != .ok { return UIColor.red }
                    if let token = token as? Defable, let def: Def = token.def { return def.uiColor }
                    return UIColor.green
                }()
                x += Skin.wafer(text: token.display, x: x, y: Screen.mac ? 1 : 0, uiColor: uiColor)
                pos += 1
            }
        }
        return x
    }
    override func draw(_ rect: CGRect) {
        if !chain.editing {
            Skin.bubble(text: "\(chain)", x: 1, y: Screen.mac ? 1 : 0, uiColor: delegate?.color ?? UIColor.green)
        } else {
            let x: CGFloat = drawTokens(at: 1, from: 0, to: chain.cursor)
            // Cursor
            if chain.tokens.count > 0 {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: x+1, y: 1))
                path.addLine(to: CGPoint(x: x+1, y: 20))
                let c = UIGraphicsGetCurrentContext()!
                c.setStrokeColor(Skin.color(.cursor).cgColor)
                c.setLineWidth(2)
                c.addPath(path)
                c.drawPath(using: .stroke)
            }
            
            _ = drawTokens(at: x, from: chain.cursor, to: chain.tokens.count)
        }
    }
    
// AnchorTappable ==================================================================================
    func onAnchorTap(point: CGPoint) {
        guard chain.editing else { return }
        moveCursor(to: point.x)
    }
    
// TowerListener ===================================================================================
    func onTriggered() { resize() }
    
// UITextInput =====================================================================================
    var autocapitalizationType: UITextAutocapitalizationType {
        get { responder!.autocapitalizationType }
        set { responder!.autocapitalizationType = newValue }
    }
    var keyboardAppearance: UIKeyboardAppearance {
        get { responder!.keyboardAppearance }
        set { responder!.keyboardAppearance = newValue }
    }
    var markedTextStyle: [NSAttributedString.Key : Any]? {
        get { responder!.markedTextStyle }
        set { responder!.markedTextStyle = newValue }
    }
    var selectedTextRange: UITextRange? {
        get { responder!.selectedTextRange }
        set { responder!.selectedTextRange = newValue }
    }
    var inputDelegate: UITextInputDelegate? {
        get { responder!.inputDelegate }
        set { responder!.inputDelegate = newValue }
    }
    
    var beginningOfDocument: UITextPosition { responder!.beginningOfDocument }
    var endOfDocument: UITextPosition { responder!.endOfDocument }
    
    func setMarkedText(_ markedText: String?, selectedRange: NSRange) { responder?.setMarkedText(markedText, selectedRange: selectedRange) }
    func unmarkText() { responder!.unmarkText() }
    func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult { responder!.compare(position, to: other) }
    
// Stubbed
    var markedTextRange: UITextRange? { responder!.markedTextRange }
    var tokenizer: UITextInputTokenizer { responder!.tokenizer }

    func text(in range: UITextRange) -> String? { responder!.text(in: range) }
    func replace(_ range: UITextRange, withText text: String) { responder!.replace(range, withText: text) }
    func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? { responder!.textRange(from: fromPosition, to: toPosition) }
    func position(from position: UITextPosition, offset: Int) -> UITextPosition? { responder!.position(from: position, offset: offset) }
    func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? { responder!.position(from: position, in: direction, offset: offset) }
    func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int { responder!.offset(from: from, to: toPosition) }
    func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? { responder!.position(within: range, farthestIn: direction) }
    func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? { responder!.characterRange(byExtending: position, in: direction) }
    func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> NSWritingDirection { responder!.baseWritingDirection(for: position, in: direction) }
    func setBaseWritingDirection(_ writingDirection: NSWritingDirection, for range: UITextRange) { responder!.setBaseWritingDirection(writingDirection, for: range) }
    func firstRect(for range: UITextRange) -> CGRect { responder!.firstRect(for: range) }
    func caretRect(for position: UITextPosition) -> CGRect { responder!.caretRect(for: position) }
    func selectionRects(for range: UITextRange) -> [UITextSelectionRect] { responder!.selectionRects(for: range) }
    func closestPosition(to point: CGPoint) -> UITextPosition? { responder!.closestPosition(to: point) }
    func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? { responder!.closestPosition(to: point, within: range) }
    func characterRange(at point: CGPoint) -> UITextRange? { responder!.characterRange(at: point) }

// UIKeyInput ======================================================================================
    var hasText: Bool { responder!.hasText }
    func insertText(_ text: String) { responder!.insertText(text) }
    func deleteBackward() { responder!.deleteBackward() }
    
    @objc func leftArrow() {
        if chain.leftArrow() { setNeedsDisplay() }
        else { keyDelegate?.onArrowLeft() }
    }
    @objc func rightArrow() {
        if chain.rightArrow() { setNeedsDisplay() }
        else { keyDelegate?.onArrowRight() }
    }
    @objc func backspace() {
        guard let token = chain.backspace() else { return }
        resize()
        delegate?.onChanged()
        delegate?.onTokenRemoved(token)
    }
//    func delete() {
//        guard let token = chain.delete() else { return }
//        render()
//        delegate?.onTokenRemoved(token)
//    }

    @objc func upArrow() { responder!.upArrow() }
    @objc func downArrow() { responder!.downArrow() }
    @objc func tab() { responder!.tab() }

    override var keyCommands: [UIKeyCommand]? {
        let commands: [UIKeyCommand] = [
            UIKeyCommand(action: #selector(rightArrow), input: UIKeyCommand.inputRightArrow),
            UIKeyCommand(action: #selector(leftArrow), input: UIKeyCommand.inputLeftArrow),
            UIKeyCommand(action: #selector(upArrow), input: UIKeyCommand.inputUpArrow),
            UIKeyCommand(action: #selector(downArrow), input: UIKeyCommand.inputDownArrow),
            UIKeyCommand(action: #selector(backspace), input: "\u{8}"),
            UIKeyCommand(action: #selector(tab), input: "\t")
        ]
        if #available(iOS 15, *) { commands.forEach { $0.wantsPriorityOverSystemBehavior = true } }
        return commands
    }

// UITextInputTraits ===============================================================================
    var smartQuotesType: UITextSmartQuotesType {
        get { responder!.smartQuotesType }
        set { responder!.smartQuotesType = newValue }
    }

// Static ==========================================================================================
	private static func usesWafer(token: Token) -> Bool {
		return token.type == .variable
			|| (token.type == .constant && ![Token.pi, Token.e, Token.i].contains(token))
			|| token.status == .deleted
	}
}
