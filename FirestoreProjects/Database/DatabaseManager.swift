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

    public func fetchValues<T: Persistable>(
        _ type: T.Type,
        matching query: T.Query,
        pathParams: [CVarArg] = [],
        completion: @escaping ([T]) -> Void
    ) {
        // Resolve the collection path
        let collectionPath = path(for: T.collectionPath, with: pathParams)
        var firestoreQuery: Query = firestore.collection(collectionPath)

        // Verify if there is any predicate to apply
        if let predicate = query.predicate {
            firestoreQuery = firestoreQuery.filter(using: predicate)
        }

        // Execute the Firestore Query
        firestoreQuery.getDocuments { [weak self] snapshot, _ in
            // Handle the query result
            self?.handle(
                persistableQuery: query,
                firestoreSnapshot: snapshot,
                completion: completion
            )
        }
    }

    private func sorted<T: Persistable>(
        _ type: T.Type,
        results: [[String: Any]],
        matching query: T.Query
    ) -> [[String: Any]] {
        var results = results

        if !query.sortDescriptors.isEmpty {
            let nsArrayResults = (results as NSArray).sortedArray(
                using: query.sortDescriptors
            )

            results = nsArrayResults as? Array ?? results
        }

        return results
    }

    private func handle<T: Persistable>(
        persistableQuery: T.Query,
        firestoreSnapshot: QuerySnapshot?,
        completion: @escaping ([T]) -> Void
    ) {
        // Handle empty Firestore snapshot
        guard let snapshot = firestoreSnapshot else {
            completion([])
            return
        }

        // Bind the document id into the Firestore's data snapshot
        // since it doesn't come in the document's snapshot
        let results = snapshot.documents.map { document -> [String: Any] in
            var identifiedData = document.data()
            identifiedData["documentID"] = document.documentID
            return identifiedData
        }

        // Sort the values based on our query's sort descriptors
        let sortedValues = sorted(
            T.self,
            results: results,
            matching: persistableQuery
        )

        // Create a Persistable collection
        let fetchedResults = FetchedResults<T>(
            results: sortedValues
        ).map { $0 }

        // Send the fetched data to the query's caller
        completion(fetchedResults)
    }

    private func path(
        for collectionPath: String,
        with params: [CVarArg]
    ) -> String {
        var path = collectionPath

        if !params.isEmpty {
            path = String(format: collectionPath, arguments: params)
        }

        return path
    }
}
