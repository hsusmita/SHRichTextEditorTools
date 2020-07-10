//
//  UITextView+LinkPresentationHelper.swift
//  SHRichTextEditorTools
//
//  Created by Ajay Bhanushali on 29/06/20.
//  Copyright © 2020 hsusmita. All rights reserved.
//

import UIKit.UITextView
import LinkPresentation

extension UITextView {

    @available(iOS 13.0, *)
    func insertLPView(for urlString: String) {
        getLPLinkView(for: urlString) { [weak self] linkView in
            guard let self = self else { return }
            
            self.superview?.insertSubview(linkView, belowSubview: self)
            linkView.sizeToFit()

            let renderer = UIGraphicsImageRenderer(size: linkView.frame.size)
            let image = renderer.image {
                linkView.layer.render(in: $0.cgContext)
            }

            linkView.removeFromSuperview()
            
            let attachment = NSTextAttachment()
            attachment.image = image
            attachment.bounds = CGRect(origin: .zero, size: image.size)
            
            let currentAtStr = NSMutableAttributedString(attributedString: self.attributedText)
            let attachmentAtStr = NSAttributedString(attachment: attachment)
            
            if let selectedRange = self.selectedTextRange {
                let cursorIndex = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
                currentAtStr.insert(attachmentAtStr, at: cursorIndex)
                currentAtStr.addAttributes(self.typingAttributes, range: NSRange(location: cursorIndex, length: 1))
            } else {
                currentAtStr.append(attachmentAtStr)
            }
            
            guard let regex = try? NSRegularExpression(pattern: "\\S+$") else { return }
            let textRange = NSRange(location: 0, length: self.selectedRange.location)
            
            if let range = regex.firstMatch(in: self.text, range: textRange)?.range {
                currentAtStr.replaceCharacters(in: range, with: "")
            }
            
            self.attributedText = currentAtStr
        }
    }
    
    @available(iOS 13.0, *)
    func getLPLinkView(for urlString: String, callBack: @escaping (LPLinkView)->Void) {
        let metadataProvider = LPMetadataProvider()
        
        let linkView = LPLinkView(metadata: LPLinkMetadata())
        linkView.frame.size = CGSize(width: self.frame.size.width-self.textContainer.lineFragmentPadding*2,
                                     height: self.frame.size.height)
        
        if let url = URL(string: urlString) {
            if let metadata = UserDefaults.standard.metadata(for: url) {
                linkView.metadata = metadata
                callBack(linkView)
                return
            }
            metadataProvider.startFetchingMetadata(for: url) { (metadata, error) in
                if let error = error {
                    print(error)
                }
                else if let metadata = metadata {
                    DispatchQueue.main.async {
                        UserDefaults.standard.store(metadata)
                        linkView.metadata = metadata
                        callBack(linkView)
                        return
                    }
                }
            }
        }
    }
}


