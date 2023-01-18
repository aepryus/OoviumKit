//
//  AnainResponder.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/13/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import Acheron
import GameController
import OoviumEngine
import UIKit

fileprivate class AnainPosition: UITextPosition {
    let position: Int
    
    init(_ position: Int) {
        self.position = position
    }
    
    static let zero = AnainPosition(0)
}
fileprivate class AnainRange: UITextRange {
    let range: NSRange
    
    init(_ range: NSRange) {
        self.range = range
    }
    
    override var start: UITextPosition { AnainPosition(range.location) }
    override var end: UITextPosition { AnainPosition(range.location + range.length) }
    override var isEmpty: Bool { range.length == 0 }
    
    static let zero = AnainRange(NSRange(location: 0, length: 0))
}

public class AnainResponder {
    let aetherView: AetherView
    weak var anainView: AnainView?
    
    init(aetherView: AetherView) {
        self.aetherView = aetherView
    }
    
    var isResponder: Bool { Screen.mac || ChainResponder.hasExternalKeyboard }
    
    func leftArrow() { anainView?.leftArrow() }
    func rightArrow() { anainView?.rightArrow() }
    func upArrow() { anainView?.keyDelegate?.onArrowUp() }
    func downArrow() { anainView?.keyDelegate?.onArrowDown() }
    func tab() { anainView?.keyDelegate?.onTab() }
    func backspace() { anainView?.backspace() }
    
// UITextInput =====================================================================================
    var autocapitalizationType: UITextAutocapitalizationType {
        get { .none }
        set { fatalError() }
    }
    var keyboardAppearance: UIKeyboardAppearance {
        get { .dark }
        set { fatalError() }
    }
    var beginningOfDocument: UITextPosition { AnainPosition.zero }
    var endOfDocument: UITextPosition {
        guard let anainView else { return AnainPosition.zero }
        return AnainPosition(anainView.anain.tokens.count)
    }
    
    private var markedText: String? = nil
    func setMarkedText(_ markedText: String?, selectedRange: NSRange) {
        guard let anainView else { return }
        defer {
            self.markedText = markedText
            let markedCount: Int = markedText?.count ?? 0
            markedTextRange = AnainRange(NSRange(location: anainView.anain.cursor - markedCount, length: markedCount))
        }
        guard markedText?.count != 0 || self.markedText?.count != 1 else {
            anainView.backspace()
            return
        }
        for _ in 0..<(self.markedText?.count ?? 0) {
            _ = anainView.anain.backspace()
        }
        guard let markedText = markedText else { return }
        for c in markedText {
            var token: Token? = nil
            if c == "\n" && anainView.anain.inString && anainView.anain.unmatchedQuote {
                token = Token.quote
            } else if anainView.anain.inString {
                token = Token.characterToken(tag: "\(c)")
            }
            if let token { _ = anainView.attemptToPost(token: token) }
        }
    }
    func unmarkText() { markedText = nil }
    func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult {
        let a: Int = (position as! AnainPosition).position
        let b: Int = (other as! AnainPosition).position
        if a == b {return .orderedSame}
        return a < b ? .orderedAscending : .orderedDescending
    }

    // Stubbed
    var inputDelegate: UITextInputDelegate?
    var selectedTextRange: UITextRange?
    var markedTextRange: UITextRange?
    var markedTextStyle: [NSAttributedString.Key : Any]?
    var tokenizer: UITextInputTokenizer = UITextInputStringTokenizer()

    func text(in range: UITextRange) -> String? { markedText }
    func replace(_ range: UITextRange, withText text: String) {}
    func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? { nil }
    func position(from position: UITextPosition, offset: Int) -> UITextPosition? { nil }
    func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? { nil }
    func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int { 0 }
    func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? { nil }
    func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? { nil }
    func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> NSWritingDirection { .rightToLeft }
    func setBaseWritingDirection(_ writingDirection: NSWritingDirection, for range: UITextRange) {}
    func firstRect(for range: UITextRange) -> CGRect { .zero }
    func caretRect(for position: UITextPosition) -> CGRect { .zero }
    func selectionRects(for range: UITextRange) -> [UITextSelectionRect] { [] }
    func closestPosition(to point: CGPoint) -> UITextPosition? { nil }
    func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? { nil }
    func characterRange(at point: CGPoint) -> UITextRange? { nil }

// UIKeyInput ======================================================================================
    public static var hasExternalKeyboard: Bool { GCKeyboard.coalesced != nil }
    private static func isNumeric(c: Character) -> Bool {
        c >= "0" && c <= "9" || c == "."
    }
    private static func isOperator(c: Character) -> Bool {
        c == "+" || c == "-" || c == "*" || c == "/" || c == "^" || c == "=" || c == "<" || c == ">"
    }
    private static func isSeparator(c: Character) -> Bool {
        c == "(" || c == "," || c == ")" || c == "[" || c == "]" || c == "\""
    }
    private static func convert(s: String) -> String {
        if s == "-" {return "\u{2212}"}
        else if s == "*" {return "\u{00D7}"}
        else if s == "/" {return "\u{00F7}"}
        else {return s}
    }

    var hasText: Bool { true }
    func insertText(_ text: String) {
        guard let anainView else { return }
        var token: Token? = nil
        
        if text == "\n" && anainView.anain.inString && anainView.anain.unmatchedQuote {
            token = Token.quote
        } else if AnainResponder.isSeparator(c: text[0]) {                    // External Keyboard
            token = Token.separatorToken(tag: text)
        } else if text == "\n" || text == "\t" {                        // External Keyboard
            anainView.editable.releaseFocus(.okEqualReturn)
            return
        } else if anainView.anain.inString {
            token = Token.characterToken(tag: text)
        } else if AnainResponder.isNumeric(c: text[0]) {                        // External Keyboard
            token = Token.digitToken(tag: text)
        } else if text == "-" {
            anainView.minusSign()
            return
        } else if AnainResponder.isOperator(c: text[0]) {                    // External Keyboard
            token = Token.operatorToken(tag: AnainResponder.convert(s: text))
        } else if text == "|" {
            token = Token.or
        } else if text == "&" {
            token = Token.and
        } else {
            _ = anainView.attemptToPost(token: Token.quote)
            token = Token.characterToken(tag: text)
        }
        if let token = token {
            _ = anainView.attemptToPost(token: token)
        } else {
            print("[ \(text) ] has no token")
        }
    }
    func deleteBackward() {
        guard let anainView else { return }
        if ChainResponder.hasExternalKeyboard {
            // actual backspace handled by key commands below; this now only triggers on (forward) delete
            anainView.delete()
        } else {
            // unless virtual keyboard
            anainView.backspace()
        }
    }

// UITextInputTraits ===============================================================================
    var smartQuotesType: UITextSmartQuotesType = .no
}
