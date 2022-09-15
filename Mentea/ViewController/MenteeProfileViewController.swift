//
//  MenteeProfileViewController.swift
//  Mentea
//
//  Created by Apple on 20/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import DropDown


class MenteeProfileViewController: UIViewController {
    
    var isFrom = ""
      var selectedUserId = ""
    
    var menuDropDown = DropDown()
    
    @IBOutlet weak var imgEdit: UIImageView!
    
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
    
    
    var ref: DatabaseReference!
       var value:NSDictionary?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        setRightBarButton()
        self.title = "Profile"
         ref = Database.database().reference()
        imgEdit.isUserInteractionEnabled = true
        imgEdit.isHidden = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction(sender:)))
        self.imgEdit.addGestureRecognizer(gesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserDetail()
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
           
           if let editprofile = storyBoard.instantiateViewController(withIdentifier: "MenteeEditProfileViewController") as? MenteeEditProfileViewController{
               self.navigationController?.pushViewController(editprofile, animated: true)
               //self.present(signup, animated:true, completion:nil)
           }
       }
    
    func getUserDetail() {
        if let id = Helper.getPREF("userId") {
            ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
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
                }
                if let hobbies = self.value?["hobbies"] as? String {
                    self.lblHobbies.text = hobbies.firstCharacterUpperCase()
                }
                if let school = self.value?["school"] as? String{
                    self.lblSchoolName.text = school.firstCharacterUpperCase()
                }
                
                if let birthday = self.value?["birthday"] as? String{
                    self.lblAge.text = birthday
                }
                
                if let about = self.value?["about"] as? String{
                    self.lblAbout.text = about
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
    
    func setRightBarButton() {
          let timerBarButton = UIBarButtonItem.init(image: UIImage.init(named: "edit_white"), style: .plain, target: self, action: #selector(settingClicked(_:)))
          timerBarButton.width=30
          self.navigationItem.rightBarButtonItems = [timerBarButton]
          menuDropDown.bottomOffset = CGPoint(x: 0, y:44)
      }
       
       @IBAction func settingClicked(_ sender: UIBarButtonItem) {
           let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
           
           if let editprofile = storyBoard.instantiateViewController(withIdentifier: "MenteeEditProfileViewController") as? MenteeEditProfileViewController{
               self.navigationController?.pushViewController(editprofile, animated: true)
               //self.present(signup, animated:true, completion:nil)
           }
       }
    

}
