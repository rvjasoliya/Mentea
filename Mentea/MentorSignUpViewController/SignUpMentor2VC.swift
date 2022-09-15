//
//  SignUpMentor2VC.swift
//  Mentea
//
//  Created by Apple on 21/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpMentor2VC: UIViewController {
    
    
    @IBOutlet weak var txtAbout: UITextField!
    @IBOutlet weak var txtSchool: UITextField!
    @IBOutlet weak var textJobTitle: UITextField!
    @IBOutlet weak var txtEpertise: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ref: DatabaseReference!
    var isFrom = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        txtAbout.delegate = self
        txtSchool.delegate = self
        textJobTitle.delegate = self
        txtEpertise.delegate = self
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
            // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if isFrom == "profile"{
            loadDefaultData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        txtAbout.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        txtSchool.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        textJobTitle.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        txtEpertise.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
    }
    
    override func viewWillAppear(_ animated: Bool) {
           NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidShow(notification:)),
                        name: UIResponder.keyboardDidShowNotification, object: nil)
       }
       
       override func viewWillDisappear(_ animated: Bool) {
           NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidShow(notification:)),
                        name: UIResponder.keyboardDidHideNotification, object: nil)
       }
       
      
       
       //MARK: Methods to manage keybaord
       @objc func keyboardDidShow(notification: NSNotification) {
           var info = notification.userInfo
           let keyBoardSize = info![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
           scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
           scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
       }

       @objc func keyboardDidHide(notification: NSNotification) {

           scrollView.contentInset = UIEdgeInsets.zero
           scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
       }
    
    func loadDefaultData() {
        let userId = Auth.auth().currentUser?.uid ?? ""
        print("current userId== \(userId)")
        ref.child("users").child(userId).observe(.value) { (snapshot) in
            if snapshot.exists(){
                if let value = snapshot.value as? [String: AnyObject]{
                     print("current userDetails== \(value)")

                    
                    let about = value["about"] as? String ?? ""
                     let occupation = value["occupation"] as? String ?? ""
                     let school = value["school"] as? String ?? ""
                     let areaOfExpertise = value["areaOfExpertise"] as? String ?? ""
                    
                    self.txtAbout.text = about
                    self.textJobTitle.text = occupation
                    self.txtSchool.text = school
                    self.txtEpertise.text = areaOfExpertise
                    
                }
            }
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
            
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
      
      // move the root view up by the distance of keyboard height
      self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }
    
    
    @IBAction func handleNext(_ sender: Any) {
        
        var about = txtAbout.text ?? ""
        var school = txtSchool.text ?? ""
        var jobTitle = textJobTitle.text ?? ""
        var expertise = txtEpertise.text ?? ""
        
      
        self.update(about: about, school: school, jobTitle: jobTitle, expertise: expertise)
        
        
        
        
    }
    
    @IBAction func handlePrev(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let signup = storyBoard.instantiateViewController(withIdentifier: "SignUpMentor1VC") as? SignUpMentor1VC{
             signup.isFrom = self.isFrom
                   self.dismiss(animated: true, completion: nil)

        }
    }
    
    func update( about: String,school : String,jobTitle:String,expertise:String){
        var userID = ""
         if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
         }
        
        let params : [String:Any] = ["about":about,
                                     "occupation":jobTitle,
                                     "school":school,
                                     "areaOfExpertise": expertise]
        print(params)
        
        ref.child("users").child(userID).updateChildValues(params) { (error, databaseReference) in
            if error == nil{
                print("Data updated successfullly")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                if let signup = storyBoard.instantiateViewController(withIdentifier: "SignUpMentor3VC") as? SignUpMentor3VC{
                     signup.isFrom = self.isFrom
                    self.present(signup, animated: true, completion: nil)
                }
            
            }else{
                
                print("error in update")
                
            }
        }
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SignUpMentor2VC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtAbout {
            txtSchool.becomeFirstResponder()
        } else if textField == txtSchool {
            textJobTitle.becomeFirstResponder()
        } else if textField == textJobTitle{
            txtEpertise.becomeFirstResponder()
        } else if textField == txtEpertise{
            var about = txtAbout.text ?? ""
                   var school = txtSchool.text ?? ""
                   var jobTitle = textJobTitle.text ?? ""
                   var expertise = txtEpertise.text ?? ""
                   
                 
                   self.update(about: about, school: school, jobTitle: jobTitle, expertise: expertise)
           txtEpertise.resignFirstResponder()
        }else{
            txtEpertise.resignFirstResponder()
        }
        return true
    }
    
}

