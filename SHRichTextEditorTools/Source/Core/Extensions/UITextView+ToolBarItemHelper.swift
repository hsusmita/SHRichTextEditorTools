//
//  UITextView+ToolBarItemHelper.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 27/09/18.
//  Copyright © 2018 hsusmita. All rights reserved.
//

import UIKit

public extension UITextView {
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
    
    func configureImageToolBarButton(
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
        textViewDelegate.registerShouldChangeText { (textView, range, replacementText) -> (Bool) in
            if replacementText == "\n" {
                if let selectionView = imageInputHandler.imageSelectionView {
                    textView.clearImageSelection(selectionView: selectionView)
                }
            }
            return true
        }
        return toolBarButton
    }
}
