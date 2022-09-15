//
//  SignupStep2MrViewController.swift
//  Mentea
//
//  Created by Apple on 22/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseAuth
import MBRadioButton
import FirebaseStorage
import GeoFire
import DropDown


class SignupStep2MrViewController: UIViewController {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var textName: UITextField!
    @IBOutlet weak var textSchool: UITextField!
    @IBOutlet weak var textOccupation: UITextField!
    @IBOutlet weak var textAccomplishment: UITextField!
    @IBOutlet weak var textFun: UITextField!
    @IBOutlet weak var txtnumMentee: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnAsian: UIButton!
    @IBOutlet weak var btncau: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    @IBOutlet weak var btnbold: UIButton!
    @IBOutlet weak var btnConsidrate: UIButton!
    @IBOutlet weak var btnFunny: UIButton!
    @IBOutlet weak var btnWise: UIButton!
    @IBOutlet weak var btnMenteeYes: UIButton!
    @IBOutlet weak var btnMenteeNo: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var textCity: UITextField!
    @IBOutlet weak var textAreaExpertise: UITextField!
    
    var ref: DatabaseReference!
    var geoFire: GeoFire?
    
    var kindofMember = ""
    var isLive = ""
    var imagePath = ""
    var genderList = [String]()
    
    var name: String?
    var isUpdate = false
    var mentorData:NSDictionary?
    
    var firstname = ""
    var lastName = ""
    var email = ""
    var password = ""
    var userType = ""
    let dropDown = DropDown()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: ref.child("Geolocs"))
        textName.delegate = self
        textSchool.delegate = self
        textOccupation.delegate = self
        textAccomplishment.delegate = self
        textFun.delegate = self
        txtnumMentee.delegate = self
        textAreaExpertise.delegate = self
        self.view.layoutSubviews()
        
        textName.text = name
        
        // Do any additional setup after loading the view.
        textName.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        textSchool.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        textOccupation.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        textAccomplishment.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        textFun.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        txtnumMentee.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        textCity.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        textAreaExpertise.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        
        btnMale.setImage(UIImage.init(named: "circle_border"), for: .normal)
        btnFemale.setImage(UIImage.init(named: "circle_border"), for: .normal)
        btnAsian.setImage(UIImage.init(named: "circle_border"), for: .normal)
        btncau.setImage(UIImage.init(named: "circle_border"), for: .normal)
        
        
        btnbold.setImage(UIImage.init(named: "circle_border"), for: .normal)
        btnConsidrate.setImage(UIImage.init(named: "circle_border"), for: .normal)
        btnFunny.setImage(UIImage.init(named: "circle_border"), for: .normal)
        btnWise.setImage(UIImage.init(named: "circle_border"), for: .normal)
        btnMenteeYes.setImage(UIImage.init(named: "circle_border"), for: .normal)
        btnMenteeNo.setImage(UIImage.init(named: "circle_border"), for: .normal)
        
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleProfileImageTap(_:))))
        
        if isUpdate{
            signUpButton.setTitle("Update", for: .normal)
            textName.text = mentorData?["name"] as? String
            textSchool.text = mentorData?["school"] as? String
            textOccupation.text = mentorData?["occupation"] as? String
            textAccomplishment.text = mentorData?["key_accomplishment"] as? String
            textFun.text = mentorData?["fun"] as? String
            txtnumMentee.text = mentorData?["no_of_mentee"] as? String
            
            
            imagePath = mentorData?["image"] as? String ?? ""
                if let url = URL(string: imagePath) {
                    self.imgUser.sd_setImage(with: url, completed: nil)
                    self.imgUser.roundedImage()
                }
            
            
            kindofMember = mentorData?["kindofMember"] as? String ?? ""
            if kindofMember == "Bold and fast"{
                btnbold.setImage(UIImage(named: "radio_select"), for: .normal)
            } else if kindofMember == "Considerate and kind"{
                btnConsidrate.setImage(UIImage(named: "radio_select"), for: .normal)
            } else if kindofMember == "Funny and outgoing"{
                btnFunny.setImage(UIImage(named: "radio_select"), for: .normal)
            } else {
                btnWise.setImage(UIImage(named: "radio_select"), for: .normal)
            }
            
            isLive = mentorData?["islive"] as? String ?? ""
            if isLive == "Yes"{
                btnMenteeYes.setImage(UIImage(named: "radio_select"), for: .normal)
            } else {
                btnMenteeNo.setImage(UIImage(named: "radio_select"), for: .normal)
            }
            
            genderList = mentorData?["gender"] as? [String] ?? []
            
            
            if genderList.contains("Male"){
                btnMale.setImage(UIImage(named: "radio_select"), for: .normal)
            }
            if genderList.contains("Female") {
                btnFemale.setImage(UIImage(named: "radio_select"), for: .normal)
            }
            if genderList.contains("Asian") {
                btnAsian.setImage(UIImage(named: "radio_select"), for: .normal)
            }
            if genderList.contains("Caucasion") {
                btncau.setImage(UIImage(named: "radio_select"), for: .normal)
            }
        }
        //self.txtnumMentee.isEditable = false
        
        
        
        
        
        loadDefaultText()
        //showDropdown()
        
        //self.txtnumMentee.isUserInteractionEnabled = true
        //let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        //self.self.txtnumMentee.addGestureRecognizer(gesture)
        
    }
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        // Do what you want
        dropDown.show()
    }
    
    func showDropdown(){
        // The view to which the drop down will appear on
        dropDown.anchorView = self.txtnumMentee // UIView or UIBarButtonItem

        // The list of items to display. Can be changed dynamically
        dropDown.dataSource = ["1", "2", "3"]
        // Action triggered on selection
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.txtnumMentee.text = item
        }

        // Will set a custom width instead of the anchor view width
        //dropDown.width = 200
    }
    
    func loadDefaultText(){
        if( globalcurrentCity != nil || globalcurrentCity.isEmpty != true){
            textCity.text = globalcurrentCity
        }
    }
    
    
    @IBAction func handleProfileImageTap(_ sender: UITapGestureRecognizer) {
        
        Helper.showActionAlert(onVC: self, onTakePhoto: takeNewPhotoFromCamera, onChooseFromGallery: choosePhotoFromExistingImages)
    }
    
    var count = 0
    
    @IBAction func handleMale(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "circle_border"){
            if count != 3 {
                sender.setImage(UIImage(named: "radio_select"), for: .normal)
                count = count + 1
            }
            
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
            count = count - 1
        }
        
        print(count)
    }
    
    
    @IBAction func handleFemale(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "circle_border"){
            
            if count != 3 {
                sender.setImage(UIImage(named: "radio_select"), for: .normal)
                count = count + 1
            }
            
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
            count = count - 1
        }
        
        print(count)
    }
    
    
    @IBAction func handleAsian(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "circle_border"){
            
            if count != 3 {
                sender.setImage(UIImage(named: "radio_select"), for: .normal)
                count = count + 1
            }
            
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
            count = count - 1
        }
        
        print(count)
    }
    
    
    @IBAction func handleCaus(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "circle_border"){
            
            if count != 3 {
                sender.setImage(UIImage(named: "radio_select"), for: .normal)
                count = count + 1
            }
            
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
            count = count - 1
        }
        
        print(count)
    }
    
    
    @IBAction func handleBold(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "circle_border"){
            sender.setImage(UIImage(named: "radio_select"), for: .normal)
            //btnbold.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnConsidrate.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnFunny.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnWise.setImage(UIImage.init(named: "circle_border"), for: .normal)
            kindofMember = btnbold.titleLabel?.text ?? ""
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
        }
    }
    
    @IBAction func handerConsider(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "circle_border"){
            
            sender.setImage(UIImage(named: "radio_select"), for: .normal)
            btnbold.setImage(UIImage.init(named: "circle_border"), for: .normal)
            //btnConsidrate.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnFunny.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnWise.setImage(UIImage.init(named: "circle_border"), for: .normal)
            kindofMember = btnConsidrate.titleLabel?.text ?? ""
            
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
        }
    }
    
    
    @IBAction func handleFunny(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "circle_border"){
            
            sender.setImage(UIImage(named: "radio_select"), for: .normal)
            btnbold.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnConsidrate.setImage(UIImage.init(named: "circle_border"), for: .normal)
            //btnFunny.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnWise.setImage(UIImage.init(named: "circle_border"), for: .normal)
            kindofMember = btnFunny.titleLabel?.text ?? ""
            
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
        }
    }
    
    
    @IBAction func handleWise(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "circle_border"){
            
            sender.setImage(UIImage(named: "radio_select"), for: .normal)
            btnbold.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnConsidrate.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnFunny.setImage(UIImage.init(named: "circle_border"), for: .normal)
            //btnWise.setImage(UIImage.init(named: "circle_border"), for: .normal)
            kindofMember = btnWise.titleLabel?.text ?? ""
            
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
        }
    }
    
    
    @IBAction func handleMenYes(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "circle_border"){
            
            sender.setImage(UIImage(named: "radio_select"), for: .normal)
            //btnMenteeYes.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnMenteeNo.setImage(UIImage.init(named: "circle_border"), for: .normal)
            isLive = "yes"
            
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
        }
    }
    
    
    
    @IBAction func handleMenNo(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "circle_border"){
            
            sender.setImage(UIImage(named: "radio_select"), for: .normal)
            btnMenteeYes.setImage(UIImage.init(named: "circle_border"), for: .normal)
            //btnMenteeNo.setImage(UIImage.init(named: "circle_border"), for: .normal)
            isLive = "no"
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
        }
    }
    
    
    func signUp(){
        
        
        
              
    }
    
    
    func AddSignUpData1(firstName:String,lastName:String,email:String,password:String,userType:String,name:String,school:String,occupation:String,
                        accomplishment:String,fun:String,no_of_mentee:String,gender:[String],currentCity:String,areaOfExpertise:String) {
        //self.ref.child("users").child(user.uid).setValue(["username": ""])
        
         var userID = ""
               
               if Auth.auth().currentUser != nil {
                   userID = Auth.auth().currentUser?.uid ?? ""
               }
        
        let location = userCurrentLocation
        let latitude = "\(location?.coordinate.latitude ?? 0)"
        let longitude = "\(location?.coordinate.longitude ?? 0)"
        
        let params :  [String : Any] =
                        ["firstname" : firstName,
                         "lastName": lastName,
                         "email":email,
                         "password" : password,
                         "userType": userType,
                         "name" : name,
                         "school": school,
                         "occupation":occupation,
                         "key_accomplishment" : accomplishment,
                         "fun": fun,
                         "gender":gender,
                         "kindofMember":self.kindofMember,
                         "no_of_mentee":no_of_mentee,
                         "islive":self.isLive,
                         "image":imagePath,
                         "latitude":latitude == "0" ? "" : latitude,
                         "longitude":longitude == "0" ? "" : longitude,
                         "userId": userID,
                         "currentCity":currentCity,
                         "areaOfExpertise":areaOfExpertise,
                         "no_of_menteeadded":"0"]
           
           
           self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").setValue(params) { (Error, DatabaseReference) in
               if Error == nil{
                   print("successfull")
                   
                   let userId = Auth.auth().currentUser?.uid ?? ""
                   Helper.setPREF(userId, key: "userId")
                Helper.setPREF(email, key: "userEmail")
                   
                  Helper.setPREF(userType, key: "userType")
                  
                  if let location = userCurrentLocation {
                      self.geoFire?.setLocation(location, forKey:Auth.auth().currentUser?.uid ?? "")
                  }
                  
                  if userType == "Mentor" {
                      
                      if let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
                          self.present(tabbar, animated: true, completion: nil)
                      }
                  } else {
                      
                      if let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
                          self.present(tabbar, animated: true, completion: nil)
                      }
                  }
                
               }else{
                   print(Error.debugDescription)
               }
           }
           
       }
    
    
     
    
    
    func AddSignUpData(name:String,school:String,occupation:String,accomplishment:String,userType:String,fun:String,no_of_mentee:String,gender:[String],currentCity:String) {
        //self.ref.child("users").child(user.uid).setValue(["username": ""])
        Helper.showLoader(onVC: self, message: "")
        
        var userID = ""
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        let location = userCurrentLocation
        let latitude = "\(location?.coordinate.latitude ?? 0)"
        let longitude = "\(location?.coordinate.longitude ?? 0)"
        
        let params :  [String : Any] = ["name" : name,
                                        "school": school,
                                        "occupation":occupation,
                                        "key_accomplishment" : accomplishment,
                                        "fun": fun,
                                        "gender":gender,
                                        "kindofMember":self.kindofMember,
                                        "no_of_mentee":no_of_mentee,
                                        "islive":self.isLive,
                                        "image":imagePath,
                                        "latitude":latitude == "0" ? "" : latitude,
                                        "longitude":longitude == "0" ? "" : longitude,
                                        "userId": userID,
                                        "currentCity":currentCity]
        
        self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(params) { (Error, DatabaseReference) in
            Helper.hideLoader(onVC: self)
            if Error == nil{
                print("successfull")
                //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                Helper.setPREF(userType, key: "userType")
                
                if let location = userCurrentLocation {
                    self.geoFire?.setLocation(location, forKey:Auth.auth().currentUser?.uid ?? "")
                }
                
                if userType == "Mentor" {
                    
                    if let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
                        self.present(tabbar, animated: true, completion: nil)
                    }
                } else {
                    
                    if let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
                        self.present(tabbar, animated: true, completion: nil)
                    }
                }
            }else{
                print(Error.debugDescription)
            }
            
        }
        
    }
    
    
    @IBAction func handleSignUp(_ sender: Any) {
        
        if btnMale.currentImage == UIImage(named: "radio_select"){
            genderList.append(btnMale.titleLabel?.text ?? "")
        }
        if btnFemale.currentImage == UIImage(named: "radio_select"){
            genderList.append(btnFemale.titleLabel?.text ?? "")
        }
        if btnAsian.currentImage == UIImage(named: "radio_select"){
            genderList.append(btnAsian.titleLabel?.text ?? "")
        }
        if btncau.currentImage == UIImage(named: "radio_select"){
            genderList.append(btncau.titleLabel?.text ?? "")
        }
        
        
        let name = textName.text ?? ""
        let school = textSchool.text ?? ""
        let occupation = textOccupation.text ?? ""
        let accom = textAccomplishment.text ?? ""
        let fun = textFun.text ?? ""
        let numofmen = txtnumMentee.text ?? ""
        let currentCity = textCity.text ?? ""
        let areaOfExpertise = textAreaExpertise.text ?? ""
        
        if name.isEmpty == true || school.isEmpty == true || occupation.isEmpty == true || accom.isEmpty == true || fun.isEmpty == true || numofmen.isEmpty == true || currentCity.isEmpty == true || areaOfExpertise.isEmpty == true {
            Helper.showOKAlert(onVC: self, title: "Alert", message: "All feilds are required")
        }else if (self.imagePath.isEmpty == true || self.imagePath == nil){
             Helper.showOKAlert(onVC: self, title: "Alert", message: "Please select profile image")
        }else{
            
            Helper.showLoader(onVC: self,message: "")
                          Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                              Helper.hideLoader(onVC: self)
                              if let error = error {
                                  print(error.localizedDescription)
                                  Helper.showOKAlert(onVC: self, title: "Alert", message: error.localizedDescription)
                              }
                              else if let user = authResult?.user {
                                  print(user)
                                  //self.AddSignUpData(firstName: self.firstname, lastName: self.lastName, email: self.email, password: self.password, userType: self.userType)
                                
                                self.AddSignUpData1(firstName: self.firstname, lastName: self.lastName, email: self.email, password: self.password, userType: self.userType, name: name, school: school, occupation: occupation, accomplishment: accom, fun: fun, no_of_mentee: numofmen, gender:self.genderList, currentCity: currentCity, areaOfExpertise: areaOfExpertise)
                              }
                  
                          }
            
            //self.AddSignUpData(name: name, school: school, occupation: occupation, accomplishment: accom, userType: "Mentor", fun: fun, no_of_mentee: numofmen, gender:genderList, currentCity: currentCity)
        }
        
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //        if let tabbar = storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
        //            self.present(tabbar, animated: true, completion: nil)
        //        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
//    func textFieldShouldReturn(textField: UITextField!) -> Bool {
//        if textField == txtnumMentee {
//           self.view.endEditing(true)
//           return false
//        }
//        return true
//    }
    
}
extension SignupStep2MrViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textName {
            textSchool.becomeFirstResponder()
        } else if textField == textSchool {
            textOccupation.becomeFirstResponder()
        } else if textField == textOccupation{
            textAreaExpertise.becomeFirstResponder()
        } else if textField == textAreaExpertise{
            textAccomplishment.becomeFirstResponder()
        }else if textField == textAccomplishment{
            textFun.becomeFirstResponder()
        }else if textField == textFun{
            txtnumMentee.becomeFirstResponder()
        }else{
            txtnumMentee.resignFirstResponder()
        }
        return true
    }
    
}



extension SignupStep2MrViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func takeNewPhotoFromCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.camera
        self.present(picker, animated: true, completion: nil)
    }
    
    func choosePhotoFromExistingImages() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        DispatchQueue.main.async {
            
            //self.imgUser.image = editedImage
            self.imgUser.maskCircle(anyImage: editedImage)
            self.createUpload(for: editedImage)
            //Helper.showLoader(onVC: self, message: NSLocalizedString("LOADING", comment: ""))
            //self.uploadCoverImage()
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func createUpload(for image: UIImage) {
        
        Helper.showLoader(onVC: self,message: "")
        
        let date = Date().string(format: "yyyy-MM-dd HH:mm:ss")
        
        
        let imageRef = Storage.storage().reference().child("userImage/"+"user"+date+"user.jpg")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            Helper.hideLoader(onVC: self)
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
            self.imagePath = urlString
        }
    }
    
}
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
