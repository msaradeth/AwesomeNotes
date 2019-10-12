//
//  NoteDetailViewController.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/11/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class NoteDetailViewController: UIViewController {

    @IBOutlet var shareButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = shareButton
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    
    @IBAction func composeButtonTapped(_ sender: Any) {
        
    }
    @IBAction func trashButtonTapped(_ sender: Any) {
        
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
