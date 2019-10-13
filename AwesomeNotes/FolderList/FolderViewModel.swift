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
    func addFolderDocument(_ folderName: String)
    func addFolderChangeListioner(completion: @escaping ()->Void)
    func loadFolderDocuments(completion: @escaping ()->Void)
}

class FolderViewModelImpl: NSObject {
    var user: User
    
    init(user: User) {
        self.user = user
    }
}

//MARK: FolderViewModel
extension FolderViewModelImpl: FolderViewModel {
    func addFolderDocument(_ folderName: String) {
        let folderRef = Firestore.firestore().collection("folders")
        folderRef.addDocument(data: [
            "folderName" : folderName,
            "userID"     : user.userID,
            "avatar" : user.avatar
            ])
    }
    
    func addFolderChangeListioner(completion: @escaping ()->Void) {
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
    
    func loadFolderDocuments(completion: @escaping ()->Void) {
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
