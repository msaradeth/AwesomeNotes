//
//  NoteListViewController.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/11/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import UIKit

class NoteListViewController: UIViewController {
    @IBOutlet weak var noteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: NoteViewModel!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButton
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.addNoteChangeListioner { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.tableView.reloadData()
                self.noteButton.title = String(self.viewModel.notes.count)
                self.editButton.isEnabled = self.viewModel.notes.count > 0 ? true : false
            }
        }
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NoteDetailViewController,
            let noteDetailViewModel = sender as? NoteDetailViewModel {
            vc.viewModel = noteDetailViewModel
        }
    }
 
    //MARK: Action
    @IBAction func editButtonTapped(_ sender: UIBarButtonItem) {
        navigationItem.rightBarButtonItem = cancelButton
        tableView.setEditing(true, animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationItem.rightBarButtonItem = editButton
        tableView.setEditing(false, animated: true)
    }
    
    @IBAction func composeButtonTapped(_ sender: UIBarButtonItem) {
        let note = Note(documentID: "", userID: "", folderID: "", text: "", timestamp: "")
        let noteDetailViewModel = NoteDetailViewModelImpl(note: note, noteViewModel: viewModel, transactionType: .add)
        self.performSegue(withIdentifier: "showNoteDetail", sender: noteDetailViewModel)
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
        tableView.deselectRow(at: indexPath, animated: true)
        let noteDetailViewModel = NoteDetailViewModelImpl(note: viewModel.notes[indexPath.item], noteViewModel: viewModel, transactionType: .update)
        self.performSegue(withIdentifier: "showNoteDetail", sender: noteDetailViewModel)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteNoteDocument(note: viewModel.notes[indexPath.row]) { [weak self] (error) in
            if let error = error {
                self?.showAlert(title: "Delete note error", message: error.localizedDescription)
            }
        }
    }
}
