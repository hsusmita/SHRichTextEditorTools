//
//  UITextView+IndentationHelper.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

public protocol IndentationEnabled {
	var indentationString: String { get }
	var indentationStringWithoutNewline: String { get }
}

extension IndentationEnabled {
	public var indentationString: String {
		return "\n\t • "
	}
	
	public var indentationStringWithoutNewline: String {
		return "\t • "
	}
}

public protocol IndentationProtocol {
	func addIndentation(at index: Int)
	func removeIndentation(at index: Int)
	func toggleIndentation(at index: Int)
	func indentationRange(at index: Int) -> NSRange?
	func indentationPresent(at index: Int) -> Bool
}

extension UITextView: IndentationEnabled {}

extension UITextView: IndentationProtocol {
	
	public func addIndentation(at index: Int) {
		let attributedStringToAppend: NSMutableAttributedString = NSMutableAttributedString(string: indentationString)
		let contentOffset = self.contentOffset
		let selectedRange = selectedTextRange
		attributedStringToAppend.addAttribute(NSAttributedStringKey.font,
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
		self.delegate?.textViewDidChange?(self)
	}
	
	public func removeIndentation(at index: Int) {
		guard let range = indentationRange(at: index) else {
			return
		}
		let selectedRange = selectedTextRange
		let updatedText: NSMutableAttributedString = NSMutableAttributedString(attributedString: attributedText)
		updatedText.replaceCharacters(in: range, with: "")
		attributedText = updatedText
		if let currentSelectedRange = selectedRange,
			let start = position(from: currentSelectedRange.start, offset: -indentationString.count),
			let end = position(from: currentSelectedRange.end, offset: -indentationString.count) {
			selectedTextRange = textRange(from: start, to: end)
		}
		setContentOffset(contentOffset, animated: false)
		self.delegate?.textViewDidChange?(self)
	}
	
	public func toggleIndentation(at index: Int) {
		guard let index = currentCursorPosition else {
			return
		}
		if let _ = indentationRange(at: index) {
			removeIndentation(at: index)
		} else {
			addIndentation(at: index)
		}
	}
	
	public func indentationRange(at index: Int) -> NSRange? {
		guard index < text.count else {
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
			return NSRange(location: lineRange.location - 1, length: indentationString.count)
		}
	}
	
	public func indentationPresent(at index: Int) -> Bool {
		guard let startOfLineIndex = startOfLineIndex, index > startOfLineIndex, index < text.count else {
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
