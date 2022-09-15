//
//  SuggestedMentorProfileVC.swift
//  Mentea
//
//  Created by apple on 30/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//
import UIKit
import FirebaseDatabase

class SuggestedMentorProfileVC: UIViewController {

    var ref: DatabaseReference!
     
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
     
    @IBOutlet weak var noOfmentee: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var gender: UILabel!
    var value:NSDictionary?
     var isFrom = ""
     var selectedUserId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
               
               ref = Database.database().reference()
              
               getUserDetail()
    }
    
        func getUserDetail() {
               if let id = Helper.getPREF("userId") {
                   ref.child("users").child(selectedUserId).observeSingleEvent(of: .value, with: { (snapshot) in
                       // Get user value
                       self.value = snapshot.value as? NSDictionary
                       //UserModel
                    print(self.value)
                       if let areaOfExpertise = self.value?["areaOfExpertise"] as? String{
                           self.lblExpertise.text = areaOfExpertise.firstCharacterUpperCase()
                           
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
                    
//                       if let name = self.value?["name"] as? String {
//                           self.lblName.text = name.firstCharacterUpperCase()
//                       }
                       if let key_accomplishment = self.value?["key_accomplishment"] as? String{
                           self.lblAchievements.text = key_accomplishment.firstCharacterUpperCase()
                       }
                    
                    if let occupation = self.value?["occupation"] as? String{
                        self.lblProfessor.text = occupation
                    }

                       if let hobbies = self.value?["fun"] as? String{
                           self.lblHobbies.text = hobbies.firstCharacterUpperCase()
                       }
                       if let school = self.value?["school"] as? String{
                            self.lblOrganization.text = school.firstCharacterUpperCase()
                       }
//                    if let no_of_mentee = self.value?["no_of_mentee"] as? String{
//                    self.noOfmentee.text = no_of_mentee
//                    }
                      if let socialGroup = self.value?["socialgroup"] as? String{
                                      self.lblSocialGroup.text = socialGroup
                                  }

                       
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
                    if let gender = self.value?["userGender"] as? String{
                        self.genderLabel.text = gender
                    }
                    
                   }) { (error) in
                       print(error.localizedDescription)
                   }
               }
           }
    



}
