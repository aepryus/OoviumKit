//
//  TextCell.swift
//  Oovium
//
//  Created by Joe Charlier on 2/5/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class EdgeCell: UITableViewCell {
	var edge: Edge? = nil {
		didSet {setNeedsDisplay()}
	}
	var input: Bool = false
	weak var aetherView: AetherView? = nil
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		backgroundColor = UIColor.clear
		
		let gesture = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe))
		addGestureRecognizer(gesture)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
// Events ==========================================================================================
	@objc func onSwipe() {
		guard let aetherView = aetherView, let edge = edge else { return }
		let to: TextLeaf = (aetherView.bubble(aexel: edge.text) as! TextBub).textLeaf
		let from: TextLeaf = (aetherView.bubble(aexel: edge.other) as! TextBub).textLeaf
		to.unlinkTo(other: from)
	}
	
// UIView ==========================================================================================
	override func draw(_ rect: CGRect) {
		guard let edge = edge else { return }
		let text = input ? edge.other : edge.text
		let p: CGFloat = 4*Oo.s
		let path = CGPath(roundedRect: CGRect(x: p, y: p, width: rect.width-2*p, height: rect.height-p), cornerWidth: 3*Oo.s, cornerHeight: 3*Oo.s, transform: nil)
		Skin.key(path: path, uiColor: text.color.uiColor)
		Skin.key(text: text.name, rect: rect, font: UIFont(name: "HelveticaNeue", size: 12*Oo.s)!)
	}
}
