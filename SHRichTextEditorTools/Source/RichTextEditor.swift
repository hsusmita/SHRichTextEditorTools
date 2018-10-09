//
//  RichTextEditor.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 27/09/18.
//  Copyright © 2018 hsusmita. All rights reserved.
//

import UIKit

protocol RichTextEditor {
	var textView: UITextView { get }
	var textViewDelegate: TextViewDelegate { get }
	var toolBar: UIToolbar { get }
	var toolBarItems: [ToolBarItem] { get }
}

extension RichTextEditor {
	func configure() {
		self.textView.touchEnabled = true
		self.textView.delegate = self.textViewDelegate
		self.toolBar.translatesAutoresizingMaskIntoConstraints = false
		self.toolBar.items = self.toolBarItems.map { $0.barButtonItem }
		self.textView.inputAccessoryView = self.toolBar
		self.textViewDelegate.registerDidTapChange { textView in
			if let index = textView.currentTappedIndex {
				if !textView.attributedText.imagePresent(at: index) {
					textView.inputView = nil
					textView.reloadInputViews()
				}
			}
		}
	}
}
