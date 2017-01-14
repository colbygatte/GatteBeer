//
//  DB.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import Foundation
import Firebase

class DB {
    static var ref: FIRDatabaseReference!
    static var usersRef: FIRDatabaseReference!
    static var userRef: FIRDatabaseReference!
    static var storageURL = "gs://gattebeer.appspot.com/beer/"
    
    static func save(object: NSObject, userPath: String) {
        DB.usersRef.child(App.loggedInUser.uid).child(userPath).setValue(object.toFirebaseObject())
    }
    
    static func delete(beer: GBBeer) {
        DB.usersRef.child(App.loggedInUser.uid).child("beers").child(beer.id).setValue(nil)
    }
}


extension NSObject {
    func toFirebaseObject() -> Any? {
        return nil
    }
}
