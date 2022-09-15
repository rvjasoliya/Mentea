//
//  SignupMentee5ViewController.swift
//  Mentea
//
//  Created by apple on 21/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import DropDown

class SignupMentee5ViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtFun: UITextField!
    @IBOutlet weak var btnHobbies: UIButton!
    @IBOutlet weak var hobbiesCollectionView: UICollectionView!
    
    var ref: DatabaseReference!
    var imagePath = ""
    var userImage : UIImage?
    var isFrom = ""
    let dropDown = DropDown()
    var hobbies = [String]()
    var hobbyList = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        txtFun.delegate = self
       
        
        imgProfile.isUserInteractionEnabled = true
        imgProfile.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleProfileImageTap(_:))))
        
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
                     
                         // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
                    // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        // Do any additional setup after loading the view.
         dropDownHobbies()
        hobbiesCollectionView.delegate = self
        hobbiesCollectionView.dataSource = self
        
        
            loadDefaultData()
        
    }
    
    override func viewWillLayoutSubviews() {
         txtFun.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
    }
    

    func loadDefaultData() {
           let userId = Auth.auth().currentUser?.uid ?? ""
           print("current userId== \(userId)")
           ref.child("users").child(userId).observe(.value) { (snapshot) in
               if snapshot.exists(){
                   if let value = snapshot.value as? [String: AnyObject]{
                        print("current userDetails== \(value)")
                       let image = value["image"] as? String ?? ""
                       let hobbies = value["hobbies"] as? String ?? ""
                    self.txtFun.text = hobbies ?? ""
                    let array  = hobbies.split(separator: ",")
                    for a in array
                    {
                        self.hobbies.append(String(a))
                    }
                    self.hobbiesCollectionView.reloadData()
          
                        self.imagePath = image
                    
                       if self.imagePath != nil ||  self.imagePath.isEmpty == false{
                           if let url = URL(string: self.imagePath ?? "") {
                               var img = UIImageView(frame: CGRect.zero)
                               img.sd_setImage(with: url) { (image, error, type, url) in
                                self.userImage = image
                               }
                               
                            self.imgProfile.sd_setImage(with: url) { (image, error, type, url) in
                                   self.userImage = image
                               }
                               
                           }
                       }else{
                           self.imgProfile.image = UIImage.init(named: "circle_dp")
                       }
                       
                       
                       
                   }
               }
           }
       }
    
    func dropDownHobbies()

     {

         // The view to which the drop down will appear on

         dropDown.anchorView = imgProfile // UIView or UIBarButtonItem
         
         // The list of items to display. Can be changed dynamically

         dropDown.dataSource = ["Adventure", "Blogging", "Cooking", "Dancing", "Fitness", "Painting", "Photography", "Singing", "Sports", "Study", "Singing", "Yoga"]

         DropDown.appearance().textColor = UIColor.black

         DropDown.appearance().selectedTextColor = UIColor.black

         DropDown.appearance().textFont = UIFont.systemFont(ofSize: 17)

         DropDown.appearance().backgroundColor = UIColor.init(hexString: "#0279de")

         DropDown.appearance().selectionBackgroundColor = UIColor.white

         DropDown.appearance().cellHeight = 40
    

         // Action triggered on selection
        // Action triggered on selection
        dropDown.multiSelectionAction = { [weak self] (indices, items) in
                           print("Muti selection action called with: \(items)")
             
            self?.hobbies.removeAll()
                  self?.hobbyList = ""
                     self?.hobbies = items
            if self!.hobbies.count <= 3 {
            
            
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
            
            
                
                self?.txtFun.text = self?.hobbyList
            }else{
                self!.dropDown.hide()
            }
                        
                       
                   
            }
          
        

//         dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//
//           print("Selected item: \(item) at index: \(index)")
//
//             if !self.hobbies.contains(item)
//             {
//                 self.hobbies.append(item)
//
//             }
//             self.hobbiesCollectionView.reloadData()
//
//             print(self.hobbies)
//
//         }

     }
     
     
    @IBAction func handleHobbies(_ sender: Any) {
        self.dropDown.show()
    }
    
     
     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MentorSignupCollectionViewCell", for: indexPath) as! MentorSignupCollectionViewCell

         cell.lblHobby.text = self.hobbies[indexPath.row]
         cell.imgCross.tag = indexPath.row
         cell.imgCross.isUserInteractionEnabled = true
         let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClick))
         cell.imgCross.addGestureRecognizer(tap)

         print(indexPath.row)

         return cell

     }
     
     @objc func onClick(sender : UITapGestureRecognizer)
      {
         let imgVieww = sender.view as! UIImageView
         var position = imgVieww.tag
         print(position)
          hobbies.remove(at: position)
          hobbiesCollectionView.reloadData()
      }


     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

         return hobbies.count

     }

     

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

                //return CGSize(width: 110, height: 110)

                return CGSize(width: collectionView.bounds.size.width / 3-10, height: collectionView.bounds.size.width / 3)

            }
    
    @objc func keyboardWillShow(notification: NSNotification) {
                  
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
          }
    
    
    @IBAction func handleProfileImageTap(_ sender: UITapGestureRecognizer) {
        Helper.showActionAlert(onVC: self, onTakePhoto: takeNewPhotoFromCamera, onChooseFromGallery: choosePhotoFromExistingImages)

       }

       

       func update(hobbies: String){

            var userID = ""
            if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
                
        }
        var hobby1 = ""
          var hobby2 = ""
          var hobby3 = ""
        
        
        if self.hobbies.count == 1 {
                    hobby1 = self.hobbies[0]
               }
        else if self.hobbies.count == 2 {
                    hobby1 = self.hobbies[0]
                    hobby2 = self.hobbies[1]
               }
        else if self.hobbies.count == 3 {
                    hobby1 = self.hobbies[0]
                    hobby2 = self.hobbies[1]
                    hobby3 = self.hobbies[2]
                }
        print("ffffsizee",self.hobbies)
        print("ffff1 \(hobby1)")
        print("ffff2 \(hobby2)")
        print("ffff3 \(hobby3)")
        
        
        let params : [String:Any] = ["image":imagePath, "hobbies":hobbies, "hobbies2":hobby2, "hobbies3":hobby3 ]

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
    
    @IBAction func handlePrev(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signup = storyBoard.instantiateViewController(withIdentifier: "SignupMentee4ViewController") as! SignupMentee4ViewController
         signup.isFrom = self.isFrom
               self.dismiss(animated: true, completion: nil)

        
    }
    
 
    @IBAction func handleDone(_ sender: Any) {
//        for (index, element) in hobbies.enumerated(){
//
//                if index == hobbies.count-1{
//                    hobbyList.append("\(element)")
//                }
//                else
//                {
//                     hobbyList.append("\(element),")
//                }
//
//            }
            
            print(hobbyList)
        self.hobbyList = txtFun.text ?? ""
        //var hobbies = txtFun.text ?? ""
        update(hobbies: hobbyList)
    }
    
}
    
extension SignupMentee5ViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate {

        

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

                self.imgProfile.maskCircle(anyImage: editedImage)

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
extension SignupMentee5ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFun {
//            for (index, element) in hobbies.enumerated(){
//
//                if index == hobbies.count-1{
//                    hobbyList.append("\(element)")
//                }
//                else
//                {
//                     hobbyList.append("\(element),")
//                }
//
//            }
            self.hobbyList = txtFun.text ?? ""
//
            print(hobbyList)
           
            update(hobbies: hobbyList)
            txtFun.resignFirstResponder()
        }   else{
            txtFun.resignFirstResponder()
        }
        return true
    }
    
}
    

