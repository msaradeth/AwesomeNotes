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
    var databaseService: DatabaseService { get set }
    func doLoginOrRegister(email: String?, password: String?, completion: @escaping (Error?)->Void)
}

class LoginOrRegisterViewModelImpl: NSObject {
    var user: User
    var selectedIndex: SelectedIndexType
    var databaseService: DatabaseService
    
    //Mark: init
    init(selectIndex: SelectedIndexType = .login, user: User, databaseService: DatabaseService) {
        self.selectedIndex = selectIndex
        self.user = user
        self.databaseService = databaseService
    }
    
    //Mark: login and sign up helper methods
    private func login(email: String, password: String, completion: @escaping (Error?)->Void) {
        databaseService.signIn(email: email, password: password) { [weak self] (user, error) in
            guard let user = user else { completion(error); return }
            self?.user = user
            completion(error)
        }
    }
    
    private func register(email: String, password: String, completion: @escaping (Error?)->Void) {
        databaseService.createUser(email: email, password: password) { [weak self] (user, error) in
            guard let user = user else { completion(error); return }
            self?.user = user
            completion(error)
        }
    }
}

extension LoginOrRegisterViewModelImpl: LoginOrRegiterViewModel {
    func doLoginOrRegister(email: String?, password: String?, completion: @escaping (Error?)->Void) {
        guard let email = email, let password = password else { return }
        if selectedIndex == .login {
            login(email: email, password: password, completion: completion)
        } else {
            register(email: email, password: password, completion: completion)
        }
    }
}
