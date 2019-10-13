//
//  MainViewController.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/12/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginSignup: UIButton!
    var user: User!
    
    static func createWith(_ user: User) -> UINavigationController{
        let vc = UIStoryboard.ininstantiateVC(storyboard: "Main", vcIdentifier: "LoginViewController") as! LoginViewController
        vc.user = user
        let navController = UINavigationController(rootViewController: vc)
        return navController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginSignupTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "showLoginOrSignup", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let emailLoginVC = segue.destination as? LoginOrRegisterViewController {
            emailLoginVC.viewModel = LoginOrRegisterViewModelImpl(user: user)
        }
    }
}
