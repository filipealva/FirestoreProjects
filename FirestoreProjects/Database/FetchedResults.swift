//
//  FetchedResults.swift
//  FirestoreProjects
//
//  Created by Filipe Alvarenga on 14/09/21.
//

import Foundation

public final class FetchedResults<T: Persistable> {

    internal let results: [[String: Any]]

    public var count: Int {
        return results.count
    }

    internal init(results: [[String: Any]]) {
        self.results = results
    }

    public func value(at index: Int) -> T {
        return T(dictionary: results[index])
    }
}

// MARK: Collection

extension FetchedResults: Collection {

    public var startIndex: Int {
        return 0
    }

    public var endIndex: Int {
        return count
    }

    // swiftlint:disable identifier_name
    public func index(after i: Int) -> Int {
        precondition(i < endIndex)
        return i + 1
    }

    public subscript(position: Int) -> T {
        return value(at: position)
    }
}
