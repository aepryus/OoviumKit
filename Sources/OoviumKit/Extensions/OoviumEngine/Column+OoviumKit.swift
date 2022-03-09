//
//  Column+OoviumKit.swift
// 	OoviumKit
//
//  Created by Joe Charlier on 3/7/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

extension Column {
//	var _width: CGFloat? = nil
	var width: CGFloat {
//		if _width == nil {
			renderWidth()
//		}
//		return _width!
	}
//	var _headerWidth: CGFloat? = nil
	var headerWidth: CGFloat {
//		get {
//			if _headerWidth == nil {
				renderHeaderWidth()
//			}
//			return _headerWidth!
//		}
	}
//	var _footerWidth: CGFloat? = nil
	var footerWidth: CGFloat {
//		get {
			renderFooterWidth()
//			return _footerWidth!
//		}
	}
	var alignment: NSTextAlignment {
		switch justify {
			case .left: return .left
			case .center: return .center
			case .right: return .right
		}
	}
	func renderHeaderWidth() -> CGFloat {
		let _headerWidth: CGFloat
		let pen: Pen = Pen(font: UIFont(name: "Verdana-Bold", size: 15)!)
		_headerWidth = (name as NSString).size(pen: pen).width+20
		return _headerWidth
	}
	func renderFooterWidth() -> CGFloat {
		let _footerWidth: CGFloat
		if aggregate == .none || aggregate == .running {
			_footerWidth = 0
		} else {
			_footerWidth = (footerTower.obje.display as NSString).size(pen: Pen()).width + 12
		}
		return _footerWidth
	}
	func renderWidth() -> CGFloat {
		let _width: CGFloat
		var width = max(90, headerWidth)
		width = max(width, footerWidth)
		for i in 0..<grid.rows {
			let cell: Cell = grid.cell(colNo: colNo, rowNo: i)
			width = max(width, cell.width)
		}
		_width = width
		return _width
	}
}
