//
//  UIViewController+Helper.swift
//  SHRichTextEditor
//
//  Created by Susmita Horrow on 11/01/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
	public static var topMostController: UIViewController? {
		var topController: UIViewController? = nil
		
		guard let window = UIApplication.shared.keyWindow else {
			return nil
		}
		topController = window.rootViewController
		repeat {
			if let newTopController = topController {
				switch newTopController {
				case (let newTopController as UINavigationController) where newTopController.visibleViewController != nil:
					topController = newTopController.visibleViewController
				case (let newTopController as UITabBarController) where newTopController.selectedViewController != nil:
					topController = newTopController.selectedViewController
				default:
					if let presentedController = newTopController.presentedViewController {
						topController = presentedController
					}
				}
			}
		} while (topController?.presentedViewController != nil)
		return topController
	}
	
	final public var isTopMostController: Bool {
		return (self === UIViewController.topMostController)
	}
}
