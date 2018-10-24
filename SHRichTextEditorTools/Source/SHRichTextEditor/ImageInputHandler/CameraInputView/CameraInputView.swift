//
//  CameraInputView.swift
//  DentalPlex
//
//  Created by Susmita Horrow on 16/01/17.
//  Copyright © 2017 Susmita Horrow. All rights reserved.
//

import Foundation
import UIKit

class CameraInputView: UIView {
	var actionOnCameraTap: (() -> ())?
	var actionOnLibraryTap: (() -> ())?

	class func cameraInputView() -> CameraInputView {
		let nib = UINib(nibName: String(describing: CameraInputView.self), bundle: Bundle(for: self.classForCoder()))
		return nib.instantiate(withOwner: self, options: nil).first as! CameraInputView
	}
	
	@IBAction func didTapCamera(_ sender: Any) {
		if let action = self.actionOnCameraTap {
			action()
		}
	}
	
	@IBAction func didTapLibrary(_ sender: Any) {
		if let action = self.actionOnLibraryTap {
			action()
		}
	}
}
