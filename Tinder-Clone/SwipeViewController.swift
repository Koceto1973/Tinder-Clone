//
//  ViewController.swift
//  Tinder-Clone
//
//  Created by K.K. on 29.10.18.
//  Copyright © 2018 K.K. All rights reserved.
//

import UIKit
import Parse

class SwipeViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var matchImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    // variables
    var displayedMatchId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        matchImageView.addGestureRecognizer(gesture)
        
        infoLabel.text = ""
        updateImage()
    }
    
    func updateImage() {
        if let query = PFUser.query() { // specific query over user objects, not generic one PFQuery()
            // current user interest here
            // current man interested in men also pops up?
            // current woman interested in women also pops up?
            if let isInterestedInWomen = PFUser.current()?["isInterestedInWomen"] {
                query.whereKey("isFemale", equalTo: isInterestedInWomen)
            }
            // other users interest here
            if let isFemale = PFUser.current()?["isFemale"] {
                query.whereKey("isInterestedInWomen", equalTo: isFemale)
            }
            
            var ignoredIds: [String] = []
            if let likedIds = PFUser.current()?["liked"] as? [String]{
                ignoredIds += likedIds
            }
            if let dislikedIds = PFUser.current()?["disliked"] as? [String]{
                ignoredIds += dislikedIds
            }
            query.whereKey("objectId", notContainedIn: ignoredIds)
            
            // we want one user at a time
            query.limit = 1
            query.findObjectsInBackground { (pfObjects, error ) in
                if let objects = pfObjects {
                    if objects.count == 0 {
                        self.matchImageView.image = UIImage(named: "002-user-1")
                        self.infoLabel.text = "Users database checked completely."
                        return
                    }
                    for object in objects {
                        if let user = object as? PFUser {
                            if let imageFile = user["photo"] as? PFFile {
                                imageFile.getDataInBackground(block: { (data, error) in
                                    if let imageData = data {
                                        self.matchImageView.image = UIImage(data: imageData )
                                        if let objectId = object.objectId {
                                            self.displayedMatchId = objectId
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        // measure the gesture
        let labelPoint = gestureRecognizer.translation(in: view)
        
        // reposition matchImageView
        matchImageView.center = CGPoint(x: view.bounds.width / 2 + labelPoint.x, y: view.bounds.height / 2 + labelPoint.y)
        let xFromCenter = view.bounds.width / 2 - matchImageView.center.x
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(100 / abs(xFromCenter), 1)
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        matchImageView.transform = scaledAndRotated
        
        // on gesture completion
        if gestureRecognizer.state == .ended {
            var attitude = ""
            // take note what gesture was
            if matchImageView.center.x < (view.bounds.width / 2 - 100) {
                attitude = "disliked"
                //print("Not Interested")
            }
            if matchImageView.center.x > (view.bounds.width / 2 + 100) {
                attitude = "liked"
                //print("Interested")
            }
            
            // swipe done and id taken
            if attitude != "" && displayedMatchId != "" {
                PFUser.current()?.addUniqueObject(displayedMatchId, forKey: attitude)
                // update server
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if success {
                        self.updateImage()
                    }
                })
            }
            
            // bring label back to initial state
            rotation = CGAffineTransform(rotationAngle: 0)
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            matchImageView.transform = scaledAndRotated
            matchImageView.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        }
    }
    
    @IBAction func LogOutPressed(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "toEntry", sender: nil)
    }
    
}

