//
//  GBUser.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import Firebase

class GBUser: NSObject {
    var uid: String!
    var apnTokens: [String]!
    
    var email: String?
    var beers: [GBBeer]!
    
    init(snapshot: FIRDataSnapshot) {
        self.uid = snapshot.key
        self.beers = []
        
        if let values = snapshot.value as? [String: Any] {
            email = values["email"] as? String
            
            let beers = values["beers"] as? [String: [String: Any]]
            if beers != nil {
                for beer in beers! {
                    let gbbeer = GBBeer(id: beer.key, values: beer.value)
                    self.beers.append(gbbeer)
                }
            }
            
            let tokens = values["apnTokens"] as? [String]
            if tokens != nil {
                apnTokens = tokens
            } else {
                apnTokens = []
            }
        } else {
            
        }
    }
    
    init(user: FIRUser) {
        uid = user.uid
        email = user.email
    }
    
    func toFirebaseObject() -> Any {
        var object: [String: Any] = [:]
        
        object["email"] = email
        object["apnTokens"] = apnTokens
        
        var beersObject: [String: Any] = [:]
        for beer in beers {
            beersObject[beer.id] = beer.toFirebaseObject()
        }
        object["beers"] = beersObject
        
        return object
    }
}
