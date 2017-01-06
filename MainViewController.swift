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

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var beers: [GBBeer] = []
    var searchedBeers: [GBBeer] = []
    var showSearchedBeers: Bool = false
    var sort: GBSortOptions!
    var searchController: UISearchController!

    override func viewWillDisappear(_ animated: Bool) {
        searchController.dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GatteBeer"
        sort = .newest
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search your beer!"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainCell")
        tableView.rowHeight = 80.0
        tableView.tableHeaderView = searchController.searchBar
        
        
        App.runWhenLoggedIn {
            self.begin()
        }
    }
    
    func begin() {
        DB.userRef.child("beers").queryOrderedByKey().observeSingleEvent(of: .value, with: { snap in
            for beerData in snap.children.reversed() {
                let beerSnap = beerData as! FIRDataSnapshot
                let beer = GBBeer(snapshot: beerSnap)
                self.beers.append(beer)
            }
            
            DispatchQueue.main.async {
                self.beers = GBBeerSorter.sort(beers: self.beers, order: self.sort)
                self.tableView.reloadData()
            }
        })
    }
    
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
        } else if segue.identifier == "Sort" {
            let vc = segue.destination as! SortViewController
            vc.sort = sort
            vc.delegate = self
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if showSearchedBeers && searchController.searchBar.text != "" {
            return searchedBeers.count
        }
        return beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beer: GBBeer
        if showSearchedBeers && searchController.searchBar.text != "" {
            beer = searchedBeers[indexPath.row]
        } else {
            beer = beers[indexPath.row]
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as! MainTableViewCell
        cell.imageView?.image = nil
        
        if beer.image != nil {
            cell.beerImageView.image = beer.image
        } else if beer.imgFile != nil {
            FIRStorage.storage().reference(forURL: DB.storageURL + beer.imgFile!).data(withMaxSize: 1000 * 10000, completion: { data, error in
                if error == nil && data != nil {
                    beer.image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        cell.beerImageView.image = beer.image
                    }
                }
            })
        }
        
        cell.beer = beer
        cell.setup()
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "View", sender: nil)
    }
    
}

// MARK: Search

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchString = searchController.searchBar.text {
            searchedBeers = beers.filter({ beer in
                let bools = [(beer.name.range(of: searchString, options: .caseInsensitive, range: nil, locale: nil) != nil),
                             (beer.location?.city?.range(of: searchString, options: .caseInsensitive, range: nil, locale: nil) != nil),
                             (beer.location?.place?.range(of: searchString, options: .caseInsensitive, range: nil, locale: nil) != nil)]
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
    func newBeer(added beer: GBBeer) {
        beers.insert(beer, at: 0)
        beers = GBBeerSorter.sort(beers: beers, order: .newest)
        tableView.reloadData()
    }
}

extension MainViewController: SortViewControllerDelegate {
    func sortOptions(sort: GBSortOptions) {
        self.sort = sort
        self.beers = GBBeerSorter.sort(beers: self.beers, order: sort)
        tableView.reloadData()
    }
}
