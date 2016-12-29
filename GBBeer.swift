//
//  GBBeer.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import Firebase
import MapKit

class GBBeer: NSObject {
    var id: String!
    var name: String!
    var rating: Int!
    
    var imgFile: String?
    var location: CLLocationCoordinate2D?
    var notes: String?
    
    init(snapshot: FIRDataSnapshot) {
        let values = snapshot.value as! [String: Any]
        
        id = snapshot.key
        name = values["name"] as! String
        notes = values["notes"] as? String
        rating = values["rating"] as! Int
        imgFile = values["imgFile"] as? String
        
        if let latitude = values["latitude"] as? Int, let longitude = values["longitude"] as? Int {
            location = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        }
    }
    
    init(id: String, values: [String: Any]) {
        self.id = id
        
    }
    
    override func toFirebaseObject() -> Any? {
        var object: [String: Any] = [:]
        
        object["name"] = name
        object["notes"] = notes
        object["longitude"] = location?.longitude
        object["latitude"] = location?.latitude
        object["imgFile"] = imgFile
        
        return object
    }
}
