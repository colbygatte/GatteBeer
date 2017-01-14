//
//  GTNavController.swift
//  GatteBeer
//
//  Created by Colby Gatte on 1/7/17.
//  Copyright © 2017 colbyg. All rights reserved.
//

// http://www.brewerydb.com/developers/docs
// API Key for BreweryDB:
// f5aad475ca9bc252aeb5eedbfe997f88
// http://api.brewerydb.com/v2/?key=f5aad475ca9bc252aeb5eedbfe997f88&format=json

import UIKit

class ContainerViewController: UIViewController {
    var containerNavigationController: UINavigationController!
    var mainViewController: MainViewController!
    
    var quickOptions: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        mainViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Main") as! MainViewController
        containerNavigationController = UINavigationController(rootViewController: mainViewController)
        
        view.addSubview(containerNavigationController.view)
    }
    
    
}
