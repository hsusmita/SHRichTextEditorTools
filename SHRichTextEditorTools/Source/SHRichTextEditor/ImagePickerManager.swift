//
//  ImagePickerManager.swift
//  DentalPlex
//
//  Created by Susmita Horrow on 16/01/17.
//  Copyright © 2017 Susmita Horrow. All rights reserved.
//

import Foundation

import Foundation
import UIKit

typealias ImagePickerManagerCompletionBlock = (_ image: UIImage?) -> ()

class ImagePickerManager: NSObject {
	
	private var parentViewController: UIViewController?
	fileprivate var actionOnImagePickerDismiss: ImagePickerManagerCompletionBlock?
	fileprivate var imagePicker: UIImagePickerController?
	
	init(with parentViewController: UIViewController) {
		super.init()
		self.parentViewController = parentViewController
	}
	
	func showImagePicker(_ type: UIImagePickerControllerSourceType, completion: @escaping ImagePickerManagerCompletionBlock) {
		self.actionOnImagePickerDismiss = completion
		switch type {
		case .camera:
			if UIImagePickerController.isSourceTypeAvailable(.camera) {
				self.imagePicker = self.imagePicker(for: .camera)
				self.parentViewController?.present(self.imagePicker!, animated: true, completion: nil)
			}
		case .photoLibrary:
			if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
				self.imagePicker = self.imagePicker(for: .photoLibrary)
				self.parentViewController?.present(self.imagePicker!, animated: true, completion: nil)
			}
		default:
			break
		}
	}
	
	func imagePicker(for type: UIImagePickerControllerSourceType) -> UIImagePickerController {
		let picker = UIImagePickerController()
		picker.sourceType = type
		picker.delegate = self
		picker.allowsEditing = false
		return picker
	}
}

extension ImagePickerManager: UINavigationControllerDelegate { }

extension ImagePickerManager: UIImagePickerControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		let chosenImage: UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
		picker.dismiss(animated: true, completion: { [unowned self] in
			self.actionOnImagePickerDismiss!(chosenImage)
		})
	}
	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		picker.dismiss(animated: true, completion: { [unowned self] in
			self.actionOnImagePickerDismiss!(nil)
		})
	}
}
