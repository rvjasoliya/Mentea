//
//  MenuTableViewCell.swift
//  Mentea
//
//  Created by Apple on 15/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var imgLogo: UIImageView!
    
    @IBOutlet weak var lblText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
