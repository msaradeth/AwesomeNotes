//
//  EmailLoginViewModel.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/12/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import Foundation
import FirebaseAuth

//Mark: user request for login or sign up
enum SelectedIndexType: Int {
    case login = 0
    case register
    
    func getValue() -> String {
        switch self {
        case .login:
            return "Login"
        case .register:
            return "Register"
        }
    }
}

//Mark: Handles login and sign up
protocol LoginOrRegiterViewModel {
    var user: User { get set }
    var selectedIndex: SelectedIndexType { get set }
    func doLoginOrRegister(email: String?, password: String?, completion: @escaping (Error?)->Void)
}

class LoginOrRegisterViewModelImpl: NSObject {
    var user: User
    var selectedIndex: SelectedIndexType
    
    //Mark: init
    init(selectIndex: SelectedIndexType = .login, user: User) {
        self.selectedIndex = selectIndex
        self.user = user
    }
    
    
    //Mark: login and sign up helper methods
    private func login(email: String, password: String, completion: @escaping (Error?)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if error == nil, let userID = result?.user.uid {
                self?.updateUser(email: email, password: password, userID: userID)
            }
            completion(error)
        }
    }
    
    private func register(email: String, password: String, completion: @escaping (Error?)->Void) {
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
            if error == nil, let userID = result?.user.uid {
                self?.updateUser(email: email, password: password, userID: userID)
            }
            completion(error)
        }
    }
    
    private func updateUser(email: String, password: String, userID: String) {
        print(userID)
        user.userID = userID
        user.isLogin = true
        user.email = email
        user.password = password
    }
}

extension LoginOrRegisterViewModelImpl: LoginOrRegiterViewModel {
    func doLoginOrRegister(email: String?, password: String?, completion: @escaping (Error?)->Void) {
        guard let email = email,
            let password = password else { return }
        if selectedIndex == .login {
            login(email: email, password: password, completion: completion)
        } else {
            register(email: email, password: password, completion: completion)
        }
    }
}
