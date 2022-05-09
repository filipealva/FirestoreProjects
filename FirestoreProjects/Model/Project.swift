//
//  Project.swift
//  FirestoreProjects
//
//  Created by Filipe Alvarenga on 21/02/21.
//

import Foundation

struct Project: Persistable, Hashable {
    var identifier: String = ""
    var projectName: String = ""

    static var collectionPath: String {
        return "projects/"
    }

    init(name: String?) {
        identifier = UUID().uuidString
        projectName = name ?? identifier
    }

    init(dictionary: [String : Any]) {
        identifier = dictionary["documentID"] as? String ?? ""
        projectName = dictionary["projectName"] as? String ?? identifier
    }

    func toDictionary() -> [String : Any] {
        return [
            "projectName": projectName
        ]
    }
}

extension Project {
    public enum PropertyValue: PropertyValueType {
        case name(String)

        public var propertyValuePair: PropertyValuePair {
            switch self {
            case .name(let name):
                return ("projectName", name)
            }
        }
    }
}

extension Project {
    public enum Query: QueryType {
        case all

        public var predicate: NSPredicate? {
            switch self {
            case .all:
                return nil
            }
        }

        public var sortDescriptors: [NSSortDescriptor] {
            return [NSSortDescriptor(key: "projectName", ascending: true)]
        }
    }
}
