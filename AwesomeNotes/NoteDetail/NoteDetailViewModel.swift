//
//  NoteDetailViewModel.swift
//  AwesomeNotes
//
//  Created by Mike Saradeth on 10/11/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//
import Foundation
import Firebase

enum TransactionType {
    case add
    case update
    
    func getErrorTitle() -> String {
        switch self {
        case .add:
            return "Add note error"
        case .update:
            return "Update note error"
        }
    }
}

protocol NoteDetailViewModel: NSObjectProtocol {
    var note: Note { get set }
    var noteViewModel: NoteViewModel { get set }
    var transactionType: TransactionType { get set }
    var databaseService: DatabaseService { get }
    func updateNoteDocument(text: String, completion: @escaping (Error?)->Void)
    func addOrUpdateNote(text: String, completion: @escaping (Error?)->Void)
    func undoDelete() -> String?
    func saveText(text: String?)
}

class NoteDetailViewModelImpl: NSObject, NoteDetailViewModel {
    var note: Note
    var noteViewModel: NoteViewModel
    var transactionType: TransactionType
    var deletedTextStack = [String]()
    var databaseService: DatabaseService
    
    init(note: Note, noteViewModel: NoteViewModel, transactionType: TransactionType, databaseService: DatabaseService) {
        self.note = note
        self.noteViewModel = noteViewModel
        self.transactionType = transactionType
        self.databaseService = databaseService
    }
    
    func updateNoteDocument(text: String, completion: @escaping (Error?)->Void) {
        databaseService.updateNoteDocument(text: text, documentID: note.documentID, completion: completion)
    }
    
    func addOrUpdateNote(text: String, completion: @escaping (Error?)->Void) {
        if transactionType == .add {
            if text.isEmpty { return }
            noteViewModel.addNoteDocument(text, completion: completion)
        } else {
            updateNoteDocument(text: text, completion: completion)
        }
    }
    
    func undoDelete() -> String? {
        return deletedTextStack.popLast()
    }
    
    func saveText(text: String?) {
        guard let text = text, !text.isEmpty else { return }
        deletedTextStack.append(text)
    }
}
