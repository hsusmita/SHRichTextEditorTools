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
		case fixed
		case flexible
	}

	let type: SpacerType
	public var barButtonItem = UIBarButtonItem()

	init(type: SpacerType) {
		self.type = type
		switch self.type {
		case .fixed:
			self.barButtonItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
		case .flexible:
			self.barButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
		}
	}
}
