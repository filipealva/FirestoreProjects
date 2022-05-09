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

    public func update<T: Persistable>(_ type: T.Type, withId identifier: String, values: [T.PropertyValue], pathParams: [CVarArg] = []) {
        var dictionary: [String: Any] = [:]

        values.forEach {
            let pair = $0.propertyValuePair
            dictionary[pair.name] = pair.value
        }

        let collectionPath = path(for: T.collectionPath, with: pathParams)
        firestore.document("\(collectionPath)\(identifier)").updateData(dictionary)
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
