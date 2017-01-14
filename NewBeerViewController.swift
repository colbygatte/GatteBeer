//
//  NewBeerViewController.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import CoreLocation

protocol NewBeerViewControllerDelegate {
    func newBeer(addedBeer beer: Beer)
}

class NewBeerViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var starsView: StarsView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    
    var imagePickerController: UIImagePickerController!
    var originalImage: UIImage?
    var locationManager: CLLocationManager!
    //var location: Location?
    var delegate: NewBeerViewControllerDelegate?
    var newBeer: Beer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        // This view is launched from 3D touch quick action,
        // wait for user to be logged in
        
        starsView.setFrame()
        starsView.set(rating: 0)
    }
    
    func fieldsPassCheck() -> Bool {
        var check = true
        if let name = nameTextField.text {
            if name.characters.count < 3 {
                print("name too short")
                check = false
            }
        } else {
            check = false
            print("no name")
        }
        return check
    }
    
    
    @IBAction func submitButtonPressed() {
        guard fieldsPassCheck() else { return }

        let entity = Beer.entity()
        let beer = Beer(entity: entity, insertInto: App.coreDataStack.managedContext)
        
        beer.name = nameTextField.text!
        beer.notes = notesTextView.text
        beer.rating = Int16(starsView.rating)
        
        App.coreDataStack.saveContext()
        
        delegate?.newBeer(addedBeer: beer)
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pictureButtonPressed() {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let alertController = UIAlertController(title: "Select option", message: "", preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Library", style: .default) { action in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    
    func sendToChoosePlace(coordinate: CLLocationCoordinate2D) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChoosePlace") as! ChoosePlaceViewController
        vc.coordinate = coordinate
        vc.mapView = mapView
        vc.delegate = self
        //navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewBeerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = originalImage
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}

extension NewBeerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        /*if !locations.isEmpty && location == nil {
            let coordinate = locations[0].coordinate
            //location = GBLocation(coordinate: coordinate)
            
            let span = MKCoordinateSpanMake(0.02, 0.02)
            let region = MKCoordinateRegionMake(coordinate, span)
            mapView.setRegion(region, animated: true)
            sendToChoosePlace(coordinate: coordinate)
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(locations[0], completionHandler: { placemarks, error in
                if error == nil {
                    let placemark = placemarks?[0]
                    
                    // Keys to placemaark?.addressDictionary
                    // Street, Country, State, City, CountryCode
                    //self.location?.city = placemark?.addressDictionary?["City"] as! String?
                    //self.location?.country = placemark?.addressDictionary?["Country"] as! String?
                    //self.location?.state = placemark?.addressDictionary?["State"] as! String?
                } else {
                    print(error?.localizedDescription)
                }
            })
        }*/
    }
}

extension NewBeerViewController: ChoosePlaceViewControllerDelegate {
    func placeChosen(mapItem: MKMapItem) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        annotation.title = mapItem.name
        
        mapView.addAnnotation(annotation)
        
    }
}




