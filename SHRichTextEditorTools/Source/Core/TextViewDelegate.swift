//
//  TextViewDelegate.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

open class TextViewDelegate: NSObject {
    fileprivate enum Event: Int {
        case textViewShouldBeginEditing
        case textViewDidBeginEditing
        case textViewShouldEndEditing
        case textViewDidEndEditing
        case textViewShouldChangeText
        case textViewDidChangeSelection
        case textViewDidChangeText
        case textViewDidChangeTap
        case textViewDidLongPress
        case textViewShouldInteractWithURL
        case textViewShouldInteractWithTextAttachment
        case textViewDidInsertImage
        case textViewDidDeleteImage
    }
    
    fileprivate var actionsForEvents: [Event: [Any]] = [:]
    
    public override init() {
        super.init()
        self.observeTapChange()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.UITextViewTextDidChangeTap, object: nil)
    }
    
    open func registerShouldBeginEditing(with handler: @escaping (UITextView) -> Bool) {
        self.register(event: .textViewShouldBeginEditing, handler: handler)
    }
    
    open func registerDidBeginEditing(with handler: @escaping (UITextView) -> ()) {
        self.register(event: .textViewDidBeginEditing, handler: handler)
    }
    
    open func registerShouldEndEditing(with handler: @escaping (UITextView) -> Bool) {
        self.register(event: .textViewShouldEndEditing, handler: handler)
    }
    
    open func registerDidEndEditing(with handler: @escaping (UITextView) -> ()) {
        self.register(event: .textViewDidEndEditing, handler: handler)
    }
    
    open func registerShouldChangeText(with handler: @escaping (UITextView, NSRange, String) -> (Bool)) {
        self.register(event: .textViewShouldChangeText, handler: handler)
    }
    
    open func registerDidChangeText(with handler: @escaping (UITextView) -> ()) {
        self.register(event: .textViewDidChangeText, handler: handler)
    }
    
    open func registerDidChangeSelection(with handler: @escaping (UITextView) -> ()) {
        self.register(event: .textViewDidChangeSelection, handler: handler)
    }
    
    open func registerShouldInteractURL(with handler: @escaping (UITextView, URL, NSRange, UITextItemInteraction) -> Bool) {
        self.register(event: .textViewShouldInteractWithURL, handler: handler)
    }
    
    open func registerShouldInteractTextAttachment(with handler: @escaping (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool) {
        self.register(event: .textViewShouldInteractWithTextAttachment, handler: handler)
    }
    
    open func registerDidTapChange(with handler: @escaping (UITextView) -> ()) {
        self.register(event: .textViewDidChangeTap, handler: handler)
    }
    
    open func registerDidLongPress(with handler: @escaping (UITextView) -> ()) {
        self.register(event: .textViewDidLongPress, handler: handler)
    }

    open func registerDidInsertImage(with handler: @escaping (UITextView, Int, UIImage) -> ()) {
        self.register(event: .textViewDidInsertImage, handler: handler)
    }
    
    open func registerDidDeleteImage(with handler: @escaping (UITextView, Int) -> ()) {
        self.register(event: .textViewDidDeleteImage, handler: handler)
    }
    
    private func register(event: Event, handler: Any) {
        if let _ = actionsForEvents[event] {
            self.actionsForEvents[event]!.append(handler)
        } else {
            self.actionsForEvents[event] = [handler]
        }
    }
    
    private func observeTapChange() {
        NotificationCenter.default.addObserver(forName: UITextView.UITextViewTextDidChangeTap, object: nil,
                                               queue: OperationQueue.main) { [weak self] notification in
                                                let textView = notification.object as! UITextView
                                                guard let actionsForTapChange: [(UITextView) -> ()] = self?.actionsForEvents[.textViewDidChangeTap] as? [(UITextView) -> ()] else {
                                                    return
                                                }
                                                for action in actionsForTapChange {
                                                    action(textView)
                                                }
                                                
        }
        NotificationCenter.default.addObserver(forName: UITextView.UITextViewTextDidLongPress,
                                               object: nil,
                                               queue: OperationQueue.main) { [weak self] notification in
                                                let textView = notification.object as! UITextView
                                                guard let actionsForLongPress: [(UITextView) -> ()] = self?.actionsForEvents[.textViewDidLongPress] as? [(UITextView) -> ()] else {
                                                    return
                                                }
                                                for action in actionsForLongPress {
                                                    action(textView)
                                                }
                                                
        }
    }
}

extension TextViewDelegate: UITextViewDelegate {
    
    public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        guard let actionsForShouldBeginEditing: [(UITextView) -> (Bool)] = self.actionsForEvents[.textViewShouldBeginEditing] as? [(UITextView) -> (Bool)] else {
            return true
        }
        var shouldBeginEditing = true
        for action in actionsForShouldBeginEditing {
            shouldBeginEditing = shouldBeginEditing && action(textView)
        }
        return shouldBeginEditing
    }
    
    public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        guard let actionsForShouldEndEditing: [(UITextView) -> (Bool)] = self.actionsForEvents[.textViewShouldEndEditing] as? [(UITextView) -> (Bool)] else {
            return true
        }
        var shouldEndEditing = true
        for action in actionsForShouldEndEditing {
            shouldEndEditing = shouldEndEditing && action(textView)
        }
        return shouldEndEditing
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        guard let actionsForBeginEditing: [(UITextView) -> ()] = self.actionsForEvents[.textViewDidBeginEditing] as? [(UITextView) -> ()] else {
            return
        }
        for action in actionsForBeginEditing {
            action(textView)
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        guard let actionsForEndEditing: [(UITextView) -> ()] = self.actionsForEvents[.textViewDidEndEditing] as? [(UITextView) -> ()] else {
            return
        }
        for action in actionsForEndEditing {
            action(textView)
        }
    }
    
    public func textView(_ textView: UITextView,
                         shouldChangeTextIn range: NSRange,
                         replacementText text: String) -> Bool {
        guard let actionsForShouldChangeText: [(UITextView, NSRange, String) -> (Bool)] =
            self.actionsForEvents[.textViewShouldChangeText] as? [(UITextView, NSRange, String) -> (Bool)] else {
                return true
        }
        var shouldChange = true
        for action in actionsForShouldChangeText {
            shouldChange = shouldChange && action(textView, range, text)
        }
        return shouldChange
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        guard let actionsForChangeText: [(UITextView) -> ()] = self.actionsForEvents[.textViewDidChangeText] as? [(UITextView) -> ()] else {
            return
        }
        for action in actionsForChangeText {
            action(textView)
        }
    }

    public func textViewDidInsertImage(_ textView: UITextView, index: Int, image: UIImage) {
        guard let actionsForDidInsertImage: [(UITextView, Int, UIImage) -> (Void)] =
            self.actionsForEvents[.textViewDidInsertImage] as? [(UITextView, Int, UIImage) -> (Void)] else {
                return
        }
        for action in actionsForDidInsertImage {
            action(textView, index, image)
        }
    }

    public func textViewDidDeleteImage(_ textView: UITextView, index: Int) {
        guard let actionsForDidDeleteImage: [(UITextView, Int) -> (Void)] =
            self.actionsForEvents[.textViewDidDeleteImage] as? [(UITextView, Int) -> (Void)] else {
                return
        }
        for action in actionsForDidDeleteImage {
            action(textView, index)
        }
    }
    
    public func textViewDidChangeSelection(_ textView: UITextView) {
        guard let actionsForChangeSelection: [(UITextView) -> ()] = self.actionsForEvents[.textViewDidChangeSelection] as? [(UITextView) -> ()] else {
            return
        }
        for action in actionsForChangeSelection {
            action(textView)
        }
    }
    
    public func textView(_ textView: UITextView,
                         shouldInteractWith URL: URL,
                         in characterRange: NSRange,
                         interaction: UITextItemInteraction) -> Bool {
        guard let actionsForShouldInteract: [(UITextView, URL, NSRange, UITextItemInteraction) -> (Bool)] =
            self.actionsForEvents[.textViewShouldInteractWithURL] as? [(UITextView, URL, NSRange, UITextItemInteraction) -> (Bool)] else {
                return true
        }
        var shouldInteract = true
        for action in actionsForShouldInteract {
            shouldInteract = shouldInteract && action(textView, URL, characterRange, interaction)
        }
        return shouldInteract
    }
    
    public func textView(_ textView: UITextView,
                         shouldInteractWith textAttachment: NSTextAttachment,
                         in characterRange: NSRange,
                         interaction: UITextItemInteraction) -> Bool {
        guard let actionsForShouldInteract: [(UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> (Bool)] =
            self.actionsForEvents[.textViewShouldInteractWithTextAttachment] as? [(UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> (Bool)] else {
                return true
        }
        var shouldInteract = true
        for action in actionsForShouldInteract {
            shouldInteract = shouldInteract && action(textView, textAttachment, characterRange, interaction)
        }
        return shouldInteract
    }
}
