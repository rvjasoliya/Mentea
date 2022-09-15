//
//  EditProfileViewController.swift
//  Mentea
//
//  Created by Apple on 18/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import Firebase
import SDWebImage
import DropDown

class EditProfileViewController: UIViewController , UITextFieldDelegate, UITextViewDelegate{
    
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblLocation: UITextField!
    
    @IBOutlet weak var lblAge: UITextField!
    
    @IBOutlet weak var lblAbout: UITextField!
    
    @IBOutlet weak var lblOrganization: UITextField!

    @IBOutlet weak var lblOccupation: UITextField!
    
    @IBOutlet weak var lblExpertise: UITextField!
    
    @IBOutlet weak var lblAccomplishment: UITextField!
    
    @IBOutlet weak var lblHobbies: UITextField!
    
    @IBOutlet weak var lblSocialGroup: UITextField!
    
    @IBOutlet weak var btnMale: UIButton!
    
    @IBOutlet weak var btnFemale: UIButton!
    
    @IBOutlet weak var btnOther: UIButton!
    
    @IBOutlet weak var btnBold: UIButton!
    
    @IBOutlet weak var btnConsidrate: UIButton!
    
    @IBOutlet weak var btnFunny: UIButton!
    
    @IBOutlet weak var btnWise: UIButton!
    
    @IBOutlet weak var btnSwich: UISwitch!
    
    @IBOutlet weak var lblNoOfMentee: UITextField!
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSocial: UIButton!
    
    @IBOutlet weak var organisationTextView: UITextView!
    
    @IBOutlet weak var occupationTextView: UITextView!
    
    @IBOutlet weak var expertiseTextView: UITextView!
    
    @IBOutlet weak var accomlishmentTextView: UITextView!
    
    @IBOutlet weak var hobbiesTxtView: UITextView!
    
    @IBOutlet weak var socialTextView: UITextView!
    
    var hobbies = [String]()
    
    
    
    var ref: DatabaseReference!
    var menuDropDown = DropDown()
    let socialDropDown = DropDown()
    var value:NSDictionary?
    var isFrom = ""
    var selectedUserId = ""
    var imagePath = ""
    var kindofMember = ""
    var islive = ""
    var genderlist = [String]()
    var count = 0
    var social = ""
    var hobbyList = ""
    
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
          ref = Database.database().reference()
         getUserDetail()
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleProfileImageTap(_:))))
        
        btnBold.setImage(UIImage(named: "circle_border"), for: .normal)
        btnConsidrate.setImage(UIImage(named: "circle_border"), for: .normal)
        btnFunny.setImage(UIImage(named: "circle_border"), for: .normal)
        btnWise.setImage(UIImage(named: "circle_border"), for: .normal)
        
        btnMale.setImage(UIImage(named: "circle_border"), for: .normal)
        btnFemale.setImage(UIImage(named: "circle_border"), for: .normal)
        btnOther.setImage(UIImage(named: "circle_border"), for: .normal)
        
        self.organisationTextView.delegate = self
        self.occupationTextView.delegate = self
        self.expertiseTextView.delegate = self
        self.accomlishmentTextView.delegate = self
        self.hobbiesTxtView.delegate = self
        self.socialTextView.delegate = self

        organisationTextView.layer.borderColor = UIColor.lightGray.cgColor
        organisationTextView.layer.borderWidth = 0.5
        organisationTextView.layer.cornerRadius = 5
        occupationTextView.layer.borderColor = UIColor.lightGray.cgColor
        occupationTextView.layer.borderWidth = 0.5
        occupationTextView.layer.cornerRadius = 5
        expertiseTextView.layer.borderColor = UIColor.lightGray.cgColor
        expertiseTextView.layer.borderWidth = 0.5
        expertiseTextView.layer.cornerRadius = 5
        accomlishmentTextView.layer.borderColor = UIColor.lightGray.cgColor
        accomlishmentTextView.layer.borderWidth = 0.5
        accomlishmentTextView.layer.cornerRadius = 5
        hobbiesTxtView.layer.borderColor = UIColor.lightGray.cgColor
        hobbiesTxtView.layer.borderWidth = 0.5
        hobbiesTxtView.layer.cornerRadius = 5
        socialTextView.layer.borderColor = UIColor.lightGray.cgColor
        socialTextView.layer.borderWidth = 0.5
        socialTextView.layer.cornerRadius = 5
        
        lblLocation.delegate = self
        lblAge.delegate = self
        lblAbout.delegate = self

        lblNoOfMentee.delegate = self
        
        

        
        
        setRightBarButton11()
        dropDownGroups()
        dropDownHobbies()

        // Do any additional setup after loading the view.
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
    
    
    func dropDownHobbies()

     {
        

         // The view to which the drop down will appear on

         menuDropDown.anchorView = hobbiesTxtView // UIView or UIBarButtonItem
         
         // The list of items to display. Can be changed dynamically

         menuDropDown.dataSource = ["Adventure", "Blogging", "Cooking", "Dancing", "Fitness", "Painting", "Photography", "Singing", "Sports", "Study", "Singing", "Yoga"]

         DropDown.appearance().textColor = UIColor.black

         DropDown.appearance().selectedTextColor = UIColor.black

         DropDown.appearance().textFont = UIFont.systemFont(ofSize: 17)

         DropDown.appearance().backgroundColor = UIColor.init(hexString: "#0279de")

         DropDown.appearance().selectionBackgroundColor = UIColor.white

         DropDown.appearance().cellHeight = 40
    

         // Action triggered on selection
        menuDropDown.multiSelectionAction = { [weak self] (indices, items) in
                   print("Muti selection action called with: \(items)")
        self?.hobbies.removeAll()
              self?.hobbyList = ""
                 self?.hobbies = items
            for (index, element) in (self?.hobbies.enumerated())!{
                   
                if index == (self?.hobbies.count)!-1 {
                        self?.hobbyList.append("\(element)")
                    }
                    else
                    {
                         self?.hobbyList.append("\(element),")
                    }
            }
             
            print(self?.hobbyList)
            
            self?.hobbiesTxtView.text = self?.hobbyList
               
           
    }
  
        
        
        
        
        
        

//         menuDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//
//           print("Selected item: \(item) at index: \(index)")
//
//             if !self.hobbies.contains(item)
//             {
//                 self.hobbies.append(item)
//
//             }
//             //self.hobbiesCollectionView.reloadData()
//
//             print(self.hobbies)
//
//         }

     }
    
    
    
    
    
    
    
    
    func dropDownGroups()

       {

           // The view to which the drop down will appear on

           socialDropDown.anchorView = btnSocial // UIView or UIBarButtonItem
           
           // The list of items to display. Can be changed dynamically

           socialDropDown.dataSource = ["White American", "European American", "Middle Eastern American", "African American", "Native American", "Asian American", "Native Hawaiin"]

           DropDown.appearance().textColor = UIColor.black

           DropDown.appearance().selectedTextColor = UIColor.black

           DropDown.appearance().textFont = UIFont.systemFont(ofSize: 17)

           DropDown.appearance().backgroundColor = UIColor.init(hexString: "#0279de")

           DropDown.appearance().selectionBackgroundColor = UIColor.white

           DropDown.appearance().cellHeight = 40

           // Action triggered on selection

           socialDropDown.selectionAction = { [unowned self] (index: Int, item: String) in

             print("Selected item: \(item) at index: \(index)")

               self.social = item
               self.socialTextView.text = item
               
           }

       }
    
    
    @IBAction func handleSocial(_ sender: Any) {
        self.socialDropDown.show()
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

               kindofMember = btnBold.titleLabel?.text ?? "" 

           }else{

               sender.setImage(UIImage(named: "circle_border"), for: .normal)

               

                   }

            }

       

           @IBAction func handleConsiderate(_ sender: UIButton) {

           

           if sender.currentImage == UIImage(named: "circle_border")

           {

               sender.setImage(UIImage(named: "radio_select"), for: .normal)

               btnBold.setImage(UIImage.init(named: "circle_border"), for: .normal)

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

               btnBold.setImage(UIImage.init(named: "circle_border"), for: .normal)

               btnConsidrate.setImage(UIImage.init(named: "circle_border"), for: .normal)

               //btnFunny.setImage(UIImage.init(named: "circle_border"), for: .normal)

               btnWise.setImage(UIImage.init(named: "circle_border"), for: .normal)

               kindofMember = btnFunny.titleLabel?.text ?? ""

               

           }

           else{

               sender.setImage(UIImage(named: "circle_border"), for: .normal)

               

           }

           

       }

       

       @IBAction func hndleWise(_ sender: UIButton) {

           if sender.currentImage == UIImage(named: "circle_border")

           {

               sender.setImage(UIImage(named: "radio_select"), for: .normal)

               btnBold.setImage(UIImage.init(named: "circle_border"), for: .normal)

               btnConsidrate.setImage(UIImage.init(named: "circle_border"), for: .normal)

               btnFunny.setImage(UIImage.init(named: "circle_border"), for: .normal)

               //btnWise.setImage(UIImage.init(named: "circle_border"), for: .normal)

               kindofMember = btnWise.titleLabel?.text ?? ""

               

           }

           else{

               sender.setImage(UIImage(named: "circle_border"), for: .normal)

               

           }

           

       }
    
    
    
    @IBAction func handleSwitch(_ sender: UISwitch) {
        
        if sender.isOn {
            print("switch on")
            self.islive = "yes"
        } else {
            self.islive = "no"
        }
        
    }
    
    
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
    
    @IBAction func handelFemale(_ sender: UIButton) {
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
    
    @IBAction func handleOther(_ sender: UIButton) {

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
    
    
    
    func getUserDetail() {
           if let id = Helper.getPREF("userId") {
               ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                   // Get user value
                   self.value = snapshot.value as? NSDictionary
                   //UserModel
                   if let areaOfExpertise = self.value?["areaOfExpertise"] as? String{
                      
                       self.expertiseTextView.text = areaOfExpertise.firstCharacterUpperCase()
                   }
                   if let currentCity = self.value?["currentCity"] as? String{
                       self.lblLocation.text = currentCity
                   }
                  if let firstName = self.value?["firstName"] as? String {
                  if let lastName = self.value?["lastName"] as? String{
                        self.lblName.text = firstName.uppercased() + " " + lastName.uppercased()
                    }
                  else{
                        self.lblName.text = firstName.uppercased()
                    }
                }
//                   if let name = self.value?["name"] as? String {
//                       self.lblName.text = name.uppercased()
//                   }
                   if let key_accomplishment = self.value?["key_accomplishment"] as? String{
                       self.accomlishmentTextView.text = key_accomplishment.firstCharacterUpperCase()
                   }
                   if let kindofMember = self.value?["kindofMember"] as? String{
                    self.kindofMember = kindofMember
                       if kindofMember == "Bold & fast"{
                        self.btnBold.setImage(UIImage(named: "radio_select"), for: .normal)
                       } else if kindofMember == "Considerate & kind"{
                        self.btnConsidrate.setImage(UIImage(named: "radio_select"), for: .normal)
                       } else if kindofMember == "Funny & outgoing"{
                        self.btnFunny.setImage(UIImage(named: "radio_select"), for: .normal)
                       } else {
                        self.btnWise.setImage(UIImage(named: "radio_select"), for: .normal)
                       }
                   }
                   if let hobbies = self.value?["fun"] as? String{
                       self.hobbiesTxtView.text = hobbies.firstCharacterUpperCase()
                   }
                   if let school = self.value?["school"] as? String{
                       self.organisationTextView.text = school.firstCharacterUpperCase()
                   }
                
                if let occupation = self.value?["occupation"] as? String{
                    self.occupationTextView.text = occupation
                }
                if let about = self.value?["about"] as? String{
                    self.lblAbout.text = about
                }
                
                if let birthday = self.value?["birthday"] as? String{
                    self.lblAge.text = birthday
                }
                if let socialGroup = self.value?["socialgroup"] as? String{
                    self.socialTextView.text = socialGroup
                }
                if let noOfMentee = self.value?["no_of_mentee"] as? String{
                    self.lblNoOfMentee.text = noOfMentee
                }
                
                if let genderlist = self.value?["gender"] as? [String]{
                    if genderlist.contains("Male"){
                        self.btnMale.setImage(UIImage(named: "radio_select"), for: .normal)
                                            }
                                            if genderlist.contains("Female") {
                                                 self.btnFemale.setImage(UIImage(named: "radio_select"), for: .normal)
                                            }
                                            if genderlist.contains("Other") {
                                                 self.btnOther.setImage(UIImage(named: "radio_select"), for: .normal)
                                            }
                }
                                            
                           
                           
                        
                if let islive = self.value?["islive"] as? String , islive == "yes"{
                    self.islive = islive
                    self.btnSwich.isOn = true
                }else{
                    self.btnSwich.isOn = false
                }
                
//                   if let email = self.value?["email"] as? String{
//                       self.lblEmail.text = email
//                   }
                   
                   if let image = self.value?["image"] as? String{
                    self.imagePath = image
                       if let url = URL(string: image) {
                           self.imgUser.sd_setImage(with: url, completed: nil)
                       }
                   }
                   // ...
               }) { (error) in
                   print(error.localizedDescription)
               }
           }
       }
    
    @IBAction func handleHobbiesButton(_ sender: Any) {
      
        menuDropDown.show()
    }
    
    
    @IBAction func handleDemographics(_ sender: Any) {
        
        socialDropDown.show()
        
    }
    
    
    func update(fun:String,school:String,occupation:String,
                accomplishment:String,currentCity:String,areaOfExpertise:String, about : String) {
        
        if btnMale.currentImage == UIImage(named: "radio_select"){
            genderlist.append(btnMale.titleLabel?.text ?? "")
        }
        if btnFemale.currentImage == UIImage(named: "radio_select"){
            genderlist.append(btnFemale.titleLabel?.text ?? "")
        }
        if btnOther.currentImage == UIImage(named: "radio_select"){
            genderlist.append(btnOther.titleLabel?.text ?? "")
        }
        
        Helper.showLoader(onVC: self, message: "")
        
        var userID = ""
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        let location = userCurrentLocation
        let latitude = "\(location?.coordinate.latitude ?? 0)"
        let longitude = "\(location?.coordinate.longitude ?? 0)"
        
        var _age = self.lblAge.text ?? ""
        var socialgroup = self.socialTextView.text ?? ""
        
        let params :  [String : Any] =
            ["fun" : fun,
             "school": school,
             "occupation":occupation,
             "key_accomplishment" : accomplishment,
             "kindofMember":self.kindofMember,
             "image":self.imagePath,
             "currentCity":currentCity,
             "areaOfExpertise":areaOfExpertise,
             "islive" : self.islive,
             "gender" : genderlist,
             "about":about,"birthday":_age,
             "no_of_mentee":lblNoOfMentee.text ?? "",
             "socialgroup":socialgroup]
        
        
        self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(params) { (Error, DatabaseReference) in
            Helper.hideLoader(onVC: self)
            if Error == nil{
                print("successfull")
                Helper.showOKAlert(onVC: self, title: "Successfull", message: "Profile updated successfully.")
                self.getUserDetail()
            }else{
                print(Error.debugDescription)
            }
        }
        
    }
     func setRightBarButton11() {
               let timerBarButton = UIBarButtonItem.init(image: UIImage.init(named: "tick_white"), style: .plain, target: self, action: #selector(settingClicked(_:)))
               timerBarButton.width=15
               self.navigationItem.rightBarButtonItems = [timerBarButton]
               menuDropDown.bottomOffset = CGPoint(x: 0, y:44)
           }
     
     @IBAction func settingClicked(_ sender: UIBarButtonItem) {
      var about = lblAbout.text ?? ""
      var fun = hobbiesTxtView.text ?? ""
      var organization = organisationTextView.text ?? ""
      var accom = accomlishmentTextView.text ?? ""
      var location = lblLocation.text ?? ""
      var areaOfExpertise = expertiseTextView.text ?? ""
        var occupation = occupationTextView.text ?? ""
        
      update(fun: fun, school: organization, occupation: occupation, accomplishment: accom, currentCity: location, areaOfExpertise: areaOfExpertise, about: about)
     }

    

}

extension EditProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
            
            self.imgUser.image = editedImage
            //self.imgUser.maskCircle(anyImage: editedImage)
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
       // LoaderController.sharedInstance.showLoader()
       
        DispatchQueue.main.async {
              Helper.showLoader(onVC: self,message: "")
            }
        
        
        let date = Date().string(format: "yyyy-MM-dd HH:mm:ss")
        
        
        let imageRef = Storage.storage().reference().child("userImage/"+"user"+date+"user.jpg")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
             LoaderController.sharedInstance.removeLoader()
              DispatchQueue.main.async {
                    Helper.hideLoader(onVC: self)
             }
            guard let downloadURL = downloadURL else {
                return
            }
            
            let urlString = downloadURL.absoluteString
            print("image url: \(urlString)")
            self.imagePath = urlString
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == lblLocation {
            lblAge.becomeFirstResponder()
        }
        else if textField == lblAge {
                lblAbout.becomeFirstResponder()
          }
        else if textField == lblAbout {
            lblAbout.resignFirstResponder()
        }
        else if textField == lblNoOfMentee{
           lblNoOfMentee.resignFirstResponder()
        }
        return true
    
}
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {


           if textView ==  self.organisationTextView{
            if(text == "\n"){
                var point = textView.frame.origin
                point.y = point.y + textView.frame.height
                       
    self.scrollView.scrollRectToVisible(CGRect.init(origin: point, size: CGSize.init(width: 200, height: 200)), animated: true)
    self.occupationTextView.becomeFirstResponder()
                   }
               }
               else if textView ==  self.occupationTextView{
  if(text == "\n")
            {
                     self.expertiseTextView.becomeFirstResponder()
                 }
               }
               else if textView ==  self.expertiseTextView{

                      if(text == "\n") {
                        self.accomlishmentTextView.becomeFirstResponder()
                    }
                  }
               else if textView ==  self.accomlishmentTextView{

          
            
                  if(text == "\n") {
                    self.lblNoOfMentee.becomeFirstResponder()
                }
              }
              
               
              
           
           return true
       }
    
  }
        
    
    
       
    



