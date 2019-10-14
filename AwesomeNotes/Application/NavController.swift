//
//  NavController.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/13/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class NavController: UINavigationController {
    let databaseService = DatabaseService()
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser { (user) in
            if user.isLogin {
                let vc = FolderListViewController.createWith(FolderViewModelImpl(user: user, folders: [], databaseService: self.databaseService))
                DispatchQueue.main.async {
                    self.isToolbarHidden = false
                    self.navigationBar.prefersLargeTitles = true
                    self.setViewControllers([vc], animated: true)
                }
            } else {
                let vc = UIStoryboard.instantiateVC(storyboard: "Main", vcIdentifier: "LoginViewController") as! LoginViewController
                vc.user = user
                vc.databaseService = self.databaseService
                DispatchQueue.main.async {
                    self.setViewControllers([vc], animated: true)
                }
            }
        }
    }
    
    func getUser(completion: @escaping (User)->Void) {
        guard let email = User.readEmail() else { completion(User()); return  }
        databaseService.getUserData(email: email) { (user, error) in
            let user = user != nil ? user! : User()
            completion(user)
        }
    }
}
