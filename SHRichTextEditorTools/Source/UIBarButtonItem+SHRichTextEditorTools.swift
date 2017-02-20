//
//  EditorBarButtonItem.swift
//  SHRichTextEditor
//
//  Created by Susmita Horrow on 14/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

private var actionOnTapAssociativeKey = "actionOnTapAssociativeKey"

public extension UIBarButtonItem {

	var actionOnTap: (() -> ())? {
		get { return objc_getAssociatedObject(self, &actionOnTapAssociativeKey) as? (() -> ()) }
		set {
			objc_setAssociatedObject(self, &actionOnTapAssociativeKey, newValue as Any, .OBJC_ASSOCIATION_RETAIN)
			self.target = self
			self.action = #selector(UIBarButtonItem.performAction(sender:))
		}
	}

	func performAction(sender: UIBarButtonItem) {
		actionOnTap?()
	}
	
	func enableBoldFeature(for textView: UITextView, textViewDelegate: TextViewDelegate) {
		let defaultTintColor = tintColor
		tintColor = UIColor.gray
		let updateState: (UITextView) -> () = { [unowned self] (textView) in
			if let index = textView.currentTappedIndex {
				self.tintColor = textView.isCharacterBold(for: index) ? defaultTintColor : UIColor.gray
			} else {
				self.tintColor = defaultTintColor
			}
		}
		actionOnTap = { [unowned self] _ in
			textView.toggleBoldface(self)
			updateState(textView)
		}
		textViewDelegate.register(event: .textViewDidChangeTap, action: updateState)
	}
	
	func enableItalicsFeature(for textView: UITextView, textViewDelegate: TextViewDelegate) {
		let defaultTintColor = tintColor
		tintColor = UIColor.gray
		let updateState: (UITextView) -> () = { [unowned self] (textView) in
			if let index = textView.currentTappedIndex {
				self.tintColor = textView.isCharacterItalic(for: index) ? defaultTintColor : UIColor.gray
			} else {
				self.tintColor = defaultTintColor
			}
		}
		actionOnTap = {  [unowned self] _ in
			textView.toggleItalics(self)
			updateState(textView)
		}
		textViewDelegate.register(event: .textViewDidChangeTap, action: updateState)
	}

	func enableIndentationFeature(for textView: UITextView, textViewDelegate: TextViewDelegate) {
		let defaultTintColor = tintColor
		tintColor = UIColor.gray
		let updateState: (UITextView) -> () = { [unowned self] (textView) in
			if let index = textView.currentTappedIndex {
				self.tintColor = textView.indentationPresent(at: index) ? defaultTintColor : UIColor.gray
			} else {
				self.tintColor = defaultTintColor
			}
		}
		actionOnTap = {
			textView.toggleIndentation()
			updateState(textView)
		}
		textViewDelegate.shouldChangeTextIn = { range, replacementText in
			guard replacementText == "\n" && range.location >= 0 && textView.indentationPresent(at: range.location - 1) else {
				return true
			}
			textView.addIndentation(at: range.location)
			return false
		}
		textViewDelegate.register(event: .textViewDidChangeTap, action: updateState)
	}
	
	func enableWordCount(for textView: UITextView, textViewDelegate: TextViewDelegate) {
		title = String(textView.text.characters.count)
		textViewDelegate.register(event: .textViewDidChange) { [unowned self] (textView) in
			self.title = String(textView.attributedText.length)
		}
	}
	
	func enableLinkInputFeature(for textView: UITextView, textViewDelegate: TextViewDelegate) {
		let defaultTintColor = tintColor
		tintColor = UIColor.gray
		let updateState: (UITextView) -> () = { [unowned self] (textView) in
			if let index = textView.currentTappedIndex {
				self.tintColor = textView.attributedText.linkPresent(at: index) ? defaultTintColor : UIColor.gray
			} else {
				self.tintColor = defaultTintColor
			}
		}
		
		actionOnTap = {
			textView.linkInputViewProvider?.showLinkInputView(completion: { url in
				if let url = url {
					textView.addLink(link: url, for: textView.selectedRange)
				}
			})
		}
		textViewDelegate.register(event: .textViewDidChangeTap, action: updateState)
	}
	
	func enableImageInputFeature(for textView: UITextView, textViewDelegate: TextViewDelegate) {
		let defaultTintColor = tintColor
		tintColor = UIColor.gray
		let updateState: (UITextView) -> () = { [unowned self] (textView) in
			guard let index = textView.currentTappedIndex else {
				self.tintColor = defaultTintColor
				return
			}
			if textView.attributedText.imagePresent(at: index) {
				if let selectionView = textView.imageInputViewProvider?.imageSelectionView {
					textView.selectImage(at: index, selectionView: selectionView)
				}
				self.tintColor = defaultTintColor
			} else {
				if let selectionView = textView.imageInputViewProvider?.imageSelectionView {
					textView.deselectImage(at: index, selectionView: selectionView)
				}
				self.tintColor = UIColor.gray
			}
		}
		
		actionOnTap = {
			textView.imageInputViewProvider?.showImageInputView(completion: { image in
				if let image = image, let index = textView.currentCursorPosition {
					textView.insertImage(image: image, at: index)
				}
			})
		}
		textViewDelegate.register(event: .textViewDidChangeTap, action: updateState)
	}
}

