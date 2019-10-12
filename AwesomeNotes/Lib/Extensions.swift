//
//  Extensions.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/12/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

extension UIViewController {
    func add(_ child: UIViewController, moveToParent: Bool = false) {
        self.addChild(child)
        self.view.addSubview(child.view)
        if moveToParent {
             child.didMove(toParent: self)
        }
    }
    
    func remove() {
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
    }
}

extension UIStoryboard {
    static func instantiateViewController(storyboard: String, viewControllerID: String) -> UIViewController {
        return UIStoryboard.init(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: viewControllerID)
    }
}
