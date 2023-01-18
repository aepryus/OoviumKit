//
//  File.swift
//  
//
//  Created by Joe Charlier on 1/17/23.
//

//import UIKit
//
//extension GraphBub {
//    class RangeView: UIView {
//        let rangeLeaf: RangeLeaf
//        
//        let startView: ChainView
//        let stopView: ChainView
//        let stepView: ChainView
//        
//        init(rangeLeaf: RangeLeaf, responder: ChainResponder) {
//            self.rangeLeaf = rangeLeaf
//            startView = ChainView(editable: rangeLeaf, responder: responder)
//            stopView = ChainView(editable: rangeLeaf, responder: responder)
//            stepView = ChainView(editable: rangeLeaf, responder: responder)
//            super.init(frame: .zero)
//            addSubview(startView)
//            addSubview(stopView)
//            addSubview(stepView)
//        }
//        required init?(coder: NSCoder) { fatalError() }
//        
//    // UIView ======================================================================================
//        override func layoutSubviews() {
//            startView.frame = CGRect(origin: CGPoint(x: rangeLeaf.x1, y: 0), size: CGSize(width: rangeLeaf.x3-rangeLeaf.x1, height: height))
//            stopView.frame = CGRect(origin: CGPoint(x: rangeLeaf.x3, y: 0), size: CGSize(width: rangeLeaf.x5-rangeLeaf.x3, height: height))
//            stepView.frame = CGRect(origin: CGPoint(x: rangeLeaf.x6, y: 0), size: CGSize(width: rangeLeaf.x10-rangeLeaf.x6, height: height))
//        }
//    }
//    
//    class RangeLeaf: Leaf, Editable {
//        var rangeViews: [RangeView] = []
//        
//        init(bubble: Bubble, params: Int = 2) {
//            
//            super.init(bubble: bubble)
//            
//            for _ in 0..<params {
//                let rangeView: RangeView = RangeView(rangeLeaf: self, responder: aetherView.responder)
//                rangeViews.append(rangeView)
//                addSubview(rangeView)
//            }
//            
//            size = CGSize(width: 130*s, height: 6+CGFloat(rangeViews.count)*24)
//        }
//        required init?(coder aDecoder: NSCoder) { fatalError() }
//        
//        fileprivate var x1: CGFloat = 0
//        fileprivate var x2: CGFloat = 0
//        fileprivate var x5: CGFloat = 0
//        fileprivate var x4: CGFloat = 0
//        fileprivate var x3: CGFloat = 0
//        fileprivate var x6: CGFloat = 0
//        fileprivate var x7: CGFloat = 0
//        fileprivate var x10: CGFloat = 0
//        fileprivate var x9: CGFloat = 0
//        fileprivate var x8: CGFloat = 0
//        
//        fileprivate var y1: CGFloat = 0
//        fileprivate var y5: CGFloat = 0
//        fileprivate var y3: CGFloat = 0
//        fileprivate var y2: CGFloat = 0
//        fileprivate var y4: CGFloat = 0
//        
//        func render() {
//            let s: CGFloat = Oo.aS
//            let p: CGFloat = 2*s
//            let wp: CGFloat = 8*s       // widows peak
//            
//            x1 = p
//            x2 = x1 + wp
//            x5 = 70*s
//            x4 = x5 - wp
//            x3 = (x1 + x5)/2
//            x6 = x5 + 16*s
//            x7 = x6 + wp
//            x10 = width - p
//            x9 = x10 - wp
//            x8 = (x6 + x10)/2
//            
//            y1 = p
//            y5 = height - p
//            y3 = height/2
//            y2 = (y1 + y3)/2
//            y4 = (y3 + y5)/2
//        }
//        
//    // Editable ====================================================================================
//        var editor: Orbit { aetherView.orb.chainEditor }
//        func onMakeFocus() {}
//        func onReleaseFocus() {}
//        func cite(_ citable: Citable, at: CGPoint) {}
//
//    // UIView ======================================================================================
//        override func layoutSubviews() {
//            render()
//            let p: CGFloat = 2*s
//            let rw: CGFloat = width
//            let rh: CGFloat = (height-2*p)/CGFloat(rangeViews.count)
//            
//            rangeViews.enumerated().forEach {
//                $1.frame = CGRect(origin: CGPoint(x: 0, y: p+rh*CGFloat($0)), size: CGSize(width: rw, height: rh))
//            }
//        }
//        override func draw(_ rect: CGRect) {
//            render()
//            let path: CGMutablePath = CGMutablePath()
//            path.move(to: CGPoint(x: x3, y: y1))
//            path.addArc(tangent1End: CGPoint(x: x5, y: y1), tangent2End: CGPoint(x: x5, y: y2), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x5, y: y3), tangent2End: CGPoint(x: x4, y: y3), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x5, y: y3), tangent2End: CGPoint(x: x5, y: y4), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x5, y: y5), tangent2End: CGPoint(x: x3, y: y5), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x1, y: y5), tangent2End: CGPoint(x: x1, y: y4), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x2, y: y3), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x1, y: y3), tangent2End: CGPoint(x: x1, y: y2), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x1, y: y1), tangent2End: CGPoint(x: x3, y: y1), radius: 12)
//            path.closeSubpath()
//            path.move(to: CGPoint(x: x2, y: y3))
//            path.addLine(to: CGPoint(x: x4, y: y3))
//            path.move(to: CGPoint(x: x3, y: y1))
//            path.addLine(to: CGPoint(x: x3, y: y5))
//            
//            path.move(to: CGPoint(x: x8, y: y1))
//            path.addArc(tangent1End: CGPoint(x: x10, y: y1), tangent2End: CGPoint(x: x10, y: y2), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x10, y: y3), tangent2End: CGPoint(x: x9, y: y3), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x10, y: y3), tangent2End: CGPoint(x: x10, y: y4), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x10, y: y5), tangent2End: CGPoint(x: x8, y: y5), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x6, y: y5), tangent2End: CGPoint(x: x6, y: y4), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x6, y: y3), tangent2End: CGPoint(x: x7, y: y3), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x6, y: y3), tangent2End: CGPoint(x: x6, y: y2), radius: 12)
//            path.addArc(tangent1End: CGPoint(x: x6, y: y1), tangent2End: CGPoint(x: x8, y: y1), radius: 12)
//            path.closeSubpath()
//            path.move(to: CGPoint(x: x7, y: y3))
//            path.addLine(to: CGPoint(x: x9, y: y3))
//
//            hitPath = path
//            Skin.bubble(path: path, uiColor: bubble.uiColor, width: 4.0/3.0*Oo.s)
//        }
//    }
//}
