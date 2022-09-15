//
//  SignupMentee3ViewController.swift
//  Mentea
//
//  Created by apple on 21/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignupMentee3ViewController: UIViewController {

    
    @IBOutlet weak var txtShortGoal: UITextField!
    @IBOutlet weak var txtLongGoal: UITextField!
    @IBOutlet weak var txtObjective: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ref: DatabaseReference!
    var isFrom  = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         ref = Database.database().reference()
         
        
        txtShortGoal.delegate = self
        txtLongGoal.delegate = self
        txtObjective.delegate = self
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
              
                  // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
              //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
        if isFrom == "profile" {
            self.loadDefaultData()
        }
    }
    
     override func viewWillLayoutSubviews() {
        txtShortGoal.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        txtLongGoal.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        txtObjective.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
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
                    
                    let shortterm = value["shortterm"] as? String ?? ""
                    let longterm = value["longterm"] as? String ?? ""
                    let objective = value["objective"] as? String ?? ""
                    
                    self.txtShortGoal.text = shortterm
                    self.txtLongGoal.text = longterm
                    self.txtObjective.text = objective
                    
                    
//                    ["shortterm:":shortGoal,
//                    "longterm":longGoal,
//                    "objective":objective]
                }
            }
        }
    }
    
    /*@objc func keyboardWillShow(notification: NSNotification) {
            
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
    

    @IBAction func handlePrev(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signup = storyBoard.instantiateViewController(withIdentifier: "SignupMentee2ViewController") as! SignupMentee2ViewController
         signup.isFrom = self.isFrom
                self.dismiss(animated: true, completion: nil)


    }
    
    
    @IBAction func handleNext(_ sender: Any) {
        var shortGoal = txtShortGoal.text ?? ""
        var longGoal = txtLongGoal.text ?? ""
        var objective = txtObjective.text ?? ""
//        if accom.isEmpty == true || fun.isEmpty == true || noOfMentee.isEmpty == true{
//            Helper.showOKAlert(onVC: self, title: "Alert", message: "All feilds are required")
//            }else{
                update(shortGoal: shortGoal, longGoal: longGoal, objective: objective)
//        }
       
            
    }
    
    func update( shortGoal: String, longGoal : String, objective:String){
        var userID = ""
         if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
         }
        
        let params : [String:Any] = ["shortterm":shortGoal,
                                     "longterm":longGoal,
                                     "objective":objective]
        print(params)
        
        ref.child("users").child(userID).updateChildValues(params) { (error, databaseReference) in
            if error == nil{
                print("Data updated successfullly")
                 let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let signup = storyBoard.instantiateViewController(withIdentifier: "SignupMentee4ViewController") as! SignupMentee4ViewController
                        signup.isFrom = self.isFrom
                        self.present(signup, animated: true, completion: nil);
            
            }else{
                
                print("error in update")
                
            }
        }
        
    }
    
}
extension SignupMentee3ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtShortGoal {
            txtLongGoal.becomeFirstResponder()
        }
        else if textField == txtLongGoal {
            txtObjective.becomeFirstResponder()
        }
        else if textField == txtObjective {
             var shortGoal = txtShortGoal.text ?? ""
                    var longGoal = txtLongGoal.text ?? ""
                    var objective = txtObjective.text ?? ""
                    update(shortGoal: shortGoal, longGoal: longGoal, objective: objective)
          
            txtObjective.resignFirstResponder()
        }  else{
            txtObjective.resignFirstResponder()
        }
        return true
    }
    
}


