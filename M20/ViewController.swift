//
//  ViewController.swift
//  M20
//
//  Created by Максим Зыкин on 12.05.2024.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UITableViewController {
    
    private let cellID = "cell"
    
    private let persistentController = NSPersistentContainer(name: "M20")
    
    private lazy var fetchedResultController: NSFetchedResultsController<Artist> = {
        let fetchRequest = Artist.fetchRequest()
        let sort = UserDefaults.standard.bool(forKey: "sort")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: sort)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentController.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        return fetchedResultController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(ArtistCell.self, forCellReuseIdentifier: cellID)
        
        setupNavigationBar()
        
        persistentController.loadPersistentStores { persistentDescription, error in
            if let error = error {
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultController.performFetch()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func setupNavigationBar() {
        let navApperance = UINavigationBarAppearance()
        navApperance.configureWithOpaqueBackground()
        navApperance.titleTextAttributes = [.foregroundColor: UIColor.white]
    
        navigationController?.navigationBar.standardAppearance = navApperance
        navigationController?.navigationBar.scrollEdgeAppearance = navApperance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addArtist))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Сортировать",
            style: .plain,
            target: self,
            action: #selector(sortButton))
        
        navigationController?.navigationBar.tintColor = .black
    }

    @objc func addArtist() {
        let newArtist = AddArtistVC()
        newArtist.artist = Artist.init(entity: NSEntityDescription.entity(forEntityName: "Artist", in: persistentController.viewContext)!, insertInto: persistentController.viewContext)
        present(newArtist,animated: true)
    }
    
    @objc func sortButton() {
        let sort = UserDefaults.standard.bool(forKey: "sort")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: !sort)
        
        fetchedResultController.fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            try self.fetchedResultController.performFetch()
            tableView.reloadData()
            UserDefaults.standard.set(!sort, forKey: "sort")
            UserDefaults.standard.synchronize()
        } catch {
            print(error.localizedDescription)
        }
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        fetchedResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artist = fetchedResultController.object(at: indexPath)
        let cell = ArtistCell()
        cell.configure(model: artist)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let artist = fetchedResultController.object(at: indexPath)
            persistentController.viewContext.delete(artist)
            try? persistentController.viewContext.save()
        }
    }
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let artist = fetchedResultController.object(at: indexPath)
            let vc = AddArtistVC()
            vc.artist = artist
            present(vc,animated: true)
            print(artist)
        }
    
}

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type{
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let artist = fetchedResultController.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath) as? ArtistCell
                cell?.configure(model: artist)
            }
        @unknown default:
            print("Error")
        }
    }
}



