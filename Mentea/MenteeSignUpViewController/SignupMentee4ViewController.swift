//
//  SignupMentee4ViewController.swift
//  Mentea
//
//  Created by apple on 21/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

// Done thank you
import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignupMentee4ViewController: UIViewController {

    
    @IBOutlet weak var btnBold: UIButton!
    @IBOutlet weak var btnConsiderate: UIButton!
    @IBOutlet weak var btnFunny: UIButton!
    @IBOutlet weak var btnWise: UIButton!
    @IBOutlet weak var txtMentorCanDo: UITextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ref: DatabaseReference!
    var kindofMember = ""
    var isFrom = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        txtMentorCanDo.delegate = self
        
        btnBold.setImage(UIImage(named: "circle-1"), for: .normal)
               btnConsiderate.setImage(UIImage(named: "circle-1"), for: .normal)
               btnFunny.setImage(UIImage(named: "circle-1"), for: .normal)
               btnWise.setImage(UIImage(named: "circle-1"), for: .normal)
        
        if isFrom == "profile" {
            loadDefaultData()
        }
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                     
                         // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
                    // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
         txtMentorCanDo.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
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
                        
                        let memberdo = value["memberdo"] as? String ?? ""
                        let kindofMemb = value["kindofMember"] as? String ?? ""
                        self.txtMentorCanDo.text = memberdo
                        self.kindofMember = kindofMemb
                        if kindofMemb == "Considerate & kind" {
                            self.btnConsiderate.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                        }else if kindofMemb == "Wise & ambitious" {
                             self.btnWise.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                        }else if kindofMemb == "Funny & outgoing" {
                             self.btnFunny.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                        }else if kindofMemb == "Bold & fast" {
                             self.btnBold.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                        }
                      
                    }
                }
            }
        }
    
   @IBAction func handleBold(_ sender: UIButton) {
           
           if sender.currentImage == UIImage(named: "circle-1"){
                      sender.setImage(UIImage(named: "radio-on-button"), for: .normal)
                      //btnbold.setImage(UIImage.init(named: "circle_border"), for: .normal)
                      btnConsiderate.setImage(UIImage.init(named: "circle-1"), for: .normal)
                      btnFunny.setImage(UIImage.init(named: "circle-1"), for: .normal)
                      btnWise.setImage(UIImage.init(named: "circle-1"), for: .normal)
                      kindofMember = btnBold.titleLabel?.text ?? ""
                  }else{
                      sender.setImage(UIImage(named: "circle-1"), for: .normal)
                  }
           
       }
       
       @IBAction func handleConsiderate(_ sender: UIButton) {
           
           if sender.currentImage == UIImage(named: "circle-1"){
                      
                      sender.setImage(UIImage(named: "radio-on-button"), for: .normal)
                      btnBold.setImage(UIImage.init(named: "circle-1"), for: .normal)
                      //btnConsidrate.setImage(UIImage.init(named: "circle_border"), for: .normal)
                      btnFunny.setImage(UIImage.init(named: "circle-1"), for: .normal)
                      btnWise.setImage(UIImage.init(named: "circle-1"), for: .normal)
                      kindofMember = btnConsiderate.titleLabel?.text ?? ""
                      
                  }else{
                      sender.setImage(UIImage(named: "circle-1"), for: .normal)
                  }
           
       }
       
       @IBAction func handleFunny(_ sender: UIButton) {
           
           if sender.currentImage == UIImage(named: "circle-1"){
               
               sender.setImage(UIImage(named: "radio-on-button"), for: .normal)
               btnBold.setImage(UIImage.init(named: "circle-1"), for: .normal)
               btnConsiderate.setImage(UIImage.init(named: "circle-1"), for: .normal)
               //btnFunny.setImage(UIImage.init(named: "circle_border"), for: .normal)
               btnWise.setImage(UIImage.init(named: "circle-1"), for: .normal)
               kindofMember = btnFunny.titleLabel?.text ?? ""
               
           }else{
               sender.setImage(UIImage(named: "circle-1"), for: .normal)
           }
           
       }
       
       
       @IBAction func hndleWise(_ sender: UIButton) {
           
           if sender.currentImage == UIImage(named: "circle-1"){
               
               sender.setImage(UIImage(named: "radio-on-button"), for: .normal)
               btnBold.setImage(UIImage.init(named: "circle-1"), for: .normal)
               btnConsiderate.setImage(UIImage.init(named: "circle-1"), for: .normal)
               btnFunny.setImage(UIImage.init(named: "circle-1"), for: .normal)
               //btnWise.setImage(UIImage.init(named: "circle_border"), for: .normal)
               kindofMember = btnWise.titleLabel?.text ?? ""
               
           }else{
               sender.setImage(UIImage(named: "circle-1"), for: .normal)
           }
           
       }
       
    
    func update( kindofMember: String,memberdo : String){
        var userID = ""
         if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
         }
        
        let params : [String:Any] = ["memberdo":memberdo,
                                     "kindofMember":kindofMember]
        print(params)
        ref.child("users").child(userID).updateChildValues(params) { (error, databaseReference) in
            if error == nil{
                print("Data updated successfullly")
                 let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                  let signup = storyBoard.instantiateViewController(withIdentifier: "SignupMentee5ViewController") as! SignupMentee5ViewController
                signup.isFrom = self.isFrom
                  self.present(signup, animated: true, completion: nil);
            }else{
                
                print("error in update")
                
            }
        }
        
    }
    
    @IBAction func handlePrev(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signup = storyBoard.instantiateViewController(withIdentifier: "SignupMentee3ViewController") as! SignupMentee3ViewController
         signup.isFrom = self.isFrom
                self.dismiss(animated: true, completion: nil)

            
    }
    
    @IBAction func btnNext(_ sender: Any) {
        var mentorCanDo = txtMentorCanDo.text ?? ""
        self.update(kindofMember: kindofMember, memberdo: mentorCanDo)
        
    }
    
}


extension SignupMentee4ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtMentorCanDo {
            var mentorCanDo = txtMentorCanDo.text ?? ""
            self.update(kindofMember: kindofMember, memberdo: mentorCanDo)
            txtMentorCanDo.resignFirstResponder()
        }   else{
            txtMentorCanDo.resignFirstResponder()
        }
        return true
    }
    
}

