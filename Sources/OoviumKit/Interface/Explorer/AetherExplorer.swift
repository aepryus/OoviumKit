//
//  AetherExplorer.swift
//  Oovium
//
//  Created by Joe Charlier on 3/27/21.
//  Copyright © 2021 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

public class AetherExplorer: UIView, UITableViewDataSource, SpaceDelegate {
	public var space: Space = Space.local {
		didSet {
			tableView.setContentOffset(.zero, animated: false)
			navigator.transform = .identity
			navigator.space = space
			navigator.transform = CGAffineTransform(rotationAngle: -.pi/2)
			navigator.topLeft(width: 32*s, height: navigator.width)
			space.delegate = self
			loadSpace()
			tableView.reloadData()
		}
	}

	unowned let aetherView: AetherView
    private lazy var controller: ExplorerController = { ExplorerController(aetherExplorer: self) }()

	static let backColor: UIColor = UIColor(red: 32/255, green: 34/255, blue: 36/255, alpha: 1)

	lazy var navigator: AetherNavigator = { AetherNavigator(explorer: self) }()
	let tableView: UITableView = AETableView()

	let lw: CGFloat = 2*Screen.s

	init(aetherView: AetherView) {
		self.aetherView = aetherView
		
		super.init(frame: .zero)

		navigator.transform = CGAffineTransform(rotationAngle: -.pi/2)
		addSubview(navigator)
		navigator.topLeft(width: 32*s, height: navigator.width)

		tableView.backgroundColor = UIColor.green.shade(0.9)
		tableView.dataSource = self
		tableView.register(AetherExplorerCell.self, forCellReuseIdentifier: "cell")
		tableView.rowHeight = 36*s
		tableView.showsVerticalScrollIndicator = false
		tableView.delaysContentTouches = false
		tableView.layer.borderWidth = lw
		tableView.layer.borderColor = UIColor.green.tint(0.8).cgColor
		tableView.layer.cornerRadius = 6*s
		addSubview(tableView)

		if Screen.mac {
			let gesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
			tableView.addGestureRecognizer(gesture)
		}
	}
	required init?(coder: NSCoder) { fatalError() }

// Events ==========================================================================================
	private var s0: CGPoint = .zero
	@objc func onPan(_ gesture: UIPanGestureRecognizer) {
		let ds: CGPoint = gesture.translation(in: tableView)
		switch gesture.state {
			case .began:
				s0 = tableView.contentOffset
			case .changed:
				tableView.contentOffset = CGPoint(x: 0, y: max(0, min(tableView.contentSize.height-tableView.height, (s0-ds).y)))
			default: break
		}
	}

// UIView ==========================================================================================
	override public func layoutSubviews() {
		tableView.topLeft(dx: 35*s, size: CGSize(width: 295*s, height: height))
	}

// UITableViewDataSource ===========================================================================
	var spaces: [Space] = []
	var aetherNames: [String] = []
	func loadSpace() {
		let group = DispatchGroup()
		group.enter()
		space.loadSpaces { (spaces: [Space]) in
			self.spaces = spaces
			group.leave()
		}
		group.enter()
		space.loadNames { (names: [String]) in
			self.aetherNames = names
			group.leave()
		}
		let semaphore = DispatchSemaphore(value: 1)
		group.notify(queue: .main) {
			semaphore.signal()
		}
		semaphore.wait()
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		spaces.count + aetherNames.count
	}
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: AetherExplorerCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AetherExplorerCell
		if indexPath.row < spaces.count {
			cell.bind(explorer: self, space: spaces[indexPath.row])
		} else {
			cell.bind(explorer: self, name: aetherNames[indexPath.row - spaces.count])
		}
		return cell
	}

// SpaceDelegate ===================================================================================
	func onChanged(space: Space) {
		DispatchQueue.main.async { self.tableView.reloadData() }
	}
}
