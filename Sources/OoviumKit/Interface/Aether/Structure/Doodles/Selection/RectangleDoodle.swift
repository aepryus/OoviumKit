//
//  RectangleDoodle.swift
//  OoviumKit
//
//  Created by Joe Charlier on 11/2/24.
//  Copyright © 2024 Aepryus Software. All rights reserved.
//

import UIKit

class RectangleDoodle: SelectionDoodle {
    private var image: UIImage
    private var startPoint: CGPoint
    private var currentPoint: CGPoint
    private let p: CGFloat = 2
    
    private var currentRange: Range
    
    override init(aetherView: AetherView, touch: UITouch) {
        
        startPoint = touch.location(in: aetherView.scrollView)
        currentPoint = startPoint
        currentRange = Range(point: currentPoint)
        
        image = UIImage()
        
        super.init(aetherView: aetherView, touch: touch)
        
        let range: Range = Range(point: startPoint)
        frame = CGRect(x: range.left-p, y: range.top-p, width: range.width+2*p, height: range.height+2*p)
    }

// SelectionDoodle =================================================================================
    override var selectionPath: CGPath { CGPath(rect: CGRect(x: min(startPoint.x, currentPoint.x), y: min(startPoint.y, currentPoint.y), width: abs(currentPoint.x-startPoint.x), height: abs(currentPoint.y-startPoint.y)), transform: nil) }
    override func add(touch: UITouch) {
        currentPoint = touch.location(in: aetherView.scrollView)
        var range: Range = Range(point: startPoint)
        range.add(point: currentPoint)
        frame = CGRect(x: range.left-p, y: range.top-p, width: range.width+2*p, height: range.height+2*p)
        setNeedsDisplay()
    }

// CALayer =========================================================================================
    override func draw(in ctx: CGContext) {
        var range: Range = Range(point: startPoint)
        range.add(point: currentPoint)
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: range.width+2*p, height: range.height+2*p), false, 0)

        let rect: CGRect = CGRect(x: p, y: p, width: range.width, height: range.height)
        Skin.lasso(path: CGPath(rect: rect, transform: nil))
        
        image = UIGraphicsGetImageFromCurrentImageContext()!
        
        UIGraphicsEndImageContext()
        
        ctx.translateBy(x: 0, y: image.size.height)
        ctx.scaleBy(x: 1, y: -1)
        if let cgImage = image.cgImage { ctx.draw(cgImage, in: bounds) }
    }
}
