//
//  AlsoEditor.swift
//  Oovium
//
//  Created by Joe Charlier on 4/20/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

class AlsoEditor: Orbit, UITableViewDataSource {
	let tableView: UITableView = AETableView()
	let otherView: UIView = UIView()
	
	var alsoLeaf: AlsoLeaf {
		return editable as! AlsoLeaf
	}

	init() {
		super.init(size: CGSize(width: 180, height: 220))
//		super.init(anchor: .bottomRight,offset: UIOffset.zero, size: CGSize(width: 180, height: 220), fixedOffset: UIOffset(horizontal: 0, vertical: 0))

		tableView.backgroundColor = .clear
		tableView.dataSource = self
		tableView.register(AlsoCell.self, forCellReuseIdentifier: "cell")
		tableView.rowHeight = 26*Oo.s
		tableView.contentInset = UIEdgeInsets(top: 2*Oo.s, left: 0, bottom: 2*Oo.s, right: 0)
		tableView.showsVerticalScrollIndicator = false
		addSubview(tableView)
		
		let schematic = Schematic(rows: 1, cols: 3)

		schematic.add(row: 0, col: 0, key: Key(text: "Open".localized, uiColor: UIColor(red: 0.8, green: 1, blue: 0.8, alpha: 1).shade(0.5), { [unowned self] in
			guard let (space, aether) = self.alsoLeaf.alsoBub.also.spaceAether else { return }
			self.alsoLeaf.aetherView.swapToAether(space: space, aether: aether)
		}))
		schematic.add(row: 0, col: 1, w: 2, h: 1, key: Key(text: "OK".localized, uiColor: UIColor(red: 0.8, green: 1, blue: 0.8, alpha: 1), { [unowned self] in
			self.alsoLeaf.releaseFocus()
		}))
		
		schematic.render(rect: CGRect(x: 0, y: 0, width: width, height: 53*Oo.s))
		schematic.keySlots.forEach {otherView.addSubview($0.key)}
		
		otherView.backgroundColor = .clear
		addSubview(otherView)
	}
	required init?(coder aDecoder: NSCoder) {fatalError()}
	
	var aetherNames: [String] {

		var aetherNames: [String] = []
		Space.local.loadNames { (names: [String]) in
			aetherNames = names
		}
		alsoLeaf.aetherView.aether.aethers.forEach { aetherNames.remove(object: $0.name) }
		return aetherNames
	}
	
// Events ==========================================================================================
	override func onInvoke() {
		tableView.reloadData()
	}
	
// UIView ==========================================================================================
	override func layoutSubviews() {
		let p: CGFloat = 4*Oo.s
		tableView.frame = CGRect(x: p, y: p+2*Oo.s, width: width-2*p, height: height-47*Oo.s-3*p-2*Oo.s-2*2*Oo.s)
		otherView.top(dy: tableView.bottom+5*Oo.s, width: width, height: 47*Oo.s)
	}
	override func draw(_ rect: CGRect) {
		let p: CGFloat = 4*Oo.s
		Skin.bubble(path: CGPath(roundedRect: CGRect(x: p, y: p, width: width-2*p, height: height-47*Oo.s-3*p-2*Oo.s), cornerWidth: 5*Oo.s, cornerHeight: 5*Oo.s, transform: nil), uiColor: UIColor.orange, width: 2*Oo.s)
		Skin.bubble(path: CGPath(roundedRect: CGRect(x: p, y: height-47*Oo.s-p, width: width-2*p, height: 47*Oo.s), cornerWidth: 5*Oo.s, cornerHeight: 5*Oo.s, transform: nil), uiColor: UIColor.orange, width: 2*Oo.s)
	}
	
// UITableViewDataSource ===========================================================================
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return aetherNames.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: AlsoCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AlsoCell
		cell.alsoEditor = self
		cell.aetherName = aetherNames[indexPath.row]
		return cell
	}
}
