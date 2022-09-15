//
//  ProfileMenteeViewController.swift
//  Mentea
//
//  Created by iMac on 16/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseDatabase
import Firebase

class ProfileMenteeViewController: UIViewController {
    
    var isFrom = ""
    var selectedUserId = ""
    
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
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblInterestSkill: UILabel!
    
    var ref: DatabaseReference!
    var value:NSDictionary?
    
    /*var userModel : UserModel! {
    didSet{
        
        lblName.text = userModel.name ?? ""
        lblSchool.text = userModel.school ?? ""
        lblFeild.text = userModel.feild_of_study ?? ""
        lblLong.text = userModel.longterm ?? ""
        lblShort.text = userModel.shortterm ?? ""
        lblInterestSkill.text = userModel.hobbies ?? ""
        lbHopbbies.text = userModel.hobbies ?? ""
        lblQualites.text = userModel.kindofMember ?? ""
                  
                      
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
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()
      
        ref = Database.database().reference()
        self.title = "Profile"
        
        //self.title = "Profile"
        // Do any additional setup after loading the view.
        //        imgUser.image =
        if isFrom == "userList" {
            getUserDetail1()
            print(selectedUserId)
        }else{
            getUserDetail()
              setRightBarButton()
        }
    }
    
    func getUserDetail1() {
            ref.child("users").child(selectedUserId).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                self.value = snapshot.value as? NSDictionary
                print(self.value)
                //UserModel
                if let currentCity = self.value?["currentCity"] as? String{
                    self.lblcity.text = currentCity
                }
                if let firstName = self.value?["firstName"] as? String {
                              if let lastName = self.value?["lastName"] as? String{
                                  self.lblName.text = firstName.uppercased() + " " + lastName.uppercased()
                                  }else{
                                  self.lblName.text = firstName.uppercased()
                                  }
                              }
//                if let name = self.value?["name"] as? String {
//                    self.lblName.text = name.firstCharacterUpperCase()
//                }
                if let field = self.value?["feild_of_study"] as? String {
                    self.lblFeild.text = field.firstCharacterUpperCase()
                }
                if let long = self.value?["longterm"] as? String {
                    self.lblLong.text = long.firstCharacterUpperCase()
                }
                if let short = self.value?["shortterm"] as? String {
                    self.lblShort.text = short.firstCharacterUpperCase()
                }
                if let memberdo = self.value?["memberdo"] as? String {
                    self.lblInterestSkill.text = memberdo.firstCharacterUpperCase()
                }
                if let kindofMember = self.value?["kindofMember"] as? String {
                    self.lblQualites.text = kindofMember.firstCharacterUpperCase()
                }
                if let hobbies = self.value?["hobbies"] as? String {
                    self.lbHopbbies.text = hobbies.firstCharacterUpperCase()
                }
                if let school = self.value?["school"] as? String{
                    self.lblSchool.text = school.firstCharacterUpperCase()
                }
                if let image = self.value?["image"] as? String{
                    if let url = URL(string: image) {
                        self.imgUser.sd_setImage(with: url, completed: nil)
                        self.imgUser.roundedImage()
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        
    }
    
    func getUserDetail() {
        if let id = Helper.getPREF("userId") {
            ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                self.value = snapshot.value as? NSDictionary
                //UserModel
                if let currentCity = self.value?["currentCity"] as? String{
                    self.lblcity.text = currentCity
                }
                if let name = self.value?["name"] as? String {
                    self.lblName.text = name.firstCharacterUpperCase()
                }
                if let field = self.value?["feild_of_study"] as? String {
                    self.lblFeild.text = field.firstCharacterUpperCase()
                }
                if let long = self.value?["longterm"] as? String {
                    self.lblLong.text = long.firstCharacterUpperCase()
                }
                if let short = self.value?["shortterm"] as? String {
                    self.lblShort.text = short.firstCharacterUpperCase()
                }
                if let memberdo = self.value?["memberdo"] as? String {
                    self.lblInterestSkill.text = memberdo.firstCharacterUpperCase()
                }
                if let kindofMember = self.value?["kindofMember"] as? String {
                    self.lblQualites.text = kindofMember.firstCharacterUpperCase()
                }
                if let hobbies = self.value?["hobbies"] as? String {
                    self.lbHopbbies.text = hobbies.firstCharacterUpperCase()
                }
                if let school = self.value?["school"] as? String{
                    self.lblSchool.text = school.firstCharacterUpperCase()
                }
                
                if let email = self.value?["email"] as? String{
                    self.lblEmail.text = email
                }
                
                if let image = self.value?["image"] as? String{
                    if let url = URL(string: image) {
                        self.imgUser.sd_setImage(with: url, completed: nil)
                        self.imgUser.roundedImage()
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    func setRightBarButton() {
         let timerBarButton = UIBarButtonItem.init(title: "Edit", style: .plain, target: self, action: #selector(editButtonAction(_:)))
         self.navigationItem.rightBarButtonItems = [timerBarButton]
         
     }
     
     @IBAction func editButtonAction(_ sender: UIBarButtonItem) {
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupStep2MenteeViewController") as! SignupStep2MenteeViewController
        newVC.isUpdate = true
        newVC.menteeData = value
        self.navigationController?.pushViewController(newVC, animated: true)
     }
}
