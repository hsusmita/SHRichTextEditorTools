//
//  TextViewImageInputHandler.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 08/10/18.
//  Copyright © 2018 hsusmita. All rights reserved.
//

import UIKit

public class TextViewImageInputHandler: ImageInputHandler {
    let textView: UITextView
    var imagePickerProvider: ImagePickerProviderProtocol?
    private var imageBorderView = ImageBorderView.imageBorderView()
    private(set) public var cameraInputView =  CameraInputView.cameraInputView()
    
    public init(textView: UITextView) {
        self.textView = textView
        self.imageBorderView.actionOnDeleteTap = {
            guard let currentIndex = textView.currentTappedIndex else {
                return
            }
            let mutableAttributedString = NSMutableAttributedString(attributedString: textView.attributedText)
            mutableAttributedString.replaceCharacters(in: NSRange(location: currentIndex, length: 1), with: "")
            textView.attributedText = mutableAttributedString
        }
    }
    
    public var imageSelectionView: UIView? {
        return self.imageBorderView
    }
    
    public func showImageInputView(completion: @escaping (UIImage?) -> ()) {
        self.cameraInputView.actionOnCameraTap = { [unowned self] in
            self.imagePickerProvider?.showImagePicker(
                .camera,
                onViewController: UIViewController.topMostController!,
                completion: completion)
        }
        self.cameraInputView.actionOnLibraryTap = { [unowned self] in
            self.imagePickerProvider?.showImagePicker(
                .photoLibrary,
                onViewController: UIViewController.topMostController!,
                completion: completion)
        }
        self.textView.inputView = self.cameraInputView
        self.textView.reloadInputViews()
    }

    public func clearImageSelection() {
        if let imageSelectionView = self.imageSelectionView {
            self.textView.clearImageSelection(selectionView: imageSelectionView)
        }
    }
}
