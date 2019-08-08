//
//  CameraInputView.swift
//  DentalPlex
//
//  Created by Susmita Horrow on 16/01/17.
//  Copyright © 2017 Susmita Horrow. All rights reserved.
//

import Foundation
import UIKit

public class CameraInputView: UIView {
    @IBOutlet private var cameraIconImageView: UIImageView!
    @IBOutlet private var libraryIconImageView: UIImageView!

    @IBOutlet var cameraHeightConstraint: NSLayoutConstraint!
    @IBOutlet var cameraWidthConstraint: NSLayoutConstraint!
    @IBOutlet var libraryHeightConstraint: NSLayoutConstraint!
    @IBOutlet var libraryWidthConstraint: NSLayoutConstraint!

    public var actionOnCameraTap: (() -> ())?
    public var actionOnLibraryTap: (() -> ())?
    public var cameraIcon: UIImage? {
        didSet {
            self.cameraIconImageView?.image = self.cameraIcon
        }
    }
    public var libraryIcon: UIImage? {
        didSet {
            self.libraryIconImageView.image = self.libraryIcon
        }
    }
    
    public var cameraIconSize: CGSize = CGSize(width: 90.0, height: 80.0) {
        didSet {
            self.cameraHeightConstraint?.constant = self.cameraIconSize.height
            self.cameraWidthConstraint?.constant = self.cameraIconSize.width
        }
    }
    public var libraryIconSize: CGSize = CGSize(width: 70.0, height: 70.0) {
        didSet {
            self.libraryHeightConstraint?.constant = self.libraryIconSize.height
            self.libraryWidthConstraint?.constant = self.libraryIconSize.width
        }
    }
    
    public class func cameraInputView() -> CameraInputView {
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
