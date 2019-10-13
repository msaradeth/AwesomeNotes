//
//  NoteDetailViewModel.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/11/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import Foundation

class NoteDetailViewModel: NSObject {
    var note: Note
    
    init(note: Note) {
        self.note = note
    }
}
