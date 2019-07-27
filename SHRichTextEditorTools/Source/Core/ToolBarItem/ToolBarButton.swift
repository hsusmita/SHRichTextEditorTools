//
//  ToolBarButton.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 27/09/18.
//  Copyright © 2018 hsusmita. All rights reserved.
//

import UIKit

/**
 ToolBarButton represents tapable elements to be shown in the toolbar.
 */
open class ToolBarButton: ToolBarItem {
    public enum ButtonType {
        case title(title: String)
        case attributed(title: String, attributes: [UIControl.State.RawValue: [NSAttributedString.Key : Any]])
        case image(image: UIImage)
    }
    
    let type: ButtonType
    let actionOnTap: (ToolBarButton) -> Void
    let actionOnSelection: (ToolBarButton, Bool) -> Void
    
    var isSelected = false {
        didSet {
            self.actionOnSelection(self, self.isSelected)
        }
    }
    
    public var barButtonItem = UIBarButtonItem()
    
    public init(type: ButtonType,
                actionOnTap: @escaping (ToolBarButton) -> Void,
                actionOnSelection: @escaping (ToolBarButton, Bool) -> Void) {
        self.type = type
        self.actionOnTap = actionOnTap
        self.actionOnSelection = actionOnSelection
        
        switch self.type {
        case .title(let title):
            self.barButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(performActionOnTap))
        case .attributed(let title, let attributes):
            self.barButtonItem = UIBarButtonItem(title: title, style: .plain, target: self, action: #selector(performActionOnTap))
            attributes.forEach { (key, value) in
                let state = UIControl.State(rawValue: key)
                self.barButtonItem.setTitleTextAttributes(value, for: state)
            }
        case .image(let image):
            self.barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(performActionOnTap))
        }
    }
    
    @objc func performActionOnTap() {
        self.isSelected = !self.isSelected
        self.actionOnTap(self)
    }
}
