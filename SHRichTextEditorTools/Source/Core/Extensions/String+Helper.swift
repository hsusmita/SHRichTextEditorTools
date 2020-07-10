//
//  String+Helper.swift
//  SHRichTextEditorTools
//
//  Created by Ajay Bhanushali on 29/06/20.
//  Copyright © 2020 hsusmita. All rights reserved.
//

import Foundation

extension String {
    var isValidURL: Bool {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else { return false }
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
}
