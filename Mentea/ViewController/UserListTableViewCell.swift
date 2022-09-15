//
//  UserListTableViewCell.swift
//  Mentea
//
//  Created by Apple on 23/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
