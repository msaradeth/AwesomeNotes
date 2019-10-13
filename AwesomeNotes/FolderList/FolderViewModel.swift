//
//  FolderViewModel.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/13/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import Foundation
import Firebase

protocol FolderViewModel {
    var user: User { get set }
    var folders: [Folder] { get set }
    func addFolderDocument(_ folderName: String)
    func deleteFolderDocument(folder: Folder, completion: @escaping (Error?)->Void)
    func addFolderChangeListioner(completion: @escaping ()->Void)
}

class FolderViewModelImpl: NSObject {
    var user: User
    var folders: [Folder]
    
    init(user: User, folders: [Folder]) {
        self.user = user
        self.folders = folders
    }
}

//MARK: FolderViewModel
extension FolderViewModelImpl: FolderViewModel {
    func addFolderDocument(_ folderName: String) {
        let db = Firestore.firestore().collection("folders")
        db.addDocument(data: [
            "folderName"  : folderName,
            "userID"      : user.userID,
            "numberOfNotes": 0,
            "timestamp"    : Date.getTimestamp()
            ])
    }
    
    func deleteFolderDocument(folder: Folder, completion: @escaping (Error?)->Void) {
        let folderDatabase = Firestore.firestore().collection("folders")
        folderDatabase.document(folder.documentID).delete() { error in
            guard error == nil else { completion(error); return }
        }
            
        let notesDatabase = Firestore.firestore().collection("notes")
        notesDatabase.whereField("folderID", isEqualTo: folder.documentID).getDocuments { (snapshot, error) in
            guard error == nil, let documents = snapshot?.documents else { completion(error); return }
            documents.forEach({ (document) in
                Firestore.firestore().collection("notes").document(document.documentID).delete() { error in
                    guard error == nil else { completion(error); return }
                }
            })
        }
    }
    
    func addFolderChangeListioner(completion: @escaping ()->Void) {
        let db = Firestore.firestore().collection("folders")
        db.whereField("userID", isEqualTo: user.userID).addSnapshotListener { [weak self] (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            var folders = [Folder]()
            documents.forEach({ (document) in
                if let folder = Folder(documentID: document.documentID, dictionary: document.data()) {
                    folders.append(folder)
                }
            })
            self?.folders = folders.sorted(by: {$0.timestamp > $1.timestamp})
            completion()
        }
    }
}
