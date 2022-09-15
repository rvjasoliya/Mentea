//
//  ProfileMentorViewController.swift
//  Mentea
//
//  Created by Apple on 23/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import SDWebImage

class ProfileMentorViewController: UIViewController {
    
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblSchool: UILabel!
    @IBOutlet weak var lblOccupation: UILabel!
    @IBOutlet weak var lblcity: UILabel!
    @IBOutlet weak var lblQualites: UILabel!
    @IBOutlet weak var lbHopbbies: UILabel!
    @IBOutlet weak var lblkey_accomplishment: UILabel!
    @IBOutlet weak var lblAreaOfExpertise: UILabel!
    
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    var ref: DatabaseReference!
    var value:NSDictionary?
    var isFrom = ""
    var selectedUserId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        ref = Database.database().reference()
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
    
    
    @IBAction func actionBtn1(_ sender: Any) {
        
    }
    
    @IBAction func actionBtn2(_ sender: Any) {
        
    }
    
    func getUserDetail1() {
        
            ref.child("users").child(selectedUserId).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                self.value = snapshot.value as? NSDictionary
                //UserModel
                if let areaOfExpertise = self.value?["areaOfExpertise"] as? String{
                    self.lblAreaOfExpertise.text = areaOfExpertise.firstCharacterUpperCase()
                    self.lblOccupation.text = areaOfExpertise.firstCharacterUpperCase()
                }
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
                if let key_accomplishment = self.value?["key_accomplishment"] as? String{
                    self.lblkey_accomplishment.text = key_accomplishment.firstCharacterUpperCase()
                }
                if let kindofMember = self.value?["kindofMember"] as? String{
                    self.lblQualites.text = kindofMember.firstCharacterUpperCase()
                }
                if let hobbies = self.value?["fun"] as? String{
                    self.lbHopbbies.text = hobbies.firstCharacterUpperCase()
                }
                if let school = self.value?["school"] as? String{
                    self.lblSchool.text = school.firstCharacterUpperCase()
                }
                if let image = self.value?["image"] as? String{
                    if let url = URL(string: image) {
                        self.imgUser.sd_setImage(with: url, completed: nil)
                    }
                }
                // ...
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
                if let areaOfExpertise = self.value?["areaOfExpertise"] as? String{
                    self.lblAreaOfExpertise.text = areaOfExpertise.firstCharacterUpperCase()
                    self.lblOccupation.text = areaOfExpertise.firstCharacterUpperCase()
                }
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
                if let key_accomplishment = self.value?["key_accomplishment"] as? String{
                    self.lblkey_accomplishment.text = key_accomplishment.firstCharacterUpperCase()
                }
                if let kindofMember = self.value?["kindofMember"] as? String{
                    self.lblQualites.text = kindofMember.firstCharacterUpperCase()
                }
                if let hobbies = self.value?["fun"] as? String{
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
                    }
                }
                // ...
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
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupStep2MrViewController") as! SignupStep2MrViewController
        newVC.isUpdate = true
        newVC.mentorData = value
        self.navigationController?.pushViewController(newVC, animated: true)
     }
    
}
