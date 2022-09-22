//
//  GridView.swift
//  Oovium
//
//  Created by Joe Charlier on 12/15/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

protocol GridViewDelegate: AnyObject {
	func numberOfRows(gridView: GridView) -> Int
	func numberOfColumns(gridView: GridView) -> Int
	func cell(gridView: GridView, column: Int, row: Int) -> UIView
	func size(gridView: GridView, column: Int, row: Int) -> CGSize
}

class GridView: UIScrollView {
	weak var gridViewDelegate: GridViewDelegate? = nil
	
	func reloadData() {
		guard let delegate = gridViewDelegate else { return }
		
		var x: CGFloat = 0
		var y: CGFloat = 0
		var size: CGSize = .zero
		var width: CGFloat = 0
		var height: CGFloat = 0
		
		var current = subviews
		for j in 0..<delegate.numberOfRows(gridView: self) {
			for i in 0..<delegate.numberOfColumns(gridView: self) {
				let cell: UIView = delegate.cell(gridView: self, column: i, row: j)
				size = delegate.size(gridView: self, column: i, row: j)
				cell.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
				if let index: Int = current.firstIndex(of: cell) { current.remove(at: index) }
				else { addSubview(cell) }
				x += size.width
			}
			width = x
			x = 0
			y += size.height
		}
		current.forEach { $0.removeFromSuperview() }
		height = y		
		bounds.size = CGSize(width: width, height: height)
	}
	
	func colNo(cx: CGFloat) -> Int {
		guard let delegate = gridViewDelegate else { return 1 }
		var size: CGSize = .zero
		var x: CGFloat = 0
		for i in 0..<delegate.numberOfColumns(gridView: self) {
			size = delegate.size(gridView: self, column: i, row: 0)
			x += size.width
			if x > cx {return max(i,1)}
		}
		return delegate.numberOfColumns(gridView: self)-1
	}
	func hide(column: Column, cx: CGFloat) {
		guard let delegate = gridViewDelegate else { return }
		
		var x: CGFloat = 0
		var y: CGFloat = 0
		var size: CGSize = .zero
		let hiddenNo: Int = column.colNo + 1
		let hiddenWidth: CGFloat = delegate.size(gridView: self, column: hiddenNo, row: 0).width
		
		let at: Int = colNo(cx: cx)

		let skipNo: Int = at > hiddenNo ? at+1 : at
		var colNo: Int = 0
		
		for j in 0..<delegate.numberOfRows(gridView: self) {
			x = 0
			colNo = 0
			for i in 0...delegate.numberOfColumns(gridView: self) {
				if i == skipNo {
					x += hiddenWidth
				} else {
					let cell: UIView = delegate.cell(gridView: self, column: colNo, row: j)
					if colNo != hiddenNo {
						size = delegate.size(gridView: self, column: colNo, row: j)
						cell.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
						x += size.width
					}
					colNo += 1
				}
			}
			y += size.height
		}
	}
	
	func row(cy: CGFloat) -> Int {
		guard let delegate = gridViewDelegate else { return 1 }
		var size: CGSize = .zero
		var y: CGFloat = 0
		for i in 0..<delegate.numberOfRows(gridView: self) {
			size = delegate.size(gridView: self, column: 0, row: i)
			y += size.height
			if y > cy {return max(i,1)}
		}
		return delegate.numberOfRows(gridView: self)-1
	}
	func hide(rowNo: Int, cy: CGFloat) {
		guard let delegate = gridViewDelegate else { return }
		
		var x: CGFloat = 0
		var y: CGFloat = 0
		var size: CGSize = .zero
		let hiddenNo: Int = rowNo + 1
		let hiddenHeight: CGFloat = delegate.size(gridView: self, column: 0, row: hiddenNo).height
		
		let at: Int = row(cy: cy)

		let skipNo: Int = at > hiddenNo ? at+1 : at
		var jRow: Int = 0
		
		for j in 0...delegate.numberOfRows(gridView: self) {
			x = 0
			
			if j == skipNo {
				y += hiddenHeight
			} else {
				if jRow != hiddenNo {
					for i in 0..<delegate.numberOfColumns(gridView: self) {
						let cell: UIView = delegate.cell(gridView: self, column: i, row: jRow)
						size = delegate.size(gridView: self, column: i, row: jRow)
						cell.frame = CGRect(x: x, y: y, width: size.width, height: size.height)
						x += size.width
					}
					y += size.height
				}
				jRow += 1
			}
		}
	}
}
