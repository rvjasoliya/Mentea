//
//  SuggestedMenteeProfileVC.swift
//  Mentea
//
//  Created by apple on 30/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//
import UIKit
import FirebaseDatabase
import Firebase

class SuggestedMenteeProfileVC: UIViewController {

    var isFrom = ""
    var selectedUserId = ""
    
    
    @IBOutlet weak var imgUser: UIImageView!
    
     @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblAge: UILabel!
    
    @IBOutlet weak var lblAbout: UILabel!
    
    @IBOutlet weak var lblSchoolName: UILabel!
    
    @IBOutlet weak var lblFeildofStudy: UILabel!
    
    @IBOutlet weak var lblObjective: UILabel!
    
    @IBOutlet weak var lblShortTerm: UILabel!
    
    @IBOutlet weak var lblLongTerm: UILabel!
    
    @IBOutlet weak var lblHobbies: UILabel!
    
    @IBOutlet weak var lblQualites: UILabel!
    
    @IBOutlet weak var genderlabel: UILabel!
    @IBOutlet weak var gender: UILabel!
    
    var ref: DatabaseReference!
    var value:NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        print(self.selectedUserId)
   
    getUserDetail()
        
    }
    
        func getUserDetail() {
            //if let id = Helper.getPREF("userId") {
                ref.child("users").child(selectedUserId).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    self.value = snapshot.value as? NSDictionary
                    //UserModel
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
                    if let field = self.value?["feild_of_study"] as? String {
                        self.lblFeildofStudy.text = field.firstCharacterUpperCase()
                    }
                    if let long = self.value?["longterm"] as? String {
                        self.lblLongTerm.text = long.firstCharacterUpperCase()
                    }
                    if let short = self.value?["shortterm"] as? String {
                        print(short)
                        self.lblShortTerm.text = short.firstCharacterUpperCase()
                    }
                    
                    
                    if let objective = self.value?["objective"] as? String{
                        self.lblObjective.text = objective.firstCharacterUpperCase()
                    }
    //                if let memberdo = self.value?["memberdo"] as? String {
    //                    self.lblInterestSkill.text = memberdo.firstCharacterUpperCase()
    //                }
                    if let memberdo = self.value?["memberdo"] as? String {
                        self.lblQualites.text = memberdo.firstCharacterUpperCase()
                        print(memberdo)
                    }
                    if let hobbies = self.value?["hobbies"] as? String {
                        self.lblHobbies.text = hobbies.firstCharacterUpperCase()
                    }
                    if let school = self.value?["school"] as? String{
//                        self.lblSchoolName.text = school.firstCharacterUpperCase()
                    }
                    
                    if let birthday = self.value?["birthday"] as? String{
                        self.lblAge.text = birthday
                    }
                    
                    if let about = self.value?["about"] as? String{
                        self.lblAbout.text = about
                    }
                    if let gender = self.value?["userGender"] as? String{
                        self.genderlabel.text = gender
                    }
                    
                    if let image = self.value?["image"] as? String{
                        if let url = URL(string: image) {
                            self.imgUser.sd_setImage(with: url, completed: nil)
                            //self.imgUser.roundedImage()
                        }
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            }

    


}
