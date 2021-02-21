//
//  Project.swift
//  FirestoreProjects
//
//  Created by Filipe Alvarenga on 21/02/21.
//

import Foundation

struct Project: Persistable {
    var identifier: String = ""
    var projectName: String = ""

    static var collectionPath: String {
        return "/projects"
    }

    init(dictionary: [String : Any]) {
        identifier = dictionary["DocumentID"] as? String ?? ""
        projectName = dictionary["projectName"] as? String ?? ""
    }

    func toDictionary() -> [String : Any] {
        return [
            "projectName": projectName
        ]
    }
}
