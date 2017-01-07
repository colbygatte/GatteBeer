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
    @IBOutlet weak var notesTextView: UITextView!
    var beer: GBBeer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = beer.image
        nameLabel.text = beer.name
        notesTextView.text = beer.notes ?? ""
        
        starsView.setFrame()
        starsView.set(rating: beer.rating ?? 0)
        
        setupMap()
    }
    
    @IBAction func shareButtonPressed() {
        
        let texts = ["", "THIS BEER IS NASTY!", "Pretty gross. Jus' saying.", "Pretty good if you don't have anything else.", "Ooh, yum.", "5 STARS!!!"]
        
        let items: [Any] = [beer.name + "\n" + texts[beer.rating ?? 0], beer.image]
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.excludedActivityTypes = [.addToReadingList, .airDrop, .addToReadingList, .openInIBooks, .postToFlickr, .saveToCameraRoll, .postToFacebook]
        
        present(activityViewController, animated: true, completion: nil)
    }
    
    func setupMap() {
        if let location = beer.location {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            annotation.title = beer.location?.place
            mapView.addAnnotation(annotation)
            
            let span = MKCoordinateSpanMake(0.02, 0.02)
            let region = MKCoordinateRegionMake(location.coordinate, span)
            mapView.setRegion(region, animated: true)
        }
    }
}
