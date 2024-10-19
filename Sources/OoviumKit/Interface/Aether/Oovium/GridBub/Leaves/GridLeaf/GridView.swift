//
//  GridView.swift
//  Oovium
//
//  Created by Joe Charlier on 12/15/19.
//  Copyright © 2019 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

protocol GridViewDelegate: AnyObject {
	func numberOfRows(gridView: GridView) -> Int
	func numberOfColumns(gridView: GridView) -> Int
	func cell(gridView: GridView, colNo: Int, rowNo: Int) -> UIView
	func size(gridView: GridView, colNo: Int, rowNo: Int) -> CGSize
}

class GridView: UIScrollView {
	weak var gridViewDelegate: GridViewDelegate? = nil
	
	func reloadData() {
		guard let delegate = gridViewDelegate else { return }
        
        // Force calculate column widths before laying anything out
        for j in 0..<delegate.numberOfRows(gridView: self) {
            for i in 0..<delegate.numberOfColumns(gridView: self) {
                _ = delegate.cell(gridView: self, colNo: i, rowNo: j)
            }
        }

        var x: CGFloat = 0
		var y: CGFloat = 0
		var size: CGSize = .zero
		var width: CGFloat = 0
		var height: CGFloat = 0
        
		var current = subviews
		for j in 0..<delegate.numberOfRows(gridView: self) {
			for i in 0..<delegate.numberOfColumns(gridView: self) {
				let cell: UIView = delegate.cell(gridView: self, colNo: i, rowNo: j)
				size = delegate.size(gridView: self, colNo: i, rowNo: j)
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
			size = delegate.size(gridView: self, colNo: i, rowNo: 0)
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
		let hiddenNo: Int = column.colNo
		let hiddenWidth: CGFloat = delegate.size(gridView: self, colNo: hiddenNo, rowNo: 0).width
		
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
					let cell: UIView = delegate.cell(gridView: self, colNo: colNo, rowNo: j)
					if colNo != hiddenNo {
						size = delegate.size(gridView: self, colNo: colNo, rowNo: j)
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
			size = delegate.size(gridView: self, colNo: 1, rowNo: i)
			y += size.height
			if y > cy { return max(i,1) }
		}
		return delegate.numberOfRows(gridView: self)
	}
	func hide(rowNo: Int, cy: CGFloat) {
		guard let delegate = gridViewDelegate else { return }
		
		var x: CGFloat = 0
		var y: CGFloat = 0
		var size: CGSize = .zero
		let hiddenNo: Int = rowNo
		let hiddenHeight: CGFloat = delegate.size(gridView: self, colNo: 1, rowNo: hiddenNo).height
		
		let at: Int = row(cy: cy)

		let skipNo: Int = at > hiddenNo ? at+1 : at
		var jRow: Int = 0
		
		for j in 0..<delegate.numberOfRows(gridView: self) {
			x = 0
			
			if j == skipNo {
				y += hiddenHeight
			} else {
				if jRow != hiddenNo {
                    for i in 0..<delegate.numberOfColumns(gridView: self) {
						let cell: UIView = delegate.cell(gridView: self, colNo: i, rowNo: jRow)
						size = delegate.size(gridView: self, colNo: i, rowNo: jRow)
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
