//
//  NSAttributedString+Helper.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 30/01/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

public extension NSAttributedString {
    func font(at index: Int) -> UIFont? {
        var range: NSRange = NSRange()
        guard index < length else {
            return nil
        }
        let currentAttributes = attributes(at: index, effectiveRange: &range)
        let font: UIFont = currentAttributes[NSAttributedString.Key.font] as! UIFont
        return font
    }
    
    func linkPresent(at index: Int) -> Bool {
        var range: NSRange = NSRange()
        guard index < length else {
            return false
        }
        let currentAttributes = attributes(at: index, effectiveRange: &range)
        return currentAttributes[NSAttributedString.Key.link] != nil
    }
    
    func imagePresent(at index: Int) -> Bool {
        guard index < length else {
            return false
        }
        let attributeValue = attribute(NSAttributedString.Key.attachment, at: index, effectiveRange: nil)
        return attributeValue != nil
    }
    
    func insert(_ image: UIImage, at index: Int, scaleFactor: CGFloat) -> NSAttributedString? {
        guard length >= index else {
            return nil
        }
        
        let textAttachment = NSTextAttachment()
        textAttachment.image = image
        textAttachment.bounds = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 25, height: UIScreen.main.bounds.width - 25)
        //        textAttachment.image = UIImage(cgImage: image.cgImage!, scale: scaleFactor, orientation: .up)
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.insert(attrStringWithImage, at: index)
        mutableAttributedString.addAttribute(NSAttributedString.Key.attachment, value: textAttachment, range: NSRange(location: index, length: 1))
        return mutableAttributedString
    }
}
