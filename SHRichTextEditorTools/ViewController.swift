//
//  ViewController.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
	var textEditor: SHRichTextEditor!
	@IBOutlet weak var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.textEditor = SHRichTextEditor(textView: self.textView)
		let wordCountToolBarItem = ToolBarButton.configureWordCountToolBarButton(
			countTextColor: UIColor.blue,
			textView: self.textView,
			textViewDelegate: self.textEditor.textViewDelegate)
		self.textEditor.toolBarItems = [
			self.textEditor.boldBarItem(),
			self.textEditor.italicBarItem(),
			self.textEditor.indentationBarItem(),
			self.textEditor.flexibleSpaceToolBarItem,
			self.textEditor.linkToolBarItem(),
			self.textEditor.imageToolBarItem(),
			wordCountToolBarItem
		]
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
}
