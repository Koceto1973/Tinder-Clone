//
//  MyTableViewCell.swift
//  Tinder-Clone
//
//  Created by K.K. on 2.11.18.
//  Copyright © 2018 K.K. All rights reserved.
//

import UIKit
import Parse

class MatchTableViewCell: UITableViewCell {

    // variables
    var recipientObjectId = ""
    
    // Outlets
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func sendTapped(_ sender: Any) {
        let message = PFObject(className: "Message")
        
        message["sender"] = PFUser.current()?.objectId
        message["recipient"] = recipientObjectId
        message["content"] = messageTextField.text
        
        message.saveInBackground()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
