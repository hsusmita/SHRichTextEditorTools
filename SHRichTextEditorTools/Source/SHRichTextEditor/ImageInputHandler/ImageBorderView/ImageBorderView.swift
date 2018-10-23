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
		let bundle = Bundle(for: ImageBorderView.classForCoder())
		return UINib(nibName: "ImageBorderView", bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! ImageBorderView
	}

	private func setBorder() {
		self.layer.borderColor = self.tintColor.cgColor
		self.layer.borderWidth = 3.0
		self.deleteButton.backgroundColor = self.tintColor
	}

	@IBAction private func didTapDeleteButton(_ sender: Any) {
		self.removeFromSuperview()
		self.actionOnDeleteTap?()
	}
}
