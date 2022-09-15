//
//  ProfileNewViewController.swift
//  Mentea
//
//  Created by Apple on 15/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import DropDown

class ProfileNewViewController: UIViewController {

    
    @IBOutlet weak var imgEdit: UIImageView!
    
   var ref: DatabaseReference!
   var menuDropDown = DropDown()
    
   
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lbAge: UILabel!
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblOrganization: UILabel!
    @IBOutlet weak var lblProfessor: UILabel!
    @IBOutlet weak var lblExpertise: UILabel!
    @IBOutlet weak var lblAchievements: UILabel!
    @IBOutlet weak var lblHobbies: UILabel!
    @IBOutlet weak var lblSocialGroup: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var noofmentee: UILabel!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var value:NSDictionary?
    var isFrom = ""
    var selectedUserId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setRightBarButton()
        ref = Database.database().reference()
        self.title = "Profile"
        menuButton.target = self.revealViewController()
                   menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
                   self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//        menuButton.target = self.revealViewController()
//        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        imgEdit.isUserInteractionEnabled = true
        imgEdit.isHidden = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction(sender:)))
        self.imgEdit.addGestureRecognizer(gesture)
       
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
          getUserDetail()
      }
    
    
    func getUserDetail() {
           if let id = Helper.getPREF("userId") {
               ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                   // Get user value
                   self.value = snapshot.value as? NSDictionary
                   //UserModel
                print(self.value)
                   if let areaOfExpertise = self.value?["areaOfExpertise"] as? String{
                       self.lblExpertise.text = areaOfExpertise.firstCharacterUpperCase()
                       
                   }
                if let no_of_mentee = self.value?["no_of_mentee"] as? String{
                    self.noofmentee.text = no_of_mentee
                 }
                   if let currentCity = self.value?["currentCity"] as? String{
                       self.lblLocation.text = currentCity
                   }
                
                if let firstName = self.value?["firstName"] as? String {
                    if let lastName = self.value?["lastName"] as? String{
                            self.lblName.text = firstName.uppercased() + " " + lastName.uppercased()
                        }else{
                            self.lblName.text = firstName.uppercased()
                        }
                    }
                
//                   if let name = self.value?["name"] as? String {
//                       self.lblName.text = name.firstCharacterUpperCase()
//                   }
                   if let key_accomplishment = self.value?["key_accomplishment"] as? String{
                       self.lblAchievements.text = key_accomplishment.firstCharacterUpperCase()
                   }
                
                if let occupation = self.value?["occupation"] as? String{
                    self.lblProfessor.text = occupation
                }
//                   if let kindofMember = self.value?["kindofMember"] as? String{
//                       self.lblQualites.text = kindofMember.firstCharacterUpperCase()
//                   }
                   if let hobbies = self.value?["fun"] as? String{
                       self.lblHobbies.text = hobbies.firstCharacterUpperCase()
                   }
                   if let school = self.value?["school"] as? String{
                        self.lblOrganization.text = school.firstCharacterUpperCase()
                   }
                  if let socialGroup = self.value?["socialgroup"] as? String{
                                  self.lblSocialGroup.text = socialGroup
                              }
//                   if let email = self.value?["email"] as? String{
//                       self.lblEmail.text = email
//                   }
                   
                   if let image = self.value?["image"] as? String{
                       if let url = URL(string: image) {
                           self.imgUser.sd_setImage(with: url, completed: nil)
                       }
                   }
                
                if let birthday = self.value?["birthday"] as? String{
                    self.lbAge.text = birthday
                }
                
                if let about = self.value?["about"] as? String{
                    self.lblAbout.text = about
                }
                
                   // ...
               }) { (error) in
                   print(error.localizedDescription)
               }
           }
       }
    
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if let editprofile = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController{
            self.navigationController?.pushViewController(editprofile, animated: true)
            //self.present(signup, animated:true, completion:nil)
        }
    }
    

   func setRightBarButton() {
       let timerBarButton = UIBarButtonItem.init(image: UIImage.init(named: "edit_white"), style: .plain, target: self, action: #selector(settingClicked(_:)))
       timerBarButton.width=30
       self.navigationItem.rightBarButtonItems = [timerBarButton]
       menuDropDown.bottomOffset = CGPoint(x: 0, y:44)
   }
    
    @IBAction func settingClicked(_ sender: UIBarButtonItem) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
               
               if let editprofile = storyBoard.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController{
                   self.navigationController?.pushViewController(editprofile, animated: true)
               }
    }


}
