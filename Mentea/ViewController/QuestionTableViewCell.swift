//
//  QuestionTableViewCell.swift
//  Mentea
//
//  Created by Apple on 18/08/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblQuestion: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
