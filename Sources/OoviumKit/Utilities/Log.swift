//
//  Log.swift
//  Oovium
//
//  Created by Joe Charlier on 7/25/20.
//  Copyright © 2020 Aepryus Software. All rights reserved.
//

import Acheron
import UIKit

func uncaughtExceptionHandler(exception: NSException) {
	print("CRASH: \(exception)")
	print("Stack Trace: \(exception.callStackSymbols)")
}

public class Crash {
	static func start() {
//		NSSetUncaughtExceptionHandler(uncaughtExceptionHandler)
		NSSetUncaughtExceptionHandler { exception in
				Log.error(with: Thread.callStackSymbols)
			}

			signal(SIGABRT) { _ in
				Log.error(with: Thread.callStackSymbols)
			}

			signal(SIGILL) { _ in
				Log.error(with: Thread.callStackSymbols)
			}

			signal(SIGSEGV) { _ in
				Log.error(with: Thread.callStackSymbols)
			}

			signal(SIGFPE) { _ in
				Log.error(with: Thread.callStackSymbols)
			}

			signal(SIGBUS) { _ in
				Log.error(with: Thread.callStackSymbols)
			}

			signal(SIGPIPE) { _ in
				Log.error(with: Thread.callStackSymbols)
			}
	}
}

public class Log {
	static let scrollView: UIScrollView = {
		let scrollView: UIScrollView = UIScrollView()
		scrollView.backgroundColor = UIColor.cyan.shade(0.5).alpha(0.3)
		scrollView.isUserInteractionEnabled = false
		return scrollView
	}()
	static var i: Int = 0
	static let pen: Pen = Pen(font: UIFont(name: "Menlo", size: 15*Screen.s)!, color: .white)

	public static func print(_ string: String) {
		Swift.print(string)

//		Swift.print("*** \(string)")
//		DispatchQueue.main.async {
//			if let window = Oovium.launchWindow {
//				if scrollView.superview == nil {
//					scrollView.frame = window.bounds
//					window.addSubview(scrollView)
//				}
//				window.bringSubviewToFront(scrollView)
//			}
//
//			let s: CGFloat = Screen.s
//			let label: UILabel = UILabel()
//			label.text = string
//			label.pen = pen
//			label.frame = CGRect(x: 8*s, y: 8*s+CGFloat(i)*20*s, width: scrollView.width, height: 20*s)
//			scrollView.addSubview(label)
//			scrollView.contentSize = CGSize(width: scrollView.width, height: max(CGFloat(i)*Screen.s, scrollView.height+1))
//			i += 1
//		}
	}
	public static func error(with error: [String]) {
		print("\(error)")
	}
}
