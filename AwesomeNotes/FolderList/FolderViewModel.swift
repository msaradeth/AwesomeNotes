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
    var databaseService: DatabaseService { get set }
    func addFolderDocument(_ folderName: String)
    func deleteFolderDocument(folder: Folder, completion: @escaping (Error?)->Void)
    func addFolderChangeListioner(completion: @escaping ()->Void)
    func logout()
}

class FolderViewModelImpl: NSObject {
    var user: User
    var folders: [Folder]
    var databaseService: DatabaseService
    
    init(user: User, folders: [Folder], databaseService: DatabaseService) {
        self.user = user
        self.folders = folders
        self.databaseService = databaseService
    }
}

//MARK: FolderViewModel
extension FolderViewModelImpl: FolderViewModel {
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
    
    
    func addFolderDocument(_ folderName: String) {
        databaseService.addFolderDocument(folderName, userID: user.userID)
    }
    
    func deleteFolderDocument(folder: Folder, completion: @escaping (Error?)->Void) {
        databaseService.deleteFolderDocument(folder: folder, completion: completion)
    }

    func logout() {
        user.isLogin = false
        databaseService.logout(user.userID)
    }
}
