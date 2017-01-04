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
    var rating: Int?
    
    var imgFile: String?
    var image: UIImage?
    var notes: String?
    var location: GBLocation?
    
    init(snapshot: FIRDataSnapshot) {
        let values = snapshot.value as! [String: Any]
        
        id = snapshot.key
        name = values["name"] as! String
        notes = values["notes"] as? String
        rating = values["rating"] as? Int
        imgFile = values["imgFile"] as? String
        
        if let locationData = values["location"] {
            location = GBLocation(snapshot: snapshot.childSnapshot(forPath: "location"))
        }
    }
    
    init(id: String, values: [String: Any]) {
        self.id = id
        
    }
    
    override func toFirebaseObject() -> Any? {
        var object: [String: Any] = [:]
        
        object["name"] = name
        object["notes"] = notes
        object["imgFile"] = imgFile
        object["rating"] = rating
        object["location"] = location?.toFirebaseObject()
        
        return object
    }
}
