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
}
