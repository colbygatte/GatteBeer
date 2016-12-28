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
    var location: CLLocationCoordinate2D!
    
    init(snapshot: FIRDataSnapshot) {
        let values = snapshot.value as! [String: Any]
        
        name = values["name"] as! String
    }
    
    init(id: String, values: [String: Any]) {
        self.id = id
        
    }
    
    func toFirebaseObject() -> Any {
        var object: [String: Any] = [:]
        
        object["name"] = name
        
        return object
    }
}
