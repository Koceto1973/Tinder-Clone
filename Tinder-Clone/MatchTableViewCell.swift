//
//  MyTableViewCell.swift
//  Tinder-Clone
//
//  Created by K.K. on 2.11.18.
//  Copyright © 2018 K.K. All rights reserved.
//

import UIKit
import Parse

class MatchTableViewCell: UITableViewCell, UITextFieldDelegate {

    // variables
    var recipientObjectId = ""
    
    // Outlets
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.messageTextField.delegate = self
        
        // keyboard dismiss
        let tapper = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        self.contentView.addGestureRecognizer(tapper)
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        let message = PFObject(className: "Message")
        
        message["sender"] = PFUser.current()?.objectId
        message["recipient"] = recipientObjectId
        message["content"] = messageTextField.text
        message.saveInBackground()
        
        messageTextField.text = ""
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // text fields keybord management
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        messageTextField.resignFirstResponder()
    }
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        messageTextField.resignFirstResponder()
        return true
    }
}
