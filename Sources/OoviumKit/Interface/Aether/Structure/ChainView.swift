//
//  ChainView.swift
//  Oovium
//
//  Created by Joe Charlier on 4/10/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import GameController
import OoviumEngine
import UIKit

protocol ChainViewDelegate: AnyObject {
	var color: UIColor {get}
	
	func onChange()
	func onEdit()
	func onOK()
	func onBackspace(token: Token)
	func onUp()
	func onDown()
	func onLeft()
	func onRight()
	func onTab()
}
extension ChainViewDelegate {
	func onLeft() {}
	func onRight() {}
	func onUp() {}
	func onDown() {}
	func onTab() {}
}

fileprivate class ChainPosition: UITextPosition {
	let position: Int
	
	init(_ position: Int) {
		self.position = position
	}
	
	static let zero = ChainPosition(0)
}
fileprivate class ChainRange: UITextRange {
	let range: NSRange
	
	init(_ range: NSRange) {
		self.range = range
	}
	
	override var start: UITextPosition {
		return ChainPosition(range.location)
	}
    override var end: UITextPosition {
		return ChainPosition(range.location + range.length)
	}
	override var isEmpty: Bool {
		return range.length == 0
	}
	
	static let zero = ChainRange(NSRange(location: 0, length: 0))
}

class ChainView: UIView, UITextInput, UITextInputTraits, AnchorTappable {
	var chain: Chain = Chain()
	weak var delegate: ChainViewDelegate?
	var hitch: Position? = nil
	var at: CGPoint
	
	init() {
		at = CGPoint(x: 12.75, y: 7)
		
		super.init(frame: CGRect.zero)
		
		backgroundColor = UIColor.clear

		inputAssistantItem.leadingBarButtonGroups.removeAll()
		inputAssistantItem.trailingBarButtonGroups.removeAll()
	}
	public required init?(coder aDecoder: NSCoder) {fatalError()}
	
	var blank: Bool {
		return chain.tokens.count == 0 && !chain.editing
	}

	static func calcWidth(chain: Chain) -> CGFloat {
		let pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!)
		var x: CGFloat = 0

		if !chain.editing {
			x = ("\(chain)" as NSString).size(withAttributes: pen.attributes).width + 3
			
		} else {
			let sb = NSMutableString()
			var token: Token
			let to = chain.tokens.count
			
			var i: Int = 0
			while i < to {
				repeat {
					token = chain.tokens[i]
					if ChainView.usesWafer(token: token) {break}
					sb.append(token.display)
					i += 1
				} while (i < to)
				if sb.length > 0 {
					x += sb.size(withAttributes: pen.attributes).width
					sb.setString("")
				}
				if ChainView.usesWafer(token: token) {
					x += max(9, (token.display as NSString).size(withAttributes: pen.attributes).width)+12
					i += 1
				}
			}
			x += 3
		}
		
		return ceil(x/0.5) * 0.5
	}
	func calcWidth() -> CGFloat {
		return ChainView.calcWidth(chain: chain)
	}
	func moveCursor(to nx: CGFloat) {
		var x: CGFloat = 3
		var lx: CGFloat = 0
		var pos: Int = 0
		let pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!)
		
		for token in chain.tokens {
			x += (token.display as NSString).size(withAttributes: pen.attributes).width
			if ChainView.usesWafer(token: token) {x += 9}
			if nx < lx+(x-lx)/2 {break}
			lx = x
			pos += 1
		}
		chain.cursor = pos
		setNeedsDisplay()
	}
	
	func render() {
		guard let hitch = hitch else {return}
		let width = calcWidth()
		let height: CGFloat = 21
		switch hitch {
			case .topLeft:	frame = CGRect(origin: at, size: CGSize(width: width, height: height))
			case .topRight:	frame = CGRect(x: at.x-width, y: at.y, width: width, height: height)
			case .top:		frame = CGRect(x: at.x-width/2, y: at.y, width: width, height: height)
			case .center:	frame = CGRect(x: at.x-width/2, y: at.y-height/2, width: width, height: height)
			default: fatalError()
		}
		if !(Screen.mac || ChainView.hasExternalKeyboard) && chain.editing {
			if chain.inString {
				becomeFirstResponder()
			} else {
				resignFirstResponder()
			}
		}
		setNeedsDisplay()
	}
	
// Chain ===========================================================================================
	func attemptToPost(token: Token) -> Bool {
		guard chain.attemptToPost(token: token) else {return false}
//		render()
		delegate?.onChange()
		return true
	}
	func post(token: Token) {
		chain.post(token: token)
		render()
		delegate?.onChange()
	}
	func minusSign() {
		chain.minusSign()
		render()
		delegate?.onChange()
	}
	func parenthesis() {
		chain.parenthesis()
		render()
		delegate?.onChange()
	}
	func braket() {
		chain.braket()
		render()
		delegate?.onChange()
	}
	@objc func backspace() {
		guard let token = chain.backspace() else { return }
		render()
		delegate?.onBackspace(token: token)
	}
	func delete() {
		guard let token = chain.delete() else { return }
		render()
		delegate?.onBackspace(token: token)
	}
	@objc func leftArrow() {
		if chain.leftArrow() { render() }
		else { delegate?.onLeft() }
	}
	@objc func rightArrow() {
		if chain.rightArrow() { render() }
		else { delegate?.onRight() }
	}
	@objc func upArrow() { delegate?.onUp() }
	@objc func downArrow() { delegate?.onDown() }
	@objc func tab() { delegate?.onTab() }
	@objc func rightDelete() {
		print("rightDelete")
	}
	func edit() {
		chain.edit()
		render()
		delegate?.onEdit()
		isUserInteractionEnabled = true
		if Screen.mac || ChainView.hasExternalKeyboard { becomeFirstResponder() }
	}
	func ok() {
		resignFirstResponder()
		isUserInteractionEnabled = false
		chain.ok()
		render()
	}
	func okDelegate() {
		delegate?.onOK()
	}

// UIView ==========================================================================================
	private func drawTokens(at x: CGFloat, from: Int, to: Int) -> CGFloat {
		var x: CGFloat = x
		let sb = NSMutableString()
		var pos: Int = from
		var token: Token
		while (pos < to) {
			repeat {
				token = chain.tokens[pos]
				if ChainView.usesWafer(token: token) {break}
				sb.append(token.display)
				pos += 1
			} while (pos < to)
			if sb.length > 0 {
				Skin.bubble(text: sb as String, x: x, y: Screen.mac ? 1 : 0, uiColor: delegate?.color ?? UIColor.green)
				let pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!)
				x += sb.size(withAttributes: pen.attributes).width
				sb.setString("")
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
				c.setStrokeColor(UIColor.white.cgColor)
				c.setLineWidth(2)
				c.addPath(path)
				c.drawPath(using: .stroke)
			}

			_ = drawTokens(at: x, from: chain.cursor, to: chain.tokens.count)
		}
	}
	
// UIResponder =====================================================================================
	override var canBecomeFirstResponder: Bool { true }
	override var canResignFirstResponder: Bool { true }
	
// UITextInput =====================================================================================
	var autocapitalizationType: UITextAutocapitalizationType {
		get {return .none}
		set {fatalError()}
	}
	var keyboardAppearance: UIKeyboardAppearance {
		get {return .dark}
		set {fatalError()}
	}
	var beginningOfDocument: UITextPosition {
		return ChainPosition.zero
	}
	var endOfDocument: UITextPosition {
		return ChainPosition(chain.tokens.count)
	}
	
	private var markedText: String? = nil
	func setMarkedText(_ markedText: String?, selectedRange: NSRange) {
		defer {
			self.markedText = markedText
			let markedCount: Int = markedText?.count ?? 0
			markedTextRange = ChainRange(NSRange(location: chain.cursor - markedCount, length: markedCount))
		}
		guard markedText?.count != 0 || self.markedText?.count != 1 else {
			backspace()
			return
		}
		for _ in 0..<(self.markedText?.count ?? 0) {
			_ = chain.backspace()
		}
		guard let markedText = markedText else {return}
		for c in markedText {
			var token: Token? = nil
			if c == "\n" && chain.inString && chain.unmatchedQuote {
				token = Token.quote
			} else if chain.inString {
				token = Token.characterToken(tag: "\(c)")
			}
			_ = attemptToPost(token: token!)
		}
	}
	func unmarkText() {
		self.markedText = nil
	}
	func compare(_ position: UITextPosition, to other: UITextPosition) -> ComparisonResult {
		let a: Int = (position as! ChainPosition).position
		let b: Int = (other as! ChainPosition).position
		if a == b {return .orderedSame}
		return a < b ? .orderedAscending : .orderedDescending
	}

	// Stubbed
	var inputDelegate: UITextInputDelegate?
	var selectedTextRange: UITextRange?
	var markedTextRange: UITextRange?
	var markedTextStyle: [NSAttributedString.Key : Any]?
	var tokenizer: UITextInputTokenizer = UITextInputStringTokenizer()

	func text(in range: UITextRange) -> String? {
		return markedText
	}
	func replace(_ range: UITextRange, withText text: String) {}
	func textRange(from fromPosition: UITextPosition, to toPosition: UITextPosition) -> UITextRange? {
		return nil
	}
	func position(from position: UITextPosition, offset: Int) -> UITextPosition? {
		return nil
	}
	func position(from position: UITextPosition, in direction: UITextLayoutDirection, offset: Int) -> UITextPosition? {
		return nil
	}
	func offset(from: UITextPosition, to toPosition: UITextPosition) -> Int {
		return 0
	}
	func position(within range: UITextRange, farthestIn direction: UITextLayoutDirection) -> UITextPosition? {
		return nil
	}
	func characterRange(byExtending position: UITextPosition, in direction: UITextLayoutDirection) -> UITextRange? {
		return nil
	}
	func baseWritingDirection(for position: UITextPosition, in direction: UITextStorageDirection) -> NSWritingDirection {
		return .rightToLeft
	}
	func setBaseWritingDirection(_ writingDirection: NSWritingDirection, for range: UITextRange) {}
	func firstRect(for range: UITextRange) -> CGRect {
		return CGRect.zero
	}
	func caretRect(for position: UITextPosition) -> CGRect {
		return CGRect.zero
	}
	func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
		return []
	}
	func closestPosition(to point: CGPoint) -> UITextPosition? {
		return nil
	}
	func closestPosition(to point: CGPoint, within range: UITextRange) -> UITextPosition? {
		return nil
	}
	func characterRange(at point: CGPoint) -> UITextRange? {
		return nil
	}

// UIKeyInput ======================================================================================
	private static func isNumeric(c: Character) -> Bool {
		return c >= "0" && c <= "9" || c == "."
	}
	private static func isOperator(c: Character) -> Bool {
		return c == "+" || c == "-" || c == "*" || c == "/" || c == "^" || c == "=" || c == "<" || c == ">"
	}
	private static func isSeparator(c: Character) -> Bool {
		return c == "(" || c == "," || c == ")" || c == "[" || c == "]" || c == "\""
	}
	private static func convert(s: String) -> String {
		if s == "-" {return "\u{2212}"}
		else if s == "*" {return "\u{00D7}"}
		else if s == "/" {return "\u{00F7}"}
		else {return s}
	}

	var hasText: Bool {
		return true
	}
	func insertText(_ text: String) {
		var token: Token? = nil
		
		if text == "\n" && chain.inString && chain.unmatchedQuote {
			token = Token.quote
		} else if ChainView.isSeparator(c: text[0]) {					// External Keyboard
			token = Token.separatorToken(tag: text)
		} else if text == "\n" || text == "\t" {						// External Keyboard
			okDelegate()
			return
		} else if chain.inString {
			token = Token.characterToken(tag: text)
		} else if ChainView.isNumeric(c: text[0]) {						// External Keyboard
			token = Token.digitToken(tag: text)
		} else if text == "-" {
			minusSign()
			return
		} else if ChainView.isOperator(c: text[0]) {					// External Keyboard
			token = Token.operatorToken(tag: ChainView.convert(s: text))
		} else if text == "|" {
			token = Token.or
		} else if text == "&" {
			token = Token.and
		}
		if let token = token {
			_ = attemptToPost(token: token)
		} else {
			print("[ \(text) ] has no token")
		}
	}
	func deleteBackward() {
		if ChainView.hasExternalKeyboard {
			// actual backspace handled by key commands below; this now only triggers on (forward) delete
			delete()
		} else {
			// unless virtual keyboard
			backspace()
		}
	}
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
	var smartQuotesType: UITextSmartQuotesType = .no

// AnchorTappable ==================================================================================
	func onAnchorTap(point: CGPoint) {
		guard chain.editing else {return}
		moveCursor(to: point.x)
	}

// Static ==========================================================================================
	private static var hasExternalKeyboard: Bool {
		if #available(iOS 14.0, *) {
			return GCKeyboard.coalesced != nil
		} else {
			return false
		}
	}
	private static func usesWafer(token: Token) -> Bool {
		return token.type == .variable
			|| (token.type == .constant && ![Token.pi, Token.e, Token.i].contains(token))
			|| token.status == .deleted
	}
}
