//
//  BlogTableViewCell.swift
//  Mentea
//
//  Created by Apple on 23/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import GrowingTextView

class BlogTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var flagImage: UIImageView!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var likeImg: UIImageView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var flagButton: UIButton!
    
    var buttonLike : (()->())!
    var buttonComment : (()->())!
    var buttonShare : (()->())!
    var buttonReport : (()->())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func actionReport(_ sender: Any) {
        buttonReport()
    }
    
    @IBAction func actionLike(_ sender: Any) {
        buttonLike()
    }
    
    @IBAction func actionComment(_ sender: Any) {
        buttonComment()
    }
    
    @IBAction func actionShare(_ sender: Any) {
        buttonShare()
    }
    
}
