//
//  ArchiveQueueViewController.swift
//  Mentea
//
//  Created by Apple on 18/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SDWebImage

class ArchiveQueueViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var NoConversationLabel: UILabel!
    @IBOutlet weak var NoConversationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var isFrom = ""
    var ref: DatabaseReference!
    var chatUserList = [MessageUserList]()
    //var archiveUserList1 = [MessageUserList]()
    var image = ""
      var assignUserId = ""
      var name = ""
      var userType = ""
      var chatStatus = ""
      var isQueue = ""
      var userList = [UserModel]()
      
      var email = ""
      var firstname = ""
      var lastName = ""
      var fun = ""
      var gender = ""
      var islive = ""
      var key_accomplishment = ""
      var kindofMember = ""
      var occupation = ""
      var password = ""
      var school = ""
      var no_of_mentee = ""
      
      var feild_of_study = ""
      var hobbies = ""
      var longterm = ""
      var currentCity = ""
      var memberdo = ""
      var objective = ""
      var shortterm = ""
      var userType1 = ""
      var userId = ""
      var areaOfExpertise = ""
      var latitude = ""
      var longitude = ""
      var selectedUserId = ""
    
//    @IBOutlet weak var lblNoChat: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.NoConversationView.isHidden = true
        self.NoConversationLabel.text = "No pending requests"

         userType = Helper.getPREF("userType") ?? ""
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        if (isFrom == "Listing"){
            self.getUserList1()
        } else {
            self.getUserListArch()
        }
        
    }
    
    func getUserListArch() {
           Helper.showLoader(onVC: self, message: "")
           
           var userID = ""
           
           if Auth.auth().currentUser != nil {
               userID = Auth.auth().currentUser?.uid ?? ""
           }
           
           ref.child("mentorAssignUsers").child(userID).observe(.value, with: { snapshot in
               Helper.hideLoader(onVC: self)
               self.chatUserList.removeAll()
               if snapshot.childrenCount > 0 {
                
                   self.chatUserList.removeAll()
                   print(snapshot.key)
                   
                   for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                       let objects = nutrition.value as! [String: AnyObject]
                       print(objects)
                       if let status = objects["reportedStatus"] as? String, status == "1" {
                           
                           if let image = objects["image"] as? String{
                                   self.image = image
                                       }
                                                                            
                                                                            if let menteeUserId = objects["menteeUserId"] as? String{
                                                                                self.assignUserId = menteeUserId
                                                                            }
                                                                            if let mentorUserId = objects["mentorUserId"] as? String{
                                                                                self.assignUserId = mentorUserId
                                                                            }
                                                                            if let name = objects["name"] as? String{
                                                                                self.name = name
                                                                            }else{
                                                                                self.name = ""
                                                                            }
                                                                            
                                                                            if let currentCity = objects["currentCity"] as? String {
                                                                                self.currentCity = currentCity
                                                                            }else{
                                                                                self.currentCity = ""
                                                                            }
                                                                            
                                                                            if let chatStatus = objects["chatStatus"] as? String{
                                                                                self.chatStatus = chatStatus
                                                                            }
                                                                            
                                                                            if let isQueue = objects["isQueue"] as? String{
                                                                                self.isQueue = isQueue
                                                                            }
                                                                                                   
                                                                            let dataObj = MessageUserList(image: self.image, assignUserId: self.assignUserId, name: self.name, currentCity: self.currentCity, chatStatus: self.chatStatus, isQueue: self.isQueue)
                                                                            
                                                                            
                                                                            self.chatUserList.append(dataObj)
                           
                       } else {
                       
                      }
                   }
               }
                   
               if(self.chatUserList.count > 0) {
//                self.lblNoChat.isHidden = true
                self.tableView.isHidden = false
                self.NoConversationView.isHidden = true
                   print(self.chatUserList.count)
                   //self.lblNoArchive.isHidden = true
                   //self.collectionViewArch.isHidden = false
                   self.tableView.reloadData()
               } else {
//                self.lblNoChat.text = "No past conversation form the archive section"
//                self.lblNoChat.isHidden = false
                self.tableView.isHidden = true
                self.NoConversationLabel.text = "No past conversation"
                self.NoConversationView.isHidden = false
                   ///self.lblNoArchive.isHidden = false
                  //self.collectionViewArch.isHidden = true
               }
               self.tableView.reloadData()
           })
           
       }
    
    
    func getUserList1() {
        Helper.showLoader(onVC: self, message: "")
        
        var userID = ""
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        ref.child("mentorAssignUsers").child(userID).observe(.value, with: { snapshot in
            Helper.hideLoader(onVC: self)
            self.chatUserList.removeAll()
            if snapshot.childrenCount > 0 {
                //self.collectionView.isHidden = false
                self.chatUserList.removeAll()
                print(snapshot.key)
                
                for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                    let objects = nutrition.value as! [String: AnyObject]
                    print(objects)
                    if let status = objects["reportedStatus"] as? String, status == "1" {
                        
                    } else {
                        
                        if self.userType == "Mentee" {
                            if let isQueue = objects["isQueue"] as? String, isQueue == "1" {
                                if let image = objects["image"] as? String{
                                                                                     self.image = image
                                                                                 }
                                                                                 
                                                                                 if let menteeUserId = objects["menteeUserId"] as? String{
                                                                                     self.assignUserId = menteeUserId
                                                                                 }
                                                                                 if let mentorUserId = objects["mentorUserId"] as? String{
                                                                                     self.assignUserId = mentorUserId
                                                                                 }
                                                                                 if let name = objects["name"] as? String{
                                                                                     self.name = name
                                                                                 }else{
                                                                                     self.name = ""
                                                                                 }
                                                                                 
                                                                                 if let currentCity = objects["currentCity"] as? String {
                                                                                     self.currentCity = currentCity
                                                                                 }else{
                                                                                     self.currentCity = ""
                                                                                 }
                                                                                 
                                                                                 if let chatStatus = objects["chatStatus"] as? String{
                                                                                     self.chatStatus = chatStatus
                                                                                 }
                                                                                 
                                                                                 if let isQueue = objects["isQueue"] as? String{
                                                                                     self.isQueue = isQueue
                                                                                 }
                                                                                                        
                                                                                 let dataObj = MessageUserList(image: self.image, assignUserId: self.assignUserId, name: self.name, currentCity: self.currentCity, chatStatus: self.chatStatus, isQueue: self.isQueue)
                                                                                 
                                                                                 
                                                                                 self.chatUserList.append(dataObj)
                            }
                        } else{
                        
                            if let isQueue = objects["isQueue"] as? String, isQueue == "1" {
                             
                                if let image = objects["image"] as? String{
                                                          self.image = image
                                                      }
                                                      
                                                      if let menteeUserId = objects["menteeUserId"] as? String{
                                                          self.assignUserId = menteeUserId
                                                      }
                                                      if let mentorUserId = objects["mentorUserId"] as? String{
                                                          self.assignUserId = mentorUserId
                                                      }
                                                      if let name = objects["name"] as? String{
                                                          self.name = name
                                                      }else{
                                                          self.name = ""
                                                      }
                                                      
                                                      if let currentCity = objects["currentCity"] as? String {
                                                          self.currentCity = currentCity
                                                      }else{
                                                          self.currentCity = ""
                                                      }
                                                      
                                                      if let chatStatus = objects["chatStatus"] as? String{
                                                          self.chatStatus = chatStatus
                                                      }
                                                      
                                                      if let isQueue = objects["isQueue"] as? String{
                                                          self.isQueue = isQueue
                                                      }
                                                                             
                                                      let dataObj = MessageUserList(image: self.image, assignUserId: self.assignUserId, name: self.name, currentCity: self.currentCity, chatStatus: self.chatStatus, isQueue: self.isQueue)
                                                      
                                                      
                                                      self.chatUserList.append(dataObj)
                                
                            }
                        }
                        
                    }
                }
            }else{
                //self.collectionView.isHidden = true
                //self.lblNoQueue.isHidden = false
            }
            if(self.chatUserList.count > 0){
               self.tableView.isHidden = false
                self.NoConversationView.isHidden = true
                self.tableView.reloadData()
            }else{

                self.tableView.isHidden = true
                self.NoConversationView.isHidden = false
            }
            self.tableView.reloadData()
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  chatUserList.count
    }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTableViewCell") as! UserListTableViewCell
        cell.selectionStyle = .none
        let newDict : MessageUserList
        newDict = chatUserList[indexPath.row]
        //cell.Namelabel.text = folder.url
        
        ref.child("users").child(newDict.assignUserId).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            
            if (snapshot.childrenCount > 0 ){
                var value = snapshot.value as? NSDictionary
                //UserModel
                
                if let name = value?["name"] as? String {
                    cell.lblUserName.text = name.firstCharacterUpperCase()
                }
               
                if let image = value?["image"] as? String{
                    
                    if let images = cell.imgUser {
                        let block: SDExternalCompletionBlock? = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) -> Void in
                            //print(image)
                            if (image == nil) {
                                images.image = #imageLiteral(resourceName: "circle_dp")
                                return
                            }
                        }
                        
                        if let url = URL(string: newDict.image) {
                            images.sd_setImage(with: url, completed: block)
                        }
                    }
                    
                }else{
                   cell.imgUser.image = UIImage(named: "ic_avatar")
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newDict : MessageUserList
               newDict = chatUserList[indexPath.row]
               let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
               if let chatview = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController{
                    chatview.isFrom = "archive"
                   chatview.receiver_Id = newDict.assignUserId
                   chatview.receiverName = newDict.name
                   chatview.onCompletion = {(action) -> Void in
                   }
                   
                   self.navigationController?.pushViewController(chatview, animated: true)
                   //self.present(chatview, animated:true, completion:nil)
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

