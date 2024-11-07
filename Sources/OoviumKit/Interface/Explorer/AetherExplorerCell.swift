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
	private var facade: Facade? = nil

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

	func bind(explorer: AetherExplorer, facade: Facade) {
		self.explorer = explorer
        self.facade = facade
        label.text = facade.description
    }

	func touch() {
		label.pen = AetherExplorerCell.highlightPen
		backgroundColor = UIColor.green.shade(0.9)
	}
	func untouch() {
		label.pen = AetherExplorerCell.pen
		backgroundColor = UIColor.green.shade(0.9)
	}
    
    private func digest(facade: AetherFacade) {
        guard facade !== explorer.aetherView.facade else { return }
        do {
            try facade.load { (json: String?) in
                guard let json else { return }
                let aether: Aether = Aether(json: json)
                DispatchQueue.main.async {
                    self.explorer.aetherView.swapToAether(facade: facade, aether: aether)
                    if Screen.iPhone { self.explorer.aetherView.slideBack() }
                }
            }
        } catch AetherLoadingError.fromNewerVersion(currentVersion: let currentVersion, fileVersion: let fileVersion) {
            AlertModal(message: "Aether [\(facade.name)] was saved using the newer v\(fileVersion) version of the Oovium engine.  Please upgrade the current v\(currentVersion) version of Oovium to open it.", right: "OK".localized).invoke()
        } catch {
            AlertModal(message: "Aether [\(facade.name)] not found.", right: "OK".localized).invoke()
        }
    }

// Events ==========================================================================================
	@objc func onTap() {
        if let facade: DirFacade = facade as? DirFacade { explorer.facade = facade }
        else if let facade: AetherFacade = facade as? AetherFacade { digest(facade: facade) }
	}
	@objc func onDoubleTap() {
        guard let facade: AetherFacade = facade as? AetherFacade else { return }
        digest(facade: facade)
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
