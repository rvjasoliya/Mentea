//
//  PopViewController.swift
//  Mentea
//
//  Created by Apple on 27/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class PopViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    
    var userType = ""
    var value:NSDictionary?
    var ref:DatabaseReference!
    var question = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        userType = Helper.getPREF("userType") ?? ""
        print("userType \(self.userType)")
        self.checkIsProfleComplete()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return question.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as! QuestionTableViewCell
        
        if indexPath.row % 2 == 0{
            cell.mainView.backgroundColor = UIColor.init(named: "E8E8E8")
        }else{
            cell.mainView.backgroundColor = UIColor.init(named: "F0F0F0")
        }
        
        cell.lblNumber.text = "\(indexPath.row + 1)."
        cell.lblQuestion.text = question[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let storyboard : UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        if self.userType == "Mentee" {
            if self.question[indexPath.row] == "What's your name?"{
               if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee1ViewController") as? SignupMentee1ViewController{
                        mentee.isFrom = "profile"
                              
                            self.present(mentee, animated: true, completion: nil)
                }
            }
            if self.question[indexPath.row] == "Please select your gender."{
                if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee1ViewController") as? SignupMentee1ViewController{
                        mentee.isFrom = "profile"
                              
                            self.present(mentee, animated: true, completion: nil)
                }
            }
            if self.question[indexPath.row] == "What's your age?"{
                if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee1ViewController") as? SignupMentee1ViewController{
                        mentee.isFrom = "profile"
                              
                            self.present(mentee, animated: true, completion: nil)
                }
            }
            
            if self.question[indexPath.row] == "Write few words about yourself that describes you best."{
                if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee2ViewController") as? SignupMentee2ViewController{
                        mentee.isFrom = "profile"
                              
                            self.present(mentee, animated: true, completion: nil)
                }
            }
            if self.question[indexPath.row] == "In which educational institute do you study."{
                if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee2ViewController") as? SignupMentee2ViewController{
                        mentee.isFrom = "profile"
                              
                            self.present(mentee, animated: true, completion: nil)
                }
            }
            if self.question[indexPath.row] == "What's your feild of study?"{
                if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee2ViewController") as? SignupMentee2ViewController{
                        mentee.isFrom = "profile"
                              
                            self.present(mentee, animated: true, completion: nil)
                }
            }
            if self.question[indexPath.row] == "What is your short term goal?"{
                if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee3ViewController") as? SignupMentee3ViewController{
                        mentee.isFrom = "profile"
                              
                            self.present(mentee, animated: true, completion: nil)
                }
            }
            if self.question[indexPath.row] == "What is your long term goal?"{
                if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee3ViewController") as? SignupMentee3ViewController{
                        mentee.isFrom = "profile"
                              
                            self.present(mentee, animated: true, completion: nil)
                }
            }
            if self.question[indexPath.row] == "What is your objective?"{
                if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee3ViewController") as? SignupMentee3ViewController{
                        mentee.isFrom = "profile"
                              
                            self.present(mentee, animated: true, completion: nil)
                }
            }
            if self.question[indexPath.row] == "Which two words describes you best."{
                if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee4ViewController") as? SignupMentee4ViewController{
                        mentee.isFrom = "profile"
                              
                            self.present(mentee, animated: true, completion: nil)
                }
            }
            if self.question[indexPath.row] == "What a mentor can do for you?"{
                if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee4ViewController") as? SignupMentee4ViewController{
                        mentee.isFrom = "profile"
                              
                            self.present(mentee, animated: true, completion: nil)
                }
            }
            if self.question[indexPath.row] == "Upload your best pic here."{
                if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee5ViewController") as? SignupMentee5ViewController{
                        mentee.isFrom = "profile"
                              
                            self.present(mentee, animated: true, completion: nil)
                }
            }
            if self.question[indexPath.row] == "What do you do for fun?"{
                if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee5ViewController") as? SignupMentee5ViewController{
                        mentee.isFrom = "profile"
                        self.present(mentee, animated: true, completion: nil)
                }
            }
            
            
        }else{
            
            if self.question[indexPath.row] == "What's your name?" {
                
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor1VC") as?  SignUpMentor1VC{
                        mentor.isFrom = "profile"
                        self.present(mentor, animated: true, completion: nil)
                }
                
            }
            if self.question[indexPath.row] == "Please select your gender."{
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor1VC") as?  SignUpMentor1VC{
                                       mentor.isFrom = "profile"
                                       self.present(mentor, animated: true, completion: nil)
                               }
            }
            if self.question[indexPath.row] == "What's your age?"{
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor1VC") as?  SignUpMentor1VC{
                                       mentor.isFrom = "profile"
                                       self.present(mentor, animated: true, completion: nil)
                               }
            }
            
            if self.question[indexPath.row] == "Write few words about yourself that describes you best."{
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor2VC") as?  SignUpMentor2VC{
                                       mentor.isFrom = "profile"
                                       self.present(mentor, animated: true, completion: nil)
                               }
            }
            if self.question[indexPath.row] == "In which organization do you work."{
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor2VC") as?  SignUpMentor2VC{
                                                    mentor.isFrom = "profile"
                                                    self.present(mentor, animated: true, completion: nil)
                                            }
            }
            if self.question[indexPath.row] == "What's your job title?"{
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor2VC") as?  SignUpMentor2VC{
                                                    mentor.isFrom = "profile"
                                                    self.present(mentor, animated: true, completion: nil)
                                            }
            }
            if self.question[indexPath.row] == "What is your area of expertise?"{
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor2VC") as?  SignUpMentor2VC{
                                                    mentor.isFrom = "profile"
                                                    self.present(mentor, animated: true, completion: nil)
                                            }
            }
            if self.question[indexPath.row] == "Write few words about your accomplishment."{
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor3VC") as?  SignUpMentor3VC{
                                                    mentor.isFrom = "profile"
                                                    self.present(mentor, animated: true, completion: nil)
                                            }
            }
            if self.question[indexPath.row] == "What do you do for fun?"{
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor3VC") as?  SignUpMentor3VC{
                                                                   mentor.isFrom = "profile"
                                                                   self.present(mentor, animated: true, completion: nil)
                                                           }
            }
            if self.question[indexPath.row] == "Which two words describes you best."{
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor4VC") as?  SignUpMentor4VC{
                                                                   mentor.isFrom = "profile"
                                                                   self.present(mentor, animated: true, completion: nil)
                                                           }
            }
            if self.question[indexPath.row] == "What is your gender preference for mentees?"{
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor4VC") as?  SignUpMentor4VC{
                                                                                  mentor.isFrom = "profile"
                                                                                  self.present(mentor, animated: true, completion: nil)
                                                                          }
            }
            if self.question[indexPath.row] == "Upload your best pic here."{
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor5VC") as?  SignUpMentor5VC{
                                                                                  mentor.isFrom = "profile"
                                                                                  self.present(mentor, animated: true, completion: nil)
                                                                          }
            }
            if self.question[indexPath.row] == "Select social group you belong to."{
                if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor5VC") as?  SignUpMentor5VC{
                        mentor.isFrom = "profile"
                        self.present(mentor, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    
    
    
    
    @IBAction func handleOk(_ sender: Any) {
        let storyboard : UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        if self.userType == "Mentee" {
            if let mentee = storyboard.instantiateViewController(withIdentifier: "SignupMentee1ViewController") as? SignupMentee1ViewController{
                mentee.isFrom = "profile"
                
                self.present(mentee, animated: true, completion: nil)
            }
        }else{
            if let mentor = storyboard.instantiateViewController(withIdentifier: "SignUpMentor1VC") as?  SignUpMentor1VC{
                mentor.isFrom = "profile"
                self.present(mentor, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func handleCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func checkIsProfleComplete(){
      
          if userType == "Mentee" {
              
                 ref.child("users").child(Auth.auth().currentUser?.uid ?? "").observe(.value) { (snapshot) in
                           if snapshot.exists(){
                           if let value = snapshot.value as? [String: AnyObject]{
                            
                              self.question.removeAll()
                              
                              let about = value["about"] as? String ?? ""
                              let birthday = value["birthday"] as? String ?? ""
                              let currentCity = value["currentCity"] as? String ?? ""
                              let feild_of_study = value["feild_of_study"] as? String ?? ""
                              let firstName = value["firstName"] as? String ?? ""
                              let hobbies = value["hobbies"] as? String ?? ""
                              let image = value["image"] as? String ?? ""
                              let kindofMember = value["kindofMember"] as? String ?? ""
                              let lastName = value["lastName"] as? String ?? ""
                              
                              let latitude = value["latitude"] as? String ?? ""
                              let longitude = value["longitude"] as? String ?? ""
                              let longterm = value["longterm"] as? String ?? ""
                              let memberdo = value["memberdo"] as? String ?? ""
                              let name = value["name"] as? String ?? ""
                              
                              let no_of_mentee = value["no_of_mentee"] as? String ?? ""
                              let objective = value["objective"] as? String ?? ""
                              let school = value["school"] as? String ?? ""
                              let shortterm = value["shortterm"] as? String ?? ""
                              let userGender = value["userGender"] as? String ?? ""
                            
                            if name.isEmpty == true{
                                self.question.append("What's your name?")
                            }
                            
                            if userGender.isEmpty == true {
                                self.question.append("Please select your gender.")
                            }
                            
                            
                            if birthday.isEmpty == true{
                                self.question.append("What's your age?")
                            }
                            
                            
                            if about.isEmpty == true{
                                self.question.append("Write few words about yourself that describes you best.")
                            }
                            if school.isEmpty == true{
                                 self.question.append("In which educational institute do you study.")
                            }
                            
                            if feild_of_study.isEmpty == true{
                                self.question.append("What's your feild of study?")
                            }
                            
                            
                          if shortterm.isEmpty == true{
                              self.question.append("What is your short term goal?")
                          }


                          if longterm.isEmpty == true{
                              self.question.append("What is your long term goal?")
                          }


                          if objective.isEmpty == true{
                              self.question.append("What is your objective?")
                            }
                                        
                            if kindofMember.isEmpty == true{
                                self.question.append("Which two words describes you best.")
                            }
                            
                            if memberdo.isEmpty == true{
                               self.question.append("What a mentor can do for you?")
                            }
                                        
                                       
                                    
                            
                            if image.isEmpty == true{
                                self.question.append("Upload your best pic here.")
                            }
                    
                            if hobbies.isEmpty == true{
                                 self.question.append("What do you do for fun?")
                            }
                               
                              self.tableView.reloadData()
                                                
                               
                             }
                           }
                       }
              
          }else {
             
              ref.child("users").child(Auth.auth().currentUser?.uid ?? "").observe(.value) { (snapshot) in
                  if snapshot.exists(){
                  if let value = snapshot.value as? [String: AnyObject]{
                        self.question.removeAll()
                        let about = value["about"] as? String ?? ""
                        let areaOfExpertise =  value["areaOfExpertise"] as? String ?? ""
                        let birthday = value["birthday"] as? String ?? ""
                        let currentCity = value["currentCity"] as? String ?? ""
                        let email = value["email"] as? String ?? ""
                        let firstName = value["firstName"] as? String ?? ""
                        let fun = value["fun"] as? String ?? ""
                        let image = value["image"] as? String ?? ""
                        let islive = value["islive"] as? String ?? ""
                        let key_accomplishment = value["key_accomplishment"] as? String ?? ""
                        let kindofMember = value["kindofMember"] as? String ?? ""
                        let lastName = value["lastName"] as? String ?? ""
                        let latitude = value["latitude"] as? String ?? ""
                        let longitude = value["longitude"] as? String ?? ""
                        let name = value["name"] as? String ?? ""
                        let no_of_mentee = value["no_of_mentee"] as? String ?? ""
                        let occupation = value["occupation"] as? String ?? ""
                        let school = value["school"] as? String ?? ""
                        let userGender = value["userGender"] as? String ?? ""
                        let gender = value["gender"] as? [String] ?? [""]
                        let socialgroup = value["socialgroup"] as? String ?? ""
                      
                    if name.isEmpty == true {
                        self.question.append("What's your name?")
                    }
                    if userGender.isEmpty == true {
                        self.question.append("Please select your gender.")
                    }
                    if birthday.isEmpty == true {
                        self.question.append("What's your age?")
                    }
                    if about.isEmpty == true {
                        self.question.append("Write few words about yourself that describes you best.")
                    }
                    if occupation.isEmpty == true {
                        self.question.append("In which organization do you work.")
                    }
                    if school.isEmpty == true {
                        self.question.append("What's your job title?")
                    }
                    if areaOfExpertise.isEmpty == true {
                        self.question.append("What is your area of expertise?")
                    }
                    if key_accomplishment.isEmpty == true {
                        self.question.append("Write few words about your accomplishment.")
                        
                    }
                    if fun.isEmpty == true {
                        self.question.append("What do you do for fun?")
                    }
                    if kindofMember.isEmpty == true {
                        self.question.append("Which two words describes you best.")
                    }
                    if gender.isEmpty == true {
                        self.question.append("What is your gender preference for mentees?")
                    }
                    if image.isEmpty == true {
                        self.question.append("Upload your best pic here.")
                    }
                    if socialgroup.isEmpty == true {
                        self.question.append("Select social group you belong to.")
                    }
                    
                    self.tableView.reloadData()
                      
                      
                    }
                  }
              }
          }
      }
    
    
    func checkMenteaProfile(){
        

                  if let id = Helper.getPREF("userId") {

                      ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in

                          // Get user value

                          self.value = snapshot.value as? NSDictionary

                          //UserModel

                         if let name = self.value?["name"] as? String{

                         }
                        
                            if let userGender = self.value?["userGender"] as? String{
                                                       
                            }
                        
                            if let birthday = self.value?["birthday"] as? String{

                            }
                        
                            if let about = self.value?["about"] as? String{

                            }
                        
                            if let school = self.value?["school"] as? String{

                            }
                        
                           

                        

                          if let field = self.value?["feild_of_study"] as? String {

                          }

                         if let long = self.value?["longterm"] as? String {

                          }

                          if let short = self.value?["shortterm"] as? String {

                          }

                          if let objective = self.value?["objective"] as? String{

                          }
                        
                          if let kindofMember = self.value?["kindofMember"] as? String{
                                
                          }

                          if let memberdo = self.value?["memberdo"] as? String {

                          }

                          if let hobbies = self.value?["hobbies"] as? String {

                          }
                          

                        if let image = self.value?["image"] as? String{
                            
                        }

                      }) { (error) in

                          print(error.localizedDescription)

                      }

                  }

    }
    
    
    func checkMentorProfile(){
         if let id = Helper.getPREF("userId") {
                       ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                           // Get user value
                           self.value = snapshot.value as? NSDictionary
                           //UserModel
                           print(self.value)
                        
                        if let name = self.value?["name"] as? String{
                            
                        }
                        
                        
                        if let userGender = self.value?["userGender"] as? String{
                                                   
                        }
                        
                        if let kindofMember = self.value?["kindofMember"] as? String{
                        }
                        
                        if let gender = self.value?["gender"] as? [String]{
                            
                        }
                            
                        
                      
                                               
                        
                           if let areaOfExpertise = self.value?["areaOfExpertise"] as? String{
                             
                           }
                    
      
                           if let key_accomplishment = self.value?["key_accomplishment"] as? String{
                            
                           }
                        
                            if let occupation = self.value?["occupation"] as? String{
                               
                            }
      
                           if let hobbies = self.value?["fun"] as? String{
                               
                           }
                           if let school = self.value?["school"] as? String{
                                
                           }
                        
                          if let socialGroup = self.value?["socialgroup"] as? String{
                                         
                          }
      
                           
                           if let image = self.value?["image"] as? String{
                               
                           }
                        
                            if let birthday = self.value?["birthday"] as? String{
                                
                            }
                        
                            if let about = self.value?["about"] as? String{
                               
                            }
                        
                            if let islive = self.value?["islive"] as? String{
                               
                            }
                            
                       }) { (error) in
                           print(error.localizedDescription)
                       }
                   }
    }
    

}
