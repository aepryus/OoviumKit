//
//  SignatureField.swift
//  Pangaea
//
//  Created by Joe Charlier on 2/17/18.
//  Copyright © 2018 Aepryus Software. All rights reserved.
//

import UIKit

class SignatureField: UITextField, NotTappable {
	override init(frame: CGRect) {
		super.init(frame: frame)
		
		self.textColor = UIColor.white
		font = UIFont.verdana(size: 15)
		autocapitalizationType = .none
		autocorrectionType = .no
		textAlignment = .center
		keyboardAppearance = .dark
		
		if #available(iOS 9.0, *) {
			inputAssistantItem.leadingBarButtonGroups.removeAll()
			inputAssistantItem.trailingBarButtonGroups.removeAll()
		}		
	}
	required init?(coder aDecoder: NSCoder) { fatalError() }
}
