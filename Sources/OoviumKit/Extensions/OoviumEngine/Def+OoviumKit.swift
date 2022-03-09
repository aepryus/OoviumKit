//
//  Def+OoviumKit.swift
// 	OoviumKit
//
//  Created by Joe Charlier on 3/9/22.
//  Copyright © 2022 Aepryus Software. All rights reserved.
//

import UIKit
import OoviumEngine

extension Def {
	var uiColor: UIColor {
		if self === RealDef.def { return UIColor.green }
		else if self === ComplexDef.def { return UIColor.cyan }
		else if self === VectorDef.def { return OOColor.marine.uiColor }
		else if self === StringDef.def { return OOColor.peach.uiColor }
		else if self === LambdaDef.def { return UIColor.cyan }
		else if self === RecipeDef.def { return UIColor.blue }
		else if self === DateDef.def { return UIColor.yellow }
		return UIColor.red
	}
}
