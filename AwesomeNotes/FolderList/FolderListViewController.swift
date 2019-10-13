//
//  FolderListViewController.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/11/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import UIKit

class FolderListViewController: UIViewController {
    @IBOutlet var logoutButton: UIBarButtonItem!
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
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItem = editButton
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel.addFolderChangeListioner { [weak self] in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.tableView.reloadData()
                self.editButton.isEnabled = self.viewModel.folders.count > 0 ? true : false
            }
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NoteListViewController,
            let folder = sender as? Folder {
            vc.title = folder.folderName
            vc.viewModel = NoteViewModelImpl(user: viewModel.user, folder: folder, notes: [])
        }
    }
    
    //MARK: Actions
    @IBAction func editButtonTapped(_ sender: Any) {
        navigationItem.rightBarButtonItem = cancelButton
        tableView.setEditing(true, animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationItem.rightBarButtonItem = editButton
        tableView.setEditing(false, animated: true)
    }
    
    @IBAction func newFolderButtonTapped(_ sender: UIBarButtonItem) {
        self.newFolder { [weak self ] (folderName) in
            self?.viewModel.addFolderDocument(folderName)
        }
    }

    @IBAction func logoutTapped(_ sender: Any) {
        viewModel.user.isLogin = false
        UIApplication.shared.keyWindow?.rootViewController = LoginViewController.createWith(viewModel.user)
    }
}


//MARK: UITableViewDataSource
extension FolderListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.folders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FolderTableViewCell.reuseIdentifier, for: indexPath) as! FolderTableViewCell
        cell.configure(viewModel.folders[indexPath.row])
        return cell
    }
}

//MARK: UITableViewDelegate
extension FolderListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "showNotes", sender: viewModel.folders[indexPath.item])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteFolderDocument(folder: viewModel.folders[indexPath.item]) { [weak self] (error) in
            if let error = error {
                self?.showAlert(title: "Delete folder error", message: error.localizedDescription)
            }
        }
    }
}
