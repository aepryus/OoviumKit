//
//  ColorToolBar.swift
//  Oovium
//
//  Created by Joe Charlier on 8/4/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class ColorToolBar: ToolBar {
	
	init(aetherView: AetherView) {
		var tools: [[Tool?]] = Array(repeating: Array(repeating: nil, count: 4), count: 4)
		
		tools[0][0] = ColorTool(color: .lime)
		tools[0][1] = ColorTool(color: .olive)
		tools[0][2] = ColorTool(color: .green)
		tools[0][3] = ColorTool(color: .blue)
		tools[1][0] = ColorTool(color: .yellow)
		tools[1][1] = ColorTool(color: .paleYellow)
		tools[1][2] = ColorTool(color: .marine)
		tools[1][3] = ColorTool(color: .cobolt)
		tools[2][0] = ColorTool(color: .orange)
		tools[2][1] = ColorTool(color: .peach)
		tools[2][2] = ColorTool(color: .lavender)
		tools[2][3] = ColorTool(color: .cyan)
		tools[3][0] = ColorTool(color: .red)
		tools[3][1] = ColorTool(color: .maroon)
		tools[3][2] = ColorTool(color: .magenta)
		tools[3][3] = ColorTool(color: .violet)
		
        super.init(aetherView: aetherView, toolBox: ToolBox(tools), offset: UIOffset(horizontal: -80, vertical: 0), fixed: UIOffset(horizontal: 1, vertical: -1))
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }

// Events ==========================================================================================
	override func onExpand() {
		aetherView.contractShapeToolBar()
	}
}
