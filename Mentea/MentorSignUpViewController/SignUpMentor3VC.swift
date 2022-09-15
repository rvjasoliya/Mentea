//
//  SignUpMentor3VC.swift
//  Mentea
//
//  Created by Apple on 21/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import DropDown

class SignUpMentor3VC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var txtAccomplishment: UITextField!
    @IBOutlet weak var txtFun: UITextField!
    @IBOutlet weak var txtNoofMentee: UITextField!
    @IBOutlet weak var btnHobbies: UIButton!
    @IBOutlet weak var hobbiesCollectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var ref: DatabaseReference!
    var isFrom = ""
    let dropDown = DropDown()
    var hobbies = [String]()
    var hobbyList = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        
        ref = Database.database().reference()
       
        
        txtAccomplishment.delegate = self
        txtFun.delegate = self
        txtNoofMentee.delegate = self
        hobbiesCollectionView.delegate = self
        hobbiesCollectionView.dataSource = self
        //txtFun.text =
        //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
            // call the 'keyboardWillHide' function when the view controlelr receive notification that keyboard is going to be hidden
          //NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
        if isFrom == "profile"{
            loadDefaultData()
        }
        dropDownHobbies()
    }
    
    override func viewWillLayoutSubviews() {
        txtAccomplishment.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
               btnHobbies.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
               txtNoofMentee.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
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
                    
                    let key_accomplishment = value["key_accomplishment"] as? String ?? ""
                    let fun = value["fun"] as? String ?? ""
                    let no_of_mentee = value["no_of_mentee"] as? String ?? ""
                     
                    
                    self.txtAccomplishment.text = key_accomplishment
                    self.txtFun.text = fun
                    self.txtNoofMentee.text = no_of_mentee

                    
                }
            }
        }
    }
    
    func dropDownHobbies()

    {

        // The view to which the drop down will appear on

        dropDown.anchorView = txtAccomplishment // UIView or UIBarButtonItem
        
        // The list of items to display. Can be changed dynamically

        dropDown.dataSource = ["Adventure", "Blogging", "Cooking", "Dancing", "Fitness", "Painting", "Photography", "Singing", "Sports", "Study", "Singing", "Yoga"]

        DropDown.appearance().textColor = UIColor.black

        DropDown.appearance().selectedTextColor = UIColor.black

        DropDown.appearance().textFont = UIFont.systemFont(ofSize: 17)

        DropDown.appearance().backgroundColor = UIColor.init(hexString: "#0279de")

        DropDown.appearance().selectionBackgroundColor = UIColor.white

        DropDown.appearance().cellHeight = 40

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

//        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//
//          print("Selected item: \(item) at index: \(index)")
//
//            if !self.hobbies.contains(item)
//            {
//                self.hobbies.append(item)
//
//            }
//            self.hobbiesCollectionView.reloadData()
//
//            print(self.hobbies)
//
//        }

    }
    
    
    @IBAction func handleHobbies(_ sender: Any) {
        dropDown.show()
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
    
    @IBAction func handlePrev(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let signup = storyBoard.instantiateViewController(withIdentifier: "SignUpMentor2VC") as? SignUpMentor2VC{
             signup.isFrom = self.isFrom
                    self.dismiss(animated: true, completion: nil)

        }
    }
    
    
    @IBAction func handleNext(_ sender: Any) {
        var accom = txtAccomplishment.text ?? ""
        //var fun = txtFun.text ?? ""
        var noOfMentee = txtNoofMentee.text ?? ""
        if noOfMentee.isEmpty == true{
            noOfMentee = "3"
        }
        
        
        //        for i:Int in hobbies.count
        //        {
        //            if(i<hobbies.count-2)
        //            {
        //                hobbyList.append("\(hobbies[i] ),")
        //            }
        //
        //        }
        //        for (index, element) in hobbies.enumerated(){
        //
        //            if index == hobbies.count-1{
        //                hobbyList.append("\(element)")
        //            }
        //            else
        //            {
        //                 hobbyList.append("\(element),")
        //            }
        //
        //        }
        self.hobbyList = self.txtFun.text ?? ""
        
        print(hobbyList)
        
        
        
        var fun1 = ""
        var fun2 = ""
        var fun3 = ""
        
        //        if hobbies.count > 0 {
        //            fun1 = hobbies[0]
        //        }
        //        if hobbies.count > 1 {
        //              fun2 = hobbies[1]
        //        }
        //        if hobbies.count > 2 {
        //             fun3 = hobbies[2]
        //         }
        
        if self.hobbies.count == 1 {
            fun1 = self.hobbies[0]
        }
        else if self.hobbies.count == 2 {
            fun1 = self.hobbies[0]
            fun2 = self.hobbies[1]
        }
        else if self.hobbies.count == 3 {
            fun1 = self.hobbies[0]
            fun2 = self.hobbies[1]
            fun3 = self.hobbies[2]
        }
        print("ffffsizee",self.hobbies)
        print("ffff1 \(fun1)")
        print("ffff2 \(fun2)")
        print("ffff3 \(fun3)")
        
        print(hobbies)
        print(fun3)
        print(fun2)
        print(fun1)
        
        update(accom: accom, fun: self.hobbyList,fun2: fun2,fun3: fun3, noOfMentee: noOfMentee)
        
    }
    
    
    func update( accom: String,fun : String,fun2 : String,fun3 : String,noOfMentee:String){
        var userID = ""
         if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
         }
        
        let params : [String:Any] = ["key_accomplishment":accom,
                                     "fun":fun,
                                     "fun2":fun2,
                                     "fun3":fun3,
                                     "no_of_mentee":noOfMentee]
        print(params)
        
        
        ref.child("users").child(userID).updateChildValues(params) { (error, databaseReference) in
            if error == nil{
                print("Data updated successfullly")
                 let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                      if let signup = storyBoard.instantiateViewController(withIdentifier: "SignUpMentor4VC") as? SignUpMentor4VC{
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
extension SignUpMentor3VC : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtAccomplishment {
            txtNoofMentee.becomeFirstResponder()
        } else if textField == txtNoofMentee {
            txtNoofMentee.resignFirstResponder()
            var accom = txtAccomplishment.text ?? ""
                          var fun = txtFun.text ?? ""
                          var noOfMentee = txtNoofMentee.text ?? ""
                          if noOfMentee.isEmpty == true{
                              noOfMentee = "3"
                          }
                     for (index, element) in hobbies.enumerated(){
                           
                            if index == hobbies.count-1{
                                hobbyList.append("\(element)")
                            }
                            else
                            {
                                 hobbyList.append("\(element),")
                            }
                            
                        }
                        
                        print(hobbyList)
            var fun1 = ""
                    var fun2 = ""
                    var fun3 = ""
                   
                   if hobbies.count > 0 {
                              fun1 = hobbies[0]
                          }
                          if hobbies.count > 1 {
                                fun2 = hobbies[1]
                          }
                          if hobbies.count > 2 {
                               fun3 = hobbies[2]
                           }
                   
                   update(accom: accom, fun: self.hobbyList,fun2: fun2,fun3: fun3, noOfMentee: noOfMentee)
                     
                   
                     txtNoofMentee.resignFirstResponder()
        }  else {
            var accom = txtAccomplishment.text ?? ""
                 var fun = txtFun.text ?? ""
                 var noOfMentee = txtNoofMentee.text ?? ""
                 if noOfMentee.isEmpty == true{
                     noOfMentee = "3"
                 }
            self.hobbyList = self.txtFun.text ?? ""
               
               print(hobbyList)
            var fun1 = ""
                    var fun2 = ""
                    var fun3 = ""
                   
                    if hobbies.count > 0 {
                              fun1 = hobbies[0]
                          }
                          if hobbies.count > 1 {
                                fun2 = hobbies[1]
                          }
                          if hobbies.count > 2 {
                               fun3 = hobbies[2]
                           }
                   
                   update(accom: accom, fun: self.hobbyList,fun2: fun2,fun3: fun3, noOfMentee: noOfMentee)
          
            txtNoofMentee.resignFirstResponder()
        }
        return true
    }
    
}

