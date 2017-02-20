//
//  ImageBorderView.swift
//  SHRichTextEditor
//
//  Created by Susmita Horrow on 30/01/17.
//  Copyright © 2017 hsusmita. All rights reserved.
//

import UIKit

class ImageBorderView: UIView {
	
	override func draw(_ rect: CGRect) {
		let roundRect = CAShapeLayer()
		roundRect.strokeColor = UIColor.red.cgColor
		roundRect.fillColor = UIColor.clear.cgColor
		roundRect.lineWidth = 3.0
		let bezeirPath = UIBezierPath(rect: bounds)
		bezeirPath.stroke()
		roundRect.path = bezeirPath.cgPath
		self.layer.addSublayer(roundRect)
	}
	
	static func imageBorderView() -> ImageBorderView {
		return Bundle.main.loadNibNamed("ImageBorderView", owner: self, options: nil)?.first as! ImageBorderView
	}
	
	@IBAction func didTapDeleteButton(_ sender: Any) {
		self.removeFromSuperview()
	}
}
