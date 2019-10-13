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
    var folders: [Folder] { get }
    func addFolderDocument(_ folderName: String)
    func deleteFolderDocument(folder: Folder) 
    func addFolderChangeListioner(completion: @escaping ()->Void)
}

class FolderViewModelImpl: NSObject {
    var user: User
    var folders: [Folder] {
        return user.folders
    }
    
    init(user: User) {
        self.user = user
    }
}

//MARK: FolderViewModel
extension FolderViewModelImpl: FolderViewModel {
    func addFolderDocument(_ folderName: String) {
        let folderRef = Firestore.firestore().collection("folders")
        folderRef.addDocument(data: [
            "folderName"  : folderName,
            "userID"      : user.userID,
            "numberOfNotes": 0,
            "timestamp"    : Date.getTimestamp()
            ])
    }
    
    func deleteFolderDocument(folder: Folder) {
        Firestore.firestore().collection("folders").document(folder.documentID).delete() { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    func addFolderChangeListioner(completion: @escaping ()->Void) {
        let folderRef = Firestore.firestore().collection("folders").whereField("userID", isEqualTo: user.userID)
        folderRef.addSnapshotListener { [weak self] (snapshot, error) in
            guard let documents = snapshot?.documents else { return }
            var folders = [Folder]()
            documents.forEach({ (document) in
                if let folder = Folder(documentID: document.documentID, dictionary: document.data()) {
                    folders.append(folder)
                }
            })
            self?.user.folders = folders.sorted(by: {$0.timestamp > $1.timestamp})
            completion()
        }
    }
    
//    func loadFolderDocuments(completion: @escaping ()->Void) {
//        let folderRef = Firestore.firestore().collection("folders")
//        folderRef.whereField("userID", isEqualTo: user.userID).getDocuments { (querySnapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//            } else {
//                for document in querySnapshot!.documents {
//                    print("\(document.documentID) => \(document.data())")
//                }
//            }
//        }
//    }
}
