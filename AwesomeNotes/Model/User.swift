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
    var folders: [Folder] = []
    var selectedFolderNotes: [Note] = []

    var dictionary: [String: Any] {
        return [
            "userID"   : userID,
            "email"    : email,
            "password" : password,
            "avartar"  : avatar
        ]
    }
}

extension User {
    convenience init?(dictionary: [String: Any]) {
        guard let userID = dictionary["userID"] as? String,
            let email = dictionary["email"] as? String,
            let password = dictionary["password"] as? String,
            let avatar = dictionary["avatar"] == nil ? "" : dictionary["avatar"] as? String
            else { return nil }
        self.init()
        self.userID = userID
        self.email = email
        self.password = password
        self.avatar = avatar
    }
}
