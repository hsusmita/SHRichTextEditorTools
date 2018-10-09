//
//  ToolBarItem.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 26/09/18.
//  Copyright © 2018 hsusmita. All rights reserved.
//

import UIKit

/**
ToolBarItem represents the items to be shown on the toolbar.
*/

public protocol ToolBarItem: class {
	var barButtonItem: UIBarButtonItem { get }
}
