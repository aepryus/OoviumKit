//
//  AetherExplorerCell.swift
//  Oovium
//
//  Created by Joe Charlier on 3/28/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class AetherExplorerCell: UITableViewCell {
	unowned var explorer: AetherExplorer!
	var name: String = "" {
		didSet { label.text = name }
	}
	var space: Space? = nil

	let label: UILabel = UILabel()
	let line: UIView = UIView()

	static let pen: Pen = Pen(font: UIFont(name: "ChicagoFLF", size: 18*Screen.s)!, color: UIColor.green.tint(0.7))
	static let highlightPen: Pen = pen.clone(color: UIColor.green.tint(0.9))

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)

		backgroundColor = UIColor.green.shade(0.9)

		line.backgroundColor = UIColor.green.shade(0.8)
		addSubview(line)

		label.pen = AetherExplorerCell.pen
		addSubview(label)

		addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTap)))

		let gesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap))
		gesture.numberOfTapsRequired = 2
		addGestureRecognizer(gesture)
	}
	required init?(coder: NSCoder) { fatalError() }

	func bind(explorer: AetherExplorer, name: String) {
		self.explorer = explorer
		self.name = name
		self.space = nil
	}
	func bind(explorer: AetherExplorer, space: Space) {
		self.explorer = explorer
		self.name = "\(space.name)/"
		self.space = space
	}

	func touch() {
		label.pen = AetherExplorerCell.highlightPen
		backgroundColor = UIColor.green.shade(0.9)
	}
	func untouch() {
		label.pen = AetherExplorerCell.pen
		backgroundColor = UIColor.green.shade(0.9)
	}

// Events ==========================================================================================
	@objc func onTap() {
		if let space = space {
			explorer.space = space
		} else {
			Space.digest(space: explorer.space, name: name) { (aether: Aether?) in
				guard let aether = aether else { return }
				DispatchQueue.main.async {
					self.explorer.aetherView.swapToAether(space: self.explorer.space, aether: aether)
					if Screen.iPhone { self.explorer.aetherView.slideBack() }
				}
			}
		}
	}
	@objc func onDoubleTap() {
		guard space == nil else { return }
		Space.digest(space: explorer.space, name: name) { (aether: Aether?) in
			guard let aether = aether else { return }
			self.explorer.aetherView.swapToAether(space: self.explorer.space, aether: aether)
			self.explorer.aetherView.slideBack()
		}
	}

// UIView ==========================================================================================
	override func layoutSubviews() {
		label.left(dx: 16*s, width: 200*s, height: 30*s)
		line.bottom(width: width, height: 1*s)
	}
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		touch()
	}
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesEnded(touches, with: event)
		untouch()
	}
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesCancelled(touches, with: event)
		untouch()
	}
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesMoved(touches, with: event)
	}
}
