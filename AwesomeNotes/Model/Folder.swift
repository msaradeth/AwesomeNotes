//
//  Folder.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/12/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import Foundation
protocol DocumentSerializable {
    init?(documentID: String, dictionary: [String: Any])
}

struct Folder {
    var documentID: String
    var userID: String
    var folderName: String
    var numberOfNotes: Int
    var timestamp: String
    
    var dictionary: [String: Any] {
        return [
            "documentID" : documentID,
            "userID" : userID,
            "folderName" : folderName,
            "numberOfNotes" : numberOfNotes,
            "timestamp" : timestamp
        ]
    }
}

extension Folder: DocumentSerializable {
    init?(documentID: String, dictionary: [String: Any]) {
        guard let userID = dictionary["userID"] as? String,
            let folderName = dictionary["folderName"] as? String,
            let numberOfNotes = dictionary["numberOfNotes"] as? Int,
            let timestamp = dictionary["timestamp"] as? String else {return nil }
        self.init(documentID: documentID, userID: userID, folderName: folderName, numberOfNotes: numberOfNotes, timestamp: timestamp)
    }
}
