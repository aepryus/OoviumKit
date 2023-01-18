//
//  AnCyanKeyPad.swift
//  OoviumKit
//
//  Created by Joe Charlier on 1/13/23.
//  Copyright © 2023 Aepryus Software. All rights reserved.
//

import OoviumEngine
import UIKit

class AnCyanKeyPad: KeyView {
    let anainEditor: AnainEditor
    
    init(anainEditor: AnainEditor) {
        self.anainEditor = anainEditor
        
        let cyanSchematic = Schematic(rows: 5, cols: 1)
        
//        super.init(anchor: .bottomRight, offset: UIOffset(horizontal: -174-6-1, vertical: -6), size: CGSize(width: 54, height: 214), fixedOffset: UIOffset(horizontal: 0, vertical: 0), uiColor: UIColor.cyan, schematic: cyanSchematic)
        super.init(size: CGSize(width: 54, height: 214), uiColor: UIColor.cyan, schematic: cyanSchematic)
        
        for (i, schematic) in anainEditor.schematics.enumerated() {
            cyanSchematic.add(row: CGFloat(i), col: 0, key: ImageKey(image: UIImage(named: schematic.imageNamed, in: Bundle(for: type(of: self)), with: nil)!, uiColor: UIColor.cyan, activeColor: UIColor.cyan.tint(0.8), {
                self.anainEditor.keyView.schematic = schematic
                for j in 0..<cyanSchematic.keySlots.count {
                    if let key: Key = cyanSchematic.keySlots[j].key as? Key {
                        key.active = false
                    } else if let key: ImageKey = cyanSchematic.keySlots[j].key as? ImageKey {
                        key.active = false
                    }
                }
                (cyanSchematic.keySlots[i].key as! ImageKey).active = true
            }))
        }
        
        self.schematic = cyanSchematic
        
        (cyanSchematic.keySlots[0].key as! ImageKey).active = true
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }
    
    var isInvoked: Bool {
        return superview != nil
    }

    func invoke() {
        anainEditor.addSubview(self)
        alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    func dismiss() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { (completed: Bool) in
            self.removeFromSuperview()
        }
    }
    func toggle() {
        if isInvoked {
            dismiss()
        } else {
            invoke()
        }
    }
}
