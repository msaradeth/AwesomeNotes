//
//  UIViewController+Ext.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/25/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit


extension UIViewController {
    var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    func showAlert(title: String?, message: String?, buttonTitle: String = "Dismiss") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: buttonTitle, style: .default) { (alertAction) in
            alertController.dismiss(animated: true)
        }
        alertController.addAction(alertAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func newFolder(completion: @escaping (String)->Void) {
        let alertController = UIAlertController(title: "New Folder", message: "Enter a name for this folder", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default)
        let saveAction = UIAlertAction(title: "Save", style: .default) { alertAction in
            if let folderName = alertController.textFields?[0].text, !folderName.isEmpty {
                completion(folderName)
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func share(itemsToShare: [Any]) {
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func imagePicker() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        self.present(picker, animated: true)
    }
}
