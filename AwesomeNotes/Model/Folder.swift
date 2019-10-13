//
//  Folder.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/12/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation

protocol DocumentSerializable {
    init?(dictionary: [String: Any])
}


struct Folder {
    var folderName: String
    var notes: [String]
    
    var dictionary: [String: Any] {
        return [
            "folderName" : folderName
        ]
    }
}

extension Folder: DocumentSerializable {
    init?(dictionary: [String: Any]) {
        guard let folderName = dictionary["folderName"] as? String else { return nil }
        self.init(folderName: folderName, notes: [])
    }
}
