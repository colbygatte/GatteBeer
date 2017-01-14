//
//  MainViewController.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import CoreLocation
import CoreData

class MainViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties
    var beers: [Beer] = []
    var searchedBeers: [Beer] = []
    var showSearchedBeers: Bool = false
    var searchController: UISearchController!
    var fetchedResultsController: NSFetchedResultsController<Beer>!
    

    // MARK: - View Life Cycle
    override func viewWillDisappear(_ animated: Bool) {
        searchController.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GatteBeer"
        // Sort descriptors
        let dateSort = NSSortDescriptor(key: #keyPath(Beer.date), ascending: true)
        
        // Fetch request
        let fetchRequest: NSFetchRequest<Beer> = Beer.fetchRequest()
        fetchRequest.sortDescriptors = [dateSort]
        
        // Fetch results controller
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: App.coreDataStack.managedContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
        
        // Set up UISearchController
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search your beer!"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        // Set up UITableView
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainCell")
        tableView.rowHeight = 80.0
        tableView.tableHeaderView = searchController.searchBar
    }
}

// MARK: - Helper methods
extension MainViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "New" {
            let vc = segue.destination as! NewBeerViewController
            vc.delegate = self
        } else if segue.identifier == "View" {
            let row = (tableView.indexPathForSelectedRow?.row)!
            
            let vc = segue.destination as! BeerViewController
            if showSearchedBeers && searchController.searchBar.text != "" {
                vc.beer = searchedBeers[row]
            } else {
                vc.beer = beers[row]
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = fetchedResultsController.sections?[section] else { return 0 }
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beer = fetchedResultsController.object(at: indexPath)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as! MainTableViewCell
        cell.imageView?.image = nil
        
        cell.beer = beer
        cell.setup()
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "View", sender: nil)
    }
    
}


// MARK: - Search
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchString = searchController.searchBar.text {
            searchedBeers = beers.filter({ beer in
                let bools = [(beer.name?.range(of: searchString, options: .caseInsensitive, range: nil, locale: nil) != nil)]
                             //(beer.location?.city?.range(of: searchString, options: .caseInsensitive, range: nil, locale: nil) != nil),
                             //(beer.location?.place?.range(of: searchString, options: .caseInsensitive, range: nil, locale: nil) != nil)]
                if bools.contains(true) {
                    return true
                } else {
                    return false
                }
            })
            
            tableView.reloadData()
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        showSearchedBeers = true
        tableView.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        showSearchedBeers = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !showSearchedBeers {
            showSearchedBeers = true
            tableView.reloadData()
        }
        searchController.dismiss(animated: true, completion: nil)
        searchController.searchBar.resignFirstResponder()
    }
}

extension MainViewController: NewBeerViewControllerDelegate {
    func newBeer(addedBeer beer: Beer) {
        beers.insert(beer, at: 0)
        tableView.reloadData()
    }
}


