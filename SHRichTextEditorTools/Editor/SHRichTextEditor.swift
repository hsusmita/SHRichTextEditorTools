//
//  SHRichTextEditor.swift
//  SHRichTextEditor
//
//  Created by Susmita Horrow on 30/01/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

class SHRichTextEditor: NSObject {
	internal let textView: UITextView
	fileprivate var imagePickerManager: ImagePickerManager?
	fileprivate var imageBorderView = ImageBorderView.imageBorderView()

	var textViewDelegate = TextViewDelegate()
	var toolbar: RichTextToolbar?
	
	init(textView: UITextView) {
		self.textView = textView
		self.textView.touchEnabled = true
		self.textView.delegate = textViewDelegate
		super.init()
		configureToolbar()
	}
	
	private func configureToolbar() {
		toolbar = RichTextToolbar.toolbar()
		toolbar?.boldButton.enableBoldFeature(for: textView, textViewDelegate: textViewDelegate)
		toolbar?.italicButton.enableItalicsFeature(for: textView, textViewDelegate: textViewDelegate)
		toolbar?.bulletButton.enableIndentationFeature(for: textView, textViewDelegate: textViewDelegate)
		textView.linkInputViewProvider = self
		toolbar?.linkButton.enableLinkInputFeature(for: textView, textViewDelegate: textViewDelegate)
		textView.imageInputViewProvider = self
		toolbar?.cameraButton.enableImageInputFeature(for: textView, textViewDelegate: textViewDelegate)
		self.textView.inputAccessoryView = toolbar
		textViewDelegate.registerDidTapChange { textView in
			if let index = textView.currentTappedIndex {
				if !textView.attributedText.imagePresent(at: index) {
					textView.inputView = nil
					textView.reloadInputViews()
				}
			}
		}
	}
}

extension SHRichTextEditor: LinkInputEnabled {
	
	var linkAttributes: [String: Any] {
		return [NSFontAttributeName: UIColor.green]
	}
	
	func showLinkInputView(completion: @escaping (URL?) -> ()) {
		let alertController = UIAlertController(title: "Add a link", message: "", preferredStyle: .alert)
		alertController.addTextField(configurationHandler: { textField in
			textField.placeholder = "http://"
		})
		let linkAction = UIAlertAction(title: "Link", style: .default, handler: { action in
			if let linkTextField: UITextField = alertController.textFields!.first, let text = linkTextField.text, !text.isEmpty {
				completion(URL(string: text))
			}
		})
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
			alertController.dismiss(animated: true, completion: nil)
		})
		alertController.addAction(cancelAction)
		alertController.addAction(linkAction)
		UIViewController.topMostController?.present(alertController, animated: true, completion: nil)
	}
}

extension SHRichTextEditor: ImageInputEnabled {

	var imageSelectionView: UIView? {
		return imageBorderView
	}
	
	func showImageInputView(completion: @escaping (UIImage?) -> ()) {
		self.imagePickerManager = ImagePickerManager(with: UIViewController.topMostController!)
		let view = CameraInputView.cameraInputView()
		view.actionOnCameraTap = { [unowned self] in
			self.imagePickerManager?.showImagePicker(.camera, completion: completion)
		}
		view.actionOnLibraryTap = { [unowned self] in
			self.imagePickerManager?.showImagePicker(.photoLibrary, completion: completion)
		}
		textView.inputView = view
		self.textView.reloadInputViews()
	}
}
