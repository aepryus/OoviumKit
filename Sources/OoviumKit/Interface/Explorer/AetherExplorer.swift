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
		}
	}

	unowned let aetherView: AetherView
    public lazy var controller: ExplorerController =  { ExplorerController(explorer: self) }()

	static let backColor: UIColor = UIColor(red: 32/255, green: 34/255, blue: 36/255, alpha: 1)

    lazy var navigator: AetherNavigator = { AetherNavigator(controller: controller, facade: facade) }()
	private let tableView: UITableView = AETableView()

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
	public override func layoutSubviews() {
		tableView.topLeft(dx: 35*s, size: CGSize(width: 295*s, height: height))
	}

// UITableViewDataSource ===========================================================================
	private var facades: [Facade] = []
	private var aetherNames: [String] = []
	private func loadSpace() {
        facade.loadFacades { (facades: [Facade]) in
            DispatchQueue.main.async {
                self.facades = facades
                self.tableView.reloadData()
            }
        }
	}

	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { facades.count }
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: AetherExplorerCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AetherExplorerCell
        cell.bind(explorer: self, facade: facades[indexPath.row])
		return cell
	}

// SpaceDelegate ===================================================================================
	func onChanged(space: Space) {
        /* onChanged is triggered anytime a file is opened or saved which made it was very chatty.  Reloading
         the table each time it was called meant there was a good chance the table was being reloaded while the user was interacting
         with it.  The reload table was reversing the order of the cells and if a user clicked on a cell, the facade
         for that cell could be shifted in between mouse down and mouse up.
         
         The fingerprinting doesn't really fix that issue, but greatly reduces the number of table reloads, there by greatly
         reducing the chance of it happening.  Needlessly reloading the table is something that needed to be fixed regardless,
         but it still would be nice to fix the underlying problem, but at the moment no good solutions are apparent.
         */
        let current: String = Facade.fingerprint(facades: self.facades)
        DispatchQueue.main.async {
            self.facade.loadFacades { (facades: [Facade]) in
                let update: String = Facade.fingerprint(facades: facades)
                guard update != current else { return }
                DispatchQueue.main.async {
                    self.facades = facades
                    self.tableView.reloadData()
                }
            }
        }
	}
}
