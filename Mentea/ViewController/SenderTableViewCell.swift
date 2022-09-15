//
//  SenderTableViewCell.swift
//  T-Notebook
//
//  Created by Apple on 17/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblSMessage: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
