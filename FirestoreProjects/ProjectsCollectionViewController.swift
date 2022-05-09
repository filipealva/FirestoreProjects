//
//  ViewController.swift
//  FirestoreProjects
//
//  Created by Filipe Alvarenga on 20/02/21.
//

import UIKit

final class ProjectsCollectionViewController: UICollectionViewController {

    // MARK: Properties

    let database = DatabaseManager()
    var projects = [Project]() {
        didSet {
            applySnapshot()
        }
    }

    private enum Section: CaseIterable {
        case projects
    }

    private lazy var dataSource: UICollectionViewDiffableDataSource<Section, Project> = {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Project> { cell, _, project in
            var content = cell.defaultContentConfiguration()
            content.text = project.projectName

            content.image = UIImage(systemName: "doc")
            content.imageProperties.preferredSymbolConfiguration = .init(
                font: content.textProperties.font,
                scale: .large
            )

            cell.contentConfiguration = content
        }

        return UICollectionViewDiffableDataSource<Section, Project>(collectionView: collectionView) { (collectionView, indexPath, project) -> UICollectionViewCell? in
            collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: project
            )
        }
    }()

    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        createLayout()
        fetchAllProjects()
        applySnapshot(animatingDifferences: false)
    }

    // MARK: Database

    private func fetchAllProjects() {
        database.fetchValues(Project.self, matching: .all) { [weak self] projects in
            self?.projects = projects
        }
    }

    // MARK: View management

    private func setupNavigationBar() {
        navigationItem.title = "Projects"
        let createProjectButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(presentCreateProject)
        )

        navigationItem.setRightBarButtonItems([createProjectButton], animated: false)
    }

    private func createLayout() {
        let config = UICollectionLayoutListConfiguration(appearance: .grouped)
        collectionView.collectionViewLayout = UICollectionViewCompositionalLayout.list(using: config)
    }

    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Project>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(projects)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    // MARK: Actions

    @objc func presentCreateProject() {
        presentCreateProject(project: nil)
    }

    private func presentCreateProject(project: Project? = nil) {
        let isCreatingProject = project?.projectName == nil
        let projectAlert = UIAlertController(
            title: isCreatingProject ? "Name your new project" : "Edit your project's name",
            message: nil,
            preferredStyle: .alert
        )

        projectAlert.addTextField() { textField in
            guard let projectName = project?.projectName else {
                textField.placeholder = "Enter a project name"
                return
            }

            textField.text = projectName
        }

        let createOrEditAction = UIAlertAction(
            title: isCreatingProject ? "Create" : "Update",
            style: .default
        ) { [weak self, unowned projectAlert] _ in
            guard let textField = projectAlert.textFields?[0] else {
                return
            }

            self?.database.write({ write in
                if isCreatingProject {
                    write.add(Project(name: textField.text))
                } else if let project = project {
                    write.update(
                        Project.self,
                        withId: project.identifier,
                        values: [.name(textField.text ?? project.identifier)]
                    )
                }
            })

            self?.fetchAllProjects()
            self?.applySnapshot()
        }

        projectAlert.addAction(createOrEditAction)
        projectAlert.addAction(.init(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))

        present(projectAlert, animated: true)
    }
}

// MARK: UICollectionViewDelegate

extension ProjectsCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let project = dataSource.itemIdentifier(for: indexPath) else {
            return
        }

        presentCreateProject(project: project)
    }
}
