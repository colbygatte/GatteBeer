//
//  GBLocation.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/31/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import Firebase
import MapKit
import AddressBook

class GBLocation: NSObject {
    var id: String!
    
    var coordinate: CLLocationCoordinate2D!
    var place: String?
    var city: String?
    var state: String?
    var country: String?
    
    var mapItem: MKMapItem? {
        didSet {
            self.coordinate = self.mapItem?.placemark.coordinate
            self.place = self.mapItem?.placemark.name
        }
    }
    
    init(snapshot: FIRDataSnapshot) {
        let values = snapshot.value as! [String: Any]
        
        id = snapshot.key
        place = values["place"] as? String
        city = values["city"] as? String
        state = values["state"] as? String
        country = values["country"] as? String
        
        let longitude = values["longitude"] as! Double
        let latitude = values["latitude"] as! Double
        coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        if snapshot.hasChild("mapItem") {
            let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
            let mapItem = MKMapItem(placemark: placemark)
            
            let mapItemValues = snapshot.childSnapshot(forPath: "mapItem").value as! [String: Any]
            mapItem.name = mapItemValues["name"] as! String?
            mapItem.phoneNumber = mapItemValues["phoneNumber"] as! String?
            if let urlString = mapItemValues["url"] as! String? {
                mapItem.url = URL(string: urlString)
            }
            
            self.mapItem = mapItem
        }
    }
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    override func toFirebaseObject() -> Any? {
        var object: [String: Any] = [:]
        
        object["longitude"] = coordinate.longitude
        object["latitude"] = coordinate.latitude
        object["place"] = place
        object["city"] = city
        object["state"] = state
        object["country"] = country
        
        if mapItem != nil {
            var mapItemObject: [String: Any] = [:]
            mapItemObject["name"] = mapItem?.name
            mapItemObject["placemarkTitle"] = mapItem?.placemark.title
            mapItemObject["phoneNumber"] = mapItem?.phoneNumber
            mapItemObject["url"] = mapItem?.url?.absoluteString
            object["mapItem"] = mapItemObject
        }
        
        return object
    }
}
