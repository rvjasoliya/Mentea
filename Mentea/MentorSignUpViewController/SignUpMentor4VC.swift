//
//  SignUpMentor4VC.swift
//  Mentea
//
//  Created by Apple on 21/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpMentor4VC: UIViewController {
    
    @IBOutlet weak var btnBold: UIButton!
    @IBOutlet weak var btnConsiderate: UIButton!
    @IBOutlet weak var btnFunny: UIButton!
    @IBOutlet weak var btnWisew: UIButton!
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var imgTick: UIImageView!
    @IBOutlet weak var imgFemale: UIImageView!
    @IBOutlet weak var imgTickFemale: UIImageView!
    @IBOutlet weak var imgOther: UIImageView!
    @IBOutlet weak var imgTickOther: UIImageView!
    var ref: DatabaseReference!
    var kindofMember = ""
    var gender = ""
    var count = 0
    var isMale = true
    var isFemale = true
    var isOther = true
    var genderList = [String]()
    var isFrom = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        imgTick.isHidden = true
        imgTickFemale.isHidden = true
        imgTickOther.isHidden = true
        
        imgMale.isUserInteractionEnabled = true
        let tapMale = UITapGestureRecognizer(target: self, action: #selector(self.handleMale(_:)))
        imgMale.addGestureRecognizer(tapMale)
        imgFemale.isUserInteractionEnabled = true
        let tapFemale = UITapGestureRecognizer(target : self, action: #selector(self.handleFemale(_:)))
        imgFemale.addGestureRecognizer(tapFemale)
        imgOther.isUserInteractionEnabled = true
        let tapOther = UITapGestureRecognizer(target: self, action: #selector(self.handleOther(_:)))
        imgOther.addGestureRecognizer(tapOther)
        
        btnBold.setImage(UIImage(named: "circle-1"), for: .normal)
        btnConsiderate.setImage(UIImage(named: "circle-1"), for: .normal)
        btnFunny.setImage(UIImage(named: "circle-1"), for: .normal)
        btnWisew.setImage(UIImage(named: "circle-1"), for: .normal)
        
        // Do any additional setup after loading the view.
        if (isFrom == "profile")
        {
            loadDefaultData()
        }
    }
    
    func loadDefaultData() {
        self.genderList.removeAll()
           let userId = Auth.auth().currentUser?.uid ?? ""
           print("current userId== \(userId)")
           ref.child("users").child(userId).observe(.value) { (snapshot) in
               if snapshot.exists(){
                   if let value = snapshot.value as? [String: AnyObject]{
                        print("current userDetails== \(value)")
                       
                       
                       let kindofMemb = value["kindofMember"] as? String ?? ""
                        self.kindofMember = kindofMemb
                    
                    print(kindofMemb)
                    
                        if kindofMemb == "Considerate & kind" {
                            self.btnConsiderate.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                        }else if kindofMemb == "Wise & ambitious" {
                             self.btnWisew.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                        }else if kindofMemb == "Funny & outgoing" {
                             self.btnFunny.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                        }else if kindofMemb == "Bold & fast" {
                             self.btnBold.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                        }
                    
                    self.genderList = value["gender"] as? [String] ?? []
                    
                    print(self.genderList)
                    
                    
                    
                    
                    if self.genderList.contains("Male"){
                        self.isMale = true
                       self.imgTick.isHidden = false
                    }
                    
                    if self.genderList.contains("Female") {
                        self.isFemale = true
                        self.imgTickFemale.isHidden = false
                    }
                    
                    if self.genderList.contains("Other") {
                        self.isOther = true
                        self.imgTickOther.isHidden = false
                    }
                       
                   }
               }
           }
       }
    
    @objc func handleMale(_ sender: UITapGestureRecognizer) {
        if isMale{
            self.imgTick.isHidden = false
            isMale = false
             gender = "Male"
        }else{
            isMale = true
            self.imgTick.isHidden = true
        }
       
    }
    
    @objc func handleFemale(_ sender: UITapGestureRecognizer){
        if isFemale {
            self.imgTickFemale.isHidden = false
            isFemale = false
             gender = "Female"
        }else{
            self.imgTickFemale.isHidden = true
            isFemale = true
        }
       
        
    }
    
    @objc func handleOther(_ sender: UITapGestureRecognizer){
        if isOther{
            self.imgTickOther.isHidden = false
              gender = "Other"
            isOther = false
        }else{
            self.imgTickOther.isHidden = true
            isOther = true
        }
    }
    
    
    
    @IBAction func handleBold(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "circle-1"){
                   sender.setImage(UIImage(named: "radio-on-button"), for: .normal)
                   //btnbold.setImage(UIImage.init(named: "circle_border"), for: .normal)
                   btnConsiderate.setImage(UIImage.init(named: "circle-1"), for: .normal)
                   btnFunny.setImage(UIImage.init(named: "circle-1"), for: .normal)
                   btnWisew.setImage(UIImage.init(named: "circle-1"), for: .normal)
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
                   btnWisew.setImage(UIImage.init(named: "circle-1"), for: .normal)
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
            btnWisew.setImage(UIImage.init(named: "circle-1"), for: .normal)
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
            kindofMember = btnWisew.titleLabel?.text ?? ""
            
        }else{
            sender.setImage(UIImage(named: "circle-1"), for: .normal)
        }
        
    }
    
    func update( kindofMember: String,gender:[String]){
        var userID = ""
         if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
         }
        
        let params : [String:Any] = ["gender":gender,
                                     "kindofMember":kindofMember]
        print(params)
        
        ref.child("users").child(userID).updateChildValues(params) { (error, databaseReference) in
            if error == nil{
                print("Data updated successfullly")
                  let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    if let signup = storyBoard.instantiateViewController(withIdentifier: "SignUpMentor5VC") as? SignUpMentor5VC {
                         signup.isFrom = self.isFrom
                        self.present(signup, animated: true, completion: nil)
                    }
            }else{
                
                print("error in update")
                
            }
        }
        
    }
    
    @IBAction func handlePrev(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let signup = storyBoard.instantiateViewController(withIdentifier: "SignUpMentor3VC") as? SignUpMentor3VC{
             signup.isFrom = self.isFrom
                  self.dismiss(animated: true, completion: nil)

        }
    }
    
    @IBAction func handleNext(_ sender: Any) {
        self.genderList.removeAll()
        if imgTick.isHidden == false{
            genderList.append("Male")
        }
        if imgTickFemale.isHidden == false{
            genderList.append("Female")
        }
        if imgTickOther.isHidden == false {
            genderList.append("Other")
        }
      
        self.update(kindofMember: kindofMember, gender: genderList)
        
        
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

