//
//  MainViewController.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = "GatteBeer"
        
        FIRAuth.auth()?.signInAnonymously() { user, error in
            if error == nil && user != nil {
                DB.usersRef.child(user!.uid).observeSingleEvent(of: .value, with: { snap in
                    App.loggedInUser = GBUser(snapshot: snap)
                    self.begin()
                })
            } else {
                print("Error signing in anonymously.")
            }
        }
    }
    
    func begin() {
        
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "hi"
        return cell
    }
}
