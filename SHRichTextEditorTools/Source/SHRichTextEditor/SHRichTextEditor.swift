//
//  SHRichTextEditor.swift
//  SHRichTextEditor
//
//  Created by Susmita Horrow on 30/01/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import Foundation
import UIKit

open class SHRichTextEditor: NSObject, RichTextEditor {
	public let textView: UITextView
	public let toolBar = UIToolbar()
	public let textViewDelegate = TextViewDelegate()
	public var toolBarItems: [ToolBarItem] = [] {
		didSet {
			self.configure()
		}
	}

	public let toolBarSelectedTintColor: UIColor
	public let toolBarDefaultTintColor: UIColor
	private var defaultImageInputHandler: ImageInputHandler
	private var defaultLinkInputHandler: LinkInputHandler

	public static let defaultIndentationButton = ToolBarButton.ButtonType.image(image: UIImage(named: "Bullet")!)
	public static let defaultItalicButton = ToolBarButton.ButtonType.image(image: UIImage(named: "Italic")!)
	public static let defaultBoldButton = ToolBarButton.ButtonType.image(image: UIImage(named: "Bold")!)
	public static let defaultLinkButton = ToolBarButton.ButtonType.image(image: UIImage(named: "Link")!)
	public static let defaultImageButton = ToolBarButton.ButtonType.image(image: UIImage(named: "Picture-Icon")!)

	public init(textView: UITextView,
		 defaultTintColor: UIColor = .gray,
		 selectedTintColor: UIColor = UIColor(red: 57/255.0, green: 200/255.0, blue: 129/255.0, alpha: 1)) {
		self.textView = textView
		self.toolBarDefaultTintColor = defaultTintColor
		self.toolBarSelectedTintColor = selectedTintColor
		self.defaultImageInputHandler = TextViewImageInputHandler(textView: self.textView)
		self.defaultLinkInputHandler = LinkInputAlert()
		super.init()
	}

	public func boldBarItem(type: ToolBarButton.ButtonType = SHRichTextEditor.defaultBoldButton,
					 actionOnSelection: ((ToolBarButton, Bool) -> Void)? = nil) -> ToolBarItem {
		let defaultAction: ((ToolBarButton, Bool) -> Void) = { [unowned self] (item, isSelected) in
			item.barButtonItem.tintColor = isSelected ? self.toolBarSelectedTintColor : self.toolBarDefaultTintColor
		}
		return ToolBarButton.configureBoldToolBarButton(
			type: type,
			actionOnSelection: actionOnSelection ?? defaultAction,
			textView: self.textView,
			textViewDelegate: self.textViewDelegate)
	}

	public func italicBarItem(type: ToolBarButton.ButtonType = SHRichTextEditor.defaultItalicButton,
					   actionOnSelection: ((ToolBarButton, Bool) -> Void)? = nil) -> ToolBarItem {
		let defaultAction: ((ToolBarButton, Bool) -> Void) = { [unowned self] (item, isSelected) in
			item.barButtonItem.tintColor = isSelected ? self.toolBarSelectedTintColor : self.toolBarDefaultTintColor
		}
		return ToolBarButton.configureItalicToolBarButton(
			type: type,
			actionOnSelection: actionOnSelection ?? defaultAction,
			textView: self.textView,
			textViewDelegate: self.textViewDelegate)
	}

	public func indentationBarItem(type: ToolBarButton.ButtonType = SHRichTextEditor.defaultIndentationButton,
							actionOnSelection: ((ToolBarButton, Bool) -> Void)? = nil) -> ToolBarItem {
		let defaultAction: ((ToolBarButton, Bool) -> Void) = { [unowned self] (item, isSelected) in
			item.barButtonItem.tintColor = isSelected ? self.toolBarSelectedTintColor : self.toolBarDefaultTintColor
		}
		return ToolBarButton.configureIndentationToolBarButton(
			type: type,
			actionOnSelection: actionOnSelection ?? defaultAction,
			textView: self.textView,
			textViewDelegate: self.textViewDelegate)
	}

	public func linkToolBarItem(type: ToolBarButton.ButtonType = SHRichTextEditor.defaultLinkButton,
						 actionOnSelection: ((ToolBarButton, Bool) -> Void)? = nil,
						 linkInputHandler: LinkInputHandler? = nil) -> ToolBarItem {
		let defaultAction: ((ToolBarButton, Bool) -> Void) = { [unowned self] (item, isSelected) in
			item.barButtonItem.tintColor = isSelected ? self.toolBarSelectedTintColor : self.toolBarDefaultTintColor
		}
		return ToolBarButton.configureLinkToolBarButton(
			type: type,
			actionOnSelection: actionOnSelection ?? defaultAction,
			linkInputHandler: linkInputHandler ?? self.defaultLinkInputHandler,
			textView: self.textView,
			textViewDelegate: self.textViewDelegate)
	}

	public func imageToolBarItem(type: ToolBarButton.ButtonType = SHRichTextEditor.defaultImageButton,
						  actionOnSelection: ((ToolBarButton, Bool) -> Void)? = nil,
						  imageInputHandler: ImageInputHandler? = nil) -> ToolBarItem {
		let defaultAction: ((ToolBarButton, Bool) -> Void) = { [unowned self] (item, isSelected) in
			item.barButtonItem.tintColor = isSelected ? self.toolBarSelectedTintColor : self.toolBarDefaultTintColor
		}
		return ToolBarButton.configureImageToolBarButton(
			type: type,
			actionOnSelection: actionOnSelection ?? defaultAction,
			imageInputHandler: imageInputHandler ?? self.defaultImageInputHandler,
			textView: self.textView,
			textViewDelegate: self.textViewDelegate)
	}

	public let fixedSpaceToolBarItem = ToolBarSpacer(type: .fixed)
	public let flexibleSpaceToolBarItem = ToolBarSpacer(type: .flexible)
}
