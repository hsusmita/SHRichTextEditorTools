//
//  UITextView+LinkHelper.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

public protocol LinkInputEnabled: class {
	var linkAttributes: [String: Any] { get }
	func showLinkInputView(completion: @escaping (URL?) -> ())
}

public protocol LinkInsertProtocol: class {
	var linkInputViewProvider: LinkInputEnabled? { get }
	func addLink(link: URL, for range: NSRange)
	func removeLink(for range: NSRange)
}

private var linkInputViewProviderKey: UInt8 = 0

extension UITextView: LinkInsertProtocol {
	
	public var linkInputViewProvider: LinkInputEnabled? {
		get {
			return objc_getAssociatedObject(self, &linkInputViewProviderKey) as? LinkInputEnabled
		}
		
		set {
			objc_setAssociatedObject(self, &linkInputViewProviderKey, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	public func addLink(link: URL, for range: NSRange) {
		guard range.location + range.length < self.attributedText.length else {
			return
		}
		let mutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText)
		mutableAttributedString.addAttributes(self.linkTextAttributes, range: range)
		mutableAttributedString.addAttribute(NSLinkAttributeName, value: link, range: range)
		self.attributedText = mutableAttributedString
	}
	
	public func removeLink(for range: NSRange) {
		guard range.location + range.length < self.attributedText.length else {
			return
		}
		let mutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText)
		mutableAttributedString.removeAttribute(NSLinkAttributeName, range: range)
		for (key, _) in self.linkTextAttributes {
			mutableAttributedString.removeAttribute(key, range: range)
		}
		self.attributedText = mutableAttributedString
	}
}
