//
//  CommentListCell.swift
//  Mentea
//
//  Created by Rv on 12/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class CommentListCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

         
    }

}
