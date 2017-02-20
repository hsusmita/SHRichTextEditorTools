//
//  ViewController.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 20/02/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var textEditor: SHRichTextEditor?
	@IBOutlet weak var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		textEditor = SHRichTextEditor(textView: textView)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

