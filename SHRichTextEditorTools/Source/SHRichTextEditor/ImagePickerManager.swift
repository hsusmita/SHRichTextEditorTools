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

public typealias ImagePickerManagerCompletionBlock = (_ image: UIImage?) -> ()

public protocol ImagePickerProviderProtocol: class {
    func showImagePicker(_ type: UIImagePickerController.SourceType,
                         onViewController: UIViewController,
                         completion: @escaping ImagePickerManagerCompletionBlock)
}

open class ImagePickerManager: NSObject, ImagePickerProviderProtocol {
    private var parentViewController: UIViewController?
    fileprivate var actionOnImagePickerDismiss: ImagePickerManagerCompletionBlock?
    fileprivate var imagePicker: UIImagePickerController?
    
    public func showImagePicker(_ type: UIImagePickerController.SourceType,
                                onViewController: UIViewController,
                                completion: @escaping ImagePickerManagerCompletionBlock) {
        self.actionOnImagePickerDismiss = completion
        switch type {
        case .camera:
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker = self.imagePicker(for: .camera)
                onViewController.present(self.imagePicker!, animated: true, completion: nil)
            }
        case .photoLibrary:
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                self.imagePicker = self.imagePicker(for: .photoLibrary)
                onViewController.present(self.imagePicker!, animated: true, completion: nil)
            }
        default:
            break
        }
    }
    
    func imagePicker(for type: UIImagePickerController.SourceType) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = type
        picker.delegate = self
        picker.allowsEditing = false
        return picker
    }
}

extension ImagePickerManager: UINavigationControllerDelegate { }

extension ImagePickerManager: UIImagePickerControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let chosenImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        picker.dismiss(animated: true, completion: { [unowned self] in
            self.actionOnImagePickerDismiss!(chosenImage)
        })
    }
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: { [unowned self] in
            self.actionOnImagePickerDismiss!(nil)
        })
    }
}
