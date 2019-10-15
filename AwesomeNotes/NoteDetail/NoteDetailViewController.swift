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
    @IBOutlet weak var trashButton: UIBarButtonItem!
    @IBOutlet weak var undoButton: UIBarButtonItem!
    var viewModel: NoteDetailViewModel!
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = shareButton
        navigationController?.navigationBar.prefersLargeTitles = false
        textView.delegate = self
        textView.text = viewModel.note.text
        updateButtons()
        viewModel.trashStackObserver = { [weak self] (traskStack) in
            DispatchQueue.main.async {
                self?.updateButtons()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        if let text = textView.text {
            viewModel.addOrUpdateNote(text: text) { [weak self] (error) in
                if let error = error {
                    self?.showAlert(title: self?.viewModel.transactionType.getErrorTitle(), message: error.localizedDescription)
                }
            }
        }
    }
    
    private func updateButtons() {
        trashButton.isEnabled = textView.text.count > 0 ? true : false
        shareButton.isEnabled = textView.text.count > 0 ? true : false
        undoButton.isEnabled = viewModel.trashStack.count > 0 ? true : false
    }
    
    //MARK: Actions
    @IBAction func shareButtonTapped(_ sender: Any) {
        if let text = textView.text {
            self.share(itemsToShare: [text])
        }
    }
    
    @IBAction func composeButtonTapped(_ sender: Any) {
        if let text = textView.text {
            viewModel.addOrUpdateNote(text: text) { [weak self] (error) in
                if let error = error {
                    self?.showAlert(title: self?.viewModel.transactionType.getErrorTitle(), message: error.localizedDescription)
                }
            }
        }
        viewModel.transactionType = .add
        textView.text = ""
        updateButtons()
    }
    
    @IBAction func undoButtonTapped(_ sender: Any) {
        if let text = viewModel.undoDelete() {
            textView.text = text
        }
    }
    
    @IBAction func trashButtonTapped(_ sender: Any) {
        viewModel.saveText(text: textView.text)
        textView.text = ""
        if viewModel.transactionType == .update {
            viewModel.noteViewModel.deleteNoteDocument(note: viewModel.note) { [weak self] (error) in
                if let error = error {
                    self?.showAlert(title: "Delete note error", message: error.localizedDescription)
                }
            }
        }
        viewModel.transactionType = .add
    }
}

extension NoteDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        updateButtons()
    }
}
