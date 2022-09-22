//
//  IvorySkin.swift
//  Oovium
//
//  Created by Joe Charlier on 4/9/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import OoviumEngine
import UIKit

public class IvorySkin: Skin {
		let pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!)
//	let pen = Pen(font: UIFont.systemFont(ofSize: 16))
	
	// Skin ============================================================================================
	override var fadePercent: CGFloat {
		return 0.04
	}
	override var backColor: UIColor {
		return UIColor.white
	}
	override var statusBarStyle: UIStatusBarStyle {
		return .darkContent
	}
	
	// Color
	override func color(_ skinColor: SkinColor) -> UIColor {
		switch skinColor {
			case .labelBack:		return UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.3)
			case .labelFore:		return UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 0.9)
			case .cursor:			return UIColor.gray
			case .ovalBack:			return UIColor.lightGray
			case .currentCell:		return OOColor.yellow.uiColor
			case .headerText:		return RGB(uiColor: UIColor.purple).shade(0.5).uiColor
			case .tailText:			return RGB(uiColor: UIColor.white).shade(0.5).uiColor
			case .signatureText:	return UIColor.darkGray
			default:				return UIColor.white
		}
	}
	
	//	case OOSkinColorLabelBack:	return [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.3];
	//	case OOSkinColorLabelFore:	return [UIColor colorWithRed:.3 green:.3 blue:.3 alpha:.9];
	//	case OOSkinColorCursor:		return [UIColor grayColor];
	//	case OOSkinColorOvalBack:	return [UIColor lightGrayColor];
	//	case OOSkinColorCurrentCell:return [Oovium color:OOColorYellow];
	//	case OOSkinColorHeaderText:	return [RGB shade:[UIColor purpleColor] percent:.5];
	//	case OOSkinColorTailText:	return [RGB shade:[UIColor whiteColor] percent:.5];
	//	return [UIColor whiteColor];
	
	
	// Pulse
	override func pulse(context: CGContext, rect: CGRect, uiColor: UIColor) {
		let accent = uiColor.shade(0.1)
		context.setFillColor(accent.cgColor)
		context.saveGState()
		context.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		context.fillEllipse(in: rect)
		context.restoreGState()
	}
	override func lasso(path: CGPath) {
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		c.addPath(path)
		UIColor(red: 1, green: 1, blue: 0.5, alpha: 1).setStroke()
		c.setLineWidth(2*Oo.s)
		c.drawPath(using: .stroke)
		c.restoreGState()
		c.drawPath(using: .stroke)
	}
	
	// Panel
	override func panel (path: CGPath, uiColor: UIColor) {
		let rgb = RGB(uiColor: uiColor)
		let field = rgb.blend(rgb: RGB.white, percent: 0.5)
		let accent = rgb.blend(rgb: RGB.black, percent: 0.5)
		
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(field.uiColor.withAlphaComponent(0.5).cgColor)
		c.setStrokeColor(accent.cgColor)
		c.setLineWidth(1.5)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	override func panel(text: String, rect: CGRect, pen: Pen) {
		let newPen = pen.clone(color: pen.color.shade(0.5))
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		(text as NSString).draw(in: rect, withAttributes: newPen.attributes)
		c.restoreGState()
	}
	override func panelOverride(text: String, rect: CGRect, pen: Pen) {
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		(text as NSString).draw(in: rect, withAttributes: pen.attributes)
		c.restoreGState()
	}
	
	// Key
	override func key(path: CGPath, uiColor: UIColor) {
		let rgb = RGB(uiColor: uiColor)
		let field = rgb.blend(rgb: RGB.white, percent: 0.5)
		let accent = rgb.blend(rgb: RGB.black, percent: 0.5)
		
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(field.cgColor)
		c.setStrokeColor(accent.cgColor)
		c.setLineWidth(Oo.s)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	override func key(text: String, rect: CGRect, font: UIFont) {
		let pen = Pen(font: font, color: .white)
		let size = (text as NSString).size(withAttributes: pen.attributes)
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		let inside = CGRect(x: (rect.size.width-size.width)/2, y: (rect.size.height-size.height)/2, width: size.width, height: size.height)
		(text as NSString).draw(in: inside, withAttributes: pen.attributes)
		c.restoreGState()
	}
	override func key(image: UIImage, rect: CGRect, font: UIFont) {
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		image.withTintColor(UIColor.white).draw(in: rect.insetBy(dx: 9, dy: 9))
		c.restoreGState()
	}
	override func bubble(path: CGPath, uiColor: UIColor, width: CGFloat) {
		let rgb = RGB(uiColor: uiColor)
		let field = rgb.blend(rgb: RGB.white, percent: 0.5)
		let accent = rgb.blend(rgb: RGB.black, percent: 0.5)
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(field.uiColor.cgColor)
		c.setStrokeColor(accent.cgColor)
		c.setLineWidth(1.5)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	override func bubble(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor? = nil, pen: Pen? = nil) {
		let uiColor = uiColor ?? pen?.color ?? UIColor.white
		var pen: Pen = pen ?? Pen(font: UIFont(name: "HelveticaNeue", size: 16)!, alignment: .center)
		let rgb = RGB(uiColor: uiColor)
		let accent = rgb.blend(rgb: RGB.black, percent: 0.5)
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		pen = pen.clone(color: accent.uiColor)
		text.draw(at: CGPoint(x: x, y: y), pen: pen)
		c.restoreGState()
	}
	override func bubble(text: String, rect: CGRect, uiColor: UIColor? = nil, pen: Pen? = nil) {
		let uiColor = uiColor ?? pen?.color ?? UIColor.white
		var pen: Pen = pen ?? Pen(font: UIFont(name: "HelveticaNeue", size: 16)!, alignment: .center)
		let rgb = RGB(uiColor: uiColor)
		let accent = rgb.blend(rgb: RGB.black, percent: 0.5)
		let size: CGSize = text.size(pen: pen, width: rect.width)
		let dy: CGFloat = (rect.height-size.height)/2 - 1
		
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		pen = pen.clone(color: accent.uiColor)
		text.draw(in: rect.offsetBy(dx: 0, dy: dy), pen: pen)
		c.restoreGState()
	}
	
	// Text
	override func text(_ text: String, rect: CGRect, uiColor: UIColor, font: UIFont, align: NSTextAlignment) {
		let rgb = RGB(uiColor: uiColor)
		let accent = rgb.blend(rgb: RGB.black, percent: 0.5)
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		let pen = Pen(font: font, color: accent.uiColor, alignment: align)
		text.draw(in: rect, withAttributes: pen.attributes)
		c.restoreGState()
	}
	override func text(_ text: String, x: CGFloat, y: CGFloat, uiColor: UIColor) {
		var pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!, color: uiColor.alpha(0.4))
		(text as NSString).draw(at: CGPoint(x: x-1, y: y-1), withAttributes: pen.attributes)
		(text as NSString).draw(at: CGPoint(x: x+1, y: y+1), withAttributes: pen.attributes)
		
		pen = pen.clone(color: UIColor.white)
		(text as NSString).draw(at: CGPoint(x: x, y: y), withAttributes: pen.attributes)
	}
	override func placeholder(_ text: String, rect: CGRect, uiColor: UIColor, align: NSTextAlignment) {
		let accent = RGB(uiColor: uiColor).shade(0.5)
		let pen = Pen(font: UIFont.placeholder(size: 16), color: accent.uiColor, alignment: .center)
		
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		(text as NSString).draw(in: rect, withAttributes: pen.attributes)
		c.restoreGState()
	}
	
	// Shape
	override func shape(text: String, rect: CGRect, uiColor: UIColor, maxWidth: CGFloat?) {
		let rgb = RGB(uiColor: uiColor)
		let accent = rgb.shade(0.5)
		
		let style: NSMutableParagraphStyle = pen.style.mutableCopy() as! NSMutableParagraphStyle
		style.lineBreakMode = .byWordWrapping
		let pen = self.pen.clone(color: accent.uiColor, alignment: .center, style: style)
		
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
		
		let c = UIGraphicsGetCurrentContext()!
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		
		(text as NSString).draw(in: textRect, withAttributes: pen.attributes)
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

	// Miscellaneous
	override func message (text: String, rect: CGRect, uiColor: UIColor, font: UIFont) {
		let style = NSMutableParagraphStyle()
		style.lineBreakMode = .byWordWrapping
		
		let accent = uiColor.shade(0.5)
		let pen = Pen(font: font, color: accent, alignment: .left, style: style)
		
		guard let c = UIGraphicsGetCurrentContext() else { return }
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		(text as NSString).draw(in: rect, withAttributes: pen.attributes)
		c.restoreGState()
	}
	// AetherPicker
	override func aetherPicker(path: CGPath) {
		let rgb = RGB(uiColor: UIColor.green).tint(0.75)
		let c = UIGraphicsGetCurrentContext()!
		c.setStrokeColor(rgb.shade(0.5).cgColor)
		c.setFillColor(rgb.tint(0.5).cgColor)
		c.setLineWidth(1*Oo.s)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	override func aetherPickerList(path: CGPath) {
		let rgb = RGB(uiColor: UIColor.orange)
		let c = UIGraphicsGetCurrentContext()!
		c.setStrokeColor(rgb.shade(0.5).cgColor)
		c.setFillColor(rgb.tint(0.5).uiColor.alpha(0.5).cgColor)
		c.setLineWidth(1*Oo.s)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	// AetherCell
	override func aetherCell(path: CGPath, uiColor: UIColor?) {
		let rgb = uiColor == nil ? RGB(r: 0, g: 127, b: 255) : RGB(uiColor: uiColor!)
		let field = rgb.tint(0.75)
		let accent = rgb.shade(0.2)
		let c = UIGraphicsGetCurrentContext()!
		field.uiColor.setFill()
		accent.uiColor.setStroke()
		c.setLineWidth(0.8*Oo.s)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	override func aetherCell (text: String, rect: CGRect, uiColor: UIColor?) {
		let rgb = uiColor == nil ? RGB(r: 0, g: 127, b: 255) : RGB(uiColor: uiColor!)
		let accent = rgb.shade(0.5)
		let c = UIGraphicsGetCurrentContext()!
		c.saveGState()
		c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
		let pen = Pen(font: UIFont.systemFont(ofSize: 14*Oo.s), color: accent.uiColor, alignment: .center)
		(text as NSString).draw(in: rect, withAttributes: pen.attributes)
		c.restoreGState()
	}
	override func wafer(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor) -> CGFloat {
		var pen = Pen(font: UIFont(name: "HelveticaNeue", size: 16)!)
		let accent = RGB(uiColor: uiColor).shade(0.5)
		let size: CGSize = (text as NSString).size(withAttributes: pen.attributes)
		let width: CGFloat = max(size.width, 9)
		let waferWidth: CGFloat = width+12
		let color = uiColor.alpha(0.3)
		let c = UIGraphicsGetCurrentContext()!
		let rect = CGRect(x: x+1, y: y+1, width: waferWidth-2, height: size.height-1)
		let path = CGPath(roundedRect: rect, cornerWidth: 8, cornerHeight: 8, transform: nil)
		c.setStrokeColor(accent.cgColor)
		c.setFillColor(color.cgColor)
		c.setLineWidth(0.5)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
		pen = pen.clone(color: accent.uiColor)
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
		c.setLineWidth(width)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	// Tool
	override func tool(path: CGPath) {
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(UIColor.white.alpha(0.7).cgColor)
		c.setStrokeColor(UIColor.black.cgColor)
		c.setLineWidth(4.0/3.0*Oo.s)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	override func plasma(path: CGPath, uiColor: UIColor) {
		let c = UIGraphicsGetCurrentContext()!
		UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4).setFill()
		UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 1).setStroke()
		c.addPath(path)
		c.setLineWidth(1)
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
	// End
	override func end(path: CGPath, uiColor: UIColor) {
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(uiColor.shade(0.3).cgColor)
		c.setStrokeColor(uiColor.shade(0.3).cgColor)
		c.setLineWidth(2)
		c.addPath(path)
		c.drawPath(using: .fillStroke)
	}
	override func end(text: String, x: CGFloat, y: CGFloat, uiColor: UIColor) {
		let pen = Pen(font: UIFont(name: "Verdana", size: 14)!, color: uiColor.shade(0.3))
		(text as NSString).draw(at: CGPoint(x: x, y: y), withAttributes: pen.attributes)
	}
	// Path
	override func gridDraw(path: CGPath, uiColor: UIColor) {
		let c = UIGraphicsGetCurrentContext()!
		
		c.setStrokeColor(uiColor.shade(0.5).cgColor)
		c.setLineWidth(2)
		c.addPath(path)
		c.drawPath(using: .stroke)
	}
	override func gridFill(path: CGPath, uiColor: UIColor) {
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(UIColor.purple.tint(0.9).cgColor)
		c.addPath(path)
		c.fillPath()
	}
	override func gridCalc(path: CGPath, uiColor: UIColor) {
		let c = UIGraphicsGetCurrentContext()!
		c.setFillColor(uiColor.tint(0.5).cgColor)
		c.addPath(path)
		c.fillPath()
	}
    
    static let expBackColor: UIColor = UIColor.green.shade(0.9)
    static let expLineColor: UIColor = UIColor.green.tint(0.8)
    static let expPen: Pen = Pen(font: .ooExplore(size: 16*Oo.gS), color: .green.tint(0.7), alignment: .center)
    static let expLw: CGFloat = 2*Oo.gS

    override func explorer(path: CGPath) {
        tray(path: path, uiColor: .green.tint(0.7), width: IvorySkin.expLw)
    }
    override func explorer(text: String, rect: CGRect) {
        let c = UIGraphicsGetCurrentContext()!
        c.saveGState()
        c.setShadow(offset: CGSize(width: 2, height: 2), blur: 2)
        text.draw(in: rect, pen: IvorySkin.expPen.clone(color: .green.tint(0.7).shade(0.5)))
        c.restoreGState()
    }
}
