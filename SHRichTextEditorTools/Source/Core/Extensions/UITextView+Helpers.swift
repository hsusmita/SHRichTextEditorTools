//
//  UITextView+SHRichTextEditorTools.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

public extension UITextView {
	var currentCursorPosition: Int? {
		guard let selectedRange = selectedTextRange else {
			return nil
		}
		return offset(from: beginningOfDocument, to: selectedRange.start)
	}
	
	var startOfLineIndex: Int? {
		guard let selectedRange = selectedTextRange,
			let startOfLinePosition = tokenizer.position(from: selectedRange.start, toBoundary: .line, inDirection:
				UITextDirection.storage(.backward)) else {
				return nil
		}
		return offset(from: beginningOfDocument, to: startOfLinePosition)
	}
	
	var isCurrentCharacterBold: Bool {
		guard let currentCursorPosition = currentCursorPosition else {
			return false
		}
		return isCharacterBold(for: currentCursorPosition)
	}
	
	var isCurrentCharacterItalic: Bool {
		guard let currentCursorPosition = currentCursorPosition else {
			return false
		}
		return isCharacterItalic(for: currentCursorPosition)
	}
	
	var isCurrentLineIndented: Bool {
		guard let currentCursorPosition = currentCursorPosition else {
			return false
		}
		return indentationPresent(at: currentCursorPosition)
	}
	
	func isCharacterBold(for index: Int) -> Bool {
		guard let font = attributedText.font(at: index) else {
			return false
		}
		return font.isBold
	}
	
	func isCharacterItalic(for index: Int) -> Bool {
		guard let font = attributedText.font(at: index) else {
			return false
		}
		return font.isItalic
	}
	
	func characterIndex(at location: CGPoint) -> Int? {
		var finalLocation = location
		finalLocation.x -= textContainerInset.left
		finalLocation.y -= textContainerInset.top
		
		let characterIndex = layoutManager.characterIndex(for: finalLocation, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
		return characterIndex
	}
    
    var currentWord: String? {
        let regex = try! NSRegularExpression(pattern: "\\S+$")
        let textRange = NSRange(location: 0, length: selectedRange.location)
        if let range = regex.firstMatch(in: text, range: textRange)?.range {
            return String(text[Range(range, in: text)!])
        }
        return nil
    }
}
