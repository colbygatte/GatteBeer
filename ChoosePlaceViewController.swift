//
//  ChoosePlaceViewController.swift
//  GatteBeer
//
//  Created by Colby Gatte on 1/2/17.
//  Copyright © 2017 colbyg. All rights reserved.
//

import UIKit
import MapKit

protocol ChoosePlaceViewControllerDelegate {
    func placeChosen(mapItem: MKMapItem)
}

class ChoosePlaceViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var coordinate: CLLocationCoordinate2D!
    var mapView: MKMapView!
    var mapItems: [MKMapItem]!
    var delegate: ChoosePlaceViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        mapItems = []
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = "beer"
        request.region = mapView.region
        
        let localSearch = MKLocalSearch(request: request)
        localSearch.start { response, error in
            if error == nil {
                self.mapItems = (response?.mapItems)!
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension ChoosePlaceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mapItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        cell.textLabel?.text = mapItems[indexPath.row].name
        return cell
    }
}

extension ChoosePlaceViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapItem = mapItems[indexPath.row]
        delegate?.placeChosen(mapItem: mapItem)
        _ = navigationController?.popViewController(animated: true)
    }
}
