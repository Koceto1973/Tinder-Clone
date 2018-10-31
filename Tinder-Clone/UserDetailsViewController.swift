//
//  UserDetailsViewController.swift
//  Tinder-Clone
//
//  Created by K.K. on 30.10.18.
//  Copyright © 2018 K.K. All rights reserved.
//

import UIKit
import Parse

class UserDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    // Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userGenderSwitch: UISwitch!
    @IBOutlet weak var interestedGenderSwitch: UISwitch!
    @IBOutlet weak var infoLabel: UILabel!    

    override func viewDidLoad() {
        super.viewDidLoad()

        infoLabel.isHidden  = true
        infoLabel.text = ""
        
        if let isFemale = PFUser.current()?["isFemale"] as? Bool {
            userGenderSwitch.setOn(isFemale, animated: false)
        }
        if let isFemale = PFUser.current()?["isInterestedInWomen"] as? Bool {
            interestedGenderSwitch.setOn(isFemale, animated: false)
        }
        if let photo = PFUser.current()?["photo"] as? PFFile {
            photo.getDataInBackground { (data, error) in
                if let imageAsData = data {
                    if let image = UIImage(data: imageAsData) {
                        self.profileImageView.image = image
                    }
                }
            }
        }
        // createWomen()
    }

    @IBAction func updateProfileImageButtonPressed(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePickerController.allowsEditing = false
        
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = image
        } else { print("There was a problem getting the image")  }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateProfileInfoButtonPressed(_ sender: Any) {
        PFUser.current()?["isFemale"] = userGenderSwitch.isOn
        PFUser.current()?["isInterestedInWomen"] = interestedGenderSwitch.isOn
        
        if let image = profileImageView.image {
            if let imageData = UIImagePNGRepresentation(image) {
                PFUser.current()?["photo"] = PFFile(name: "profile.png", data: imageData)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if error == nil {
                        debugPrint("user data update ok")
                    } else { // detailed error processing
                        var errorInfo = "user data update fail"
                        if let nsError = error as NSError? {
                            if let detailedErrorInfo = nsError.userInfo["error"] as? String {
                                errorInfo = detailedErrorInfo
                            }
                        }
                        debugPrint(errorInfo)
                        self.infoLabel.isHidden = false
                        self.infoLabel.text = errorInfo
                    }
                })
            }
        }
    }
    
    // run once to womanize the app
    func createWomen() {
        let imageUrls = ["https://upload.wikimedia.org/wikipedia/en/7/76/Edna_Krabappel.png","https://static.comicvine.com/uploads/scale_small/0/40/235856-101359-ruth-powers.png","http://vignette3.wikia.nocookie.net/simpsons/images/f/fb/Serious-sam--cover.jpg/revision/latest?cb=20131109214146","https://s-media-cache-ak0.pinimg.com/736x/e4/42/5a/e4425aad73f01d36ace4c86c3156dcdc.jpg","http://www.simpsoncrazy.com/content/pictures/onetimers/LurleenLumpkin.gif","https://vignette2.wikia.nocookie.net/simpsons/images/b/bc/Becky.gif/revision/latest?cb=20071213001352","http://vignette3.wikia.nocookie.net/simpsons/images/b/b0/Woman_resembling_Homer.png/revision/latest?cb=20141026204206"]
        
        var counter = 0
        
        for imageUrl in imageUrls {
            counter += 1
            if let url = URL(string: imageUrl) {
                if let data = try? Data(contentsOf: url) {
                    let imageFile = PFFile(name: "photo.png", data: data)
                    
                    let user = PFUser()
                    user["photo"] = imageFile
                    user.username = String("user\(counter)")
                    user.password = "123456"
                    user["isFemale"] = true
                    user["isInterestedInWomen"] = false
                    
                    user.signUpInBackground(block: { (success, error) in
                        if success {
                            print("Women User \(String(describing: user.username)) created!")
                        }
                    })
                }
            }
        }
    }
    
}
