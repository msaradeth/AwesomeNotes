//
//  FolderTableViewCell.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/12/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class FolderTableViewCell: UITableViewCell {
    static let reuseIdentifier = "FolderTableViewCell"
    @IBOutlet weak var folderNameLabel: UILabel!
    @IBOutlet weak var numberOfNotesLabel: UILabel!
    
    func configure(_ folder: Folder) {
        self.folderNameLabel.text = folder.folderName
        self.numberOfNotesLabel.text = String(folder.notes.count)
    }
}
