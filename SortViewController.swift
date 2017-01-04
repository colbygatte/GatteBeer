//
//  SortViewController.swift
//  GatteBeer
//
//  Created by Colby Gatte on 1/3/17.
//  Copyright © 2017 colbyg. All rights reserved.
//

import UIKit

class SortViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var cities: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        cities = ["Westlake", "Lake Charles"]
        
    }
}

extension SortViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = cities[indexPath.row]
        return cell
    }
}
