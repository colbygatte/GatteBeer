//
//  AppDelegate.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?
    var launchedShortcutItem: UIApplicationShortcutItem?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        
        App.icon = UIImage(named: "beer.png")
        App.starRed = UIImage(named: "star_red.png")
        App.starGray = UIImage(named: "star_gray.png")
        App.formatter.dateFormat = "hh:mma yyyy-MM-dd"
        
        DB.ref = FIRDatabase.database().reference()
        DB.usersRef = DB.ref.child("users")
        
        App.loginAnonymously() {
           print("Logged in")
        }
        
        // Push notifications
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            UNUserNotificationCenter.current().delegate = self
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
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
            vc.sortOptions(sort: .best)
            vc.tableView.reloadData()
        }
        
        return succeeded
    }
    
    // Notifications
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        print("\n\nTOKEN:\(token)\n\n")
        App.apnToken = token
    }
}


