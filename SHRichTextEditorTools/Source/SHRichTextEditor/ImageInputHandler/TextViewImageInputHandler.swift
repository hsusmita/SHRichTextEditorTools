//
//  TextViewImageInputHandler.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 08/10/18.
//  Copyright © 2018 hsusmita. All rights reserved.
//

import UIKit

class TextViewImageInputHandler: ImageInputHandler {
	let textView: UITextView
	private var imagePickerManager: ImagePickerManager?
	private var imageBorderView = ImageBorderView.imageBorderView()

	init(textView: UITextView) {
		self.textView = textView
		self.imageBorderView.actionOnDeleteTap = {
			let currentIndex = textView.currentTappedIndex!
			let mutableAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
			mutableAttributedString.replaceCharacters(in: NSRange(location: currentIndex, length: 1), with: "")
			textView.attributedText = mutableAttributedString
		}
	}

	var imageSelectionView: UIView? {
		return self.imageBorderView
	}

	func showImageInputView(completion: @escaping (UIImage?) -> ()) {
		let view = CameraInputView.cameraInputView()
		self.imagePickerManager = ImagePickerManager(with: UIViewController.topMostController!)
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
