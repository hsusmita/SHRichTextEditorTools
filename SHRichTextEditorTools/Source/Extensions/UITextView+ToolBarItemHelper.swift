//
//  UITextView+ToolBarItemHelper.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 27/09/18.
//  Copyright © 2018 hsusmita. All rights reserved.
//

import UIKit

public extension UITextView {
	func configureBoldToolBarButton(
		type: ToolBarButton.ButtonType,
		actionOnSelection: @escaping ((ToolBarButton, Bool) -> Void),
		textViewDelegate: TextViewDelegate) -> ToolBarButton {
		let toolBarButton = ToolBarButton(
			type: type,
			actionOnTap: { [unowned self] item in
				guard let index = self.currentCursorPosition,
					!self.attributedText.imagePresent(at: index) else {
					return
				}
				self.toggleBoldface(self)
			},
			actionOnSelection: actionOnSelection
		)
		textViewDelegate.registerDidTapChange(with: { textView in
			guard let index = textView.currentTappedIndex else {
				return
			}
			toolBarButton.isSelected = textView.isCharacterBold(for: index)
		})
		return toolBarButton
	}

	func configureItalicToolBarButton(
		type: ToolBarButton.ButtonType,
		actionOnSelection: @escaping ((ToolBarButton, Bool) -> Void),
		textViewDelegate: TextViewDelegate) -> ToolBarButton {
		let toolBarButton = ToolBarButton(
			type: type,
			actionOnTap: { [unowned self] item in
				guard let index = self.currentCursorPosition,
					!self.attributedText.imagePresent(at: index) else {
						return
				}
				self.toggleItalics(self)
			},
			actionOnSelection: actionOnSelection
		)
		textViewDelegate.registerDidTapChange(with: { textView in
			guard let index = textView.currentTappedIndex else {
				return
			}
			toolBarButton.isSelected = textView.isCharacterItalic(for: index)
		})
		return toolBarButton
	}

	func configureWordCountToolBarButton(
		countTextColor: UIColor,
		textViewDelegate: TextViewDelegate) -> ToolBarButton {
		let toolBarButton = ToolBarButton(
			type: ToolBarButton.ButtonType.attributed(title: String(self.attributedText.length), attributes: [UIControl.State.disabled.rawValue: [NSAttributedString.Key.foregroundColor: countTextColor]]),
			actionOnTap: { _ in },
			actionOnSelection: { _,_  in }
		)
		toolBarButton.barButtonItem.tintColor = countTextColor
		toolBarButton.barButtonItem.isEnabled = false
		textViewDelegate.registerDidChangeText { (textView) in
			toolBarButton.barButtonItem.title = String(textView.attributedText.length)
		}
		return toolBarButton
	}

	func configureLinkToolBarButton(
		type: ToolBarButton.ButtonType,
		actionOnSelection: @escaping ((ToolBarButton, Bool) -> Void),
		linkInputHandler: LinkInputHandler,
		textViewDelegate: TextViewDelegate) -> ToolBarButton {
		let actionOnCompletion = { (url: URL?) -> Void in
			if let url = url {
				self.addLink(link: url, for: self.selectedRange, linkAttributes: linkInputHandler.linkAttributes)
			}
		}
		let actionOnTap: (ToolBarButton) -> Void = { item in
			linkInputHandler.showLinkInputView(completion: actionOnCompletion)
		}
		let toolBarButton = ToolBarButton(type: type, actionOnTap: actionOnTap, actionOnSelection: actionOnSelection)
		let actionOnTapChange: (UITextView) -> () = { (textView) in
			guard let index = textView.currentTappedIndex else {
				return
			}
			toolBarButton.isSelected = textView.attributedText.linkPresent(at: index)
		}
		textViewDelegate.registerDidTapChange(with: actionOnTapChange)
		let actionOnLongPress: (UITextView) -> () = { (textView) in
			guard let index = textView.currentTappedIndex else {
				return
			}
			if let url = textView.attributedText.attribute(NSAttributedString.Key.link, at: index, effectiveRange: nil) as? URL {
				 UIApplication.shared.open(url)
			}
			toolBarButton.isSelected = textView.attributedText.linkPresent(at: index)
		}
		textViewDelegate.registerDidLongPress(with: actionOnLongPress)
		return toolBarButton
	}

	public func configureImageToolBarButton(
		type: ToolBarButton.ButtonType,
		actionOnSelection: @escaping ((ToolBarButton, Bool) -> Void),
		imageInputHandler: ImageInputHandler,
		textViewDelegate: TextViewDelegate) -> ToolBarButton {
		let actionOnTap: (ToolBarButton) -> Void = { [unowned self] item in
			imageInputHandler.showImageInputView(completion: { image in
				if let image = image, let index = self.currentCursorPosition {
					self.insertImage(image: image, at: index)
				}
			})
		}
		let toolBarButton = ToolBarButton(type: type, actionOnTap: actionOnTap, actionOnSelection: actionOnSelection)

		let updateState: (UITextView) -> () = { (textView) in
			guard let index = textView.currentTappedIndex else {
				return
			}
			if textView.attributedText.imagePresent(at: index) {
				if let selectionView = imageInputHandler.imageSelectionView {
					textView.selectImage(at: index, selectionView: selectionView)
				}
				toolBarButton.isSelected = true
			} else {
				if let selectionView = imageInputHandler.imageSelectionView {
					textView.deselectImage(at: index, selectionView: selectionView)
				}
				toolBarButton.isSelected = false
			}
		}
		textViewDelegate.registerDidTapChange(with: updateState)
		return toolBarButton
	}
	
	public func configureIndentationToolBarButton(
		type: ToolBarButton.ButtonType,
		actionOnSelection: @escaping ((ToolBarButton, Bool) -> Void),
		textViewDelegate: TextViewDelegate) -> ToolBarButton {
		let toolBarButton = ToolBarButton(
			type: type,
			actionOnTap: { [unowned self] _ in
				guard let index = self.currentCursorPosition,
					!self.attributedText.imagePresent(at: index) else {
						return
				}
				self.toggleIndentation()
			},
			actionOnSelection: actionOnSelection
		)

		let updateState: (UITextView) -> () = { (textView) in
			guard let index = textView.currentTappedIndex else {
				return
			}
			toolBarButton.isSelected = textView.indentationPresent(at: index)
		}
		textViewDelegate.registerShouldChangeText { (textView, range, replacementText) -> (Bool) in
			guard replacementText == "\n" && range.location >= 0 && textView.indentationPresent(at: range.location - 1) else {
				return true
			}
			textView.addIndentation(at: range.location)
			return false
		}
		textViewDelegate.registerDidTapChange(with: updateState)
		return toolBarButton
	}
}
