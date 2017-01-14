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
    @IBOutlet weak var newestButton: UIButton!
    @IBOutlet weak var oldestButton: UIButton!
    @IBOutlet weak var bestButton: UIButton!
    @IBOutlet weak var worstButton: UIButton!
    var sort: GBSortOptions!
    var buttons: [GBSortOptions: UIButton]!
    
    var cities: [String]!
    var selectedCity: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        navigationItem.hidesBackButton = true
        
        buttons = [.newest: newestButton, .oldest: oldestButton, .worst: worstButton, .best: bestButton]
        
        for button in buttons {
            if button.value.restorationIdentifier == sort.rawValue {
                button.value.alpha = 0.5
            }
        }
        
        cities = ["Westlake", "Lake Charles"]
        
    }
    
    @IBAction func sortButtonPressed(sender: UIButton) {
        if let id = sender.restorationIdentifier {
            buttons[sort]?.alpha = 1
            sender.alpha = 0.5
            sort = GBSortOptions(rawValue: id)
        } else {
            print("Error with UIButton restoration ID")
        }
    }
    
    @IBAction func doneButtonPressed() {
        if let indexPath = tableView.indexPathForSelectedRow {
            selectedCity = cities[indexPath.row]
        }
        
        //delegate?.sortOptions(sort: sort)
        
        _ = navigationController?.popViewController(animated: true)
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
