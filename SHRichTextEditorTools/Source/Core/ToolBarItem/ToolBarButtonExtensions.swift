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
        textViewDelegate.registerShouldChangeText { (textView, range, text) -> (Bool) in
            if text == "\n" {
                toolBarButton.isSelected = false
            }
            return true
        }
//        textViewDelegate.registerDidChangeText { textView in
//            guard let index = textView.currentCursorPosition, index - 1 > 0 else {
//                return
//            }
//            toolBarButton.isSelected = textView.isCharacterBold(for: index - 1) || textView.isCharacterBold(for: index)
//        }
        textViewDelegate.registerDidTapChange(with: { textView in
            guard let index = textView.currentTappedIndex else {
                return
            }
            let prevIndex = index - 1
            if prevIndex > 0 {
                toolBarButton.isSelected = textView.isCharacterBold(for: index) || textView.isCharacterBold(for: prevIndex)
            } else {
                toolBarButton.isSelected = textView.isCharacterBold(for: index)
            }
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
            actionOnTap: { item in
                textView.toggleItalics(textView)
        },
            actionOnSelection: actionOnSelection
        )
        textViewDelegate.registerShouldChangeText { (textView, range, text) -> (Bool) in
            if text == "\n" {
                toolBarButton.isSelected = false
            }
            return true
        }
//        textViewDelegate.registerDidChangeText { textView in
//            guard let index = textView.currentCursorPosition, index - 1 > 0 else {
//                return
//            }
//            toolBarButton.isSelected = textView.isCharacterItalic(for: index - 1) || textView.isCharacterItalic(for: index)
//        }
        textViewDelegate.registerDidTapChange(with: { textView in
            guard let index = textView.currentTappedIndex else {
                return
            }
            let prevIndex = index - 1
            if prevIndex > 0 {
                toolBarButton.isSelected = textView.isCharacterItalic(for: index) || textView.isCharacterItalic(for: prevIndex)
            } else {
                toolBarButton.isSelected = textView.isCharacterItalic(for: index)
            }
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
        toolBarButton.barButtonItem.title = String(textView.attributedText.length)
        textViewDelegate.registerDidChangeText { (textView) in
            toolBarButton.barButtonItem.title = String(textView.attributedText.length)
        }
        return toolBarButton
    }
    
    static func configureRemainingCharacterCountToolBarButton(maximumCharacterCount: Int,
                                                              textAttributes: [NSAttributedString.Key: Any],
                                                              textView: UITextView,
                                                              textViewDelegate: TextViewDelegate) -> ToolBarButton {
        let toolBarButton = ToolBarButton(
            type: ToolBarButton.ButtonType.attributed(
                title: String(textView.attributedText.length),
                attributes: [UIControl.State.disabled.rawValue: textAttributes]),
            actionOnTap: { _ in },
            actionOnSelection: { _,_  in }
        )
        toolBarButton.barButtonItem.setTitleTextAttributes(textAttributes, for: .normal)
        toolBarButton.barButtonItem.isEnabled = false
        toolBarButton.barButtonItem.title = String(max(0, maximumCharacterCount - textView.attributedText.length))
        textViewDelegate.registerDidChangeText { (textView) in
            let count = max(0, maximumCharacterCount - textView.attributedText.length)
            toolBarButton.barButtonItem.title = String(count)
        }
        textViewDelegate.registerShouldChangeText { (textView, range, text) -> (Bool) in
            return textView.text.count + (text.count - range.length) <= maximumCharacterCount
        }
        return toolBarButton
    }

    static func configureLinkToolBarButton(
        type: ToolBarButton.ButtonType,
        actionOnSelection: @escaping ((ToolBarButton, Bool) -> Void),
        linkInputHandler: LinkInputHandler,
        linkTapHandler: @escaping ((URL) -> ()),
        textView: UITextView,
        textViewDelegate: TextViewDelegate) -> ToolBarButton {
        let actionOnTap: (ToolBarButton) -> Void = { item in
            if textView.selectedRange.location == NSNotFound || textView.selectedRange.length == 0 {
                return
            }
            let range = textView.selectedRange
            linkInputHandler.showLinkInputView { url in
                if let url = url {
                    if UIApplication.shared.canOpenURL(url) {
                        textView.addLink(link: url, for: range, linkAttributes: linkInputHandler.linkAttributes)
                    }
                }
            }
        }
        let toolBarButton = ToolBarButton(type: type, actionOnTap: actionOnTap, actionOnSelection: actionOnSelection)
        let currentTypingAttributes = textView.typingAttributes
        textViewDelegate.registerShouldChangeText { (textView, range, text) -> (Bool) in
            guard (range.location - 1) >= 0 else {
                return true
            }
            if (text == " " || text == "\n") && textView.attributedText.linkPresent(at: range.location - 1) {
                let attributedString = NSMutableAttributedString(string: text, attributes: currentTypingAttributes)
                textView.textStorage.insert(attributedString, at: range.location)
                let cursor = NSRange(location: textView.selectedRange.location + 1, length: 0)
                textView.selectedRange = cursor
                return false
            }
            return true
        }
        
        textViewDelegate.registerShouldInteractURL { (textView, url, range, _) -> Bool in
            linkTapHandler(url)
            return false
        }
        return toolBarButton
    }
    
    static func configureImageToolBarButton(
        type: ToolBarButton.ButtonType,
        actionOnSelection: @escaping ((ToolBarButton, Bool) -> Void),
        imageAttachmentBounds: CGRect,
        imageInputHandler: ImageInputHandler,
        textView: UITextView,
        textViewDelegate: TextViewDelegate) -> ToolBarButton {
        let actionOnTap: (ToolBarButton) -> Void = { item in
            imageInputHandler.showImageInputView(completion: { image in
                if let image = image, let index = textView.currentCursorPosition {
                    textView.insertImage(image: image, at: index, attachmentBounds: imageAttachmentBounds)
                    textViewDelegate.textViewDidInsertImage(textView, index: index, image: image)
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
        imageAttachmentBounds: CGRect,
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
                        textView.insertImage(image: image, at: index, attachmentBounds: imageAttachmentBounds)
                        textViewDelegate.textViewDidInsertImage(textView, index: index, image: image)
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
            } else {
                if let selectionView = imageInputHandler.imageSelectionView {
                    textView.deselectImage(at: index, selectionView: selectionView)
                }
            }
        }
        textViewDelegate.registerDidChangeText(with: { (textView) in
            if let selectionView = imageInputHandler.imageSelectionView {
                textView.clearImageSelection(selectionView: selectionView)
            }
        })
        
        textViewDelegate.registerDidBeginEditing(with: { (textView) in
            if textView.inputView != nil {
                textView.inputView = nil
                textView.reloadInputViews()
                toolBarButton.barButtonItem.image = imageInputIcon
            }
        })
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
