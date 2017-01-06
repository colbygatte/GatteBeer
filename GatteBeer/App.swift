//
//  App.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

struct App {
    static var loggedInUser: GBUser!
    static var loggedIn: Bool = false
    static var apnToken: String?
    static var quickLaunch: String?
    static var formatter = DateFormatter()
    
    static var icon: UIImage!
    static var starRed: UIImage!
    static var starGray: UIImage!
    
    static var afterLoginBlocks: [(()->())] = []
    
    static func loginAnonymously(completion: @escaping ()->()) {
        FIRAuth.auth()?.signInAnonymously() { user, error in
            if error == nil && user != nil {
                DB.usersRef.child(user!.uid).observeSingleEvent(of: .value, with: { snap in
                    App.loggedInUser = GBUser(snapshot: snap)
                    DB.userRef = DB.usersRef.child(App.loggedInUser.uid)
                    App.loggedIn = true
                    completion()
                    for block in App.afterLoginBlocks {
                        block()
                    }
                    App.afterLoginBlocks = []
                })
            } else {
                print("Error signing in anonymously.")
            }
        }
    }
    
    static func runWhenLoggedIn(block: @escaping ()->()) {
        if App.loggedIn {
            block()
        } else {
            App.afterLoginBlocks.append(block)
        }
    }
    
    struct Theme {
        
    }
}

// below from http://stackoverflow.com/questions/24263007/how-to-use-hex-colour-values-in-swift-ios
extension UIColor {
    static func hexString(hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
