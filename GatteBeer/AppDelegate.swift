//
//  AppDelegate.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var launchedShortcutItem: UIApplicationShortcutItem?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        App.icon = UIImage(named: "beer.png")
        App.starRed = UIImage(named: "star_red.png")
        App.starGray = UIImage(named: "star_gray.png")
        App.formatter.dateFormat = "hh:mma yyyy-MM-dd"
        
        
        var continueDelegate = true
        if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsKey.shortcutItem] as? UIApplicationShortcutItem {
            launchedShortcutItem = shortcutItem
            
            continueDelegate = false
        }
        return continueDelegate
    }

    // 3D touch
    func applicationDidBecomeActive(_ application: UIApplication) {
        guard let shortcut = launchedShortcutItem else { return }
        
        _ = handleShortcut(shortcutItem: shortcut)
        
        launchedShortcutItem = nil
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        completionHandler(handleShortcut(shortcutItem: shortcutItem))
    }

    func handleShortcut(shortcutItem: UIApplicationShortcutItem) -> Bool {
        var succeeded = false
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let navController = window?.rootViewController as! UINavigationController
        
        if shortcutItem.type == "add" {
            let vc = sb.instantiateViewController(withIdentifier: "New")
            navController.pushViewController(vc, animated: false)
            succeeded = true
        } else {
            navController.popToRootViewController(animated: false)
            let vc = navController.visibleViewController as! MainViewController
            vc.tableView.reloadData()
        }
        
        return succeeded
    }
}


