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
		case textViewShouldInteractWithURL
		case textViewShouldInteractWithTextAttachment
	}
	
	fileprivate var actionsForEvents: [Event: [Any]] = [:]
	
	public override init() {
		super.init()
		observeTapChange()
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
	open func registerShouldBeginEditing(with handler: (UITextView) -> Bool) {
		register(event: .textViewShouldBeginEditing, handler: handler)
	}
	
	open func registerShouldEndEditing(with handler: (UITextView) -> Bool) {
		register(event: .textViewShouldEndEditing, handler: handler)
	}
	
	open func registerDidBeginEditing(with handler: (UITextView) -> ()) {
		register(event: .textViewDidBeginEditing, handler: handler)
	}
	
	open func registerDidEndEditing(with handler: (UITextView) -> ()) {
		register(event: .textViewDidEndEditing, handler: handler)
	}
	
	open func registerShouldChangeText(with handler: (UITextView, NSRange, String) -> (Bool)) {
		register(event: .textViewShouldChangeText, handler: handler)
	}
	
	open func registerDidChangeText(with handler: (UITextView) -> ()) {
		register(event: .textViewDidChangeText, handler: handler)
	}
	
	open func registerDidChangeSelection(with handler: (UITextView) -> ()) {
		register(event: .textViewDidChangeSelection, handler: handler)
	}
	
	open func registerShouldInteractURL(with handler: (UITextView, URL, NSRange, UITextItemInteraction) -> Bool) {
		register(event: .textViewShouldInteractWithURL, handler: handler)
	}
	
	open func registerShouldInteractTextAttachment(with handler: (UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> Bool) {
		register(event: .textViewShouldInteractWithTextAttachment, handler: handler)
	}
	
	open func registerDidTapChange(with handler: (UITextView) -> ()) {
		register(event: .textViewDidChangeTap, handler: handler)
	}
	
	private func register(event: Event, handler: Any) {
		if let _ = actionsForEvents[event] {
			actionsForEvents[event]!.append(handler)
		} else {
			actionsForEvents[event] = [handler]
		}
	}
	
	private func observeTapChange() {
		NotificationCenter.default.addObserver(forName: UITextView.UITextViewTextDidChangeTap, object: nil,
		                                       queue: OperationQueue.main) { [unowned self] notification in
												let textView = notification.object as! UITextView
												guard let actionsForTapChange: [(UITextView) -> ()] = self.actionsForEvents[.textViewDidChangeTap] as? [(UITextView) -> ()] else {
													return
												}
												for action in actionsForTapChange {
													action(textView)
												}
		
		}
		
	}
}

extension TextViewDelegate: UITextViewDelegate {
	
	public func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
		guard let actionsForShouldBeginEditing: [(UITextView) -> (Bool)] = actionsForEvents[.textViewShouldBeginEditing] as? [(UITextView) -> (Bool)] else {
			return true
		}
		var shouldBeginEditing = true
		for action in actionsForShouldBeginEditing {
			shouldBeginEditing = shouldBeginEditing && action(textView)
		}
		return shouldBeginEditing
	}
	
	public func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
		guard let actionsForShouldEndEditing: [(UITextView) -> (Bool)] = actionsForEvents[.textViewShouldEndEditing] as? [(UITextView) -> (Bool)] else {
			return true
		}
		var shouldEndEditing = true
		for action in actionsForShouldEndEditing {
			shouldEndEditing = shouldEndEditing && action(textView)
		}
		return shouldEndEditing
	}
	
	public func textViewDidBeginEditing(_ textView: UITextView) {
		guard let actionsForBeginEditing: [(UITextView) -> ()] = actionsForEvents[.textViewDidBeginEditing] as? [(UITextView) -> ()] else {
			return
		}
		for action in actionsForBeginEditing {
			action(textView)
		}
	}
	
	public func textViewDidEndEditing(_ textView: UITextView) {
		guard let actionsForEndEditing: [(UITextView) -> ()] = actionsForEvents[.textViewDidEndEditing] as? [(UITextView) -> ()] else {
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
			actionsForEvents[.textViewShouldChangeText] as? [(UITextView, NSRange, String) -> (Bool)] else {
			return true
		}
		var shouldChange = true
		for action in actionsForShouldChangeText {
			shouldChange = shouldChange && action(textView, range, text)
		}
		return shouldChange
	}
	
	public func textViewDidChange(_ textView: UITextView) {
		guard let actionsForChangeText: [(UITextView) -> ()] = actionsForEvents[.textViewDidChangeText] as? [(UITextView) -> ()] else {
			return
		}
		for action in actionsForChangeText {
			action(textView)
		}
	}
	
	public func textViewDidChangeSelection(_ textView: UITextView) {
		guard let actionsForChangeSelection: [(UITextView) -> ()] = actionsForEvents[.textViewDidChangeSelection] as? [(UITextView) -> ()] else {
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
			actionsForEvents[.textViewShouldChangeText] as? [(UITextView, URL, NSRange, UITextItemInteraction) -> (Bool)] else {
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
			actionsForEvents[.textViewShouldChangeText] as? [(UITextView, NSTextAttachment, NSRange, UITextItemInteraction) -> (Bool)] else {
				return true
		}
		var shouldInteract = true
		for action in actionsForShouldInteract {
			shouldInteract = shouldInteract && action(textView, textAttachment, characterRange, interaction)
		}
		return shouldInteract
	}
}
