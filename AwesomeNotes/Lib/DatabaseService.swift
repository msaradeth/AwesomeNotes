//
//  DatabaseService.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/13/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import Foundation
import Firebase

class DatabaseService: NSObject {
    
    //MARK: User Collection - add, get, login, register
    func addUserDocument(_ email: String, password: String, avatar: String, lastLogin: String) {
        let db = Firestore.firestore().collection("users")
        db.addDocument(data: [
            "email"     : email,
            "password"  : password,
            "avatar"    : avatar,
            "lastLogin" : lastLogin,
            "timestamp" : Date.getTimestamp()
            ])
    }
    
    func getUserData(email: String, completion: @escaping (User?, Error?)->Void) {
        let db = Firestore.firestore().collection("users")
        db.whereField("email", isEqualTo: email).getDocuments { (snapshot, error) in
            guard error == nil, let documents = snapshot?.documents,
                let document = documents.first,
                let user = User(documentID: document.documentID, dictionary: document.data())
            else { completion(nil, error); return }
            completion(user, error)
        }
    }
    
    func signIn(email: String, password: String, completion: @escaping (User?, Error?)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            guard error == nil else {completion(nil, error); return}
            self?.getUserData(email: email, completion: { (user, error) in
                guard let user = user, error == nil else {completion(nil, error); return}
                self?.updateLastLogin(documentID: user.userID, timestamp: Date.getTimestamp())
                User.saveEmail(email: email)
                completion(user, error)
            })
        }
    }
    
    func createUser(email: String, password: String, completion: @escaping (User?, Error?)->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            guard error == nil else {completion(nil, error); return}
            self?.addUserDocument(email, password: password, avatar: "", lastLogin: Date.getTimestamp())
            
            self?.getUserData(email: email, completion: { (user, error) in
                guard let user = user, error == nil else {completion(nil, error); return}
                User.saveEmail(email: email)
                completion(user, error)
            })
        }
    }
    
    func updateLastLogin(documentID: String, timestamp: String) {
        let db = Firestore.firestore().collection("users").document(documentID)
        db.updateData(["lastLogin" : timestamp])
    }
    
    func logout(_ documentID: String) {
        updateLastLogin(documentID: documentID, timestamp: "")
    }
}

//MARK: Folder Collection - add, delete, update
extension DatabaseService {
    func addFolderDocument(_ folderName: String, userID: String) {
        let db = Firestore.firestore().collection("folders")
        db.addDocument(data: [
            "folderName"  : folderName,
            "userID"      : userID,
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
}

//MARK: Notes Collection: add, delete, update
extension DatabaseService {
    func addNoteDocument(_ text: String, userID: String, documentID: String, completion: @escaping (Error?)->Void) {
        let db = Firestore.firestore().collection("notes")
        db.addDocument(data: [
            "userID"    : userID,
            "folderID"  : documentID,
            "text"     : text,
            "timestamp" : Date.getTimestamp()
        ]) { error in
            completion(error)
        }
        updateNumberOfNotes(folderID: documentID)
    }
    
    func deleteNoteDocument(note: Note, completion: @escaping (Error?)->Void) {
        let db = Firestore.firestore().collection("notes")
        db.document(note.documentID).delete() { error in
            completion(error)
        }
        updateNumberOfNotes(folderID: note.folderID)
    }
    
    func updateNoteDocument(text: String, documentID: String, completion: @escaping (Error?)->Void) {
        let db = Firestore.firestore().collection("notes")
        db.document(documentID).updateData([
            "text" : text]) { (error) in
                completion(error)
        }
    }
    
    func updateNumberOfNotes(folderID: String) {
        let notesDatabase = Firestore.firestore().collection("notes")
        notesDatabase.whereField("folderID", isEqualTo: folderID).getDocuments { (snapshot, error) in
            guard error == nil, let documents = snapshot?.documents else { return }
            
            let folderDatabase = Firestore.firestore().collection("folders").document(folderID)
            folderDatabase.updateData(["numberOfNotes" : documents.count])
        }
    }
    
}
