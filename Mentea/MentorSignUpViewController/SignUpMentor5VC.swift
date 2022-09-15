//
//  SignUpMentor5VC.swift
//  Mentea
//
//  Created by Apple on 21/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import DropDown

class SignUpMentor5VC: UIViewController {
    
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnYes: UIButton!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var txtSocialGroup: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSocial: UIButton!
    
    var ref: DatabaseReference!
     var userImage : UIImage?
    let dropDown = DropDown()
    var group = ""
    
    @IBOutlet weak var lblSocial: UITextField!
    var imagePath = ""
    var isLive = ""
    var isFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        imgUser.isUserInteractionEnabled = true
        imgUser.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleProfileImageTap(_:))))
        btnYes.setImage(UIImage.init(named: "circle-1"), for: .normal)
        btnNo.setImage(UIImage.init(named: "circle-1"), for: .normal)

        // Do any additional setup after loading the view.
        
            loadDefaultData()
        dropDownGroups()
       
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

    
    func dropDownGroups()

    {

        // The view to which the drop down will appear on

        dropDown.anchorView = btnSocial // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically

        dropDown.dataSource = ["White American", "European American", "Middle Eastern American", "African American", "Native American", "Asian American", "Native Hawaiin"]

        DropDown.appearance().textColor = UIColor.black

        DropDown.appearance().selectedTextColor = UIColor.black

        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 17)

        DropDown.appearance().backgroundColor = UIColor.init(hexString: "#0279de")

        DropDown.appearance().selectionBackgroundColor = UIColor.white

        DropDown.appearance().cellHeight = 40

        // Action triggered on selection

        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in

          print("Selected item: \(item) at index: \(index)")

            self.group = item
            self.txtSocialGroup.text = item
            
        }

    }
    
    @IBAction func handleSocialMenu(_ sender: Any) {
        self.dropDown.show()
    }
    
    func loadDefaultData() {
              let userId = Auth.auth().currentUser?.uid ?? ""
              print("current userId== \(userId)")
              ref.child("users").child(userId).observe(.value) { (snapshot) in
                  if snapshot.exists(){
                      if let value = snapshot.value as? [String: AnyObject]{
                           print("current userDetails== \(value)")
                          let image = value["image"] as? String ?? ""
                          let islive = value["islive"] as? String ?? ""
                        let socialgroup = value ["socialgroup"] as? String ?? ""
                           self.isLive = islive
                           self.imagePath = image
                       
                        self.txtSocialGroup.text = socialgroup
                        
                          if self.imagePath != nil ||  self.imagePath.isEmpty == false{
                            
                              if let url = URL(string: self.imagePath ?? "") {
                                  var img = UIImageView(frame: CGRect.zero)
                                  img.sd_setImage(with: url) { (image, error, type, url) in
                                   self.userImage = image
                                   
                                  }
                                  
                               self.imgUser.sd_setImage(with: url) { (image, error, type, url) in
                                      self.userImage = image
                                  }
                                  
                              }
                          }else{
                              self.imgUser.image = UIImage.init(named: "circle_dp")
                          }
                        
                        if islive == "yes" {
                            self.btnYes.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                        }else if islive == "no"{
                            self.btnNo.setImage(UIImage.init(named: "radio-on-button"), for: .normal)
                        }
                          
                          
                          
                      }
                  }
              }
          }
    
    
    @IBAction func handlePrev(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let signup = storyBoard.instantiateViewController(withIdentifier: "SignUpMentor4VC") as? SignUpMentor4VC{
             signup.isFrom = self.isFrom
                  self.dismiss(animated: true, completion: nil)

        }
        
    }
    

    
    @IBAction func btnYes(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "circle-1"){
            sender.setImage(UIImage(named: "radio-on-button"), for: .normal)
             btnNo.setImage(UIImage.init(named: "circle-1"), for: .normal)
             isLive = "yes"
                  
              }else{
                  sender.setImage(UIImage(named: "circle-1"), for: .normal)
              }
    }
    
    
    @IBAction func btnNo(_ sender: UIButton) {
       if sender.currentImage == UIImage(named: "circle-1"){
                sender.setImage(UIImage(named: "radio-on-button"), for: .normal)
                btnYes.setImage(UIImage.init(named: "circle-1"), for: .normal)
                  //btnMenteeNo.setImage(UIImage.init(named: "circle_border"), for: .normal)
                  isLive = "no"
              }else{
                  sender.setImage(UIImage(named: "circle-1"), for: .normal)
              }
    }
    
    @IBAction func handleDone(_ sender: Any) {
        update()
    }
    
    @IBAction func handleProfileImageTap(_ sender: UITapGestureRecognizer) {
        Helper.showActionAlert(onVC: self, onTakePhoto: takeNewPhotoFromCamera, onChooseFromGallery: choosePhotoFromExistingImages)
    }
    
    func update(){
           var userID = ""
            if Auth.auth().currentUser != nil {
               userID = Auth.auth().currentUser?.uid ?? ""
            }
        self.group = self.txtSocialGroup.text ?? ""
        
        let params : [String:Any] = ["image":imagePath, "islive":self.isLive, "socialgroup":self.group]
           print(params)
           
           ref.child("users").child(userID).updateChildValues(params) { (error, databaseReference) in
               if error == nil{
                   print("Data updated successfullly")
                      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        if let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController{
                           self.present(nextViewController, animated:true, completion:nil)
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
extension SignUpMentor5VC : UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
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
    
}

