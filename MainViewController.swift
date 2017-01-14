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
    var sortView: SortView!

    override func viewWillDisappear(_ animated: Bool) {
        searchController.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "GatteBeer"
        sort = .newest
        sortView = SortView()
        
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
    
    @IBAction func sortButtonPressed() {
        sortView.frame = view.frame
        sortView.alpha = 0.0
        navigationController?.view.addSubview(sortView)
        sortView.setFrame()
        sortView.delegate = self
        
        UIView.animate(withDuration: TimeInterval(0.2), animations: {
            self.sortView.alpha = 1.0
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "New" {
            let vc = segue.destination as! NewBeerViewController
            vc.delegate = self
        } else if segue.identifier == "View" {
            let indexPath = (tableView.indexPathForSelectedRow)!
            
            let vc = segue.destination as! BeerViewController
            vc.beer = getBeer(indexPath: indexPath)
        }
    }
    
    func getBeer(indexPath: IndexPath) -> GBBeer {
        if showSearchedBeers && searchController.searchBar.text != "" {
            return searchedBeers[indexPath.row]
        } else {
            return beers[indexPath.row]
        }
    }
    
    func removeBeer(indexPath: IndexPath) {
        if showSearchedBeers && searchController.searchBar.text != "" {
            searchedBeers.remove(at: indexPath.row)
        } else {
            beers.remove(at: indexPath.row)
        }
    }
    
    func getBeerCount() -> Int {
        if showSearchedBeers && searchController.searchBar.text != "" {
            return searchedBeers.count
        }
        return beers.count
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getBeerCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let beer = getBeer(indexPath: indexPath)
        
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
        cell.setup(row: indexPath.row)
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "View", sender: nil)
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            DB.delete(beer: getBeer(indexPath: indexPath))
            removeBeer(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
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

extension MainViewController: SortViewDelegate {
    // This is a quick action so we make sure to run it after
    // the user is logged in
    func sortOptions(sort: GBSortOptions) {
        App.runWhenLoggedIn() {
            self.sort = sort
            self.beers = GBBeerSorter.sort(beers: self.beers, order: sort)
            self.tableView.reloadData()
        }
    }
}
