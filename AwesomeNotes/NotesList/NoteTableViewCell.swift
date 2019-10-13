//
//  NoteTableViewCell.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/13/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import UIKit

class NoteTableViewCell: UITableViewCell {
    static let reuseIdentifier = "NoteTableViewCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!

    func configure(note: Note) {
        let lines = note.text.split { $0.isNewline }
        titleLabel.text = lines.count > 0 ? String(lines[0]) : ""
        subtitleLabel.text = lines.count > 1 ? String(lines[1]) : ""
    }
}
