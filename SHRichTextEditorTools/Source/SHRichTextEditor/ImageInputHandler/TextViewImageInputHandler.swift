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
    var imagePickerProvider: ImagePickerProviderProtocol?
    private var imageBorderView = ImageBorderView.imageBorderView()
    
    init(textView: UITextView) {
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
    
    var imageSelectionView: UIView? {
        return self.imageBorderView
    }
    
    func showImageInputView(completion: @escaping (UIImage?) -> ()) {
        let view = CameraInputView.cameraInputView()
        view.actionOnCameraTap = { [unowned self] in
            self.imagePickerProvider?.showImagePicker(
                .camera,
                onViewController: UIViewController.topMostController!,
                completion: completion)
        }
        view.actionOnLibraryTap = { [unowned self] in
            self.imagePickerProvider?.showImagePicker(
                .photoLibrary,
                onViewController: UIViewController.topMostController!,
                completion: completion)
        }
        textView.inputView = view
        self.textView.reloadInputViews()
    }
}
