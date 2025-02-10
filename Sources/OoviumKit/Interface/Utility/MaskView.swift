//
//  MaskView.swift
//  Oovium
//
//  Created by Joe Charlier on 8/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

public class MaskView: UIView {
	public var content: UIView {
		didSet {
			oldValue.removeFromSuperview()
			content.frame = self.bounds
			addSubview(content)
		}
	}
	public var path: CGPath? {
        didSet {
            guard let shapeLayer: CAShapeLayer = layer.mask as? CAShapeLayer else { return }
            shapeLayer.path = path
            shapeLayer.fillColor = UIColor.black.cgColor
        }
	}
	
	public init(content: UIView) {
		self.content = content
		
		super.init(frame: CGRect.zero)
		
		addSubview(self.content)
		
		let mask = CAShapeLayer()
		mask.fillColor = UIColor.black.cgColor
		layer.mask = mask
	}
	public init(frame: CGRect, content: UIView, path: CGPath) {
		self.content = content

		super.init(frame: frame)

		self.content.frame = self.bounds
		addSubview(self.content)

		let mask = CAShapeLayer()
		mask.path = path
		mask.fillColor = UIColor.black.cgColor
		layer.mask = mask
	}
	public required init?(coder aDecoder: NSCoder) { fatalError() }
		
// UIView ==========================================================================================
    override public func layoutSubviews() {
        if let mask { mask.frame = bounds }
    }
	public override var frame: CGRect {
		didSet {
			content.frame = bounds
            if let mask { mask.frame = bounds }
		}
	}
	public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let path else { return super.point(inside: point, with: event) }
		return path.contains(point)
	}
}
