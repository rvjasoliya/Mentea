//
//  RightChatImageCell.swift
//  T-Notebook
//
//  Created by Apple on 25/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class RightChatImageCell: UITableViewCell {

    
    @IBOutlet weak var imgRight: UIImageView!
    
    @IBOutlet weak var lblDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
