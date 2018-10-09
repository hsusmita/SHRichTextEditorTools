//
//  UITextView+LinkHelper.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

public protocol LinkInputHandler: class {
	var linkAttributes: [NSAttributedStringKey: Any] { get }
	func showLinkInputView(completion: @escaping (URL?) -> ())
}

extension UITextView {
	public func addLink(link: URL, for range: NSRange, linkAttributes: [NSAttributedStringKey: Any]) {
		guard range.location + range.length < self.attributedText.length else {
			return
		}
		let mutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText)
		mutableAttributedString.addAttributes(linkAttributes, range: range)
		mutableAttributedString.addAttribute(NSAttributedStringKey.link, value: link, range: range)
		self.attributedText = mutableAttributedString
	}
	
	public func removeLink(for range: NSRange) {
		guard range.location + range.length < self.attributedText.length else {
			return
		}
		let mutableAttributedString = NSMutableAttributedString(attributedString: self.attributedText)
		mutableAttributedString.removeAttribute(NSAttributedStringKey.link, range: range)
		for (key, _) in self.linkTextAttributes {
			mutableAttributedString.removeAttribute(NSAttributedStringKey(rawValue: key), range: range)
		}
		self.attributedText = mutableAttributedString
	}
}
