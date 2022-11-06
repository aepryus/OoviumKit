//
//  TronSkin.swift
//  Oovium
//
//  Created by Joe Charlier on 4/9/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

public class TronSkin: Skin {
	let pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!)
	
	// Skin ============================================================================================
	// Color
	override func color(_ skinColor: SkinColor) -> UIColor {
		switch skinColor {
			case .labelBack:	return UIColor(red: 0, green: 0.3, blue: 0, alpha: 0.5)
			case .ovalBack:		return .black.alpha(0.3)
			case .currentCell:	return .purple
			default:			return .white
		}
	}
	
	// Text
	override func text(_ text: String, rect: CGRect, uiColor: UIColor, font: UIFont, align: NSTextAlignment) {
		var pen = Pen(font: font, color: uiColor.alpha(0.4), alignment: align)
		(text as NSString).draw(in: rect.offsetBy(dx: -1, dy: -1), withAttributes: pen.attributes)
		(text as NSString).draw(in: rect.offsetBy(dx: 1, dy: 1), withAttributes: pen.attributes)
		
		pen = pen.clone(color: UIColor.white)
		(text as NSString).draw(in: rect, withAttributes: pen.attributes)
	}
	override func text(_ text: String, x: CGFloat, y: CGFloat, uiColor: UIColor) {
		var pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!, color: uiColor.alpha(0.4))
		(text as NSString).draw(at: CGPoint(x: x-1, y: y-1), withAttributes: pen.attributes)
		(text as NSString).draw(at: CGPoint(x: x+1, y: y+1), withAttributes: pen.attributes)
		
		pen = pen.clone(color: UIColor.white)
		(text as NSString).draw(at: CGPoint(x: x, y: y), withAttributes: pen.attributes)
	}
	override func placeholder(_ text: String, rect: CGRect, uiColor: UIColor, align: NSTextAlignment) {
		var pen = Pen(font: UIFont.placeholder(size: 16), color: uiColor.shade(0.76), alignment: .center)
		
		(text as NSString).draw(in: rect.offsetBy(dx: 1, dy: 1), withAttributes: pen.attributes)
		(text as NSString).draw(in: rect.offsetBy(dx: -1, dy: -1), withAttributes: pen.attributes)
		
		pen = pen.clone(color: UIColor.white.shade(0.3))
		(text as NSString).draw(in: rect, withAttributes: pen.attributes)
	}
	override func panelOverride(text: String, rect: CGRect, pen: Pen) {
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		(text as NSString).draw(in: rect, withAttributes: pen.attributes)
		c.restoreGState()
	}
	// Grid
	override func gridDraw(path: CGPath, uiColor: UIColor) {
		let c = UIGraphicsGetCurrentContext()!
		
		c.setStrokeColor(uiColor.tint(0.25).alpha(0.4).cgColor)
		c.setLineWidth(3)
		c.addPath(path)
		c.drawPath(using: .stroke)

		c.setStrokeColor(uiColor.tint(0.25).alpha(0.6).cgColor)
		c.setLineWidth(2)
		c.addPath(path)
		c.drawPath(using: .stroke)
		
		c.setStrokeColor(UIColor.white.cgColor)
		c.setLineWidth(1)
		c.addPath(path)
		c.drawPath(using: .stroke)
	}
	override func gridFill(path: CGPath, uiColor: UIColor) {
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(UIColor.black.alpha(0.7).cgColor)
		c.addPath(path)
		c.fillPath()
	}
	override func gridCalc(path: CGPath, uiColor: UIColor) {
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(uiColor.tint(0.25).alpha(0.7).cgColor)
		c.addPath(path)
		c.fillPath()
	}
	// Pulse
	override func pulse(context: CGContext, rect: CGRect, uiColor: UIColor) {
		context.setFillColor(uiColor.alpha(0.5).cgColor)
		context.fillEllipse(in: rect)
		context.setFillColor(UIColor.white.cgColor)
		context.fillEllipse(in: rect.insetBy(dx: 1, dy: 1))
	}
	override func lasso(path: CGPath) {
		bubble(path: path, uiColor: UIColor.yellow, width: 2)
	}
	
	// Panel
	override func panel (path: CGPath, uiColor: UIColor) {
		let c = UIGraphicsGetCurrentContext()!
		let width: CGFloat = 4/3*Oo.s
		
		c.setFillColor(UIColor.black.withAlphaComponent(0.7).cgColor)
		c.addPath(path)
		c.drawPath(using: .fill)
		
		c.setStrokeColor(uiColor.withAlphaComponent(0.4).cgColor)
		c.setLineWidth(width*3)
		c.addPath(path)
		c.drawPath(using: .stroke)
		
		c.setStrokeColor(uiColor.withAlphaComponent(0.6).cgColor)
		c.setLineWidth(width*2)
		c.addPath(path)
		c.drawPath(using: .stroke)
		
		c.setStrokeColor(UIColor.white.cgColor)
		c.setLineWidth(width)
		c.addPath(path)
		c.drawPath(using: .stroke)
	}
	override func panel(text: String, rect: CGRect, pen: Pen) {
		let pen = pen.clone(color: pen.color.shade(0.7))
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		(text as NSString).draw(in: rect, withAttributes: pen.attributes)
		c.restoreGState()
	}
	
	// Key
	override func key (path: CGPath, uiColor: UIColor) {
		let rgb = RGB(uiColor: uiColor)
		let field = rgb.blend(rgb: RGB.white, percent: 0.25)
		let accent = rgb.blend(rgb: RGB.black, percent: 0.5)
		
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(field.cgColor)
		c.setStrokeColor(accent.cgColor)
		c.setLineWidth(2/3*Oo.s)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	override func key (text: String, rect: CGRect, font: UIFont) {
		let pen = Pen(font: font, color: UIColor.black)
		let size = (text as NSString).size(withAttributes: pen.attributes)
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		let inside = CGRect(x: rect.origin.x+(rect.size.width-size.width)/2, y: rect.origin.y+(rect.size.height-size.height)/2, width: size.width, height: size.height)
		(text as NSString).draw(in: inside, withAttributes: pen.attributes)
		c.restoreGState()
	}
	override func key(image: UIImage, rect: CGRect, font: UIFont) {
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		image.withTintColor(UIColor.black).draw(in: rect.insetBy(dx: 9, dy: 9))
		c.restoreGState()
	}
	override func shapeKey(path: CGPath) {
		let c = UIGraphicsGetCurrentContext()!
		
		c.addPath(path)
		c.setLineWidth(0)
		UIColor.black.alpha(0.7).setFill()
		c.drawPath(using: .fill)
		
		c.addPath(path)
		c.setLineWidth(6)
		UIColor.black.alpha(0.4).setStroke()
		c.drawPath(using: .stroke)
		
		c.addPath(path)
		c.setLineWidth(4)
		UIColor.black.alpha(0.6).setStroke()
		c.drawPath(using: .stroke)
		
		c.addPath(path)
		c.setLineWidth(2)
		UIColor.white.setStroke()
		c.drawPath(using: .stroke)
	}
	
	// Bubble
	override func bubble(path: CGPath, uiColor: UIColor, width: CGFloat) {
		let c = UIGraphicsGetCurrentContext()!
		
		c.setFillColor(UIColor.black.withAlphaComponent(0.7).cgColor)
		c.addPath(path)
		c.drawPath(using: .fill)
		
		c.setStrokeColor(uiColor.withAlphaComponent(0.4).cgColor)
		c.setLineWidth(width*3)
		c.addPath(path)
		c.drawPath(using: .stroke)
		
		c.setStrokeColor(uiColor.withAlphaComponent(0.6).cgColor)
		c.setLineWidth(width*2)
		c.addPath(path)
		c.drawPath(using: .stroke)
		
		c.setStrokeColor(UIColor.white.cgColor)
		c.setLineWidth(width)
		c.addPath(path)
		c.drawPath(using: .stroke)
	}
	override func bubble(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor? = nil, pen: Pen? = nil) {
		let uiColor = uiColor ?? pen?.color ?? UIColor.white
		var pen = (pen ?? Pen(font: UIFont(name: "HelveticaNeue", size: 16)!)).clone(color: uiColor.alpha(0.4))
		text.draw(at: CGPoint(x: x+1, y: y+1), pen: pen)
		text.draw(at: CGPoint(x: x-1, y: y-1), pen: pen)
		
		pen = pen.clone(color: UIColor.white)
		text.draw(at: CGPoint(x: x, y: y), pen: pen)
	}
	override func bubble(text: String, rect: CGRect, uiColor: UIColor? = nil, pen: Pen? = nil) {
		let uiColor = uiColor ?? pen?.color ?? UIColor.white
		var pen = (pen ?? Pen(font: UIFont(name: "Verdana", size: 15)!, alignment: .center)).clone(color: uiColor.alpha(0.4))
		let size: CGSize = text.size(pen: pen, width: rect.width)
		let dy: CGFloat = (rect.height-size.height)/2 - 1
		text.draw(in: rect.offsetBy(dx: 1, dy: 1+dy), pen: pen)
		text.draw(in: rect.offsetBy(dx: -1, dy: -1+dy), pen: pen)
		
		pen = pen.clone(color: UIColor.white)
		text.draw(in: rect.offsetBy(dx: 0, dy: dy), pen: pen)
	}

    // Shape
    override func shape(path: CGPath, uiColor: UIColor) {
        let c = UIGraphicsGetCurrentContext()!
        c.addPath(path)
        c.setFillColor(uiColor.shade(0.0).alpha(0.3).cgColor)
        c.setStrokeColor(uiColor.tint(0.5).cgColor)
        c.setLineWidth(1)
        c.drawPath(using: .fillStroke)
    }
	override func shape(text: String, rect: CGRect, uiColor: UIColor, maxWidth: CGFloat?) {
		let style: NSMutableParagraphStyle = self.pen.style.mutableCopy() as! NSMutableParagraphStyle
		style.lineBreakMode = .byWordWrapping
		var pen = self.pen.clone(alignment: .center, style: style)
		
		var size = (text as NSString).size(withAttributes: pen.attributes)
		if text.components(separatedBy: " ").count > 1 {
			while size.width > size.height*4 {
				size = (text as NSString).boundingRect(with: CGSize(width: size.width*0.9, height: 2000), options: [.usesLineFragmentOrigin], attributes: pen.attributes, context: nil).size
			}
		}
		if let maxWidth = maxWidth, size.width > maxWidth {
			size = (text as NSString).boundingRect(with: CGSize(width: maxWidth, height: 2000), options: [.usesLineFragmentOrigin], attributes: pen.attributes, context: nil).size
		}
		
		let textRect = CGRect(x: rect.origin.x+(rect.size.width-size.width)/2, y: rect.origin.y+(rect.size.height-size.height)/2-1, width: size.width+0.5, height: size.height+0.5)
		
        pen = pen.clone(color: uiColor.shade(0.8))
		text.draw(in: textRect.offsetBy(dx: 1, dy: 1), withAttributes: pen.attributes)
		text.draw(in: textRect.offsetBy(dx: -1, dy: -1), withAttributes: pen.attributes)
		
        pen = pen.clone(color: uiColor.tint(0.8))
		text.draw(in: textRect, withAttributes: pen.attributes)
	}
	// Miscellaneous
	override func message (text: String, rect: CGRect, uiColor: UIColor, font: UIFont) {
		let style = NSMutableParagraphStyle()
		style.lineBreakMode = .byWordWrapping
		
		var pen = Pen(font: font, color: uiColor.alpha(0.4), alignment: .left, style: style)
		(text as NSString).draw(in: rect.offsetBy(dx: -1, dy: 1), withAttributes: pen.attributes)
		(text as NSString).draw(in: rect.offsetBy(dx: 1, dy: 1), withAttributes: pen.attributes)
		
		pen = pen.clone(color: UIColor.white)
		(text as NSString).draw(in: rect, withAttributes: pen.attributes)
	}
	// AetherPicker
	override func aetherPicker (path: CGPath) {
		let rgb = RGB(uiColor: UIColor.green)
		let c = UIGraphicsGetCurrentContext()!
		c.setStrokeColor(rgb.shade(0.4).cgColor)
		c.setFillColor(rgb.tint(0.9).uiColor.alpha(0.85).cgColor)
		c.setLineWidth(4/3*Oo.s)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	override func aetherPickerList (path: CGPath) {
		panel(path: path, uiColor: UIColor.orange)
	}
	// AetherCell
	override func aetherCell (path: CGPath, uiColor: UIColor?) {
		let rgb = uiColor == nil ? RGB(r: 0, g: 191, b: 255) : RGB(uiColor: uiColor!)
		let field = rgb.blend(rgb: RGB.white, percent: 0.6)
		let accent = rgb.blend(rgb: RGB.white, percent: 0.8)
		let c = UIGraphicsGetCurrentContext()!
		field.uiColor.alpha(0.7).setFill()
		accent.uiColor.setStroke()
		c.setLineWidth(4.0/3.0*Oo.s)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	override func aetherCell (text: String, rect: CGRect, uiColor: UIColor?) {
		let rgb = RGB(uiColor: uiColor ?? .cyan)
		let accent = rgb.blend(rgb: RGB.white, percent: 0.9)
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		let pen = Pen(font: UIFont(name: "HelveticaNeue", size: 14*Oo.s)!, color: accent.uiColor, alignment: .center)
		(text as NSString).draw(in: rect, withAttributes: pen.attributes)
		c.restoreGState()
	}
	override func wafer(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor) -> CGFloat {
		var pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!)
		let size: CGSize = (text as NSString).size(withAttributes: pen.attributes)
		let width: CGFloat = max(size.width, 9)
		let waferWidth: CGFloat = width+12
		let c = UIGraphicsGetCurrentContext()!
		
		let rect = CGRect(x: x+1, y: y+1, width: waferWidth-2, height: size.height-1)
		let path = CGPath(roundedRect: rect, cornerWidth: 8, cornerHeight: 8, transform: nil)
		c.setFillColor(uiColor.alpha(0.3).cgColor)
		c.setStrokeColor(uiColor.alpha(0.7).cgColor)
		c.setLineWidth(0.5)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
		
		pen = pen.clone(color: UIColor.white)
		(text as NSString).draw(at: CGPoint(x: x+(waferWidth-size.width)/2, y: y), withAttributes: pen.attributes)
		
		return waferWidth
	}
	// Tray
	override func tray(path: CGPath, uiColor: UIColor, width: CGFloat) {
		let rgb = RGB(uiColor: uiColor)
		let field = rgb.tint(0.5)
		let accent = rgb.shade(0.5)
		
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(field.cgColor)
		c.setStrokeColor(accent.cgColor)
		c.setLineWidth(1.5)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	// Tool
	override func tool(path: CGPath) {
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(UIColor.black.alpha(0.7).cgColor)
        c.setStrokeColor(UIColor.white.shade(0.7).cgColor)
		c.setLineWidth(4.0/3.0*Oo.s)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
    override func plasma(path: CGPath, uiColor: UIColor, stroke: CGFloat, fill: CGFloat) {
        let c = UIGraphicsGetCurrentContext()!
        c.addPath(path)
        uiColor.alpha(stroke).setStroke()
        uiColor.alpha(fill).setFill()
        c.drawPath(using: .fillStroke)
    }
	// About
	override func about(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor, font: UIFont) {
		var pen = Pen(font: font, color: uiColor.alpha(0.4))
		(text as NSString).draw(at: CGPoint(x: x+1, y: y+1), withAttributes: pen.attributes)
		(text as NSString).draw(at: CGPoint(x: x-1, y: y-1), withAttributes: pen.attributes)
		
		pen = pen.clone(color: UIColor.white)
		(text as NSString).draw(at: CGPoint(x: x, y: y), withAttributes: pen.attributes)
	}
	override func about(path: CGPath, uiColor: UIColor) {
		let width: CGFloat = 2
		let c = UIGraphicsGetCurrentContext()!
		
		c.setStrokeColor(uiColor.withAlphaComponent(0.4).cgColor)
		c.setLineWidth(width*3)
		c.addPath(path)
		c.drawPath(using: .stroke)
		
		c.setStrokeColor(uiColor.withAlphaComponent(0.6).cgColor)
		c.setLineWidth(width*2)
		c.addPath(path)
		c.drawPath(using: .stroke)
		
		c.setStrokeColor(UIColor.white.cgColor)
		c.setLineWidth(width)
		c.addPath(path)
		c.drawPath(using: .stroke)
	}
	// End
	override func end(path: CGPath, uiColor: UIColor) {
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(uiColor.cgColor)
		c.setStrokeColor(uiColor.cgColor)
		c.setLineWidth(2)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	override func end(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor) {
		let pen = Pen(font: UIFont(name: "Verdana", size: 14)!, color: uiColor)
		(text as NSString).draw(at: CGPoint(x: x, y: y), withAttributes: pen.attributes)
	}
    
    static let expBackColor: CGColor = UIColor.green.shade(0.9).cgColor
    static let expLineColor: CGColor = UIColor.green.tint(0.8).cgColor
    static let expPen: Pen = Pen(font: .ooExplore(size: 16*Oo.gS), color: .green.tint(0.7), alignment: .center)
    static let expLw: CGFloat = 2*Oo.gS

    override func explorer(path: CGPath) {
        let c: CGContext = UIGraphicsGetCurrentContext()!
        c.addPath(path)
        c.setStrokeColor(TronSkin.expLineColor)
        c.setFillColor(TronSkin.expBackColor)
        c.setLineWidth(TronSkin.expLw)
        c.drawPath(using: .fillStroke)
    }
    override func explorer(text: String, rect: CGRect) {
        text.draw(in: rect, pen: TronSkin.expPen)
    }
}
