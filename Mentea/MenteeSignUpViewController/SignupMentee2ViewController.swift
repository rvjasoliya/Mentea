//
//  SignupMentee2ViewController.swift
//  Mentea
//
//  Created by apple on 21/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignupMentee2ViewController: UIViewController {

    
    @IBOutlet weak var txtAboutYourself: UITextField!
    @IBOutlet weak var txtSchoolName: UITextField!
    @IBOutlet weak var txtFieldOfStudy: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ref: DatabaseReference!
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        
        txtAboutYourself.delegate = self
               txtSchoolName.delegate = self
               txtFieldOfStudy.delegate = self
        //NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillShow:"), name: UIResponder.keyboardWillShowNotification, object: nil)
        //NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillHide:"), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
              
                  // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
              //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
      

        if isFrom == "profile" {
            self.loadDefaultData()
        }
    }
    
    override func viewWillLayoutSubviews() {
        txtAboutYourself.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        txtSchoolName.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        txtFieldOfStudy.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
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
   /* @objc func keyboardWillShow(notification: NSNotification) {
            
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
    }*/
    
    func loadDefaultData() {
        let userId = Auth.auth().currentUser?.uid ?? ""
        print("current userId== \(userId)")
        ref.child("users").child(userId).observe(.value) { (snapshot) in
            if snapshot.exists(){
                if let value = snapshot.value as? [String: AnyObject]{
                     print("current userDetails== \(value)")
                    if let about = value["about"] as? String {
                        self.txtAboutYourself.text = about
                    }
                    if let school = value["school"] as? String {
                        self.txtSchoolName.text = school
                    }
                    
                    if let feild_of_study = value["feild_of_study"] as? String{
                        self.txtFieldOfStudy.text = feild_of_study
                    }
                    
                }
            }
        }
    }
    

    @IBAction func handlePrev(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signup = storyBoard.instantiateViewController(withIdentifier: "SignupMentee1ViewController") as! SignupMentee1ViewController
         signup.isFrom = self.isFrom
        self.dismiss(animated: true, completion: nil)
    
    }
    
    
    @IBAction func handleNext(_ sender: Any) {
        var about = txtAboutYourself.text ?? ""
        var school = txtSchoolName.text ?? ""
        var fieldOfStudy = txtFieldOfStudy.text ?? ""
//            if about.isEmpty == true || school.isEmpty == true || fieldOfStudy.isEmpty == true{
//                 Helper.showOKAlert(onVC: self, title: "Alert", message: "All feilds are required")
//             }else{
                 self.update(about: about, school: school, fieldOfStudy: fieldOfStudy)
//             }

       
    }
    
    func update( about: String,school : String,fieldOfStudy:String){
        var userID = ""
         if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
         }
        
        let params : [String:Any] = ["about":about,
                                     "school":school,
                                     "feild_of_study": fieldOfStudy]
        print(params)
        
        ref.child("users").child(userID).updateChildValues(params) { (error, databaseReference) in
            if error == nil{
                print("Data updated successfullly")
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let signup = storyBoard.instantiateViewController(withIdentifier: "SignupMentee3ViewController") as! SignupMentee3ViewController
                signup.isFrom = self.isFrom
                self.present(signup, animated: true, completion: nil);
            }
            else{
                
                print("error in update")
                
            }
        }
        
    }
    
    
}
extension SignupMentee2ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtAboutYourself {
            txtSchoolName.becomeFirstResponder()
        } else if textField == txtSchoolName {
            txtFieldOfStudy.becomeFirstResponder()
        } else if textField == txtFieldOfStudy{
             var about = txtAboutYourself.text ?? ""
                    var school = txtSchoolName.text ?? ""
                    var fieldOfStudy = txtFieldOfStudy.text ?? ""
                    self.update(about: about, school: school, fieldOfStudy: fieldOfStudy)

            txtFieldOfStudy.resignFirstResponder()
        } else{
            txtFieldOfStudy.resignFirstResponder()
        }
        return true
    }
    
}

