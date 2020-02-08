//
//  ImageBorderView.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 30/01/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit

class ImageBorderView: UIView {
	@IBOutlet var deleteButton: UIButton!
	var actionOnDeleteTap: (() -> ())?

	override func awakeFromNib() {
		super.awakeFromNib()
		self.setBorder()
	}

	static func imageBorderView() -> ImageBorderView {
		let nib = UINib(nibName: String(describing: ImageBorderView.self), bundle: Bundle(for: self.classForCoder()))
		return nib.instantiate(withOwner: self, options: nil).first as! ImageBorderView
	}

	private func setBorder() {
		self.layer.borderColor = self.tintColor.cgColor
		self.layer.borderWidth = 4.0
		self.deleteButton.backgroundColor = self.tintColor
	}

	@IBAction private func didTapDeleteButton(_ sender: Any) {
		self.removeFromSuperview()
		self.actionOnDeleteTap?()
	}
}
