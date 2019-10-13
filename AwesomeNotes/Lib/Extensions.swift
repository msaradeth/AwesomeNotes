//
//  Extensions.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/12/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import UIKit

extension UIViewController {
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
}

extension UIStoryboard {
    static func ininstantiateVC(storyboard: String, vcIdentifier: String) -> UIViewController {
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: vcIdentifier)
    }
}

extension UITextField {
    static func isValidEmail(_ email: String?) -> Bool {
        guard let email = email else { return false }
        let emailRegEx = "^[\\w\\.-]+@([\\w\\-]+\\.)+[A-Z]{1,4}$"
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String?) -> Bool {
        guard let characterCount = password?.count else { return false }
        return characterCount > 5 ? true : false
    }
}


extension Date {
    static func getTimestamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let timeStamp: String = dateFormatter.string(from: Date())
        return timeStamp
    }
}
