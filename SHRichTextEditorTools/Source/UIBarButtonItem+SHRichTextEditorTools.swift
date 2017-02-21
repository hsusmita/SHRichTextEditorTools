//
//  UIBarButtonItem+SHRichTextEditorTools.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

private var actionOnTapAssociativeKey = "actionOnTapAssociativeKey"
private var selectedStateHandlerKey = "selectedStateHandlerKey"

public extension UIBarButtonItem {

	var actionOnTap: (() -> ())? {
		get { return objc_getAssociatedObject(self, &actionOnTapAssociativeKey) as? (() -> ()) }
		set {
			objc_setAssociatedObject(self, &actionOnTapAssociativeKey, newValue as Any, .OBJC_ASSOCIATION_RETAIN)
			self.target = self
			self.action = #selector(UIBarButtonItem.performAction(sender:))
		}
	}
	
	var selectedStateHandler: ((Bool) -> ())? {
		get { return objc_getAssociatedObject(self, &selectedStateHandlerKey) as? ((Bool) -> ()) }
		set {
			objc_setAssociatedObject(self, &selectedStateHandlerKey, newValue as Any, .OBJC_ASSOCIATION_RETAIN)
		}
	}

	func performAction(sender: UIBarButtonItem) {
		actionOnTap?()
	}
	
	func enableBoldFeature(for textView: UITextView, textViewDelegate: TextViewDelegate) {
		let updateState: (UITextView) -> () = { [unowned self] (textView) in
			guard let selectedStateHandler = self.selectedStateHandler,
				let index = textView.currentTappedIndex else {
					return
			}
			selectedStateHandler(textView.isCharacterBold(for: index))
		}
		actionOnTap = { [unowned self] _ in
			textView.toggleBoldface(self)
			updateState(textView)
		}
		
		textViewDelegate.registerDidTapChange(with: updateState)
	}
	
	func enableItalicsFeature(for textView: UITextView, textViewDelegate: TextViewDelegate) {
		let updateState: (UITextView) -> () = { [unowned self] (textView) in
			guard let selectedStateHandler = self.selectedStateHandler,
				let index = textView.currentTappedIndex else {
					return
			}
			selectedStateHandler(textView.isCharacterItalic(for: index))
		}
		actionOnTap = {  [unowned self] _ in
			textView.toggleItalics(self)
			updateState(textView)
		}
		textViewDelegate.registerDidTapChange(with: updateState)
	}

	func enableIndentationFeature(for textView: UITextView, textViewDelegate: TextViewDelegate) {
		let updateState: (UITextView) -> () = { [unowned self] (textView) in
			guard let selectedStateHandler = self.selectedStateHandler,
				let index = textView.currentTappedIndex else {
					return
			}
			selectedStateHandler(textView.indentationPresent(at: index))
		}
		actionOnTap = {
			textView.toggleIndentation()
			updateState(textView)
		}
		textViewDelegate.registerShouldChangeText { (textView, range, replacementText) -> (Bool) in
			guard replacementText == "\n" && range.location >= 0 && textView.indentationPresent(at: range.location - 1) else {
				return true
			}
			textView.addIndentation(at: range.location)
			return false

		}
		textViewDelegate.registerDidTapChange(with: updateState)
	}
	
	func enableWordCount(for textView: UITextView, textViewDelegate: TextViewDelegate) {
		title = String(textView.text.characters.count)
		textViewDelegate.registerDidChangeText { [unowned self] (textView) in
			self.title = String(textView.attributedText.length)
		}
	}
	
	func enableLinkInputFeature(for textView: UITextView, textViewDelegate: TextViewDelegate) {
		let updateState: (UITextView) -> () = { [unowned self] (textView) in
			guard let selectedStateHandler = self.selectedStateHandler,
				let index = textView.currentTappedIndex else {
					return
			}
			selectedStateHandler(textView.attributedText.linkPresent(at: index))
		}
		
		actionOnTap = {
			textView.linkInputViewProvider?.showLinkInputView(completion: { url in
				if let url = url {
					textView.addLink(link: url, for: textView.selectedRange)
				}
			})
		}
		textViewDelegate.registerDidTapChange(with: updateState)
	}
	
	func enableImageInputFeature(for textView: UITextView, textViewDelegate: TextViewDelegate) {
		let updateState: (UITextView) -> () = { [unowned self] (textView) in
			guard let index = textView.currentTappedIndex else {
				return
			}
			if textView.attributedText.imagePresent(at: index) {
				if let selectionView = textView.imageInputViewProvider?.imageSelectionView {
					textView.selectImage(at: index, selectionView: selectionView)
				}
				self.selectedStateHandler?(true)
			} else {
				if let selectionView = textView.imageInputViewProvider?.imageSelectionView {
					textView.deselectImage(at: index, selectionView: selectionView)
				}
				self.selectedStateHandler?(false)
			}
		}
		
		actionOnTap = {
			textView.imageInputViewProvider?.showImageInputView(completion: { image in
				if let image = image, let index = textView.currentCursorPosition {
					textView.insertImage(image: image, at: index)
				}
			})
		}
		textViewDelegate.registerDidTapChange(with: updateState)
	}
}

