//
//  ToolBarSpacer.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 27/09/18.
//  Copyright © 2018 hsusmita. All rights reserved.
//

import UIKit

/**
 ToolBarSpacer represents spacer elements which can be used to manage layout of elements in the toolbar.
 */

open class ToolBarSpacer: ToolBarItem {
    public enum SpacerType {
        case fixed(width: CGFloat)
        case flexible
    }
    
    let type: SpacerType
    public var barButtonItem = UIBarButtonItem()
    
    init(type: SpacerType) {
        self.type = type
        switch self.type {
        case .fixed(let width):
            self.barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            self.barButtonItem.width = width
        case .flexible:
            self.barButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
    }
}
