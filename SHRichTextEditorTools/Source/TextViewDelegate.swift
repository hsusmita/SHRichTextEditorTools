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
	public typealias EventHandler = (UITextView) -> ()
	
	public enum Event {
		case textViewWillBeginEditing
		case textViewWillEndEditing
		case textViewDidBeginEditing
		case textViewDidEndEditing
		case textViewDidChangeSelection
		case textViewDidChange
		case textViewWillChangeEditing
		case textViewDidChangeTap
		case textViewDidTapDelete
		case textViewDidTapReturn
	}
	
	fileprivate var actionsForEvents: [Event: [EventHandler]] = [:]
	
	open func register(event: Event, action: @escaping EventHandler) {
		if let _ = actionsForEvents[event] {
			actionsForEvents[event]!.append(action)
		} else {
			actionsForEvents[event] = [action]
		}
	}
	
	override init() {
		super.init()
		NotificationCenter.default.addObserver(forName: UITextView.UITextViewTextDidChangeTap,
		                                       object: nil,
		                                       queue: OperationQueue.main) { notification in
												let textView = notification.object as! UITextView
												let actions: [EventHandler] = self.actionsForEvents[.textViewDidChangeTap]!
												actions.forEach { action in
													action(textView)
												}
		}
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	var shouldChangeTextIn: ((_ range: NSRange, _ text: String) -> Bool)?
	var shouldBeginEditing: (() -> Bool)?
	var shouldEndEditing: (() -> Bool)?
	var shouldInteractWithURL: ((_ URL: URL, _ characterRange: NSRange, _ interaction: UITextItemInteraction) -> Bool)?
	var shouldInteractWithTextAttachment: ((_ textAttachment: NSTextAttachment, _ characterRange: NSRange, _ interaction: UITextItemInteraction) -> Bool)?
}

extension TextViewDelegate: UITextViewDelegate {
	
	private func performActions(for event: Event, with textView: UITextView) {
		guard let actions: [EventHandler] = actionsForEvents[event] else {
			return
		}
		actions.forEach { action in
			action(textView)
		}
	}
	
	public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		performActions(for: .textViewWillBeginEditing, with: textView)
		if let shouldBeginEditing = shouldBeginEditing {
			return shouldBeginEditing()
		} else {
			return true
		}
	}
	
	public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		performActions(for: .textViewWillEndEditing, with: textView)
		if let shouldEndEditing = shouldEndEditing {
			return shouldEndEditing()
		} else {
			return true
		}
	}
	
	public func textViewDidBeginEditing(_ textView: UITextView) {
		performActions(for: .textViewDidBeginEditing, with: textView)
	}
	
	public func textViewDidEndEditing(_ textView: UITextView) {
		performActions(for: .textViewDidEndEditing, with: textView)
	}
	
	public func textView(_ textView: UITextView,
	                     shouldChangeTextIn range: NSRange,
	                     replacementText text: String) -> Bool {
		performActions(for: .textViewWillChangeEditing, with: textView)
		if range.length == 1 && text.characters.isEmpty {
			performActions(for: .textViewDidTapDelete, with: textView)
		} else if range.length == 0 && (text.rangeOfCharacter(from: CharacterSet.newlines) != nil) {
			performActions(for: .textViewDidTapReturn, with: textView)
		}
		if let shouldChangeTextIn = shouldChangeTextIn {
			return shouldChangeTextIn(range, text)
		}
		return true
	}
	
	public func textViewDidChange(_ textView: UITextView) {
		guard let actions: [EventHandler] = actionsForEvents[.textViewDidChange] else {
			return
		}
		actions.forEach { action in
			action(textView)
		}
	}
	
	public func textViewDidChangeSelection(_ textView: UITextView) {
		guard let actions: [EventHandler] = actionsForEvents[.textViewDidChangeSelection] else {
			return
		}
		actions.forEach { action in
			action(textView)
		}
	}
	
	public func textView(_ textView: UITextView,
	                     shouldInteractWith URL: URL,
	                     in characterRange: NSRange,
	                     interaction: UITextItemInteraction) -> Bool {
		if let shouldInteractWithURL = shouldInteractWithURL {
			return shouldInteractWithURL(URL, characterRange, interaction)
		}
		return false
	}
	
	public func textView(_ textView: UITextView,
	                     shouldInteractWith textAttachment: NSTextAttachment,
	                     in characterRange: NSRange,
	                     interaction: UITextItemInteraction) -> Bool {
		if let shouldInteractWithTextAttachment = shouldInteractWithTextAttachment {
			return shouldInteractWithTextAttachment(textAttachment, characterRange, interaction)
		}
		return false
	}
}
