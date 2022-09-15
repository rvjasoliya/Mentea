//
//  MenteeView.swift
//  Mentea
//
//  Created by Apple on 29/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage

class ManteeView : UIView {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSchool: UILabel!
    @IBOutlet weak var lblFeild: UILabel!
    @IBOutlet weak var lblcity: UILabel!
    @IBOutlet weak var lblLong: UILabel!
    @IBOutlet weak var lblShort: UILabel!
    @IBOutlet weak var lblQualites: UILabel!
    @IBOutlet weak var lbHopbbies: UILabel!
    @IBOutlet weak var lblInterestSkill: UILabel!
    
    
    var userModel : UserModel! {
    didSet{
        
        lblName.text = userModel.name.firstCharacterUpperCase() ?? ""
        lblSchool.text = userModel.school.firstCharacterUpperCase() ?? ""
        lblFeild.text = userModel.feild_of_study.firstCharacterUpperCase() ?? ""
        lblLong.text = userModel.longterm.firstCharacterUpperCase() ?? ""
        lblShort.text = userModel.shortterm.firstCharacterUpperCase() ?? ""
        lblInterestSkill.text = userModel.hobbies.firstCharacterUpperCase() ?? ""
        lblcity.text = userModel.currentCity ?? ""
        lbHopbbies.text = userModel.hobbies.firstCharacterUpperCase() ?? ""
        lblQualites.text = userModel.kindofMember.firstCharacterUpperCase() ?? ""
                  
                      
                      if let images = imgUser {
                      let block: SDExternalCompletionBlock? = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) -> Void in
                                                         //print(image)
                              if (image == nil) {
                                  images.image = #imageLiteral(resourceName: "ic_avatar")
                                  return
                              }
                          }
                                                     
                          if let url = URL(string: userModel.image) {
                              images.roundedImage()
                              images.sd_setImage(with: url, completed: block)
                              //cell.imgUser.maskCircle(anyImage: images)
                          }
                      }
                      
        
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
            commonInit()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            commonInit()
        }
        
        func commonInit() {
            Bundle.main.loadNibNamed("ManteeView", owner: self, options: nil)
            contentView.fixInView(self)
        }
    
}
