//
//  User.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/12/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import UIKit

class User: NSObject {
    var userID: String = ""
    var email: String = ""
    var password: String = ""
    var avatar: String = ""
    var isLogin: Bool = false

    var dictionary: [String: Any] {
        return [
            "userID"   : userID,
            "email"    : email,
            "password" : password,
            "avartar"  : avatar,
            "isLogin"  : isLogin
        ]
    }
}

extension User {
    convenience init?(documentID: String, dictionary: [String: Any]) {
        let userID = documentID
        let lastLogin = dictionary["lastLogin"] as? String ?? ""
        let isLogin = !lastLogin.isEmpty ? true : false
        guard
            let email = dictionary["email"] as? String,
            let password = dictionary["password"] as? String,
            let avatar = dictionary["avatar"] == nil ? "" : dictionary["avatar"] as? String
            else { return nil }
        self.init()
        self.userID = userID
        self.email = email
        self.password = password
        self.avatar = avatar
        self.isLogin = isLogin
    }
}



//MARK: save and read email
extension User {
    static func saveEmail(email: String) {
        let fileURLWithPath = FileManager.docutmentsDirectory
                .appendingPathComponent("AwesomeNotes")
                .appendingPathExtension(".json")
        do {
            try email.write(to: fileURLWithPath, atomically: true, encoding: String.Encoding.utf8)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    static func readEmail() -> String? {
        let fileURLWithPath = FileManager.docutmentsDirectory
            .appendingPathComponent("AwesomeNotes")
            .appendingPathExtension(".json")
        do {
            let email = try String(contentsOf: fileURLWithPath)
            return email
        } catch let error {
            print("Failed reading from URL: \(fileURLWithPath), Error: " + error.localizedDescription)
        }
        return nil
    }
}


