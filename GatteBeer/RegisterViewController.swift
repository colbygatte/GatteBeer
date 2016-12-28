//
//  RegisterViewController.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var password1TextField: UITextField!
    @IBOutlet weak var password2TextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func registerButtonPressed() {
        if let email = emailTextField.text, let pw1 = password1TextField.text, let pw2 = password2TextField.text {
            if pw1 == pw2 && pw1.characters.count >= 6 && email.characters.count > 6 {
                // @@@@ Register user here
            } else {
                print("Something is awry")
            }
        } else {
            print("Fields not filled out")
        }
    }
    
    @IBAction func backButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
}
