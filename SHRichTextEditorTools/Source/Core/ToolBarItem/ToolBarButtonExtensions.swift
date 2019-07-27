//
//  TToolBarButtonExtensions.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 27/09/18.
//  Copyright © 2018 hsusmita. All rights reserved.
//

import UIKit

public extension ToolBarButton {
    static func configureBoldToolBarButton(
        type: ToolBarButton.ButtonType,
        actionOnSelection: @escaping ((ToolBarButton, Bool) -> Void),
        textView: UITextView,
        textViewDelegate: TextViewDelegate) -> ToolBarButton {
        let toolBarButton = ToolBarButton(
            type: type,
            actionOnTap: { item in
                textView.toggleBoldface(textView)
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
    
    static func configureItalicToolBarButton(
        type: ToolBarButton.ButtonType,
        actionOnSelection: @escaping ((ToolBarButton, Bool) -> Void),
        textView: UITextView,
        textViewDelegate: TextViewDelegate) -> ToolBarButton {
        let toolBarButton = ToolBarButton(
            type: type,
            actionOnTap: { _ in
                textView.toggleItalics(textView)
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
    
    static func configureWordCountToolBarButton(
        countTextColor: UIColor,
        textView: UITextView,
        textViewDelegate: TextViewDelegate) -> ToolBarButton {
        let toolBarButton = ToolBarButton(
            type: ToolBarButton.ButtonType.attributed(title: String(textView.attributedText.length), attributes: [UIControl.State.disabled.rawValue: [NSAttributedString.Key.foregroundColor: countTextColor]]),
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
    
    static func configureLinkToolBarButton(
        type: ToolBarButton.ButtonType,
        actionOnSelection: @escaping ((ToolBarButton, Bool) -> Void),
        linkInputHandler: LinkInputHandler,
        textView: UITextView,
        textViewDelegate: TextViewDelegate) -> ToolBarButton {
        let actionOnCompletion = { (url: URL?) -> Void in
            if let url = url {
                textView.addLink(link: url, for: textView.selectedRange, linkAttributes: linkInputHandler.linkAttributes)
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
    
    static func configureImageToolBarButton(
        type: ToolBarButton.ButtonType,
        actionOnSelection: @escaping ((ToolBarButton, Bool) -> Void),
        imageInputHandler: ImageInputHandler,
        textView: UITextView,
        textViewDelegate: TextViewDelegate) -> ToolBarButton {
        let actionOnTap: (ToolBarButton) -> Void = { item in
            imageInputHandler.showImageInputView(completion: { image in
                if let image = image, let index = textView.currentCursorPosition {
                    textView.insertImage(image: image, at: index)
                    textViewDelegate.textViewDidChange(textView)
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
        textViewDelegate.registerDidChangeText(with: updateState)
        textViewDelegate.registerDidTapChange(with: updateState)
        return toolBarButton
    }
    
    static func configureToggleTextAndImageInputToolBarButton(
        textInputIcon: UIImage,
        imageInputIcon: UIImage,
        tintColor: UIColor,
        imageInputHandler: ImageInputHandler,
        textView: UITextView,
        textViewDelegate: TextViewDelegate) -> ToolBarButton {
        let actionOnTap: (ToolBarButton) -> Void = { item in
            if textView.inputView != nil {
                textView.inputView = nil
                textView.reloadInputViews()
                item.barButtonItem.image = imageInputIcon
            } else {
                imageInputHandler.showImageInputView(completion: { image in
                    if let image = image, let index = textView.currentCursorPosition {
                        textView.insertImage(image: image, at: index)
                        textViewDelegate.textViewDidChange(textView)
                    }
                })
                item.barButtonItem.image = textInputIcon
            }
            
        }
        let toolBarButton = ToolBarButton(type: ToolBarButton.ButtonType.image(image: imageInputIcon), actionOnTap: actionOnTap, actionOnSelection: { _, _ in })
        toolBarButton.barButtonItem.tintColor = tintColor
        
        let updateState: (UITextView) -> () = { (textView) in
            guard let index = textView.currentTappedIndex else {
                return
            }
            if textView.attributedText.imagePresent(at: index) {
                if let selectionView = imageInputHandler.imageSelectionView {
                    textView.selectImage(at: index, selectionView: selectionView)
                }
                toolBarButton.isSelected = true
                toolBarButton.barButtonItem.image = textInputIcon
                imageInputHandler.showImageInputView(completion: { image in
                    if let image = image, let index = textView.currentCursorPosition {
                        textView.insertImage(image: image, at: index)
                        textViewDelegate.textViewDidChange(textView)
                    }
                })
            } else {
                if let selectionView = imageInputHandler.imageSelectionView {
                    textView.deselectImage(at: index, selectionView: selectionView)
                }
                toolBarButton.isSelected = false
                toolBarButton.barButtonItem.image = imageInputIcon
            }
        }
        textViewDelegate.registerDidChangeText(with: updateState)
        textViewDelegate.registerDidTapChange(with: updateState)
        return toolBarButton
    }
    static func configureIndentationToolBarButton(
        type: ToolBarButton.ButtonType,
        actionOnSelection: @escaping ((ToolBarButton, Bool) -> Void),
        textView: UITextView,
        textViewDelegate: TextViewDelegate) -> ToolBarButton {
        let toolBarButton = ToolBarButton(
            type: type,
            actionOnTap: { _ in textView.toggleIndentation() },
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
