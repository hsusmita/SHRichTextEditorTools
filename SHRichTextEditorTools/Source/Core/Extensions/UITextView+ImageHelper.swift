//
//  UITextView+ImageHelper.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

public protocol ImageInputHandler: class {
	func showImageInputView(completion: @escaping (UIImage?) -> ())
	var imageSelectionView: UIView? { get }
}

public extension UITextView {
	func insertImage(image: UIImage, at index: Int) {
		let oldWidth = image.size.width
		let scaleFactor = oldWidth / (self.frame.size.width - 20)
		let spaceString = NSMutableAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font: self.font ?? UIFont.systemFont(ofSize: 12.0)])
		let finalAttributedString = NSMutableAttributedString(attributedString: spaceString)
		guard let attributedStringWithImage = self.attributedText.insert(image, at: index, scaleFactor: scaleFactor) else {
			return
		}
		finalAttributedString.append(attributedStringWithImage)
		finalAttributedString.append(spaceString)
		self.attributedText = finalAttributedString
	}

	func selectImage(at index: Int, selectionView: UIView) {
		let glyphRange: NSRange = layoutManager.range(ofNominallySpacedGlyphsContaining: index)
		var textRect: CGRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
		textRect.origin.x += textContainerInset.left
		textRect.origin.y += textContainerInset.top
		selectionView.frame = textRect
		selectionView.removeFromSuperview()
		addSubview(selectionView)
	}
	
	public func deselectImage(at index: Int, selectionView: UIView) {
		selectionView.removeFromSuperview()
	}
}
