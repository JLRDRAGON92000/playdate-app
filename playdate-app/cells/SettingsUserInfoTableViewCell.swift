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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
