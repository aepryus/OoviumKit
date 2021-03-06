//
//  BubbleTool.swift
//  Oovium
//
//  Created by Joe Charlier on 8/5/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import UIKit

public class BubbleTool: Tool {
	let maker: Maker
	let recoil: BubbleTool?
	
	init(maker: Maker) {
		self.maker = maker
		self.recoil = nil
		super.init()
	}
	init(maker: Maker, recoil: BubbleTool) {
		self.maker = maker
		self.recoil = recoil
		super.init()
	}
	public required init?(coder aDecoder: NSCoder) { fatalError() }
	
	lazy var image: UIImage = {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 40*Oo.s, height: 40*Oo.s), false, 0.0)
		
		self.maker.drawIcon()
		
		let image = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		return image
	}()
	
// Tool ============================================================================================
	override func render() {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 40*Oo.s, height: 40*Oo.s), false, 0.0)
		
		self.maker.drawIcon()
		
		let image = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		self.image = image
	}
	override func rescale() {
		UIGraphicsBeginImageContextWithOptions(CGSize(width: 40*Oo.s, height: 40*Oo.s), false, 0.0)
		
		self.maker.drawIcon()
		
		let image = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()
		
		self.image = image
	}

// UIView ==========================================================================================
	public override func draw(_ rect: CGRect) {
		super.draw(rect)
		image.draw(at: CGPoint.zero)
	}
}
