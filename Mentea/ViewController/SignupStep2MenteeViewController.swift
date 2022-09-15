//
//  SignupStep2MenteeViewController.swift
//  Mentea
//
//  Created by Apple on 22/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import FirebaseStorage
import GeoFire

class SignupStep2MenteeViewController: UIViewController {
    
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtSchool: UITextField!
    @IBOutlet weak var txtFeildStudy: UITextField!
    @IBOutlet weak var txtShortTerm: UITextField!
    @IBOutlet weak var txtLongTerm: UITextField!
    @IBOutlet weak var txtHobbies: UITextField!
    @IBOutlet weak var txtObjective: UITextField!
    @IBOutlet weak var textMemberdo: UITextField!
    @IBOutlet weak var textCurrentCity: UITextField!
    @IBOutlet weak var btnBlod: UIButton!
    @IBOutlet weak var btnConsidrate: UIButton!
    @IBOutlet weak var btnFunny: UIButton!
    @IBOutlet weak var btnWise: UIButton!    
    @IBOutlet weak var signUpButton: UIButton!
    
    var kindofMember = ""
    var imagePath = ""
    var ref: DatabaseReference!
    var geoFire: GeoFire?
    var name: String?
    var isUpdate = false
    var menteeData:NSDictionary?
    
    var firstname = ""
    var lastName = ""
    var email = ""
    var password = ""
    var userType = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: ref.child("Geolocs"))
        txtName.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        txtSchool.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        txtFeildStudy.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        txtShortTerm.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        txtLongTerm.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        txtHobbies.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        txtObjective.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        textMemberdo.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        textCurrentCity.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        
        txtName.text = name ?? ""
        
        txtName.delegate = self
        txtSchool.delegate = self
        textCurrentCity.delegate = self
        txtFeildStudy.delegate = self
        txtShortTerm.delegate = self
        txtLongTerm.delegate = self
        txtHobbies.delegate = self
        txtObjective.delegate = self
        textMemberdo.delegate = self
        
        //txtName.text = name
        
        // Do any additional setup after loading the view.
        btnBlod.setImage(UIImage.init(named: "circle_border"), for: .normal)
        btnConsidrate.setImage(UIImage.init(named: "circle_border"), for: .normal)
        btnFunny.setImage(UIImage.init(named: "circle_border"), for: .normal)
        btnWise.setImage(UIImage.init(named: "circle_border"), for: .normal)
        
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleProfileImageTap(_:))))
        
        
        if isUpdate{
            signUpButton.setTitle("Update", for: .normal)
            txtName.text = menteeData?["name"] as? String
            txtSchool.text = menteeData?["school"] as? String
            txtFeildStudy.text = menteeData?["feild_of_study"] as? String
            textCurrentCity.text = menteeData?["currentCity"] as? String
            txtShortTerm.text = menteeData?["shortterm"] as? String
            txtLongTerm.text = menteeData?["longterm"] as? String
            txtHobbies.text = menteeData?["hobbies"] as? String
            txtObjective.text = menteeData?["objective"] as? String
            textMemberdo.text = menteeData?["memberdo"] as? String
            imagePath = (menteeData?["image"] as? String) ?? ""
            if let url = URL(string: self.imagePath) {
                self.imgUser.sd_setImage(with: url, completed: nil)
                self.imgUser.roundedImage()
            }
            
            imgUser.isUserInteractionEnabled = true
            imgUser.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleProfileImageTap(_:))))
            kindofMember = menteeData?["kindofMember"] as? String ?? ""
            if kindofMember == "Bold and fast"{
                btnBlod.setImage(UIImage(named: "radio_select"), for: .normal)
            } else if kindofMember == "Considerate and kind"{
                btnConsidrate.setImage(UIImage(named: "radio_select"), for: .normal)
            } else if kindofMember == "Funny and outgoing"{
                btnFunny.setImage(UIImage(named: "radio_select"), for: .normal)
            } else {
                btnWise.setImage(UIImage(named: "radio_select"), for: .normal)
            }
        }
        
        loadDefaultText()
        
    }
    
    func loadDefaultText(){
           if( globalcurrentCity != nil || globalcurrentCity.isEmpty != true){
               textCurrentCity.text = globalcurrentCity
           }
       }
    
    @IBAction func handleProfileImageTap(_ sender: UITapGestureRecognizer) {
        Helper.showActionAlert(onVC: self, onTakePhoto: takeNewPhotoFromCamera, onChooseFromGallery: choosePhotoFromExistingImages)
    }
    
    
    @IBAction func handleBold(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "circle_border"){
            sender.setImage(UIImage(named: "radio_select"), for: .normal)
            //btnbold.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnConsidrate.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnFunny.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnWise.setImage(UIImage.init(named: "circle_border"), for: .normal)
            kindofMember = btnBlod.titleLabel?.text ?? ""
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
        }
    }
    
    
    @IBAction func handleConsidrate(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "circle_border"){
            
            sender.setImage(UIImage(named: "radio_select"), for: .normal)
            btnBlod.setImage(UIImage.init(named: "circle_border"), for: .normal)
            //btnConsidrate.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnFunny.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnWise.setImage(UIImage.init(named: "circle_border"), for: .normal)
            kindofMember = btnConsidrate.titleLabel?.text ?? ""
            
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
        }
    }
    
    
    @IBAction func btnFunny(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "circle_border"){
            
            sender.setImage(UIImage(named: "radio_select"), for: .normal)
            btnBlod.setImage(UIImage.init(named: "circle_border"), for: .normal)
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
            btnBlod.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnConsidrate.setImage(UIImage.init(named: "circle_border"), for: .normal)
            btnFunny.setImage(UIImage.init(named: "circle_border"), for: .normal)
            //btnWise.setImage(UIImage.init(named: "circle_border"), for: .normal)
            kindofMember = btnWise.titleLabel?.text ?? ""
            
        }else{
            sender.setImage(UIImage(named: "circle_border"), for: .normal)
        }
    }
    
    
    
    @IBAction func handleSignUp(_ sender: Any) {
        
        //        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //        if let tabbar = storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
        //            self.present(tabbar, animated: true, completion: nil)
        //        }
        
        let name = txtName.text ?? ""
        let school = txtSchool.text ?? ""
        let feilds = txtFeildStudy.text ?? ""
        let shorterm = txtShortTerm.text ?? ""
        let longterm = txtLongTerm.text ?? ""
        let hobbies = txtHobbies.text ?? ""
        let objective = txtObjective.text ?? ""
        let memberdo = textMemberdo.text ?? ""
        let city = textCurrentCity.text ?? ""
        
        if name.isEmpty == true || school.isEmpty == true || feilds.isEmpty == true || shorterm.isEmpty == true || longterm.isEmpty == true || hobbies.isEmpty == true || objective.isEmpty == true || memberdo.isEmpty == true || city.isEmpty == true{
            
            Helper.showOKAlert(onVC: self, title: "Alert", message: "All feilds are required")
            
        } else if (self.imagePath.isEmpty == true || self.imagePath == nil){
             Helper.showOKAlert(onVC: self, title: "Alert", message: "Please select profile image")
        }else {
            
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
                                           
                                            self.AddSignUpData1(firstName: self.firstname, lastName: self.lastName, email: self.email, password: self.password, userType: self.userType, name: name, school: school, feild_of_study: feilds, shortterm: shorterm, longterm: longterm, hobbies: hobbies, objective: objective, memberdo: memberdo, kindofMember: self.kindofMember,currentCity: city)
                                         }
                             
                                     }
            
            self.AddSignUpData(name: name, school: school, feild_of_study: feilds, shortterm: shorterm, userType: "Mentee", longterm: longterm, hobbies: hobbies, objective: objective, memberdo: memberdo, kindofMember: self.kindofMember,currentCity: city)
            
        }
    }
    
    func AddSignUpData1(firstName:String,lastName:String,email:String,password:String,userType:String,name:String,school:String,feild_of_study:String,shortterm:String,longterm:String,hobbies:String,objective:String,memberdo:String,kindofMember:String,currentCity:String) {
           //self.ref.child("users").child(user.uid).setValue(["username": ""])
           Helper.showLoader(onVC: self, message: "")
           var userID = ""
           
           if Auth.auth().currentUser != nil {
               userID = Auth.auth().currentUser?.uid ?? ""
           }
           
           let location = userCurrentLocation
           let latitude = "\(location?.coordinate.latitude ?? 0)"
           let longitude = "\(location?.coordinate.longitude ?? 0)"
           //"21.209989"         21.211819      21.214881
           //"72.850436"         72.855865      72.862402
           
           
           let params :  [String : Any] = ["firstname" : firstName,
                                           "lastName": lastName,
                                           "email":email,
                                           "password" : password,
                                           "userType": userType,
                                           "name" : name,
                                           "currentCity":currentCity,
                                           "school": school,
                                           "feild_of_study":feild_of_study,
                                           "shortterm" : shortterm,
                                           "longterm":longterm,
                                           "hobbies":hobbies,
                                           "objective":objective,
                                           "memberdo":memberdo,
                                           "kindofMember":kindofMember,
                                           "latitude":latitude == "0" ? "" : latitude,
                                           "longitude":longitude == "0" ? "" : longitude,
                                           "image":imagePath,
                                           "userId" : userID]
           
           self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(params) { (Error, DatabaseReference) in
               Helper.hideLoader(onVC: self)
               if Error == nil{
                   print("successfully")
                   //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let userId = Auth.auth().currentUser?.uid ?? ""
                Helper.setPREF(userId, key: "userId")
                   
                Helper.setPREF(email, key: "userEmail")
                Helper.setPREF(userType, key: "userType")
                   if let location = userCurrentLocation {
                      // let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(latitude) ?? 0), longitude: CLLocationDegrees(Double(longitude) ?? 0))
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
           
           //    self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").setValue(params) { (Error, DatabaseReference) in
           //            if Error == nil{
           //                print("successfull")
           //                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
           //
           //                       if userType == "Mentor" {
           //
           //                        if let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
           //                                      self.present(tabbar, animated: true, completion: nil)
           //                        }
           //                       } else {
           //
           //                        if let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
           //                                                                self.present(tabbar, animated: true, completion: nil)
           //                                                  }
           //                       }
           //            }else{
           //                print(Error.debugDescription ?? "Errorr")
           //            }
           //        }
           
       }
    
    
    func AddSignUpData(name:String,school:String,feild_of_study:String,shortterm:String,userType:String,longterm:String,hobbies:String,objective:String,memberdo:String,kindofMember:String,currentCity:String) {
        //self.ref.child("users").child(user.uid).setValue(["username": ""])
        Helper.showLoader(onVC: self, message: "")
        var userID = ""
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        let location = userCurrentLocation
        let latitude = "\(location?.coordinate.latitude ?? 0)"
        let longitude = "\(location?.coordinate.longitude ?? 0)"
        //"21.209989"         21.211819      21.214881
        //"72.850436"         72.855865      72.862402
        
        
        let params :  [String : Any] = ["name" : name,
                                        "currentCity":currentCity,
                                        "school": school,
                                        "feild_of_study":feild_of_study,
                                        "shortterm" : shortterm,
                                        "longterm":longterm,
                                        "hobbies":hobbies,
                                        "objective":objective,
                                        "memberdo":memberdo,
                                        "kindofMember":kindofMember,
                                        "latitude":latitude == "0" ? "" : latitude,
                                        "longitude":longitude == "0" ? "" : longitude,
                                        "image":imagePath,
                                        "userId" : userID]
        
        self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(params) { (Error, DatabaseReference) in
            Helper.hideLoader(onVC: self)
            if Error == nil{
                print("successfully")
                //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                if let location = userCurrentLocation {
                   // let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(latitude) ?? 0), longitude: CLLocationDegrees(Double(longitude) ?? 0))
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
        
        //    self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").setValue(params) { (Error, DatabaseReference) in
        //            if Error == nil{
        //                print("successfull")
        //                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //
        //                       if userType == "Mentor" {
        //
        //                        if let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
        //                                      self.present(tabbar, animated: true, completion: nil)
        //                        }
        //                       } else {
        //
        //                        if let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
        //                                                                self.present(tabbar, animated: true, completion: nil)
        //                                                  }
        //                       }
        //            }else{
        //                print(Error.debugDescription ?? "Errorr")
        //            }
        //        }
        
    }
    
}
extension SignupStep2MenteeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtName {
            textCurrentCity.becomeFirstResponder()
        } else if textField == textCurrentCity {
            txtSchool.becomeFirstResponder()
        } else if textField == txtSchool {
            txtFeildStudy.becomeFirstResponder()
        } else if textField == txtFeildStudy{
            txtShortTerm.becomeFirstResponder()
        }else if textField == txtShortTerm{
            txtLongTerm.becomeFirstResponder()
        }else if textField == txtLongTerm{
            txtHobbies.becomeFirstResponder()
        }else if textField == txtHobbies{
            txtObjective.becomeFirstResponder()
        }else if textField == txtObjective{
            textMemberdo.becomeFirstResponder()
        }else{
            textMemberdo.resignFirstResponder()
        }
        return true
    }
    
}
extension SignupStep2MenteeViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
            //Helper.showLoader(onVC: self, message: NSLocalizedString("LOADING", comment: ""))
            //self.uploadCoverImage()
            self.createUpload(for: editedImage)
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func createUpload(for image: UIImage) {
        
        Helper.showLoader(onVC: self, message: "")
        
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

