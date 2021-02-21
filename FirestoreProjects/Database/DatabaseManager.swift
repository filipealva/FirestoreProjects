//
//  DatabaseManager.swift
//  FirestoreProjects
//
//  Created by Filipe Alvarenga on 21/02/21.
//

import Foundation
import FirebaseFirestore

public final class DatabaseManager {
    private let firestore: Firestore

    public convenience init() {
        self.init(firestore: Firestore.firestore())
    }

    internal init(firestore: Firestore) {
        self.firestore = firestore
    }

    public func write(_ block: (WriteTransaction) -> Void) {
        let transaction = WriteTransaction(firestore: firestore)
        block(transaction)
    }
}
