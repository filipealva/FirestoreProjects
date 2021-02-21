//
//  WriteTransaction.swift
//  FirestoreProjects
//
//  Created by Filipe Alvarenga on 21/02/21.
//

import Foundation
import FirebaseFirestore

public final class WriteTransaction {
    private let firestore: Firestore

    internal init(firestore: Firestore) {
        self.firestore = firestore
    }

    public func add<T: Persistable>(_ value: T) {
        let collectionPath = T.collectionPath
        firestore.document(
            "\(collectionPath)\(value.identifier)"
        ).setData(
            value.toDictionary()
        )
    }
}
