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
    public var facade: DirFacade = Facade.create(space: Space.local) as! SpaceFacade {
		didSet {
			tableView.setContentOffset(.zero, animated: false)
			navigator.transform = .identity
			navigator.facade = facade
			navigator.transform = CGAffineTransform(rotationAngle: -.pi/2)
			navigator.topLeft(width: 32*s, height: navigator.width)
            facade.space.delegate = self
			loadSpace()
			tableView.reloadData()
		}
	}

	unowned let aetherView: AetherView
    public lazy var controller: ExplorerController =  { ExplorerController(explorer: self) }()

	static let backColor: UIColor = UIColor(red: 32/255, green: 34/255, blue: 36/255, alpha: 1)

    lazy var navigator: AetherNavigator = { AetherNavigator(controller: controller, facade: facade) }()
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
    
    func setNavigator() {
    }

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
	var facades: [Facade] = []
	var aetherNames: [String] = []
	func loadSpace() {
        facade.loadFacades { (facades: [Facade]) in
            self.facades = facades
        }
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        facades.count
	}
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: AetherExplorerCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AetherExplorerCell
        cell.bind(explorer: self, facade: facades[indexPath.row])
		return cell
	}

// SpaceDelegate ===================================================================================
	func onChanged(space: Space) {
		DispatchQueue.main.async {
            self.facade.loadFacades { (facades: [Facade]) in
                self.facades = facades
                self.tableView.reloadData()
            }
        }
	}
}
