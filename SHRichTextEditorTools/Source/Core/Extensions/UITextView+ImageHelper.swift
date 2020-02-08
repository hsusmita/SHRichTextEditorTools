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
        let scaleFactor = oldWidth / (self.frame.size.width)
        guard let attributedStringWithImage = self.attributedText.insert(image, at: index, scaleFactor: scaleFactor) else {
            return
        }
        let finalAttributedString = NSMutableAttributedString(attributedString: attributedStringWithImage)
        finalAttributedString.addAttributes(self.typingAttributes, range: NSRange(location: 0, length: finalAttributedString.length))
        self.attributedText = finalAttributedString
    }
    
    func selectImage(at index: Int, selectionView: UIView) {
        let glyphRange: NSRange = layoutManager.range(ofNominallySpacedGlyphsContaining: index)
        var textRect: CGRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        if let attachment = self.attributedText.attribute(NSAttributedString.Key.attachment, at: index, longestEffectiveRange: nil, in: NSRange(location: 0, length: self.attributedText.length)) as? NSTextAttachment {
            textRect.size.height = attachment.bounds.height
            textRect.size.width = attachment.bounds.width
            if let image = attachment.image,
                attachment.bounds.height == 0 {
                textRect.size.height = image.size.height
                textRect.size.width = image.size.width
            }
        }
        textRect.origin.x += self.textContainerInset.left
        textRect.origin.y += self.textContainerInset.top
        selectionView.frame = textRect
        selectionView.removeFromSuperview()
        self.addSubview(selectionView)
        if let newPosition = self.position(from: self.beginningOfDocument, offset: index + 1) {
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func deselectImage(at index: Int, selectionView: UIView) {
        selectionView.removeFromSuperview()
    }
    
    func clearImageSelection(selectionView: UIView) {
        selectionView.removeFromSuperview()
    }
}
