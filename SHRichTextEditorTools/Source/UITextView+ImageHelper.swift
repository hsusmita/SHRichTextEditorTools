//
//  UITextView+ImageHelper.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

public protocol ImageInputEnabled: class {
	func showImageInputView(completion: @escaping (UIImage?) -> ())
	var imageSelectionView: UIView? { get }
}

public protocol ImageInsertProtocol {
	var imageInputViewProvider: ImageInputEnabled? { get }
	func insertImage(image: UIImage, at index: Int)
	func selectImage(at index: Int, selectionView: UIView)
	func deselectImage(at index: Int, selectionView: UIView)
}

private var imageInputViewProviderKey: UInt8 = 0

extension UITextView: ImageInsertProtocol {
	
	public var imageInputViewProvider: ImageInputEnabled? {
		get {
			return objc_getAssociatedObject(self, &imageInputViewProviderKey) as? ImageInputEnabled
		}
		
		set {
			objc_setAssociatedObject(self, &imageInputViewProviderKey, newValue, .OBJC_ASSOCIATION_RETAIN)
		}
	}
	
	public func insertImage(image: UIImage, at index: Int) {
		let oldWidth = image.size.width
		let scaleFactor = oldWidth / (self.frame.size.width - 20)
		self.attributedText = self.attributedText.insert(image, at: index, scaleFactor: scaleFactor)
	}

	public func selectImage(at index: Int, selectionView: UIView) {
		let glyphRange: NSRange = layoutManager.range(ofNominallySpacedGlyphsContaining: index)
		var textRect: CGRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
		textRect.origin.x += textContainerInset.left
		textRect.origin.y += textContainerInset.top
		selectionView.frame = textRect
		addSubview(selectionView )
	}
	
	public func deselectImage(at index: Int, selectionView: UIView) {
		imageInputViewProvider?.imageSelectionView?.removeFromSuperview()
	}
}
