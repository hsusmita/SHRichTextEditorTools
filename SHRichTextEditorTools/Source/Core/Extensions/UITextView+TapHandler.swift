//
//  UITextView+TapHandler.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

private var currentTappedIndexKey: UInt8 = 0

public extension UITextView {
	static let UITextViewTextDidChangeTap = Notification.Name(rawValue: "UITextViewTextDidChangeTap")
	static let UITextViewTextDidLongPress = Notification.Name(rawValue: "UITextViewTextDidLongPress")

    var touchEnabled: Bool {
		get {
			guard let gestureRecognizers = gestureRecognizers else {
				return false
			}
			return !gestureRecognizers.filter({ $0.isKind(of: UITapGestureRecognizer.self) }).isEmpty
		}
		
		set {
			let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
			tap.delegate = self
			self.addGestureRecognizer(tap)

			let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
			longPress.delegate = self
			self.addGestureRecognizer(longPress)
		}
	}
	
	private(set) var currentTappedIndex: Int? {
		get {
			return objc_getAssociatedObject(self, &currentTappedIndexKey) as? Int
		}
		
		set {
			objc_setAssociatedObject(self, &currentTappedIndexKey, newValue, .OBJC_ASSOCIATION_COPY)
		}
		
	}
	
	@objc func handleTap(_ sender: UITapGestureRecognizer) {
		let location = sender.location(in: self)
		if let index = self.characterIndex(at: location), index < textStorage.length {
			self.currentTappedIndex = index
			let notification: Notification = Notification(name: UITextView.UITextViewTextDidChangeTap, object: self, userInfo: nil)
			NotificationCenter.default.post(notification)
		}
	}

	@objc func handleLongPress(_ sender: UILongPressGestureRecognizer) {
		let location = sender.location(in: self)
		if let index = self.characterIndex(at: location), index < textStorage.length {
			self.currentTappedIndex = index
			let notification: Notification = Notification(name: UITextView.UITextViewTextDidLongPress, object: self, userInfo: nil)
			NotificationCenter.default.post(notification)
		}

	}
    
    func updateTappedIndex(to index: Int) {
        self.currentTappedIndex = index
    }
}

extension UITextView: UIGestureRecognizerDelegate {
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
}
