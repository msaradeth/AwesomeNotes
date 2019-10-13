//
//  LoginViewController.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/11/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import UIKit

class LoginOrRegisterViewController: UIViewController {
    @IBOutlet weak var avatarButton: UIButton!
    @IBOutlet weak var loginRegisterButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewModel: LoginOrRegiterViewModel!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginRegisterButton.isEnabled = UITextField.isValidEmail(emailTextField.text) && UITextField.isValidPassword(passwordTextField.text)
    }
    
    //MARK: Actions
    @IBAction func loginRegisterButtonTapped(_ sender: Any) {
        viewModel.doLoginOrRegister(email: emailTextField.text, password: passwordTextField.text) { [weak self] (error) in
            if let error = error {
                self?.showAlert(title: self?.viewModel.selectedIndex.getValue(), message: error.localizedDescription)
            } else {
                guard let user = self?.viewModel.user else { return }
                UIApplication.shared.keyWindow?.rootViewController = FolderListViewController.createWith(FolderViewModelImpl(user: user))
            }
        }
    }
    
    @IBAction func segmentedControlTapped(_ sender: UISegmentedControl) {
        viewModel.selectedIndex = SelectedIndexType(rawValue: sender.selectedSegmentIndex)!
        loginRegisterButton.setTitle(viewModel.selectedIndex.getValue(), for: .normal)
    }
    
    @IBAction func addAvatarPressed(_ sender: Any) {
    }
}

//MARK: enable/disable login or registration Button
extension LoginOrRegisterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        if textField.tag == 0 { //is email
            loginRegisterButton.isEnabled = UITextField.isValidEmail(newString) && UITextField.isValidPassword(passwordTextField.text)
        } else { //is password
            loginRegisterButton.isEnabled = UITextField.isValidPassword(newString) && UITextField.isValidEmail(emailTextField.text)
        }
        return true
    }
}


