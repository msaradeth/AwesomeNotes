//
//  LoginViewController.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/11/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import Firebase

enum Collection {
    static let users = "users"
    static let folders = "folders"
}

class EmailLoginViewController: UIViewController {
    @IBOutlet weak var avatarImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let db = Firestore.firestore()
//        var documentRef: DocumentReference?
//        documentRef = db.collection(Collection.users).addDocument(data: [
//            "email" : "joe@gmail.com",
//            "password" : "444"
//            ]
//        ) { (error) in
//            if let error = error {
//                print("Error adding Document \(error)")
//            } else {
//                print("added document with ID: \(documentRef!.documentID)")
//            }
//        }

//        self.performSegue(withIdentifier: "showFolders", sender: self)
//        // Do any additional setup after loading the view.
    }
    

    @IBAction func addAvatarPressed(_ sender: Any) {
//        self.performSegue(withIdentifier: "showFolders", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
