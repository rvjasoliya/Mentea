//
//  RightChatFileCell.swift
//  T-Notebook
//
//  Created by Apple on 27/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class RightChatFileCell: UITableViewCell {
    
    @IBOutlet weak var imgFileType: UIImageView!
    
    @IBOutlet weak var lblDate: UILabel!
    
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
