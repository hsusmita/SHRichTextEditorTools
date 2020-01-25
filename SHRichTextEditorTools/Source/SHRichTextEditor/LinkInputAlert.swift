//
//  LinkInputAlert.swift
//  SHRichTextEditorTools
//
//  Created by Susmita Horrow on 08/10/18.
//  Copyright © 2018 hsusmita. All rights reserved.
//

import UIKit

class LinkInputAlert: LinkInputHandler {
    var linkAttributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue,
                NSAttributedString.Key.foregroundColor: UIColor.blue]
    }
    
    func showLinkInputView(completion: @escaping (URL?) -> ()) {
        let alertController = UIAlertController(title: "Add a link", message: "", preferredStyle: .alert)
        alertController.addTextField(configurationHandler: { textField in
            textField.placeholder = "http://"
        })
        let linkAction = UIAlertAction(title: "Link", style: .default, handler: { action in
            if let linkTextField: UITextField = alertController.textFields!.first, let text = linkTextField.text, !text.isEmpty {
                completion(URL(string: text))
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
        })
        alertController.addAction(cancelAction)
        alertController.addAction(linkAction)
        UIViewController.topMostController?.present(alertController, animated: true, completion: nil)
    }
}
