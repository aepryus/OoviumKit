//
//  AetherView.swift
//  Oovium
//
//  Created by Joe Charlier on 4/8/17.
//  Copyright © 2017 Aepryus Software. All rights reserved.
//

import Acheron
import Aegean
import OoviumEngine
import UIKit

public protocol AetherViewDelegate: AnyObject {
	func onNew(aetherView: AetherView, aether: Aether)
	func onClose(aetherView: AetherView, aether: Aether)
	func onOpen(aetherView: AetherView, aether: Aether)
	func onSave(aetherView: AetherView, aether: Aether)
}
extension AetherViewDelegate {
	func onNew(aetherView: AetherView, aether: Aether) {}
	func onClose(aetherView: AetherView, aether: Aether) {}
	func onOpen(aetherView: AetherView, aether: Aether) {}
	func onSave(aetherView: AetherView, aether: Aether) {}
}

public class AetherView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate, AnchorDoubleTappable, GadgetDelegate {
	public var aether: Aether
    public var facade: AetherFacade?
    
    lazy var responder: ChainResponder = { ChainResponder(aetherView: self) }()
	
    let scrollView: UIScrollView = UIScrollView()
	
	public weak var aetherViewDelegate: AetherViewDelegate? = nil
	
	var maker: Maker = ObjectMaker()
	var shape: OOShape = .ellipse
	var color: OOColor = .lime
	
	var bubbles: [Bubble] = [Bubble]()
	var doodles: [Doodle] = [Doodle]()
	
	var aetherScale: CGFloat { Oo.s }
	var hoverScale: CGFloat { Oo.s }
	
	var readOnly: Bool = false
	private(set) var focus: Editable? = nil
	var selected: Set<Bubble> = Set<Bubble>()
	var copyBuffer: Set<Bubble> = Set<Bubble>()
	var locked: Bool = false
	var currentTextLeaf: TextLeaf? = nil
	let oldPicker: Bool
	
	public var hovers: [Hover] = []
	public var aetherPicker: AetherPicker? = nil
	var bubbleToolBar: BubbleToolBar? = nil
	var shapeToolBar: ShapeToolBar? = nil
	var colorToolBar: ColorToolBar? = nil
	
	public var aetherPickerOffset: UIOffset = UIOffset.zero
	public var toolBarOffset: UIOffset?
	
    lazy public var orb: Orb = {
        var dx: CGFloat = -Screen.safeRight
        var dy: CGFloat = -Screen.safeBottom
        if Screen.mac {
            dx -= 10*s
            dy -= 10*s
        } else {
            dx -= 2*s
            dy += 8*s
        }
        return Orb(aetherView: self, view: self, dx: dx, dy: dy)
    }()
	private var burn: Bool
	public var backView: UIView? = nil {
		didSet {
			oldValue?.removeFromSuperview()
			if let backView = backView, burn {
				addSubview(backView)
				sendSubviewToBack(backView)
			}
		}
	}

    lazy var aetherHover: AetherHover = { AetherHover(aetherView: self) }()
	
	lazy var anchoring: Anchoring = { Anchoring(aetherView: self) }()
	var anchored: Bool { anchoring.anchorTouch != nil }
	
	lazy var focusTapGesture: FocusTapGesture = { FocusTapGesture(aetherView: self) }()
	let tapGesture: TapGesture = TapGesture()
	lazy var doubleTap: DoubleTap = { DoubleTap(aetherView: self) }()
	lazy var makeGesture: MakeGesture = { MakeGesture(aetherView: self) }()
	lazy var anchorTap: AnchorTap = { AnchorTap(aetherView: self) }()
    lazy var anchorDoubleTapGesture: AnchorDoubleTap = { AnchorDoubleTap(aetherView: self) }()
	lazy var anchorPan: AnchorPan = { AnchorPan(aetherView: self) }()
	
	public var needsStretch: Bool = false
	public var lockVerticalScrolling: Bool = false

	var slid: Bool = false
	
	public init(aether: Aether, toolBox: ToolBox, toolsOn: Bool = true, burn: Bool = true, oldPicker: Bool = false) {
		self.aether = aether
		self.burn = burn
		self.oldPicker = oldPicker

		super.init(frame: CGRect(x: 0, y: 0, width: self.aether.width, height: self.aether.height))
		
        backgroundColor = Skin.backColor
		scrollView.backgroundColor = UIColor.clear

		addSubview(scrollView)

		if !oldPicker {
			addSubview(aetherHover)
            aetherHover.frame = CGRect(x: 4*gS, y: Screen.mac ? 3*gS : Screen.safeTop, width: Screen.mac ? 300*gS : 240*gS, height: Screen.mac ? 40*gS : 32*gS)
            aetherHover.hookView.addAction { [unowned self] in
                if aetherHover.aetherNameView.editing { aetherHover.controller.onAetherViewReturn() }
				self.slideToggle()
			}
		} else if toolsOn {
			aetherPicker = AetherPicker(aetherView: self)
			aetherPicker?.invoke()
		}
		
		if #available(iOS 11.0, *) {
			scrollView.contentInsetAdjustmentBehavior = .never
		}
		scrollView.contentOffset = CGPoint(x: aether.xOffset, y: aether.yOffset)
		scrollView.delegate = self
		
		initToolBars(toolBox: toolBox)
		if toolsOn { bubbleToolBar?.invoke() }

		openAether(aether)
		
		scrollView.scrollsToTop = false
		
		if !Screen.mac {
			scrollView.showsVerticalScrollIndicator = false
			scrollView.showsHorizontalScrollIndicator = false
		}
		
//		if Screen.mac {
//			orb = AetherViewOrb(aetherView: self)
//		}
		
		anchoring.start()
		
		makeGesture.delegate = self
		scrollView.addGestureRecognizer(makeGesture)
		
		focusTapGesture.delegate = self
		scrollView.addGestureRecognizer(focusTapGesture)
        
		scrollView.addGestureRecognizer(tapGesture)
		
		doubleTap.delegate = self
		scrollView.addGestureRecognizer(doubleTap)
		
		let citeGesture = CiteGesture(aetherView: self)
		scrollView.addGestureRecognizer(citeGesture)
		
		anchorTap.delegate = self
		scrollView.addGestureRecognizer(anchorTap)
		
        anchorDoubleTapGesture.delegate = self
        scrollView.addGestureRecognizer(anchorDoubleTapGesture)
        
		anchorPan.delegate = self
		scrollView.addGestureRecognizer(anchorPan)
		
		let aetherTap = AetherTap(aetherView: self)
		scrollView.addGestureRecognizer(aetherTap)
		
		let pasteGesture = PasteGesture(aetherView: self)
		scrollView.addGestureRecognizer(pasteGesture)

		NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillChangeFrame(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
//		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        safeZone.isUserInteractionEnabled = false
//        addSubview(safeZone)
	}
	
    public convenience init(aether: Aether, toolsOn: Bool = true, burn: Bool = true, oldPicker: Bool = false) {
		var tools: [[Tool?]] = Array(repeating: Array(repeating: nil, count: 5), count: 2)
		
		tools[0][0] = AetherView.objectTool
		tools[1][0] = AetherView.gateTool
		tools[0][1] = AetherView.mechTool
		tools[1][1] = AetherView.tailTool
		tools[0][2] = AetherView.gridTool
//		tools[1][2] = AetherView.typeTool
		tools[0][3] = AetherView.cronTool
		tools[0][4] = AetherView.textTool
//		tools[0][5] = AetherView.alsoTool
		
        self.init(aether: aether, toolBox: ToolBox(tools), toolsOn: toolsOn, burn: burn, oldPicker: oldPicker)
	}
	public convenience init() {
		self.init(aether: Aether())
	}
	public required init?(coder aDecoder: NSCoder) { fatalError() }
    
// GadgetDelegate ==================================================================================
    let safeZone: UIView = ColorView(.red.alpha(0.5))
    
    private var isFullScreen: Bool { max(Screen.width, Screen.height) == max(width, height) && min(Screen.width, Screen.height) == min(width, height) }
    private let macPadding: CGFloat = 6*Screen.s
    private let iOSPadding: CGFloat = 3*Screen.s

    public var safeTop: CGFloat {
        if Screen.mac { return macPadding }
        if isFullScreen { return max(Screen.safeTop+(Screen.iPhone ? -s : 3*s), iOSPadding) }
        return iOSPadding
    }
    public var safeBottom: CGFloat {
        if Screen.mac { return macPadding + 2*s }
        if isFullScreen { return max(Screen.safeBottom, iOSPadding) }
        return iOSPadding
    }
    public var safeLeft: CGFloat {
        if Screen.mac { return macPadding }
        if isFullScreen { return max(Screen.safeLeft, iOSPadding) }
        return iOSPadding
    }
    public var safeRight: CGFloat {
        if Screen.mac { return macPadding + 2*s }
        if isFullScreen { return max(Screen.safeRight, iOSPadding) }
        return iOSPadding
    }
    
// =================================================================================================
	
	public func reload() {
		closeCurrentAether()
		openAether(aether)
	}
	public func makePannable() {
		guard Screen.mac else { return }
		let gesture = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
		scrollView.addGestureRecognizer(gesture)
	}
	let dx: CGFloat = Screen.iPhone ? Screen.width - 20*Screen.s : 365*Screen.s
	func slideOff() {
		guard left == 0 else { return }
		self.layer.shadowOffset = CGSize(width: -3, height: 0)
		self.layer.shadowOpacity = 1
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowRadius = 8
		lock()
		UIView.animate(withDuration: 0.2) { [unowned self] in
			self.frame = self.frame.offsetBy(dx: dx, dy: 0)
		}
	}
	func slideBack() {
		guard abs(left-dx) < 0.00001 else { print("\(left) != \(dx)"); return }
		self.layer.shadowOffset = CGSize(width: -3, height: 0)
		self.layer.shadowOpacity = 1
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowRadius = 8
		UIView.animate(withDuration: 0.2) { [unowned self] in
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
		} completion: { (complete: Bool) in
			self.unlock()
		}
	}
	func slideToggle() {
        if self.left == 0 { slideOff() }
		else { slideBack() }
	}
	var tripWire: UITapGestureRecognizer!
	var lockedHovers: [Hover] = []
	func lock() {
		lockedHovers = hovers
		scrollView.isUserInteractionEnabled = false
		lockedHovers.forEach { $0.isUserInteractionEnabled = false }
		focus?.releaseFocus()
		retract()
		tripWire = UITapGestureRecognizer(target: self, action: #selector(onTrip))
		addGestureRecognizer(tripWire)
	}
	func unlock() {
		scrollView.isUserInteractionEnabled = true
		lockedHovers.forEach { $0.isUserInteractionEnabled = true }
		removeGestureRecognizer(tripWire)
	}
	@objc func onTrip() {
		slideBack()
	}
	
// Hovers ==========================================================================================
	func add(hover: Hover) {
		guard hover.aetherView === self else { fatalError() }
		hovers.append(hover)
		addSubview(hover)
	}
	func remove(hover: Hover) {
		guard hover.aetherView === self else { fatalError() }
		hovers.remove(object: hover)
		hover.removeFromSuperview()
	}
	func invoked(hover: Hover) -> Bool {
		return hovers.contains(hover)
	}
	func retract() {
		hovers.forEach { $0.retract() }
	}
	
// Orb =============================================================================================
	private func render(orbit: Orbit) {
		var x: CGFloat
		var y: CGFloat
		
		let offsetX: CGFloat = (orbit.offset.horizontal - 14) * hoverScale
		let offsetY: CGFloat = (orbit.offset.vertical - 14) * hoverScale
		
		x = width - hoverScale*orbit.size.width + offsetX
		y = height - hoverScale*orbit.size.height + offsetY
		
		orbit.frame = CGRect(x: x, y: y, width: hoverScale*orbit.size.width, height: hoverScale*orbit.size.height)
	}
	func orb(it orbit: Orbit) {
		guard orbit.superview == nil else { return }
		render(orbit: orbit)
		addSubview(orbit)
		orbit.alpha = 0
		UIView.animate(withDuration: 0.2) {
			orbit.alpha = 1
//		} completion: { (completed: Bool) in
//			orbit.onFadeIn()
		}
	}
	func deorb(it orbit: Orbit) {
		UIView.animate(withDuration: 0.2) {
			orbit.alpha = 0
		} completion: { (completed: Bool) in
			guard completed else { return }
			orbit.removeFromSuperview()
//			self.onFadeOut()
		}
	}
	
// Bubbles =========================================================================================
	func add(bubble: Bubble) {
		bubbles.append(bubble)
		scrollView.addSubview(bubble)
		bubble.aetherView = self
	}
	func remove(bubbles: Set<Bubble>) {
		for bubble in bubbles {
			for tower in bubble.aexel.towers {
				moorings[tower.variableToken] = nil
				aether.wipe(token: tower.variableToken)
			}
			bubble.onRemove()
			bubble.removeFromSuperview()
			self.bubbles.remove(object: bubble)
		}
	}
	func remove(bubble: Bubble) {
		remove(bubbles: Set<Bubble>([bubble]))
	}
	func removeAllBubbles() {
		remove(bubbles: Set<Bubble>(bubbles))
	}
	func bubble(aexel: Aexel) -> Bubble {
		for bubble in bubbles {
			if aexel === bubble.aexel {return bubble}
		}
		fatalError()
	}
	func typeBub(name: String) -> TypeBub? {
		return bubbles.first(where: {$0 is TypeBub && ($0 as! TypeBub).type.name == name}) as! TypeBub?
	}
	
// Doodles =========================================================================================
	func add(doodle: Doodle) {
		doodles.append(doodle)
		scrollView.layer.insertSublayer(doodle, at: 0)
	}
	func remove(doodle: Doodle) {
        doodle.removeFromSuperlayer()
		doodles.remove(object: doodle)
	}
	func removeAllDoodles() {
        doodles.forEach { $0.removeFromSuperlayer() }
		doodles.removeAll()
	}
	
// =================================================================================================
	func makeFocus(editable: Editable, dismissEditor: Bool = true) {
		clearFocus(dismissEditor: dismissEditor)
		focus = editable
		editable.onMakeFocus()
        
        if let delegate = editable as? ChainViewDelegate {
            responder.chainView = delegate.chainView
        }

        if !orb.hasOrbits { orb.launch(orbit: editable.editor) }
	}
	func clearFocus(dismissEditor: Bool = true) {
		guard let focus else { return }
		self.focus = nil
		focus.onReleaseFocus()
		if dismissEditor {
            orb.deorbit()
//            if focus is ChainViewDelegate { DispatchQueue.main.async { self.responder.resignFirstResponder() } }
        }
	}
	
// Aethers =========================================================================================
	public func closeCurrentAether() {
		saveAether()
		clearFocus()
		aetherViewDelegate?.onClose(aetherView: self, aether: aether)
		removeAllBubbles()
		removeAllDoodles()
	}
	public func openAether(_ aether: Aether) {
		self.aether = aether
		
		aetherPicker?.aetherButton.setNeedsDisplay()
        aetherHover.aetherNameView.setNeedsDisplay()
		
		readOnly = aether.readOnly
		if readOnly { dismissToolBars() }
		else { showToolBars() }

		aether.aexels.forEach { (aexel: Aexel) in
			switch aexel.type {
				case "object":	add(bubble: ObjectBub(aexel as! Object, aetherView: self))
				case "gate":	add(bubble: GateBub(aexel as! Gate, aetherView: self))
				case "mech":	add(bubble: MechBub(aexel as! Mech, aetherView: self))
				case "tail":	add(bubble: TailBub(aexel as! Tail, aetherView: self))
				case "auto":	add(bubble: AutoBub(aexel as! Auto, aetherView: self))
				case "oovi":	add(bubble: OoviBub(aexel as! Oovi, aetherView: self))
				case "grid":	add(bubble: GridBub(aexel as! Grid, aetherView: self))
				case "type":	add(bubble: TypeBub(aexel as! Type, aetherView: self))
				case "miru":	add(bubble: MiruBub(aexel as! Miru, aetherView: self))
				case "cron":	add(bubble: CronBub(aexel as! Cron, aetherView: self))
				case "text":	add(bubble: TextBub(aexel as! Text, aetherView: self))
				case "also":	add(bubble: AlsoBub(aexel as! Also, aetherView: self))
				default:		print("invalid type [\(aexel.type ?? "nil")]")
			}
		}

		bubbles.forEach { $0.wire() }
		bubbles.forEach { $0.frame = CGRect(origin: CGPoint(x: $0.aexel.x, y: $0.aexel.y), size: $0.bounds.size) }
		stretch(animated:false)

		let c0: CGPoint = CGPoint(x: aether.xOffset, y: aether.yOffset)
		let a0: CGPoint = CGPoint(x: aether.width, y: aether.height)
        let a1: CGPoint = a0 == .zero ? .zero : CGPoint(x: width, y: height)
		scrollView.setContentOffset(c0-a0+a1, animated: false)

		aetherViewDelegate?.onOpen(aetherView: self, aether: aether)
	}
	public func saveAether(complete: @escaping (Bool)->() = {Bool in}) {
		markPositions()
        facade?.store(aether: aether, { (success: Bool) in
            complete(success)
            self.aetherViewDelegate?.onSave(aetherView: self, aether: self.aether)
        })
	}
	public func swapToAether(facade: AetherFacade? = nil, aether: Aether) {
		closeCurrentAether()
		self.facade = facade
		openAether(aether)
		if oldPicker { aetherPicker?.retract() }
	}
	public func swapToAether(_ facadeAether: (facade: AetherFacade, aether: Aether)) {
		swapToAether(facade: facadeAether.0, aether: facadeAether.1)
	}
	public func clearAether() {
		self.aether.removeAllAexels()
		UIView.animate(withDuration: 0.2, animations: {
			self.bubbles.forEach {$0.alpha = 0}
			self.doodles.forEach {$0.opacity = 0}
		}) { (finsihed: Bool) in
			self.removeAllBubbles()
            self.removeAllDoodles()
		}
	}
	
	func triggerMaker(at: V2) {
		let bubble = maker.make(aetherView: self, at: at)
		add(bubble: bubble)
		bubble.create()
		stretch()
		bubbleToolBar?.recoil()
	}
	
	public func markPositions() {
		aether.version = Aether.engineVersion

		guard !readOnly else { return }

		aether.xOffset = Double(scrollView.contentOffset.x)
		aether.yOffset = Double(scrollView.contentOffset.y)
		aether.width = Double(bounds.size.width)
		aether.height = Double(bounds.size.height)
		for bubble in bubbles {
			bubble.aexel.x = Double(bubble.left)
			bubble.aexel.y = Double(bubble.top)
		}
	}
	
// Links ===========================================================================================
	var moorings: [Token:Mooring] = [:]
	func mooring(token: Token) -> Mooring? {
		return moorings[token]
	}
	func link(from: Mooring, to: Mooring, wake: Bool) {
		let linkDoodle = from.link(mooring: to, wake: wake)
		add(doodle: linkDoodle)
	}
	func link(from: Mooring, to: Mooring) {
		self.link(from: from, to: to, wake: true)
	}
	func unlink(from: Mooring, to: Mooring) {
		from.unlink(mooring: to)
		for doodle in from.doodles {
			if doodle.to === to {
				doodles.remove(object: doodle)
			}
		}
	}
	
// Stretch =========================================================================================
	func snapBack() {
		scrollView.setContentOffset(CGPoint(x: aether.xOffset, y: aether.yOffset), animated: false)
	}
	func homing(current: CGFloat, extent: CGFloat) -> CGFloat {
		return min(max(current, 0), extent)
	}
	
	private func findOrbit() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
		var maxLeft: CGFloat = 0
		var minRight: CGFloat = CGFloat.greatestFiniteMagnitude
		var maxTop: CGFloat = 0
		var minBottom: CGFloat = CGFloat.greatestFiniteMagnitude
		
		for bubble in bubbles {
			maxLeft	  = max(maxLeft,   bubble.left + max(0, bubble.width-100))
			minRight  = min(minRight,  bubble.left + min(bubble.width, 100))
			maxTop	  = max(maxTop,	   bubble.top + max(0, bubble.height-36))
			minBottom = min(minBottom, bubble.top + min(bubble.height, 36))
		}
	
		return (minRight, minBottom, maxLeft-minRight, maxTop-minBottom)
	}
	public func stretch(animated: Bool) {
		let wx = width != 0 ? width : CGFloat(aether.width)
		let wy = height != 0 ? height : CGFloat(aether.height)
		
		guard bubbles.count > 0 else {
			scrollView.contentSize = CGSize(width: wx, height: wy)
			scrollView.contentOffset = CGPoint.zero
			return
		}

		let (minRight, minBottom, orbitWidth, orbitHeight) = findOrbit()
		
		let offset = scrollView.contentOffset
		scrollView.contentSize = CGSize(width: wx*2+orbitWidth, height: wy*2+orbitHeight)
		let dx = minRight-wx
		let dy = minBottom-wy
		for bubble in bubbles {
			bubble.frame = CGRect(x: bubble.left-dx, y: bubble.top-dy, width: bubble.width, height: bubble.height)
		}
		scrollView.contentOffset = CGPoint(x: offset.x-dx, y: offset.y-dy)
		scrollView.setContentOffset(CGPoint(x: homing(current: offset.x-dx, extent: wx+orbitWidth), y: homing(current: offset.y-dy, extent: wy+orbitHeight)), animated: animated)
		
//		print("Stretch Report ======================")
//		print("aetherView.size:(\(width),\(height))")
//		print("wx: \(wx), wy: \(wy)")
//		print("maxLeft: \(maxLeft), minRight: \(minRight), maxTop: \(maxTop), minBottom: \(minBottom)")
//		print("contentSize: \(contentSize)")
//		print("contentInset: \(contentInset)")
//		print("contentOffset: \(contentOffset)")
//		print("    bubbles =========================")
//		for bubble in bubbles {
//			print("      \(bubble.aexel.name), anchor: (\(bubble.anchor.x),\(bubble.anchor.y)), aexel.pos: (\(bubble.aexel.x),\(bubble.aexel.y)), size: \(bubble.frame)")
//		}
//		print("====================================\n\n")
	}
	public func stretch() {
		stretch(animated: true)
	}
	func spread() {
		guard bubbles.count > 0 else { return }
		let w = max(width, height)
		let (_, _, orbitWidth, orbitHeight) = findOrbit()
		scrollView.contentSize = CGSize(width: w*2+orbitWidth, height: w*2+orbitHeight)
	}
	
// Selected ========================================================================================
    private var selectedIsHomogeneous: Bool {
        guard let first = selected.first else { return false }
        return selected.allSatisfy { type(of: first) == type(of: $0) }
    }
	private func invokeContext() {
        guard !orb.hasOrbits || orb.isContext else { return }
        guard let first: Bubble = selected.first else { orb.deorbit(); return }
        
        let context: Context
        if selected.count == 1 {
            context = first.context
        } else if selectedIsHomogeneous {
            context = first.multiContext
        } else {
            context = orb.multiContext
        }
        
        if orb.current === context { return }
        if orb.current != nil { orb.deorbit() }
        orb.launch(orbit: context)
	}
	func select(bubbles: [Bubble]) {
        guard bubbles.count > 0 else { return }
        bubbles.forEach {
            guard $0.selectable else { return }
            $0.select()
            selected.insert($0)
        }
        invokeContext()
	}
	func select(path: CGPath) {
		select(bubbles: bubbles.filter({path.contains($0.center)}))
	}
	func select(bubble: Bubble) {
        guard focus == nil else { return }
		select(bubbles: [bubble])
	}
	func unselect(bubble: Bubble) {
		bubble.unselect()
		selected.remove(at: selected.firstIndex(of: bubble)!)
		invokeContext()
	}
	func unselectAll() {
		for bubble in selected {
			bubble.unselect()
		}
		selected.removeAll()
		invokeContext()
	}
	func setSelectedsStartPoint() {
        selected.forEach { $0.setStartPoint() }
	}
	func moveSelected(by: CGPoint) {
		selected.forEach { $0.move(by: by) }
	}
	func deleteSelected() {
		remove(bubbles: selected)

		var deleted: Set<Tower> = Set<Tower>()
		selected.forEach {deleted.formUnion($0.aexel.towers)}
		
		var affected: Set<Tower> = Set<Tower>()
		deleted.forEach {affected.formUnion($0.allDownstream())}
		affected.subtract(deleted)
		
		for tower in deleted {
			tower.variableToken.status = .deleted
			tower.variableToken.label = "DELETED"
			if tower.variableToken.type == .variable {
				AEMemoryUnfix(aether.memory, tower.index)
			}
			tower.abstract()
		}
		
		aether.evaluate(towers: affected)

		selected.forEach {aether.removeAexel($0.aexel)}

		aether.buildMemory()
		stretch()
		orb.chainEditor.customSchematic?.render(aether: aether)
	}
	func copyBubbles() {
		copyBuffer = selected
		unselectAll()
	}
	func pasteBubbles(at: CGPoint) {
		guard let first = copyBuffer.first else { return }
		let anchor = first.frame.origin
		for bubble in copyBuffer {
			let copy: Bubble = bubble.copy() as! Bubble
			let pos = bubble.frame.origin
			copy.frame = CGRect(origin: at+pos-anchor, size: copy.frame.size)
			add(bubble: copy)
		}
	}
	
// Events ==========================================================================================
	@objc func onTap() {
		retract()
		unselectAll()
	}
	private var s0: CGPoint = .zero
	@objc func onPan(_ gesture: UIPanGestureRecognizer) {
		let ds: CGPoint = gesture.translation(in: scrollView)
		switch gesture.state {
			case .began:
				s0 = scrollView.contentOffset
			case .changed:
				scrollView.contentOffset = s0-ds
			default: break
		}
	}
	@objc func onKeyboardWillHide(_ notification: Notification) {
		guard let y: CGFloat = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height, y != 0 else { return }
		UIApplication.shared.sendAction(#selector(UIView.resignFirstResponder), to: nil, from: nil, for: nil)
	}
	@objc func onKeyboardWillChangeFrame(_ notification: Notification) {
		guard let textLeaf = currentTextLeaf, let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }

		let point = scrollView.contentOffset

		let fY = textLeaf.bubble.bottom
		let cY = scrollView.contentOffset.y
		let wY = Screen.height
		let kY = keyboardFrame.height

		let y = (fY-cY) - (wY-kY)
		if y > 0 {
			scrollView.setContentOffset(CGPoint(x: point.x, y: point.y+y+32), animated: true)
		}
	}

// AnchorDoubleTappable ============================================================================
    @objc func onAnchorDoubleTap(point: CGPoint) {
        pasteBubbles(at: point)
        stretch()
    }

// UIScrollViewDelegate ============================================================================
	public func scrollViewDidScroll(_ scrollView: UIScrollView) {
		if lockVerticalScrolling {scrollView.contentOffset.x = CGFloat(aether.xOffset)}
	}
	public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		if needsStretch {
			stretch()
			needsStretch = false
		}
	}

// UIGestureRecognizerDelegate =====================================================================
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		guard !Screen.mac else { return true }
		if gestureRecognizer === anchorPan && otherGestureRecognizer is DoubleTap { return false }
		if gestureRecognizer is DoubleTap && otherGestureRecognizer === anchorPan { return false }
		return true
	}

// ToolBars ========================================================================================
	public func snuffToolBars() {
		bubbleToolBar?.dismiss(animated: false)
		shapeToolBar?.dismiss(animated: false)
		colorToolBar?.dismiss(animated: false)
		aetherPicker?.dismiss(animated: false)
	}
	public func dismissToolBars() {
		bubbleToolBar?.dismiss()
		shapeToolBar?.dismiss()
		colorToolBar?.dismiss()
	}
	public func showToolBars() {
		guard !readOnly else { return }
		if let toolBar = bubbleToolBar { toolBar.invoke() }
	}
	public func renderToolBars() {
		bubbleToolBar?.render()
		shapeToolBar?.render()
		colorToolBar?.render()
	}
	func initToolBars(toolBox: ToolBox) {
		bubbleToolBar = BubbleToolBar(aetherView: self, toolBox: toolBox)
		bubbleToolBar!.onSelect = { [unowned self] (tool: Tool) in
			let bubbleTool: BubbleTool = tool as! BubbleTool
			self.maker = bubbleTool.maker
		}

		if toolBox.contains(AetherView.textTool) {
			shapeToolBar = ShapeToolBar(aetherView: self)
			shapeToolBar!.onSelect = { [unowned self] (tool: Tool) in
				let shapeTool: ShapeTool = tool as! ShapeTool
				self.shape = shapeTool.shape
			}

			colorToolBar = ColorToolBar(aetherView: self)
			colorToolBar!.onSelect = { [unowned self] (tool: Tool) in
				let colorTool: ColorTool = tool as! ColorTool
				self.color = colorTool.color
			}
		}
	}
	private func findOrigin() -> CGPoint {
		var origin: CGPoint = CGPoint(x: 0, y: 0)
		var view: UIView? = self
		while view != nil {
			origin = origin + view!.frame.origin
			view = view!.superview
		}
		return origin
	}
	public func placeToolBars() {
		let fixedOffset: UIOffset = toolBarOffset ?? UIOffset(horizontal: -12, vertical: 12)		
		bubbleToolBar?.fixed = fixedOffset
		shapeToolBar?.fixed = fixedOffset
		colorToolBar?.fixed = fixedOffset
	}
	public func invokeBubbleToolBar() {
		bubbleToolBar?.invoke()
	}
	public func dismissBubbleToolBar() {
		bubbleToolBar?.dismiss()
	}
	
	public func layoutAetherPicker() {
		let fullScreen: Bool = (width == Screen.width && height == Screen.height) || (width == Screen.height && height == Screen.width)
		let origin: CGPoint = findOrigin()
		
		let fixedOffset: UIOffset
		if fullScreen {
			fixedOffset = UIOffset(horizontal: origin.x+aetherPickerOffset.horizontal, vertical: origin.y+aetherPickerOffset.vertical)
		} else {
			fixedOffset = UIOffset(horizontal: origin.x+9+aetherPickerOffset.horizontal, vertical: origin.y+9-Screen.safeTop+aetherPickerOffset.vertical)
		}
		
		aetherPicker?.fixed = fixedOffset
	}
	public func invokeAetherPicker() {
		layoutAetherPicker()
		aetherPicker?.invoke()
	}
	public func snapAetherPicker() {
		aetherPicker?.invoke(animated: false)
	}
	public func dismissAetherPicker() {
		aetherPicker?.dismiss()
	}

	func invokeAetherInfo() {
		let aetherInfo: AetherInfo = AetherInfo(aetherView: self)
		aetherInfo.invoke()
	}

	func invokeShapeToolBar() {
		shapeToolBar?.invoke()
	}
	func dismissShapeToolBar() {
		shapeToolBar?.dismiss()
	}
	func contractShapeToolBar() {
		shapeToolBar?.contract()
	}
	
	func invokeColorToolBar() {
		colorToolBar?.invoke()
	}
	func dismissColorToolBar() {
		colorToolBar?.dismiss()
	}
	func contractColorToolBar() {
		colorToolBar?.contract()
	}
	public func invokeMessageHover(_ message: String) {
		let messageHover: MessageHover = MessageHover(aetherView: self)
		messageHover.message = message
		messageHover.invoke()
	}
	public func invokeConfirmModal(_ message: String, _ closure: @escaping()->()) {
		let confirmModal: ConfirmModal = ConfirmModal(aetherView: self)
        confirmModal.message = message
        confirmModal.closure = closure
        confirmModal.invoke()
	}

// UIView ==========================================================================================
    public override var frame: CGRect {
        didSet {
            stretch()
        }
    }
	public override func layoutSubviews() {
		backView?.frame = bounds
		scrollView.frame = bounds
		hovers.forEach { $0.render() }
        aetherHover.frame = CGRect(x: safeLeft, y: safeTop, width: Screen.mac ? 300*gS : 270*gS, height: 32*Oo.s)
        safeZone.frame = CGRect(x: safeLeft, y: safeTop, width: width-safeLeft-safeRight, height: height-safeTop-safeBottom)
        orb.layout()
//		if orb is AetherViewOrb { orb.orbits.forEach { render(orbit: $0) } }
	}
	
// Static ==========================================================================================
	public static let objectTool = BubbleTool(maker: ObjectMaker())
	public static let gateTool = BubbleTool(maker: GateMaker(), recoil: objectTool)
	public static let mechTool = BubbleTool(maker: MechMaker(), recoil: objectTool)
	public static let tailTool = BubbleTool(maker: TailMaker(), recoil: objectTool)
	public static let gridTool = BubbleTool(maker: GridMaker(), recoil: objectTool)
	public static let typeTool = BubbleTool(maker: TypeMaker())
	public static let cronTool = BubbleTool(maker: CronMaker(), recoil: objectTool)
	public static let textTool = BubbleTool(maker: TextMaker())
	public static let alsoTool = BubbleTool(maker: AlsoMaker(), recoil: objectTool)
	
	public static let ooviTool = BubbleTool(maker: OoviMaker(), recoil: objectTool)
}
