//
//  ViewController.swift
//  FirestoreProjects
//
//  Created by Filipe Alvarenga on 20/02/21.
//

import UIKit

class ProjectsCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let project = Project(name: "First project")
        DatabaseManager().write { write in
            write.add(project)
        }
    }
}

