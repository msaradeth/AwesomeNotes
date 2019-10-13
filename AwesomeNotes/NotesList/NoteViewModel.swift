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
    func deleteNoteDocument(note: Note, completion: @escaping (Error?)->Void)
    func addNoteDocument(_ text: String, completion: @escaping (Error?)->Void)
    func updateNumberOfNotes(folderID: String) 
    func addNoteChangeListioner(completion: @escaping ()->Void)
}

class NoteViewModelImpl: NSObject {
    var user: User
    var folder: Folder
    var notes: [Note]
    
    init(user: User, folder: Folder, notes: [Note]) {
        self.user = user
        self.folder = folder
        self.notes = notes
    }
}

//MARK: FolderViewModel
extension NoteViewModelImpl: NoteViewModel {
    func addNoteDocument(_ text: String, completion: @escaping (Error?)->Void) {
        let db = Firestore.firestore().collection("notes")
        db.addDocument(data: [
            "userID"    : user.userID,
            "folderID"  : folder.documentID,
            "text"     : text,
            "timestamp" : Date.getTimestamp()
        ]) { error in
            completion(error)
        }
        updateNumberOfNotes(folderID: folder.documentID)
    }
    
    func deleteNoteDocument(note: Note, completion: @escaping (Error?)->Void) {
        let db = Firestore.firestore().collection("notes")
        db.document(note.documentID).delete() { error in
            completion(error)
        }
        updateNumberOfNotes(folderID: note.folderID)
    }
    
    func updateNumberOfNotes(folderID: String) {
        let notesDatabase = Firestore.firestore().collection("notes")
        notesDatabase.whereField("folderID", isEqualTo: folderID).getDocuments { (snapshot, error) in
            guard error == nil, let documents = snapshot?.documents else { return }
            
            let folderDatabase = Firestore.firestore().collection("folders").document(folderID)
            folderDatabase.updateData(["numberOfNotes" : documents.count])
        }
    }
    
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
}
