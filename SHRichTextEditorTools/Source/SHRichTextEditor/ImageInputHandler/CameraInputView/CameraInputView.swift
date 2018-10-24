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

	class func cameraInputView() -> CameraInputView? {
		var nib: UINib?
		if let bundle = Bundle.getResourcesBundle(for: CameraInputView.self) {
			nib = UINib(nibName: "CameraInputView", bundle: bundle)
		} else {
			nib = UINib(nibName: "CameraInputView", bundle: nil)
		}
		return nib?.instantiate(withOwner: self, options: nil)[0] as? CameraInputView

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
