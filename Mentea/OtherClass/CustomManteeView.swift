//
//  CustomManteeView.swift
//  Mentea
//
//  Created by Apple on 28/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//


import UIKit

class CustomManteeView: UIView {
    
   @IBOutlet var contentView: UIView!
    
    
    var userModel : UserModel! {
        didSet{
//                lblName.text = userModel.name ?? ""
//                lblSchool.text = userModel.school ?? ""
//                lblOccupation.text = userModel.occupation ?? ""
//
//
//                    if let images = imgUser {
//                    let block: SDExternalCompletionBlock? = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) -> Void in
//                                                       //print(image)
//                            if (image == nil) {
//                                images.image = #imageLiteral(resourceName: "ic_avatar")
//                                return
//                            }
//                        }
//
//                        if let url = URL(string: userModel.image) {
//                            images.roundedImage()
//                            images.sd_setImage(with: url, completed: block)
//                            //cell.imgUser.maskCircle(anyImage: images)
//                        }
//                    }
                    
                
    //            self.labelText.attributedText = self.attributeStringForModel(userModel: userModel)
    //            self.imageViewBackground.image = UIImage(named:String(Int(1 + arc4random() % (8 - 1))))
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
            Bundle.main.loadNibNamed(CustomManteeView.className1, owner: self, options: nil)
            contentView.fixInView(self)
            
    //        imageViewProfile.contentMode = .scaleAspectFill
    //        imageViewProfile.layer.cornerRadius = 30
    //        imageViewProfile.clipsToBounds = true
            
        }
    
}
extension NSObject {
    
    class var className1: String {
        return String(describing: self)
    }
}
