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
    var beers: [GBBeer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "MainTableViewCell", bundle: nil), forCellReuseIdentifier: "MainCell")
        tableView.rowHeight = 80.0
        title = "GatteBeer"
        
        FIRAuth.auth()?.signInAnonymously() { user, error in
            if error == nil && user != nil {
                DB.usersRef.child(user!.uid).observeSingleEvent(of: .value, with: { snap in
                    App.loggedInUser = GBUser(snapshot: snap)
                    DB.userRef = DB.usersRef.child(App.loggedInUser.uid)
                    self.begin()
                })
            } else {
                print("Error signing in anonymously.")
            }
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
            vc.beer = beers[row]
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell") as! MainTableViewCell
        cell.imageView?.image = nil
        let beer = beers[indexPath.row]
        
        if beer.image != nil {
            cell.beerImageView.image = beer.image
        } else if beer.imgFile != nil {
            FIRStorage.storage().reference(forURL: DB.storageURL + beer.imgFile!).data(withMaxSize: 1000 * 10000, completion: { data, error in
                if error == nil && data != nil {
                    beer.image = UIImage(data: data!)
                    DispatchQueue.main.async {
                        cell.beerImageView.image = beer.image
                        //self.tableView.reloadRows(at: [indexPath], with: .automatic)
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

extension MainViewController: NewBeerViewControllerDelegate {
    func newBeer(added beer: GBBeer) {
        beers.insert(beer, at: 0)
        tableView.reloadData()
    }
}
