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
    
    func becomeFirstResponder()
    func resignFirstResponder()
    
    func onTokenKeyAdded(_ key: TokenKey)
    func onTokenKeyRemoved(_ key: TokenKey)

    func onChanged()
    func onWidthChanged(oldWidth: CGFloat?, newWidth: CGFloat)

    func onCalculated()
}
extension ChainViewDelegate {
    func onEditStart() {}
    func onEditStop() {}
    
    func onChanged(oldWidth: CGFloat?, newWidth: CGFloat) {}
    
    func onCalculated() {}
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
    unowned let editable: Editable
    unowned let responder: ChainResponder?
    var alwaysShow: Bool = false

    var chain: Chain! {
        didSet {
            guard let key: TokenKey = chain.key
            else { fatalError() }
            Citadel.startListening(to: key, listener: self)
        }
    }
    public private(set) var editing: Bool = false
    public var cursor: Int = 0

    weak var delegate: ChainViewDelegate?
    weak var keyDelegate: ChainViewKeyDelegate?
    
    var oldWidth: CGFloat?
    var oldTokenKeys: [TokenKey]?
    
    static let pen: Pen = Pen(font: .ooAether(size: 16))
    
    init(editable: Editable, responder: ChainResponder?) {
        self.editable = editable
        self.responder = responder
        super.init(frame: .zero)
        
        backgroundColor = UIColor.clear
        
        inputAssistantItem.leadingBarButtonGroups.removeAll()
        inputAssistantItem.trailingBarButtonGroups.removeAll()
    }
    public required init?(coder aDecoder: NSCoder) { fatalError() }
    
// Computed ========================================================================================
    var aetherView: AetherView { editable.aetherView }
    var citadel: Citadel { aetherView.citadel }
    var chainCore: ChainCore { citadel.chainCore(key: chain.key!) }
    
    var blank: Bool { chain.isEmpty && !editing }
    
    var chainDisplay: String {
        alwaysShow || citadel.inAFog(key: chain.key!)
        ? citadel.tokenDisplay(key: chain.key!)
        : citadel.valueDisplay(key: chain.key!) }

    func resize() {
        var widthNeeded: CGFloat
        if !editing {
            widthNeeded = chainDisplay.size(pen: ChainView.pen).width + 3
        } else {
            widthNeeded = 3
            var sb: String = ""
            var token: Token
            var key: TokenKey
            let to = chain.tokenKeys.count
            
            var i: Int = 0
            while i < to {
                repeat {
                    key = chain.tokenKeys[i]
                    token = citadel.anyToken(key: key)
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
        
        chain.tokenKeys.forEach { (key: TokenKey) in
            let token: Token = citadel.anyToken(key: key)
            x += token.display.size(pen: ChainView.pen).width
            if ChainView.usesWafer(token: token) {x += 9}
            if nx < lx+(x-lx)/2 { return }
            lx = x
            pos += 1
        }
        cursor = pos
        triggerKeyboardIfNeeded()
        resize()
    }
    
    private func triggerKeyboardIfNeeded() {
        guard !ChainResponder.hasExternalKeyboard && editing else { return }
        if chain.isInString(at: cursor) { delegate?.becomeFirstResponder() }
        else { delegate?.resignFirstResponder() }
    }
    private func handleKeyRemoved(_ key: TokenKey) {
        triggerKeyboardIfNeeded()
        resize()
        delegate?.onChanged()
        delegate?.onTokenKeyRemoved(key)
    }
    
// Chain ===========================================================================================
    var inString: Bool { chain.isInString(at: cursor) }
    var unmatchedQuote: Bool { chain.unmatchedQuote }
    func attemptToPost(key: TokenKey) -> Bool {
        guard citadel.canBeAdded(thisKey: key, to: chain.key!) else { return false }
        
        chain.post(key: key, at: cursor)
        
        if key.hasTower { citadel.increment(key: chain.key!, dependenceOn: key) }
        
        cursor += 1
        triggerKeyboardIfNeeded()
        resize()
        delegate?.onChanged()
        delegate?.onTokenKeyAdded(key)
        
        return true
    }
    func attemptToPost(token: Token) -> Bool { attemptToPost(key: token.key) }
    func post(key: TokenKey) { _ = attemptToPost(key: key) }
    func post(token: Token) { post(key: token.key) }
    func parenthesis() {
        chain.parenthesis(at: cursor)
        cursor += 1
        resize()
        delegate?.onChanged()
    }
    func braket() {
        chain.braket(at: cursor)
        cursor += 1
        resize()
        delegate?.onChanged()
    }
    func delete() {
        guard let key: TokenKey = chain.delete(at: cursor) else { return }
        if key.hasTower { citadel.decrement(key: chain.key!, dependenceOn:  key)}
        handleKeyRemoved(key)
    }
       
    @objc func rightDelete() { print("rightDelete") }
    func edit() {
        oldTokenKeys = chain.tokenKeys
        editing = true
        cursor = chain.tokenKeys.count
        delegate?.onEditStart()
        isUserInteractionEnabled = true
        resize()
        delegate?.onChanged()
    }
    func ok() {
        resignFirstResponder()
        isUserInteractionEnabled = false
        editing = false
        aetherView.citadel.trigger(key: chain.key!)
        resize()
        delegate?.onChanged()
    }
    func cancel() {
        chain.clear()
        oldTokenKeys?.forEach { chain.post(key: $0) }
        ok()
    }
    
// UIResponder =====================================================================================
    override var canBecomeFirstResponder: Bool { true }
    override var canResignFirstResponder: Bool { true }
            
// UIView ==========================================================================================
    private func drawTokens(at x: CGFloat, from: Int, to: Int) -> CGFloat {
        var x: CGFloat = x
        var sb: String = ""
        var pos: Int = from
        var key: TokenKey
        var token: Token
        while (pos < to) {
            repeat {
                key = chain.tokenKeys[pos]
                token = citadel.anyToken(key: key)
                if ChainView.usesWafer(token: token) { break }
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
                    if let token = token as? TowerToken, token.status != .ok  { return .red }
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
        if !editing {
            Skin.bubble(text: chainDisplay, x: 1, y: Screen.mac ? 1 : 0, uiColor: delegate?.color ?? UIColor.green)
        } else {
            let x: CGFloat = drawTokens(at: 1, from: 0, to: cursor)
            // Cursor
            if chain.tokenKeys.count > 0 {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: x+1, y: 1))
                path.addLine(to: CGPoint(x: x+1, y: 20))
                let c = UIGraphicsGetCurrentContext()!
                c.setStrokeColor(Skin.color(.cursor).cgColor)
                c.setLineWidth(2)
                c.addPath(path)
                c.drawPath(using: .stroke)
            }
            
            _ = drawTokens(at: x, from: cursor, to: chain.tokenKeys.count)
        }
    }
    
// AnchorTappable ==================================================================================
    func onAnchorTap(point: CGPoint) {
        guard editing else { return }
        moveCursor(to: point.x)
    }
    
// TowerListener ===================================================================================
    func onTriggered() {
        resize()
        delegate?.onCalculated()
    }
    
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
        if cursor > 0 {
            cursor -= 1
            setNeedsDisplay()
        } else { keyDelegate?.onArrowLeft() }
    }
    @objc func rightArrow() {
        if cursor < chain.tokenKeys.count {
            cursor += 1
            setNeedsDisplay()
        } else { keyDelegate?.onArrowRight() }
    }
    @objc func backspace() {            // delete left
        guard let key: TokenKey = chain.backspace(at: cursor) else { return }
        if key.hasTower { citadel.decrement(key: chain.key!, dependenceOn:  key)}
        cursor -= 1
        handleKeyRemoved(key)
    }

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
    var autocorrectionType: UITextAutocorrectionType {
        get { .no }
        set { fatalError() }
    }

// Static ==========================================================================================
	private static func usesWafer(token: Token) -> Bool {
        if token.code == .cn && ![Token.pi, Token.e, Token.i].contains(token) { return true }
        guard let token: TowerToken = token as? TowerToken else { return false }
        return token.code == .va || token.code == .cl || token.status == .deleted
	}
}
