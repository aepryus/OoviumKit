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
public extension AetherViewDelegate {
	func onNew(aetherView: AetherView, aether: Aether) {}
	func onClose(aetherView: AetherView, aether: Aether) {}
	func onOpen(aetherView: AetherView, aether: Aether) {}
	func onSave(aetherView: AetherView, aether: Aether) {}
}

public class AetherView: UIView, UIScrollViewDelegate, UIGestureRecognizerDelegate, AnchorDoubleTappable, GadgetDelegate {
	public var aether: Aether
    var citadel: Citadel
    public var facade: AetherFacade?
    
    lazy var responder: ChainResponder = { ChainResponder(aetherView: self) }()
    lazy var anResponder: AnainResponder = { AnainResponder(aetherView: self) }()

    let scrollView: UIScrollView = UIScrollView()
	
	public weak var aetherViewDelegate: AetherViewDelegate? = nil
	
	var maker: Maker = ObjectMaker()
	var shape: Text.Shape = .ellipse
	var color: Text.Color = .lime
	
	var bubbles: [Bubble] = [Bubble]()
	var doodles: [Doodle] = [Doodle]()
    
    let raphus: Raphus = Raphus()
	
	var aetherScale: CGFloat { Oo.s }
	var hoverScale: CGFloat { Oo.s }
	
	var readOnly: Bool = false
	private(set) var focus: Editable? = nil
	public var selected: Set<Bubble> = Set<Bubble>()
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
	
	public init(toolBox: ToolBox, toolsOn: Bool = true, burn: Bool = true, oldPicker: Bool = false) {
		aether = Aether()
        citadel = aether.compile()

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
		} else {
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
	}
	
    public convenience init(toolsOn: Bool = true, burn: Bool = true, oldPicker: Bool = false) {
		var tools: [[Tool?]] = Array(repeating: Array(repeating: nil, count: 10), count: 2)
		
		tools[0][0] = AetherView.objectTool
		tools[1][0] = AetherView.gateTool
		tools[0][1] = AetherView.mechTool
		tools[1][1] = AetherView.tailTool
		tools[0][2] = AetherView.gridTool
//		tools[1][2] = AetherView.typeTool
		tools[0][3] = AetherView.cronTool
		tools[0][4] = AetherView.textTool
//        tools[0][5] = AetherView.analyticTool
//        tools[0][6] = AetherView.systemTool
//        tools[0][7] = AetherView.coordinateTool
//        tools[0][8] = AetherView.tensorTool
//        tools[0][9] = AetherView.graphTool
//		tools[0][5] = AetherView.alsoTool
		
        self.init(toolBox: ToolBox(tools), toolsOn: toolsOn, burn: burn, oldPicker: oldPicker)
	}
	public required init?(coder aDecoder: NSCoder) { fatalError() }
    
    public func compileAether() {
        citadel = aether.compile()
        citadel.notifyListeners()
    }
    
    public func create<T: Aexel>(at: V2) -> T {
        let aexel: T = aether.create(at: at)
        citadel.plugIn(aexons: [aexel])
        return aexel
    }
    
    public func printTowers() { citadel.printTowers() }
    
// Events ==========================================================================================
    public func onReturn() {
        if let modal: AlertModal = Modal.current as? AlertModal { modal.ok() }
    }
    public func onEscape() {
        if let modal: Modal = Modal.current { modal.dismiss() }
        else if let focus { focus.cancelFocus() }
        else { unselectAll() }
    }
    public func onCut() {
        onCopy()
        deleteSelected()
    }
    public func onCopy() {
        markPositions()
        // General ======================
        if selected.count == 1, let bubble: Bubble = selected.first {
            if let objectBub: ObjectBub = bubble as? ObjectBub {
                UIPasteboard.general.string = citadel.value(key: objectBub.object.tokenKey)
            } else if let gateBub: GateBub = bubble as? GateBub {
                UIPasteboard.general.string = citadel.value(key: gateBub.gate.tokenKey)
            } else if let cronBub: CronBub = bubble as? CronBub {
                UIPasteboard.general.string = citadel.value(key: cronBub.cron.tokenKey)
            } else if let textBub: TextBub = bubble as? TextBub {
                UIPasteboard.general.string = textBub.text.name
            } else if let gridBub: GridBub = bubble as? GridBub {
                var string: String = ""
                
                gridBub.grid.columns.forEach({ string += "\($0.name)," })
                string.removeLast()
                string += "\n"

                for i: Int in 1...gridBub.grid.rows {
                    for j: Int in 1...gridBub.grid.columns.count {
                        string += "\(citadel.value(key: gridBub.grid.cell(colNo: j, rowNo: i).chain.key!) ?? "0"),"
                    }
                    string.removeLast()
                    string += "\n"
                }

                UIPasteboard.general.string = string
            }
        } else {
            UIPasteboard.general.string = nil
        }

        // Oovium =======================
        let array: [[String:Any]] = selected.compactMap({ $0.aexel }).map({ $0.unload() })
        UIPasteboard.oovium.string = array.toJSON()
    }
    public func onPaste() {
        if responder.chainView == nil {
            guard let json: String = UIPasteboard.oovium.string else { return }
            let aexels: [Aexel] = citadel.paste(array: json.toArray())
            let bubbles: [Bubble] = aexels.map { createBubble(aexel: $0)! }
            bubbles.forEach { add(bubble: $0) }
            bubbles.forEach { $0.wireMoorings() }
            
            bubbles.forEach { $0.frame = CGRect(origin: CGPoint(x: $0.aexel.x, y: $0.aexel.y), size: $0.bounds.size) }
            stretch(animated:false)

            unselectAll()
            select(bubbles: bubbles)
            
            citadel.notifyListeners()
            
        } else {
            if let string: String = UIPasteboard.general.string {
                responder.paste(text: string)
            }
        }
    }

// GadgetDelegate ==================================================================================
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
    public func hideScrollIndicators() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
    }
    var dx: CGFloat { Screen.iPhone ? Screen.width - 20*Screen.s + Screen.safeLeft : 355*Screen.s }
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
		guard left > 0.00001 else { print("\(left) != \(dx)"); return }
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
        focus?.releaseFocus(.administrative)
		retract()
		tripWire = UITapGestureRecognizer(target: self, action: #selector(onTrip))
		addGestureRecognizer(tripWire)
	}
	func unlock() {
		scrollView.isUserInteractionEnabled = true
		lockedHovers.forEach { $0.isUserInteractionEnabled = true }
		removeGestureRecognizer(tripWire)
	}
	@objc func onTrip() { slideBack() }
	
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
	func invoked(hover: Hover) -> Bool { hovers.contains(hover) }
	func retract() { hovers.forEach { $0.retract() } }
	
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
		}
	}
	func deorb(it orbit: Orbit) {
		UIView.animate(withDuration: 0.2) {
			orbit.alpha = 0
		} completion: { (completed: Bool) in
			guard completed else { return }
			orbit.removeFromSuperview()
		}
	}
	
// Bubbles =========================================================================================
	func add(bubble: Bubble) {
		bubbles.append(bubble)
		scrollView.addSubview(bubble)
	}
	private func remove(bubbles: Set<Bubble>) {
        // Remove Doodles
        let moorings: [Mooring] = bubbles.flatMap { $0.moorings }
        var doodles: Set<LinkDoodle> = Set()
        moorings.forEach { doodles.formUnion($0.doodles) }
        doodles.forEach {
            $0.detangle()
            remove(doodle: $0)
        }
        
        // Remove Moorings
        moorings.compactMap({ $0.tokenKey }).forEach { self.moorings[$0] = nil }
        
        // Remove Bubbles
        bubbles.forEach {
            $0.onRemove()
            $0.removeFromSuperview()
            self.bubbles.remove(object: $0)
        }
	}
	func remove(bubble: Bubble) { remove(bubbles: Set<Bubble>([bubble])) }
	func removeAllBubbles() { remove(bubbles: Set<Bubble>(bubbles)) }
    func bubble(aexel: Aexel) -> Bubble { bubbles.first(where: { aexel === $0.aexel })! }
	func typeBub(name: String) -> TypeBub? { bubbles.first(where: {$0 is TypeBub && ($0 as! TypeBub).type.name == name}) as! TypeBub? }
	
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
		focus = editable
		editable.onMakeFocus()
        
        if let delegate = editable as? ChainViewDelegate {
            responder.chainView = delegate.chainView
        }

        if !orb.hasOrbits { orb.launch(orbit: editable.editor) }
	}
    func clearFocus(release: Release) {
		guard let focus else { return }
		self.focus = nil
		focus.onReleaseFocus()
        responder.chainView = nil
        let next: Editable? = focus.nextFocus(release: release)
        if let next { next.makeFocus() }
        else { orb.deorbit() }
	}
	
// Aethers =========================================================================================
	public func closeCurrentAether() {
		saveAether()
        focus?.releaseFocus(.administrative)
		aetherViewDelegate?.onClose(aetherView: self, aether: aether)
		removeAllBubbles()
		removeAllDoodles()
	}
    private func createBubble(aexel: Aexel) -> Bubble? {
        switch aexel.type {
            case "also":        return AlsoBub(aexel as! Also, aetherView: self)
            case "analytic":    return AnalyticBub(aexel as! Analytic, aetherView: self)
            case "auto":        return AutoBub(aexel as! Automata, aetherView: self)
            case "coordinate":  return CoordinateBub(aexel as! Coordinate, aetherView: self)
            case "cron":        return CronBub(aexel as! Cron, aetherView: self)
            case "gate":        return GateBub(aexel as! Gate, aetherView: self)
            case "graph":       return GraphBub(aexel as! Graph, aetherView: self)
            case "grid":        return GridBub(aexel as! Grid, aetherView: self)
            case "mech":        return MechBub(aexel as! Mech, aetherView: self)
            case "miru":        return MiruBub(aexel as! Miru, aetherView: self)
            case "object":      return ObjectBub(aexel as! Object, aetherView: self)
            case "oovi":        return OoviBub(aexel as! Oovi, aetherView: self)
            case "system":      return SystemBub(aexel as! System, aetherView: self)
            case "tail":        return TailBub(aexel as! Tail, aetherView: self)
            case "tensor":      return TensorBub(aexel as! Tensor, aetherView: self)
            case "text":        return TextBub(aexel as! Text, aetherView: self)
            case "type":        return TypeBub(aexel as! Type, aetherView: self)
            default:
                print("invalid type [\(aexel.type ?? "nil")]")
                return nil
        }
    }
	public func openAether(_ aether: Aether) {
		self.aether = aether
        compileAether()
		
		aetherPicker?.aetherButton.setNeedsDisplay()
        aetherHover.aetherNameView.setNeedsDisplay()
		
		readOnly = aether.readOnly
		if readOnly { dismissToolBars() }
		else { showToolBars() }
        
        aether.aexels.forEach { add(bubble: createBubble(aexel: $0)!) }
        
        citadel.notifyListeners()

		bubbles.forEach { $0.wireMoorings() }
		bubbles.forEach { $0.frame = CGRect(origin: CGPoint(x: $0.aexel.x, y: $0.aexel.y), size: $0.bounds.size) }
		stretch(animated:false)

		let c0: CGPoint = CGPoint(x: aether.xOffset, y: aether.yOffset)
		let a0: CGPoint = CGPoint(x: aether.width, y: aether.height)
        let a1: CGPoint = a0 == .zero ? .zero : CGPoint(x: width, y: height)
		scrollView.setContentOffset(c0-a0+a1, animated: false)
	}
	public func saveAether(complete: @escaping (Bool)->() = {Bool in}) {
		markPositions()
        guard let facade else { complete(false); return }
        facade.store(aether: aether, { (success: Bool) in
            complete(success)
            self.aetherViewDelegate?.onSave(aetherView: self, aether: self.aether)
        })
	}
	public func swapToAether(facade: AetherFacade? = nil, aether: Aether) {
		closeCurrentAether()
		self.facade = facade
		openAether(aether)
        raphus.wipe()
        dodo()
		if oldPicker { aetherPicker?.retract() }
        aetherViewDelegate?.onOpen(aetherView: self, aether: aether)
	}
	public func swapToAether(_ facadeAether: (facade: AetherFacade, aether: Aether)) {
		swapToAether(facade: facadeAether.0, aether: facadeAether.1)
	}
    public func swapToNewAether() {
        let dirFacade: DirFacade = Facade.create(space: Space.local) as! SpaceFacade
        dirFacade.loadFacades { (facades: [Facade]) in
            let aether: Aether = Aether()
            var aetherNo: Int = 0
            var name: String = ""
            repeat {
                aetherNo += 1
                name = String(format: "%@%02d", "aether".localized, aetherNo)
            } while facades.first { $0.name == name } != nil
            aether.name = name
            aether.width = Double(self.width)
            aether.height = Double(self.height)
            aether.xOffset = 400
            aether.yOffset = 260
            self.aetherViewDelegate?.onNew(aetherView: self, aether: aether)
            let url: URL = dirFacade.url.appendingPathComponent(aether.name).appendingPathExtension("oo")
            let aetherFacade: AetherFacade = Facade.create(url: url) as! AetherFacade
            aetherFacade.store(aether: aether) { (success: Bool) in
                guard success else { return }
                self.swapToAether(facade: aetherFacade, aether: aether)
            }
        }
    }
	public func clearAether() {
		UIView.animate(withDuration: 0.2, animations: {
			self.bubbles.forEach { $0.alpha = 0 }
			self.doodles.forEach { $0.opacity = 0 }
		}) { (finished: Bool) in
            self.delete(bubbles: Set(self.bubbles))
		}
	}
	
	func triggerMaker(at: V2) {
        if let focus { focus.releaseFocus(.administrative) }
		let bubble = maker.make(aetherView: self, at: at)
		add(bubble: bubble)
		bubble.create()
		stretch()
        dodo()
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
    
// Undo ============================================================================================
    public func dodo() {
        markPositions()
        raphus.dodo(json: aether.toJSON())
    }
    public func undo() {
        guard let json: String = raphus.undo() else { return }
        removeAllBubbles()
        removeAllDoodles()
        openAether(Aether(json: json))
    }
    public func redo() {
        guard let json: String = raphus.redo() else { return }
        removeAllBubbles()
        removeAllDoodles()
        openAether(Aether(json: json))
    }
	
// Links ===========================================================================================
	var moorings: [TokenKey:Mooring] = [:]
	
// Stretch =========================================================================================
	func snapBack() { scrollView.setContentOffset(CGPoint(x: aether.xOffset, y: aether.yOffset), animated: false) }
	func homing(current: CGFloat, extent: CGFloat) -> CGFloat { min(max(current, 0), extent) }
	
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
	public func stretch(animated: Bool = true) {
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
    func selectedDeletable() -> Bool { citadel.nukable(keys: selected.flatMap({ $0.aexel.tokenKeys })) }
    private func delete(bubbles: Set<Bubble>) {
        citadel.nuke(keys: bubbles.flatMap({ $0.aexel.tokenKeys }))
        remove(bubbles: bubbles)
        aether.remove(aexels: bubbles.map({ $0.aexel }))
        stretch()
        orb.chainEditor.customSchematic?.render(aether: aether)
        unselectAll()
        dodo()
    }
    func deleteSelected() { delete(bubbles: selected) }
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
            aether.addAexel(copy.aexel)
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
	public func invokeBubbleToolBar() { bubbleToolBar?.invoke() }
	public func dismissBubbleToolBar() { bubbleToolBar?.dismiss() }
	
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
	public func snapAetherPicker() { aetherPicker?.invoke(animated: false) }
	public func dismissAetherPicker() { aetherPicker?.dismiss() }

	func invokeShapeToolBar() { shapeToolBar?.invoke() }
    func dismissShapeToolBar() { shapeToolBar?.dismiss() }
	func contractShapeToolBar() { shapeToolBar?.contract() }
	
	func invokeColorToolBar() { colorToolBar?.invoke() }
	func dismissColorToolBar() { colorToolBar?.dismiss() }
	func contractColorToolBar() { colorToolBar?.contract() }
    
	public func invokeMessageHover(_ message: String) {
		let messageHover: MessageHover = MessageHover(aetherView: self)
		messageHover.message = message
		messageHover.invoke()
	}
	public func invokeConfirmModal(_ message: String, _ complete: @escaping()->()) {
        AlertModal(message: message, left: "No".localized, right: "Yes".localized, complete: complete).invoke()
	}
    public func invokeInfoModal(_ message: String, _ complete: (()->())? = nil) {
        AlertModal(message: message, right: "OK".localized, complete: complete).invoke()
    }

// UIView ==========================================================================================
    public override var frame: CGRect {
        didSet { stretch() }
    }
	public override func layoutSubviews() {
		backView?.frame = bounds
		scrollView.frame = bounds
		hovers.forEach { $0.render() }
        aetherHover.frame = CGRect(x: safeLeft, y: safeTop, width: Screen.mac ? 300*gS : 270*gS, height: 32*Oo.s)
        orb.layout()
	}
	
// Static ==========================================================================================
    public static let alsoTool = BubbleTool(maker: AlsoMaker(), recoil: objectTool)
    public static let analyticTool = BubbleTool(maker: AnalyticMaker())
    public static let coordinateTool = BubbleTool(maker: CoordinateMaker())
    public static let cronTool = BubbleTool(maker: CronMaker(), recoil: objectTool)
    public static let gateTool = BubbleTool(maker: GateMaker(), recoil: objectTool)
    public static let graphTool = BubbleTool(maker: GraphMaker())
    public static let gridTool = BubbleTool(maker: GridMaker(), recoil: objectTool)
    public static let mechTool = BubbleTool(maker: MechMaker(), recoil: objectTool)
	public static let objectTool = BubbleTool(maker: ObjectMaker())
    public static let systemTool = BubbleTool(maker: SystemMaker(), recoil: objectTool)
    public static let tailTool = BubbleTool(maker: TailMaker(), recoil: objectTool)
    public static let tensorTool = BubbleTool(maker: TensorMaker())
    public static let textTool = BubbleTool(maker: TextMaker())
    public static let typeTool = BubbleTool(maker: TypeMaker())

//	public static let ooviTool = BubbleTool(maker: OoviMaker(), recoil: objectTool)
}
