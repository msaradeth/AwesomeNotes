//
//  AppDelegate.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/11/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit
import Firebase
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let databaseService = DatabaseService()
    var user: User!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        FirebaseApp.configure()
        configureFirebase()

        let navController = UINavigationController(rootViewController: FlashScreen.create())
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = navController
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func configureFirebase() {
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        
        // Enable offline data persistence
        let db = Firestore.firestore()
        db.settings = settings
    }
}

