//
//  Note.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/13/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import Foundation

struct Note {
    var documentID: String
    var userID: String
    var folderID: String
    var text: String
    
    var dictionary: [String: Any] {
        return [
            "documentID": documentID,
            "userID": userID,
            "folderID": folderID,
            "text"    : text
        ]
    }
}

extension Note: DocumentSerializable {
    init?(documentID: String, dictionary: [String : Any]) {
        guard let userID = dictionary["userID"] as? String,
            let folderID = dictionary["folderID"] as? String,
            let text = dictionary["text"] as? String else { return nil }
        self.init(documentID: documentID, userID: userID, folderID: folderID, text: text)
    }
}
