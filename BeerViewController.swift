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
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var starsView: StarsView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var openInMapsButton: UIButton!
    var beer: GBBeer!

    
    @IBAction func openInMapsButtonPressed() {
        if let location = beer.location {
            
            location.mapItem?.openInMaps(launchOptions: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if beer.image == nil {
            imageView.backgroundColor = beer.randomColor
            imageView.image = App.transparentBeer
        } else {
            imageView.image = beer.image
        }
        
        nameLabel.text = beer.name
        notesTextView.text = beer.notes ?? ""
        
        if let place = beer.location?.place {
            infoLabel.text = "Consumed at \(place)."
        } else {
            infoLabel.text = ""
        }
        
        starsView.setFrame()
        starsView.set(rating: beer.rating ?? 0)
        starsView.editable = false
    }
    
    @IBAction func shareButtonPressed() {
        let texts = ["", "THIS BEER IS NASTY!", "Pretty gross. Jus' saying.", "Pretty good if you don't have anything else.", "Ooh, yum.", "5 STARS!!!"]
        
        let items: [Any] = [beer.name + "\n" + texts[beer.rating ?? 0], beer.image]
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = view
        activityViewController.excludedActivityTypes = [.addToReadingList, .airDrop, .addToReadingList, .openInIBooks, .postToFlickr, .saveToCameraRoll, .postToFacebook]
        
        present(activityViewController, animated: true, completion: nil)
    }
}
