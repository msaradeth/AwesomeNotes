//
//  FolderListViewController.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/11/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import UIKit

class FolderListViewController: UIViewController {
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    var viewModel: FolderViewModel!
    
    //helper function - reusable code
    static func createWith(_ viewModel: FolderViewModel) -> UINavigationController{
        let vc = UIStoryboard.ininstantiateVC(storyboard: "Notes", vcIdentifier: "FolderListViewController") as! FolderListViewController
        vc.viewModel = viewModel
        let navController = UINavigationController(rootViewController: vc)
        navController.navigationBar.prefersLargeTitles = true
        navController.isToolbarHidden = false
        return navController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = editButton
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.addFolderChangeListioner { [weak self] in
            self?.tableView.reloadData()
            self?.editButton.isEnabled = (self?.viewModel.user.folders.count ?? 0) > 0 ? true : false
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NoteListViewController, let folder = sender as? Folder {
            vc.title = folder.folderName
            vc.viewModel = NoteViewModelImpl(user: viewModel.user, folderName: folder.folderName, notes: folder.notes)
        }
    }

    
    //MARK: Actions
    @IBAction func editButtonTapped(_ sender: Any) {
        navigationItem.rightBarButtonItem = cancelButton
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationItem.rightBarButtonItem = editButton
    }
    
    @IBAction func newFolderButtonTapped(_ sender: UIBarButtonItem) {
        self.newFolder { [weak self ] (folderName) in
            self?.viewModel.addFolderDocument(folderName)
        }
    }

}


//MARK: UITableViewDataSource
extension FolderListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.user.folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderTableViewCell.reuseIdentifier, for: indexPath) as! FolderTableViewCell
        print("indexPath: ", indexPath.row, indexPath.item)
        cell.configure(viewModel.user.folders[indexPath.row])
        return cell
    }
}

//MARK: UITableViewDelegate
extension FolderListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "showNotes", sender: viewModel.user.folders[indexPath.item])
    }
}
