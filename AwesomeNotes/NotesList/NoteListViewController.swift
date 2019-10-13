//
//  NoteListViewController.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/11/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import UIKit

class NoteListViewController: UIViewController {
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: NoteViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButton
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.addNoteChangeListioner { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.tableView.reloadData()
                self.editButton.isEnabled = self.viewModel.notes.count > 0 ? true : false
            }
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
 
    //MARK: Action
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationItem.rightBarButtonItem = editButton
    }
    
    @IBAction func composeButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "showNoteDetail", sender: self)
    }
}

//MARK: UITableViewDataSource
extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.reuseIdentifier, for: indexPath) as! NoteTableViewCell
        cell.configure(note: viewModel.notes[indexPath.item])
        return cell
    }
}

//MARK: UITableViewDelegate
extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        self.performSegue(withIdentifier: "showNoteDetail", sender: viewModel.notes[indexPath.item])
    }
}
