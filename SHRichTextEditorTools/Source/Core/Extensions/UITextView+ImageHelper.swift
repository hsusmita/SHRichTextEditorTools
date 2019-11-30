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
        let scaleFactor = oldWidth / (self.frame.size.width - 10)
        let spaceString = NSMutableAttributedString(string: "\n", attributes: self.typingAttributes)
        let finalAttributedString = NSMutableAttributedString(attributedString: spaceString)
        guard let attributedStringWithImage = self.attributedText.insert(image, at: index, scaleFactor: scaleFactor) else {
            return
        }
        finalAttributedString.append(attributedStringWithImage)
        finalAttributedString.append(spaceString)
        finalAttributedString.addAttributes(self.typingAttributes, range: NSRange(location: 0, length: finalAttributedString.length))
        self.attributedText = finalAttributedString
    }
    
    func selectImage(at index: Int, selectionView: UIView) {
        let glyphRange: NSRange = layoutManager.range(ofNominallySpacedGlyphsContaining: index)
        var textRect: CGRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        textRect.size.height = self.frame.size.width - 10
        textRect.origin.x += textContainerInset.left
        textRect.origin.y += textContainerInset.top
        selectionView.frame = textRect
        selectionView.removeFromSuperview()
        addSubview(selectionView)
    }
    
    func deselectImage(at index: Int, selectionView: UIView) {
        selectionView.removeFromSuperview()
    }
    
    func clearImageSelection(selectionView: UIView) {
        selectionView.removeFromSuperview()
    }
}
