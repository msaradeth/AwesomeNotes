//
//  Extensions.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/12/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import UIKit


extension UIStoryboard {
    static func instantiateVC(storyboard: String, vcIdentifier: String) -> UIViewController {
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

extension UIView {
    func makeCircle() {
        self.layer.cornerRadius = self.bounds.size.width / 2.0
        self.clipsToBounds = true
    }
}

extension FileManager {
    static let docutmentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
}
