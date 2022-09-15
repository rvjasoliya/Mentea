//
//  SignUpMentor1VC.swift
//  Mentea
//
//  Created by Apple on 21/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import CoreLocation
import GeoFire

class SignUpMentor1VC: UIViewController {
    
    @IBOutlet weak var txtAge: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imgMale: UIImageView!
    @IBOutlet weak var imgTickMale: UIImageView!
    @IBOutlet weak var imgFemale: UIImageView!
    @IBOutlet weak var imgTickFemale: UIImageView!
    @IBOutlet weak var imgOther: UIImageView!
    @IBOutlet weak var imgTickOther: UIImageView!
    @IBOutlet weak var txtDate: UIDatePicker!
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    var ref: DatabaseReference!
    var locationManager = CLLocationManager()
   
    var gender = ""
    var birthDay = ""
    var firstName = ""
    var lastName = ""
    var geoFire: GeoFire?
    var isFrom = ""
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: ref.child("Geolocs"))
        //txtName.isUserInteractionEnabled = false
        txtName.text = firstName+" "+lastName
        
       
        
        txtName.delegate = self
        txtAge.delegate = self
        
        txtDate.datePickerMode = .date
        imgTickMale.isHidden = true
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
        locationSetup()
        
        
            if self.isFrom == "profile" {
                   self.loadDefaultData()
               }
        
        }
    
    override func viewWillLayoutSubviews() {
        txtName.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
               txtAge.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
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
                           if let name = value["name"] as? String{
                               self.txtName.text = name ?? ""
                           }
                           
                           if let userGender  = value["userGender"] as? String{
                               if userGender == "Male" {
                                   self.gender = "Male"
                                   self.imgTickMale.isHidden = false
                                   self.imgTickFemale.isHidden = true
                                   self.imgTickOther.isHidden = true
                               } else if userGender == "Female" {
                                   self.gender = "Female"
                                   self.imgTickMale.isHidden = true
                                   self.imgTickFemale.isHidden = false
                                   self.imgTickOther.isHidden = true
                               } else if userGender == "Other" {
                                   self.gender = "Other"
                                   self.imgTickMale.isHidden = true
                                   self.imgTickFemale.isHidden = true
                                   self.imgTickOther.isHidden = false
                               }
                           }
                           
                           if let birthday = value["birthday"] as? String{
                               self.txtAge.text = birthday
                           }
                           
                           
                           
                       }
                   }
               }
           }
    
    
    
    
    func locationSetup() {
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 100
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
    }
    
    @objc func handleMale(_ sender: UITapGestureRecognizer) {
        gender = "Male"
        self.imgTickMale.isHidden = false
        self.imgTickFemale.isHidden = true
        self.imgTickOther.isHidden = true
    }
    
    @objc func handleFemale(_ sender: UITapGestureRecognizer){
        gender = "Female"
        self.imgTickMale.isHidden = true
        self.imgTickFemale.isHidden = false
        self.imgTickOther.isHidden = true
    }
    
    @objc func handleOther(_ sender: UITapGestureRecognizer){
        gender = "Other"
        self.imgTickMale.isHidden = true
        self.imgTickFemale.isHidden = true
        self.imgTickOther.isHidden = false
    }
    
    
    @IBAction func handleback(_ sender: Any) {
        if self.isFrom == "profile"{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController {
                self.present(nextViewController, animated:true, completion:nil)
            }
        } else {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if let signup = storyBoard.instantiateViewController(withIdentifier: "SignupStep1MrViewController") as? SignupStep1MrViewController {
                 self.present(signup, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func datePickerChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = DateFormatter.Style.short
        //dateFormatter.timeStyle = DateFormatter.Style.short
        dateFormatter.dateFormat = "dd-MM-yyyy"
        //"MMM dd,yyyy"
        birthDay = dateFormatter.string(from: txtDate.date)
        print(birthDay)
    }
    
    
    
    
    @IBAction func handleNext(_ sender: Any) {
        var name = txtName.text ?? ""
        var age = txtAge.text ?? ""
        
        self.update(name: name, date: age, gender: gender)
    }
    
    
    func update(name:String,date:String,gender:String){
        var userID = ""
         if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
         }
      
               let location = userCurrentLocation
               let latitude = "\(location?.coordinate.latitude ?? 0)"
               let longitude = "\(location?.coordinate.longitude ?? 0)"
        
        let params : [String:Any] = ["name":name,
                                     "birthday":date,
                                     "userGender":gender,
                                     "currentCity": globalcurrentCity,
                                     "latitude":latitude == "0" ? "" : latitude,
                                     "longitude":longitude == "0" ? "" : longitude]
        print(params)
        
        ref.child("users").child(userID).updateChildValues(params) { (error, databaseReference) in
            if error == nil{
                print("Data updated successfullly")
                
                if let location = userCurrentLocation {
                    self.geoFire?.setLocation(location, forKey:Auth.auth().currentUser?.uid ?? "")
                }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                if let signup = storyBoard.instantiateViewController(withIdentifier: "SignUpMentor2VC") as? SignUpMentor2VC{
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
extension SignUpMentor1VC : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        manager.stopUpdatingLocation()
        userCurrentLocation = location
        userCurrentLocation?.fetchCityAndCountry{ city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)  // Rio de Janeiro, Brazil
            globalcurrentCity = city
        }
        
    }

}
extension SignUpMentor1VC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtName {
            self.txtAge.becomeFirstResponder()
        } else{
            self.txtAge.resignFirstResponder()
            var name = txtName.text ?? ""
            var age = txtAge.text ?? ""
            
            self.update(name: name, date: age, gender: gender)
        }
        return true
    }
    
}



