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
    @IBOutlet weak var textView: UITextView!
    
    var viewModel: NoteDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = shareButton
        navigationController?.navigationBar.prefersLargeTitles = false
        textView.text = viewModel.note.text
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
    }
    
    @IBAction func composeButtonTapped(_ sender: Any) {
        //save and new edit
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        textView.text = ""
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
