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
		let inputVIew = UINib(nibName: "CameraInputView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CameraInputView
		return inputVIew
	}
	
	@IBAction func didTapCamera(_ sender: Any) {
		if let action = actionOnCameraTap {
			action()
		}
	}
	
	@IBAction func didTapLibrary(_ sender: Any) {
		if let action = actionOnLibraryTap {
			action()
		}
	}
}
