//
//  Persistable.swift
//  FirestoreProjects
//
//  Created by Filipe Alvarenga on 20/02/21.
//

import Foundation

public protocol Persistable {
    var identifier: String { get }
    static var collectionPath: String { get }

    init(dictionary: [String: Any])

    func toDictionary() -> [String: Any]
}

public typealias PropertyValuePair = (name: String, value: Any)

public protocol PropertyValueType {
    var propertyValuePair: PropertyValuePair { get }
}

public enum DefaultPropertyValue: PropertyValueType {

    public var propertyValuePair: PropertyValuePair {
        return ("", 0)
    }
}

public protocol QueryType {
    var predicate: NSPredicate? { get }
    var sortDescriptors: [NSSortDescriptor] { get }
}

public enum DefaultQuery: QueryType {
    case all
    case identifier(String)

    public var predicate: NSPredicate? {
        switch self {
        case .all:
            return nil
        case .identifier(let value):
            return NSPredicate(format: "identifier ==[c] %@", value)
        }
    }

    public var sortDescriptors: [NSSortDescriptor] {
        return []
    }
}

