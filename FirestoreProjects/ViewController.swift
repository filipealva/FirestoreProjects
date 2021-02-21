//
//  ViewController.swift
//  FirestoreProjects
//
//  Created by Filipe Alvarenga on 20/02/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let project = Project(name: "Yet another test")
        DatabaseManager().write { write in
            write.add(project)
        }
    }


}

