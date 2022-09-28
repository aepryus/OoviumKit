//
//  EdgesView.swift
//  Oovium
//
//  Created by Joe Charlier on 2/5/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit


class EdgesView: UITableView, UITableViewDelegate, UITableViewDataSource {
	var textBub: TextBub? = nil {
		didSet {
			reloadData()
			
		}
	}
	let input: Bool
	
	init(input: Bool) {
		self.input = input
		super.init(frame: CGRect.zero, style: .plain)
		
		backgroundColor = UIColor.clear
		
		delegate = self
		dataSource = self
		register(EdgeCell.self, forCellReuseIdentifier: "cell")
		separatorStyle = .none
		allowsSelection = false
		rowHeight = 26*Oo.s
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
// UITableViewDelegate =============================================================================
	
// UITableViewDataSource ===========================================================================
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		guard let textBub = textBub else {return 0}
		return input ? textBub.text.edges.count : textBub.text.outputEdges.count
	}
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let textBub = textBub else { fatalError() }
		let cell: EdgeCell = tableView.dequeueReusableCell(withIdentifier: "cell")! as! EdgeCell
		cell.edge = input ? textBub.text.edges[indexPath.row] : textBub.text.outputEdges[indexPath.row]
		cell.input = input
		cell.aetherView = textBub.aetherView
		return cell
	}
}
