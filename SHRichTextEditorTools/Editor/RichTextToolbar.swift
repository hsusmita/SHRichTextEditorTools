//
//  RichTextToolbar.swift
//  DentalPlex
//
//  Created by Susmita Horrow on 05/01/17.
//  Copyright © 2017 Susmita Horrow. All rights reserved.
//

import UIKit

enum ToolbarButtonType: Int {
	case bullet
	case bold
	case italic
	case link
	case camera
}

typealias BarButtonAction = (() -> ())

class RichTextToolbar: UIToolbar {
	@IBOutlet weak var bulletButton: UIBarButtonItem!
	@IBOutlet weak var boldButton: UIBarButtonItem!
	@IBOutlet weak var italicButton: UIBarButtonItem!
	@IBOutlet weak var linkButton: UIBarButtonItem!
	@IBOutlet weak var cameraButton: UIBarButtonItem!

	private var actions: [ToolbarButtonType: BarButtonAction] = [:]

	class func toolbar() -> RichTextToolbar {
		let toolBar = UINib(nibName: "RichTextToolbar", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! RichTextToolbar
		return toolBar
	}
}
