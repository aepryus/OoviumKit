//
//  BubbleToolBar.swift
//  Oovium
//
//  Created by Joe Charlier on 8/4/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

class BubbleToolBar: ToolBar {
	
	init(aetherView: AetherView, toolBox: ToolBox) {
		super.init(aetherView: aetherView, toolBox: toolBox, offset: .zero, fixed: ToolBar.fixed)
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
	
	func recoil() {
		guard let recoil = (selected as! BubbleTool).recoil else { return }
		recoilSelect(tool: recoil)
	}
	
// Events ==========================================================================================
	override func onExpand() {
		if (selected as! BubbleTool).maker is TextMaker {
			aetherView.contractShapeToolBar()
			aetherView.contractColorToolBar()
			aetherView.dismissShapeToolBar()
			aetherView.dismissColorToolBar()
		}
	}
	override func onContract() {
		if (selected as! BubbleTool).maker is TextMaker {
			aetherView.invokeShapeToolBar()
			aetherView.invokeColorToolBar()
		}
	}
}
