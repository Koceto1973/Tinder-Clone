//
//  ViewController.swift
//  Tinder-Clone
//
//  Created by K.K. on 29.10.18.
//  Copyright © 2018 K.K. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let testObject = PFObject(className: "test")
        testObject["test"] = "test"
        testObject.saveInBackground { (success, error) in
            if success {
                print("test ok")
            } else {
                print("test failed")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

