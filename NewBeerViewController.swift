//
//  NewBeerViewController.swift
//  GatteBeer
//
//  Created by Colby Gatte on 12/28/16.
//  Copyright © 2016 colbyg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class NewBeerViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    @IBOutlet weak var rating: UISegmentedControl!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePickerController: UIImagePickerController!
    var originalImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func fieldsPassCheck() -> Bool {
        var check = true
        
        if let name = nameTextField.text {
            if name.characters.count < 3 {
                print("name too short")
                check = false
            }
        } else {
            check = false
            print("no name")
        }
        
        
        return check
    }
    
    @IBAction func submitButtonPressed() {
        if fieldsPassCheck() {
            // First, lets add the beer to the user.
            let newBeerRef = DB.usersRef.child(App.loggedInUser.uid).childByAutoId()
            
            let newBeer = GBBeer(id: newBeerRef.key, values: [:])
            newBeer.name = nameTextField.text!
            newBeer.notes = notesTextField.text
            newBeer.rating = rating.selectedSegmentIndex
            newBeer.imgFile = "\(newBeerRef.key).jpg"
            print("\(newBeer.id).jpg")
            
            DB.save(object: newBeer, userPath: "beers/\(newBeerRef.key)")
            
            let storageRef = FIRStorage.storage().reference(forURL: "gs://gattebeer.appspot.com/beer/\(newBeerRef.key).jpg")
            if originalImage != nil {
                let imageData = UIImageJPEGRepresentation(originalImage!, 0.01)
                storageRef.put(imageData!, metadata: nil) { metadata, error in
                    if error == nil {
                        
                    } else {
                        print(error.debugDescription)
                    }
                }
            }
        }
    }
    
    @IBAction func pictureButtonPressed() {
        imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let alertController = UIAlertController(title: "Select option", message: "", preferredStyle: .actionSheet)
        let photoLibraryAction = UIAlertAction(title: "Library", style: .default) { action in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}


extension NewBeerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = originalImage
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}
