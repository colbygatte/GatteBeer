//
//  BeerViewController.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class BeerViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var starsView: StarsView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notesTextField: UITextField!
    var beer: GBBeer!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        
        imageView.image = beer.image
        nameLabel.text = beer.name
        starsView.set(rating: beer.rating ?? 0)
        
        setupMap()
    }
    
    func setupMap() {
        if let location = beer.location {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = beer.name
            mapView.addAnnotation(annotation)
            
            let span = MKCoordinateSpanMake(0.02, 0.02)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
        }
    }
}

extension BeerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
    
        
        return view
    }
}
