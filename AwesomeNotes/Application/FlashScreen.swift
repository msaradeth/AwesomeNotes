//
//  FlashScreen.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/13/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class FlashScreen: UIViewController {
    static func create() -> FlashScreen {
        let vc = UIStoryboard.instantiateVC(storyboard: "Main", vcIdentifier: "FlashScreen") as! FlashScreen
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getUser { [weak self] (user) in
            guard let self = self else { return }
            self.appDelegate.user = user
            if user.isLogin {
                let vc = FolderListViewController.createWith(FolderViewModelImpl(user: user, folders: [], databaseService: self.appDelegate.databaseService))
                DispatchQueue.main.async {
                    self.navigationController?.isToolbarHidden = false
                    self.navigationController?.navigationBar.prefersLargeTitles = true
                    self.navigationController?.setViewControllers([vc], animated: true)
                }
            } else {
                let vc = UIStoryboard.instantiateVC(storyboard: "Main", vcIdentifier: "LoginViewController") as! LoginViewController
                vc.user = user
                vc.databaseService = self.appDelegate.databaseService
                DispatchQueue.main.async {
                    self.navigationController?.setViewControllers([vc], animated: true)
                }
            }
        }
    }
    
    func getUser(completion: @escaping (User)->Void) {
        guard let email = User.readEmail() else { completion(User()); return  }
        appDelegate.databaseService.getUserData(email: email) { (user, error) in
            let user = user != nil ? user! : User()
            completion(user)
        }
    }
}
