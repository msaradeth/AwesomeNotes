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
    var folderName: String { get set }
    var notes: [String] { get set }
    func addNoteDocument(_ note: String)
    func addNoteChangeListioner(completion: @escaping ()->Void)
    func loadNoteDocuments(completion: @escaping ()->Void)
}

class NoteViewModelImpl: NSObject {
    var user: User
    var folderName: String
    var notes: [String]
    
    init(user: User, folderName: String, notes: [String]) {
        self.user = user
        self.folderName = folderName
        self.notes = notes
    }
}

//MARK: FolderViewModel
extension NoteViewModelImpl: NoteViewModel {
    func addNoteDocument(_ note: String) {
        let folderRef = Firestore.firestore().collection("folders")
        folderRef.addDocument(data: [
            "folderName" : folderName,
            "userID"     : user.userID,
            "avatar" : user.avatar
            ])
    }
    
    func addNoteChangeListioner(completion: @escaping ()->Void) {
        let folderRef = Firestore.firestore().collection("folders").whereField("userID", isEqualTo: user.userID)
        folderRef.addSnapshotListener { [weak self] (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            self?.user.folders.removeAll()
            documents.forEach({ (document) in
                if let folder = Folder(dictionary: document.data()) {
                    self?.user.folders.append(folder)
                }
            })
            completion()
        }
    }
    
    func loadNoteDocuments(completion: @escaping ()->Void) {
        let folderRef = Firestore.firestore().collection("folders")
        folderRef.whereField("userID", isEqualTo: user.userID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }
    }
}
