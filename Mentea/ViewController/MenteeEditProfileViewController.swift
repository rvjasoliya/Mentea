
import UIKit
import SDWebImage
import FirebaseDatabase
import FirebaseAuth
import Firebase
import FirebaseStorage
import DropDown

class MenteeEditProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UITextField!
    @IBOutlet weak var lblAge: UITextField!
    @IBOutlet weak var lblAbout: UITextField!
    @IBOutlet weak var lblOrganization: UITextField!
    @IBOutlet weak var lblFieldOfStudy: UITextField!
    @IBOutlet weak var lblObjective: UITextField!
    @IBOutlet weak var lblShortTermGoal: UITextField!
    @IBOutlet weak var lblLongTermGoal: UITextField!
    @IBOutlet weak var lblHobbies: UITextField!
    @IBOutlet weak var lblQualities: UITextField!
    @IBOutlet weak var btnBold: UIButton!
    @IBOutlet weak var btnFunny: UIButton!
    @IBOutlet weak var btnConsidrate: UIButton!
    @IBOutlet weak var btnWise: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnDone: UIButton!
    
    @IBOutlet weak var qualitiesTextView: UITextView!
    @IBOutlet weak var organisationTextView: UITextView!
    
    @IBOutlet weak var fieldOdStudyTextView: UITextView!
    
    @IBOutlet weak var objectiveTextView: UITextView!
    
    @IBOutlet weak var shortTermTextView: UITextView!
    
    @IBOutlet weak var longTermTextView: UITextView!
    
    @IBOutlet weak var hobbiesTextView: UITextView!
  
    @IBOutlet weak var noOfmentorTxtFld: UITextField!
    
    
    var hobbies = [String]()
    var hobbyList = ""
    
    var ref: DatabaseReference!
    var menuDropDown = DropDown()
    var value:NSDictionary?
    var imagePath = ""
    var kindofMember = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Profile"
        ref = Database.database().reference()
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleProfileImageTap(_:))))
        
        btnBold.setImage(UIImage(named: "circle_border"), for: .normal)
        btnConsidrate.setImage(UIImage(named: "circle_border"), for: .normal)
        btnFunny.setImage(UIImage(named: "circle_border"), for: .normal)
        btnWise.setImage(UIImage(named: "circle_border"), for: .normal)
        
          lblLocation.delegate = self
          lblAge.delegate = self
          lblAbout.delegate = self
          organisationTextView.delegate = self
          fieldOdStudyTextView.delegate = self
          objectiveTextView.delegate = self
          hobbiesTextView.delegate = self
          shortTermTextView.delegate = self
          longTermTextView.delegate = self
          qualitiesTextView.delegate = self
        noOfmentorTxtFld.delegate = self
        
        
        organisationTextView.layer.borderColor = UIColor.lightGray.cgColor
        organisationTextView.layer.borderWidth = 0.5
        organisationTextView.layer.cornerRadius = 5
        qualitiesTextView.layer.borderColor = UIColor.lightGray.cgColor
        qualitiesTextView.layer.borderWidth = 0.5
        qualitiesTextView.layer.cornerRadius = 5
        fieldOdStudyTextView.layer.borderColor = UIColor.lightGray.cgColor
        fieldOdStudyTextView.layer.borderWidth = 0.5
        fieldOdStudyTextView.layer.cornerRadius = 5
        objectiveTextView.layer.borderColor = UIColor.lightGray.cgColor
        objectiveTextView.layer.borderWidth = 0.5
        objectiveTextView.layer.cornerRadius = 5
        shortTermTextView.layer.borderColor = UIColor.lightGray.cgColor
        shortTermTextView.layer.borderWidth = 0.5
        shortTermTextView.layer.cornerRadius = 5
        longTermTextView.layer.borderColor = UIColor.lightGray.cgColor
        longTermTextView.layer.borderWidth = 0.5
        longTermTextView.layer.cornerRadius = 5
        hobbiesTextView.layer.borderColor = UIColor.lightGray.cgColor
        hobbiesTextView.layer.borderWidth = 0.5
        hobbiesTextView.layer.cornerRadius = 5
        
        noOfmentorTxtFld.layer.borderColor = UIColor.lightGray.cgColor
               noOfmentorTxtFld.layer.borderWidth = 0.5
               noOfmentorTxtFld.layer.cornerRadius = 5
        
        
        
        getUserDetail()
        setRightBarButton11()
        dropDownHobbies()
        
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
    
    func setRightBarButton11() {
                 let timerBarButton = UIBarButtonItem.init(image: UIImage.init(named: "tick_white"), style: .plain, target: self, action: #selector(settingClicked(_:)))
                 timerBarButton.width=15
                 self.navigationItem.rightBarButtonItems = [timerBarButton]
                 menuDropDown.bottomOffset = CGPoint(x: 0, y:44)
             }
       
       @IBAction func settingClicked(_ sender: UIBarButtonItem) {
      
        AddSignUpData(school: self.organisationTextView.text ?? "", feild_of_study: self.fieldOdStudyTextView.text ?? "", shortterm: self.shortTermTextView.text ?? "",longterm: self.longTermTextView.text ?? "",hobbies: self.hobbiesTextView.text ?? "", objective: self.objectiveTextView.text ?? "", kindofMember: kindofMember, currentCity: self.lblLocation.text ?? "", birthday: self.lblAge.text ?? "", about: self.lblAbout.text ?? "")
       }
    
    func dropDownHobbies()

      {

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
                
                self?.hobbiesTextView.text = self?.hobbyList
                    
            }
          
    }
    
    @IBAction func handleDone(_ sender: Any) {
        
        
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
    
    func getUserDetail() {
        if let id = Helper.getPREF("userId") {
            ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                self.value = snapshot.value as? NSDictionary
                //UserModel
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
                //                if let name = self.value?["name"] as? String {
                //                    self.lblName.text = name.uppercased()
                //                }
                if let field = self.value?["feild_of_study"] as? String {
                    self.fieldOdStudyTextView.text = field.firstCharacterUpperCase()
                }
                if let long = self.value?["longterm"] as? String {
                    self.longTermTextView.text = long.firstCharacterUpperCase()
                }
                if let short = self.value?["shortterm"] as? String {
                    self.shortTermTextView.text = short.firstCharacterUpperCase()
                }
                if let short = self.value?["objective"] as? String {
                    self.objectiveTextView.text = short.firstCharacterUpperCase()
                }
                
                if let memberdo = self.value?["memberdo"] as? String {
                    self.qualitiesTextView.text = memberdo.firstCharacterUpperCase()
                }
                if let hobbies = self.value?["hobbies"] as? String {
                    self.hobbiesTextView.text = hobbies.firstCharacterUpperCase()
                }
                if let school = self.value?["school"] as? String{
                    self.organisationTextView.text = school.firstCharacterUpperCase()
                }
                if let about = self.value?["about"] as? String{
                    self.lblAbout.text = about
                }
                if let birthday = self.value?["birthday"] as? String{
                    self.lblAge.text = birthday
                }
                
                if let no_of_mentee = self.value?["no_of_mentee"] as? String{
                    self.noOfmentorTxtFld.text = no_of_mentee
                }
                
                if let kindofMember = self.value?["kindofMember"] as? String {
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
                
                
                if let image = self.value?["image"] as? String{
                    self.imagePath = image
                    if let url = URL(string: image) {
                        self.imgUser.sd_setImage(with: url, completed: nil)
                        //self.imgUser.roundedImage()
                    }
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    
    @IBAction func handleHobbiesButton(_ sender: Any) {
        
        menuDropDown.show()
    }
    
    
    func AddSignUpData(school:String,feild_of_study:String,shortterm:String,longterm:String,hobbies:String,objective:String,kindofMember:String,currentCity:String,birthday:String, about : String) {
        //self.ref.child("users").child(user.uid).setValue(["username": ""])
        Helper.showLoader(onVC: self, message: "")
        var userID = ""
        var _age = self.lblAge.text ?? ""
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        let params :  [String : Any] = [
            "currentCity":currentCity,
            "school": school,
            "feild_of_study":feild_of_study,
            "shortterm" : shortterm,
            "longterm":longterm,
            "hobbies":hobbies,
            "objective":objective,
            "kindofMember":kindofMember,
            "image":imagePath,
            "about": about,
            "no_of_mentee":self.noOfmentorTxtFld.text ?? "3",
            "birthday":_age ]
        
        self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(params) { (Error, DatabaseReference) in
            Helper.hideLoader(onVC: self)
            if Error == nil{
                print("successfully")
                Helper.showOKAlert(onVC: self, title: "Successfull", message: "Profile updated successfully.")
                self.getUserDetail()
                //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            }else{
                print(Error.debugDescription)
            }
        }
      }
}
extension MenteeEditProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
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
        DispatchQueue.main.async {
                              Helper.showLoader(onVC: self,message: "")
                          }
        
        
        
        let date = Date().string(format: "yyyy-MM-dd HH:mm:ss")
        
        
        let imageRef = Storage.storage().reference().child("userImage/"+"user"+date+"user.jpg")
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
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
           } else if textField == noOfmentorTxtFld{
            noOfmentorTxtFld.resignFirstResponder()
        }
           return true
     
    }
    
 
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {


        if textView == organisationTextView{
           
            if(text == "\n") {
                var point = textView.frame.origin
                point.y = point.y + textView.frame.height
                                      
                self.scrollView.scrollRectToVisible(CGRect.init(origin: point, size: CGSize.init(width: 200, height: 200)), animated: true)
               self.fieldOdStudyTextView.becomeFirstResponder()
                }
            }
            else if textView == fieldOdStudyTextView{
           
                if(text == "\n") {
                 objectiveTextView.becomeFirstResponder()
              }
            }
            else if textView == objectiveTextView{
           
                   if(text == "\n") {
                    shortTermTextView.becomeFirstResponder()
                 }
               }
            else if textView == shortTermTextView{
           
               if(text == "\n") {
                longTermTextView.becomeFirstResponder()
             }
           }
            else if textView == longTermTextView{
            
               if(text == "\n") {
                        qualitiesTextView.becomeFirstResponder()
                 }
           }
          
            else if textView == qualitiesTextView{
          
               if(text == "\n") {
                       qualitiesTextView.resignFirstResponder()
                 }
           }
    
        
        
        return true
    }
    
    
    
    



}
