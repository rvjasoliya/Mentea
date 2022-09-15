//
//  CustomView.swift
//  TinderSwipeView_Example
//
//  Created by Nick on 29/05/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import SDWebImage

class CustomView: UIView {
        
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblAgeCity: UILabel!
    
    @IBOutlet weak var lblOccupation: UILabel!
        
    @IBOutlet weak var lblHobbies: UILabel!
    
    @IBOutlet weak var lblAccomplishments: UILabel!
    
    @IBOutlet weak var lblSociety: UILabel!
    
    @IBOutlet weak var btnViewMore: UIButton!
  
    
    @IBOutlet weak var genderLabel: UILabel!
    
    
      var suggested_userId = ""
    
//    @IBOutlet weak var imgUser: UIImageView!
//    @IBOutlet weak var lblName: UILabel!
//    @IBOutlet weak var lblSchool: UILabel!
//    @IBOutlet weak var lblOccupation: UILabel!
//    @IBOutlet weak var lblQuilties: UILabel!
//    @IBOutlet weak var lblHobbies: UILabel!
//    @IBOutlet weak var lblCity: UILabel!
//    @IBOutlet weak var lblAreas: UILabel!
//    @IBOutlet weak var lblSociety: UILabel!
    
    
    
    var userModel : UserModel! {
        didSet{
            
            lblName.text = userModel.name.firstCharacterUpperCase() ?? ""
            lblAgeCity.text = userModel.currentCity ?? ""
            genderLabel.text = userModel.userGender?.firstCharacterUpperCase() ?? ""
            print("\(userModel.userType) hello")
            
            if(userModel.userType == "Mentee")
            {
                print("\(userModel.userType) hello")
                lblHobbies.text = "Loves \(userModel.hobbies.firstCharacterUpperCase() ?? "")"
                lblOccupation.text = "Studied in \(userModel.school.firstCharacterUpperCase() ?? "")"
                lblAccomplishments.text = "My objective is \(userModel.objective.firstCharacterUpperCase() ?? "")"
            }
            else{
                lblHobbies.text = "Loves \(userModel.fun.firstCharacterUpperCase() ?? "")"
                lblOccupation.text = "Work as \(userModel.occupation.firstCharacterUpperCase() ?? "")"
                lblAccomplishments.text = userModel.key_accomplishment.firstCharacterUpperCase() ?? ""
               
            }
            
            
            //lblSociety.text = "Member of \()"
            
//            lblName.text = userModel.name.firstCharacterUpperCase() ?? ""
//            lblSchool.text = userModel.school.firstCharacterUpperCase() ?? ""
//            lblOccupation.text = userModel.occupation.firstCharacterUpperCase() ?? ""
//            lblQuilties.text = userModel.kindofMember.firstCharacterUpperCase() ?? ""
//            lblHobbies.text = userModel.fun.firstCharacterUpperCase() ?? ""
//            lblCity.text = userModel.currentCity ?? ""
//            lblAreas.text = userModel.key_accomplishment.firstCharacterUpperCase() ?? ""
//            lblSociety.text = userModel.areaOfExpertise?.firstCharacterUpperCase() ?? ""

                if let images = profileImage {
                let block: SDExternalCompletionBlock? = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) -> Void in
                                                   //print(image)
                        if (image == nil) {
                            images.image = #imageLiteral(resourceName: "ic_avatar")
                            return
                        }
                    }

                    if let url = URL(string: userModel.image) {
                        //images.roundedImage()
                        images.sd_setImage(with: url, completed: block)
                        //cell.imgUser.maskCircle(anyImage: images)
                    }
                }
                
            
//            self.labelText.attributedText = self.attributeStringForModel(userModel: userModel)
//            self.imageViewBackground.image = UIImage(named:String(Int(1 + arc4random() % (8 - 1))))
            
            self.btnViewMore.addTarget(self, action: #selector(checkAction(_:)), for: .touchUpInside)
            
        }
      
    }
    
      @IBAction func checkAction(_ sender : UIButton) {
        suggested_userId = userModel.userId ?? ""
        homeViewDelegate?.loadViewCon(userID : suggested_userId)
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
        Bundle.main.loadNibNamed(CustomView.className, owner: self, options: nil)
        contentView.fixInView(self)
        
//        imageViewProfile.contentMode = .scaleAspectFill
//        imageViewProfile.layer.cornerRadius = 30
//        imageViewProfile.clipsToBounds = true
        
    }
  

}

extension UIView{
    
    func fixInView(_ container: UIView!) -> Void{
        
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
    
    func reloadDataaa() {
         self.setNeedsDisplay()
     }

    
}


 
extension NSObject {
    
    class var className: String {
        return String(describing: self)
    }
}
