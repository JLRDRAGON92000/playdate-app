//
//  SettingsUserInfoTableViewCell.swift
//  playdate-app
//
//  Created by Jared Rankin on 2020-04-01.
//  Copyright © 2020 Jared Rankin. All rights reserved.
//

import UIKit

class SettingsUserInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        displayNameLabel.font = UIFont(name: "Gibson-Bold", size: 24)
        emailLabel.font = UIFont(name: "Gibson-Regular", size: 20)
        
    }
}
