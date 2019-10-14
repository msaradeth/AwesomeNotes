//
//  NoteViewModel.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/13/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import Foundation
import Firebase

protocol NoteViewModel: NSObjectProtocol {
    var user: User { get set }
    var notes: [Note] { get set }
    var databaseService: DatabaseService { get }
    func deleteNoteDocument(note: Note, completion: @escaping (Error?)->Void)
    func addNoteDocument(_ text: String, completion: @escaping (Error?)->Void)
    func updateNumberOfNotes(folderID: String) 
    func addNoteChangeListioner(completion: @escaping ()->Void)
}

class NoteViewModelImpl: NSObject {
    var user: User
    var folder: Folder
    var notes: [Note]
    var databaseService: DatabaseService
    
    init(user: User, folder: Folder, notes: [Note], databaseService: DatabaseService) {
        self.user = user
        self.folder = folder
        self.notes = notes
        self.databaseService = databaseService
    }
}

//MARK: FolderViewModel
extension NoteViewModelImpl: NoteViewModel {
    func addNoteChangeListioner(completion: @escaping ()->Void) {
        let db = Firestore.firestore().collection("notes")
        db.whereField("folderID", isEqualTo: folder.documentID).addSnapshotListener { [weak self] (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            var notes = [Note]()
            documents.forEach({ (document) in
                if let note = Note(documentID: document.documentID, dictionary: document.data()) {
                    notes.append(note)
                }
            })
            self?.notes = notes.sorted(by: {$0.timestamp > $1.timestamp})
            completion()
        }
    }
    
    func addNoteDocument(_ text: String, completion: @escaping (Error?)->Void) {
        databaseService.addNoteDocument(text, userID: user.userID, documentID: folder.documentID, completion: completion)
    }
    
    func deleteNoteDocument(note: Note, completion: @escaping (Error?)->Void) {
        databaseService.deleteNoteDocument(note: note, completion: completion)
    }
    
    func updateNumberOfNotes(folderID: String) {
        databaseService.updateNumberOfNotes(folderID: folderID)
    }

}
