//
//  NoteViewModel.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/13/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import Foundation
import Firebase

protocol NoteViewModel {
    var user: User { get set }
    var notes: [Note] { get }
    func addNoteDocument(_ note: String)
    func addNoteChangeListioner(completion: @escaping ()->Void)
}

class NoteViewModelImpl: NSObject {
    var user: User
    var folder: Folder
    var notes: [Note] {
        return user.selectedFolderNotes
    }
    
    init(user: User, folder: Folder) {
        self.user = user
        self.folder = folder
    }
}

//MARK: FolderViewModel
extension NoteViewModelImpl: NoteViewModel {
    func addNoteDocument(_ note: String) {
        let noteRef = Firestore.firestore().collection("notes")
        noteRef.addDocument(data: [
            "userID"     : user.userID,
            "folderID"  : folder.documentID,
            "note"     : note
            ])
    }
    
    func addNoteChangeListioner(completion: @escaping ()->Void) {
        let noteRef = Firestore.firestore().collection("notes").whereField("FolderID", isEqualTo: folder.documentID)
        noteRef.addSnapshotListener { [weak self] (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            self?.user.selectedFolderNotes.removeAll()
            documents.forEach({ (document) in
                if let note = Note(documentID: document.documentID, dictionary: document.data()) {
                    self?.user.selectedFolderNotes.append(note)
                }
            })
            completion()
        }
    }
}
