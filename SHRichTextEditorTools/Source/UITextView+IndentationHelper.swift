//
//  UITextView+IndentationHelper.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

protocol IndentationEnabled {
	var indentationString: String { get }
	var indentationStringWithoutNewline: String { get }
}

extension IndentationEnabled {
	var indentationString: String {
		return "\n\t • "
	}
	
	var indentationStringWithoutNewline: String {
		return "\t • "
	}
}

protocol IndentationProtocol {
	func addIndentation(at index: Int)
	func removeIndentation(at index: Int)
	func toggleIndentation(at index: Int)
	func indentationRange(at index: Int) -> NSRange?
}

extension UITextView: IndentationEnabled {}

extension UITextView: IndentationProtocol {
	
	func addIndentation(at index: Int) {
		let attributedStringToAppend: NSMutableAttributedString = NSMutableAttributedString(string: indentationString)
		let contentOffset = self.contentOffset
		let selectedRange = selectedTextRange
		attributedStringToAppend.addAttribute(NSFontAttributeName,
		                                      value: self.attributedText.font(at: index) ?? font!,
		                                      range: NSRange(location: 0, length: attributedStringToAppend.length))
		let updatedText: NSMutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
		
		updatedText.insert(attributedStringToAppend, at: index)
		attributedText = updatedText
		
		if let currentSelectedRange = selectedRange,
			let start = position(from: currentSelectedRange.start, offset: attributedStringToAppend.length),
			let end = position(from: currentSelectedRange.end, offset: attributedStringToAppend.length) {
			selectedTextRange = textRange(from: start, to: end)
		}
		setContentOffset(contentOffset, animated: false)
	}
	
	func removeIndentation(at index: Int) {
		guard let range = indentationRange(at: index) else {
			return
		}
		let selectedRange = selectedTextRange
		let updatedText: NSMutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
		updatedText.replaceCharacters(in: range, with: "")
		attributedText = updatedText
		if let currentSelectedRange = selectedRange,
			let start = position(from: currentSelectedRange.start, offset: -indentationString.characters.count),
			let end = position(from: currentSelectedRange.end, offset: -indentationString.characters.count) {
			selectedTextRange = textRange(from: start, to: end)
		}
		setContentOffset(contentOffset, animated: false)
	}
	
	func toggleIndentation(at index: Int) {
		guard let index = currentCursorPosition else {
			return
		}
		if let _ = indentationRange(at: index) {
			removeIndentation(at: index)
		} else {
			addIndentation(at: index)
		}
	}
	
	func indentationRange(at index: Int) -> NSRange? {
		guard index < text.characters.count else {
			return nil
		}
		var lineRange = NSMakeRange(NSNotFound, 0)
		layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
		guard lineRange.location < attributedText.length else {
			return nil
		}
		let rangeOfText = (text as NSString).substring(with: lineRange)
		let indentationRange = (rangeOfText as NSString).range(of: indentationStringWithoutNewline)
		if indentationRange.length == 0 {
			return nil
		} else {
			return NSRange(location: lineRange.location - 1, length: indentationString.characters.count)
		}
	}
	
	func indentationPresent(at index: Int) -> Bool {
		guard let startOfLineIndex = startOfLineIndex, index > startOfLineIndex else {
			return false
		}
		let range = NSRange(location: startOfLineIndex, length: index - startOfLineIndex)
		let substring = (text as NSString).substring(with: range)
		return substring.contains(indentationStringWithoutNewline)
	}
	
	func addIndentationAtStartOfLine() {
		if let startOfLineIndex = startOfLineIndex {
			addIndentation(at: startOfLineIndex)
		}
	}
	
	func removeIndentationFromStartOfLine() {
		if let startOfLineIndex = startOfLineIndex {
			removeIndentation(at: startOfLineIndex)
		}
	}
	
	func toggleIndentation() {
		guard let index = currentCursorPosition else {
			return
		}
		if indentationPresent(at: index) {
			removeIndentationFromStartOfLine()
		} else {
			addIndentationAtStartOfLine()
		}
	}
}
