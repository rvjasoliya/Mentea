//
//  ChatListViewController.swift
//  Mentea
//
//  Created by Apple on 23/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import DropDown
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SDWebImage

class ChatListViewController: UIViewController ,UITableViewDelegate, UITableViewDataSource {
    
    var menuDropDown = DropDown()
    var ref: DatabaseReference!
    var chatUserList = [MessageUserList]()
    var quechatUserList = [MessageUserList]()
    var archiveUserList1 = [MessageUserList]()
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
    
    var items = [String]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var collectionViewArch: UICollectionView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var myView = UIView()
    
    @IBOutlet weak var lblQueue: UILabel!
    @IBOutlet weak var lblChats: UILabel!
    @IBOutlet weak var lblArchives: UILabel!
    @IBOutlet weak var vwArchives: UIView!
    @IBOutlet weak var vwBottomA: UIView!
    @IBOutlet weak var lblNoArchive: UILabel!
    
    @IBOutlet weak var lblNoQueue: UILabel!
    
    @IBOutlet weak var vwNoData: UIView!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    var carbonTabSwipeNavigation = CarbonTabSwipeNavigation()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        ref = Database.database().reference()
        userType = Helper.getPREF("userType") ?? ""
        self.title = "Message"
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //setRightBarButton()
        //getUserList()
        //getUserList1()
        //getUserListArch()
        setupCarbonTabSwipe()
        
        if userType == "Mentor"{
            self.lblQueue.text = "Queue"
            self.lblChats.text = "Chats"
            self.lblArchives.isHidden = false
            self.vwArchives.isHidden = false
            self.lblArchives.text = "Archives"
            self.vwBottomA.isHidden = false
        }
        else{
            self.lblQueue.text = "Requested Mentor Users"
            self.lblChats.text = "Chats"
            self.lblArchives.isHidden = false
            self.lblArchives.text = "Archives"
            self.vwArchives.isHidden = false
            self.vwBottomA.isHidden = false
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.myView = UIView()
        self.myView.backgroundColor = UIColor.black
        self.myView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 1)
            //self.tableView.addSubview(self.myView)
        
        // Do any additional setup after loading the view.
    }
    
    
    func setupCarbonTabSwipe() {
        
        if (userType == "Mentor"){
            items =  ["Chat", "Queue", "Archive"]
        } else {
            items =  ["Chat", "Requested", "Archive"]
        }
        
        carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items as [AnyObject], delegate: self)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
        carbonTabSwipeNavigation.toolbar.barTintColor = UIColor.init(hexString: "10c2f0")
        style()
        //carbonTabSwipeNavigation.carbonTabSwipeScrollView.bounces = false
        //carbonTabSwipeNavigation.carbonTabSwipeScrollView.bouncesZoom = false
    }
           
    func style() {
        carbonTabSwipeNavigation.carbonSegmentedControl?.backgroundColor = UIColor.init(hexString: "10c2f0")
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.darkGray)
        carbonTabSwipeNavigation.setIndicatorHeight(2)
        if #available(iOS 13.0, *) {
            carbonTabSwipeNavigation.carbonSegmentedControl?.selectedSegmentTintColor = .black
        } else {
            // Fallback on earlier versions
        }
        if CurrentDevice.isiPad {
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(AppConstants.PORTRAIT_SCREEN_WIDTH / 3, forSegmentAt: 0)
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(AppConstants.PORTRAIT_SCREEN_WIDTH / 3, forSegmentAt: 1)
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(AppConstants.PORTRAIT_SCREEN_WIDTH / 3, forSegmentAt: 2)
            //carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(AppConstants.PORTRAIT_SCREEN_WIDTH / 5, forSegmentAt: 3)
            //            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(AppConstants.PORTRAIT_SCREEN_WIDTH / 5, forSegmentAt: 4)
        } else {
            
            
            
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(AppConstants.PORTRAIT_SCREEN_WIDTH / 3, forSegmentAt: 0)
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(AppConstants.PORTRAIT_SCREEN_WIDTH / 3, forSegmentAt: 1)
            carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(AppConstants.PORTRAIT_SCREEN_WIDTH / 3, forSegmentAt: 2)
            //carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(95, forSegmentAt: 3)
            //carbonTabSwipeNavigation.carbonSegmentedControl?.setWidth(100, forSegmentAt: 4)
            if AppConstants.PORTRAIT_SCREEN_WIDTH - 490 > 0 {
                carbonTabSwipeNavigation.carbonSegmentedControl?.tabExtraWidth = AppConstants.PORTRAIT_SCREEN_WIDTH - 490
            }
        }
        carbonTabSwipeNavigation.toolbar.backgroundColor = UIColor.init(hexString: "10c2f0")
        carbonTabSwipeNavigation.setNormalColor(UIColor.white, font: UIFont.systemFont(ofSize: 16))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.white, font: UIFont.boldSystemFont(ofSize: 16))
        
        //            if isNewClient{
        //carbonTabSwipeNavigation.currentTabIndex = 2
        //            }
        //carbonTabSwipeNavigation.currentTabIndex = 1
        //carbonTabSwipeNavigation.currentTabIndex = 0
        updateQueueUsertoChat()
    }
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        /*if userType == "Mentee" {
            getDataFromDatabase()
        }else{
            getDataFromDatabaseMentee()
        }*/
        print(userType)
//        if userType == "Mentee" {
//            getDataFromDatabaseMentee()
//        }else{
//            getDataFromDatabase()
//        }
        //nearbyMantee { (userList) in
            //print("nearby User Count : ",userList.count)
        //}
    }
    
    func updateQueueUsertoChat() {
        //self.updateQueueUsertoChat(noMenteeadded: (Int(noOfmenteeadded) ?? 0), noMentee: (Int(noOfmentee) ?? 0), userId: userId)
        
        ref.child("users").child(Auth.auth().currentUser?.uid ?? "").observeSingleEvent(of: .value) { (snapshot) in
            if snapshot.childrenCount > 0{
                let objects = snapshot.value as! [String: AnyObject]
                var noOfmenteeadded = "0"
                var noOfmentee = "0"
                if let no_of_menteeadded = objects["no_of_menteeadded"] as? String{
                    noOfmenteeadded = no_of_menteeadded
                }
                if let no_of_mentee = objects["no_of_mentee"] as? String{
                    noOfmentee = no_of_mentee
                }
                let noMentee = (Int(noOfmentee) ?? 0)
                let noMenteeadded = (Int(noOfmenteeadded) ?? 0)
                
                if noMenteeadded < noMentee {
                    self.ref.child("mentorAssignUsers").child(Auth.auth().currentUser?.uid ?? "").observe(.value, with: { snapshot in
                        if snapshot.childrenCount > 0 {
                            for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                                let objects = nutrition.value as! [String: AnyObject]
                                if ((objects["isQueue"] as? String ?? "0") == "1") && ((objects["reportedStatus"] as? String ?? "0") == "0") {
                                    print("isQueue--  1")
                                    //self.updateChatRecord(noMenteeadded: noMenteeadded, userId: objects["menteeUserId"] as? String ?? "")
                                    break
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    func updateChatRecord(noMenteeadded:Int,userId: String) {
        self.ref.child("mentorAssignUsers").child(Auth.auth().currentUser?.uid ?? "").child(userId).observe(.value, with: { (snapshot) in
            if(snapshot.exists()) {
                self.ref.child("mentorAssignUsers").child(Auth.auth().currentUser?.uid ?? "").child(userId).updateChildValues([
                    "isQueue": "0"
                ])
                let like = "\(noMenteeadded + 1)"
                self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues([
                    "no_of_menteeadded": like
                ])
                self.updateQueueUsertoChat()
            }
        })
        
        
        /*self.ref.child("mentorAssignUsers").child(userId).child(Auth.auth().currentUser?.uid ?? "").updateChildValues([
            "isQueue": "0"
        ])
        let like = "\(noMenteeadded + 1)"
        self.ref.child("users").child(userId).updateChildValues([
            "no_of_menteeadded": like
        ])*/
    }
   
    
    func getUserList() {
        Helper.showLoader(onVC: self, message: "")
        
        var userID = ""
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        ref.child("mentorAssignUsers").child(userID).observe(.value, with: { snapshot in
            Helper.hideLoader(onVC: self)
            self.chatUserList.removeAll()
            if snapshot.childrenCount > 0 {
                self.tableView.isHidden = false
                //self.userList.removeAll()
                print(snapshot.key)
                
                for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                    let objects = nutrition.value as! [String: AnyObject]
                    
                    if let status = objects["reportedStatus"] as? String, status == "1" {
                        
                    } else {
                        print(objects)
                        if self.userType == "Mentee"{
                            if let chatStatus = objects["chatStatus"] as? String, chatStatus == "1" {
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
                                }else{
                                    self.chatStatus = "0"
                                }
                                
                                if let isQueue = objects["isQueue"] as? String{
                                    self.isQueue = isQueue
                                }
                                
                                let dataObj = MessageUserList(image: self.image, assignUserId: self.assignUserId, name: self.name, currentCity: self.currentCity, chatStatus: self.chatStatus, isQueue: self.isQueue)
                                
                                self.chatUserList.append(dataObj)
                            }
                            
                        } else {
                            
                            if let isQueue = objects["isQueue"] as? String, isQueue == "0"{
                                
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
                                }else{
                                    self.chatStatus = "0"
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
                self.tableView.isHidden = true
                self.vwNoData.isHidden = false
            }
            if(self.chatUserList.count > 0){
                print(self.chatUserList.count)
                self.tableView.isHidden = false
                self.vwNoData.isHidden = true
                self.tableView.reloadData()
                // self.collectionView.reloadData()
            }else{
                self.vwNoData.isHidden = false
                self.tableView.isHidden = true
            }
            self.tableView.reloadData()
            
        })
        
    }
    
    func getUserListArch() {
        Helper.showLoader(onVC: self, message: "")
        
        var userID = ""
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        ref.child("mentorAssignUsers").child(userID).observe(.value, with: { snapshot in
            Helper.hideLoader(onVC: self)
            self.archiveUserList1.removeAll()
            if snapshot.childrenCount > 0 {
                self.collectionViewArch.isHidden = false
                self.archiveUserList1.removeAll()
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
                                                                         
                                                                         
                                                                         self.archiveUserList1.append(dataObj)
                        
                    } else {
                    
                   }
                }
            }
                
            if(self.archiveUserList1.count > 0) {
                print(self.archiveUserList1.count)
                self.lblNoArchive.isHidden = true
                self.collectionViewArch.isHidden = false
                self.collectionViewArch.reloadData()
            } else {
                self.lblNoArchive.isHidden = false
               self.collectionViewArch.isHidden = true
            }
            self.collectionViewArch.reloadData()
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
            self.quechatUserList.removeAll()
            if snapshot.childrenCount > 0 {
                self.collectionView.isHidden = false
                self.quechatUserList.removeAll()
                print(snapshot.key)
                
                for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                    let objects = nutrition.value as! [String: AnyObject]
                    print(objects)
                    if let status = objects["reportedStatus"] as? String, status == "1" {
                        
                    } else {
                        
                        if self.userType == "Mentee" {
                            if let chatStatus = objects["chatStatus"] as? String, chatStatus == "0" {
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
                                                                                 
                                                                                 
                                                                                 self.quechatUserList.append(dataObj)
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
                                                      
                                                      
                                                      self.quechatUserList.append(dataObj)
                                
                            }
                        }
                        
                    }
                }
            }else{
                self.collectionView.isHidden = true
                self.lblNoQueue.isHidden = false
            }
            if(self.quechatUserList.count > 0){
                self.collectionView.isHidden = false
                self.lblNoQueue.isHidden = true
                self.collectionView.reloadData()
            }else{
               self.collectionView.isHidden = true
                self.lblNoQueue.isHidden = false
            }
            self.collectionView.reloadData()
        })
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatUserList.count
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
                                images.image = #imageLiteral(resourceName: "ic_avatar")
                                return
                            }
                        }
                        
                        if let url = URL(string: newDict.image) {
                            //images.roundedImage()
                            images.sd_setImage(with: url, completed: block)
                            //cell.imgUser.maskCircle(anyImage: images)
                        }
                    }
                    
                }else{
                   cell.imgUser.image = UIImage(named: "ic_avatar")
                }
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
//        cell.lblUserName.text = newDict.name.firstCharacterUpperCase()
//
//        if newDict.image.isEmpty != true || newDict.image != nil{
//
//            if let images = cell.imgUser {
//                let block: SDExternalCompletionBlock? = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) -> Void in
//                    //print(image)
//                    if (image == nil) {
//                        images.image = #imageLiteral(resourceName: "ic_avatar")
//                        return
//                    }
//                }
//
//                if let url = URL(string: newDict.image) {
//                    //images.roundedImage()
//                    images.sd_setImage(with: url, completed: block)
//                    //cell.imgUser.maskCircle(anyImage: images)
//                }
//            }
            
//        }else{
//            cell.imgUser.image = #imageLiteral(resourceName: "ic_avatar")
//        }
//
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let newDict : MessageUserList
        newDict = chatUserList[indexPath.row]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let chatview = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController{
            chatview.receiver_Id = newDict.assignUserId
            chatview.receiverName = newDict.name
            chatview.onCompletion = {(action) -> Void in
                self.getUserList()
            }
            self.present(chatview, animated:true, completion:nil)
        }
        
    }
    
    func setRightBarButton() {
        let timerBarButton = UIBarButtonItem.init(image: UIImage.init(named: "settings"), style: .plain, target: self, action: #selector(settingClicked(_:)))
        self.navigationItem.rightBarButtonItems = [timerBarButton]
        menuDropDown.anchorView = timerBarButton
        menuDropDown.textColor = .white
        menuDropDown.dataSource = [NSLocalizedString("Profile", comment: ""),NSLocalizedString("My Blog", comment: ""), NSLocalizedString("Logout", comment: "") ]
        menuDropDown.cellNib = UINib(nibName: "MyCell", bundle: nil)
        //Old
        //menuDropDown.backgroundColor = UIColor(hexString: "7be2e7")
         menuDropDown.backgroundColor = UIColor(hexString: "3b5998")
        menuDropDown.customCellConfiguration = { (index:Index,text: String,cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell else { return }
            cell.optionLabel.textColor = .white
            if text == "Profile" {
                cell.logoImageView.image = UIImage(named: "user")
            } else if text == "Logout" {
                cell.logoImageView.image = UIImage(named: "logout")
            } else if text == "My Blog" {
                cell.logoImageView.image = UIImage(named: "people2")
            }
        }
        menuDropDown.selectionAction = { [weak self] (index, item) in
            if index == 0 {
                if self?.userType == "Mentor" {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    if let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileMentorViewController") as? ProfileMentorViewController{
                          profile.isFrom = ""
                        self?.navigationController?.pushViewController(profile, animated: true)
                    }
                } else{
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    if let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileMenteeViewController") as? ProfileMenteeViewController{
                          profile.isFrom = ""
                        self?.navigationController?.pushViewController(profile, animated: true)
                    }
                }
            }
            if index == 1 {
                let profile = self?.storyboard?.instantiateViewController(withIdentifier: "MyBlogsVC") as! MyBlogsVC
                self?.navigationController?.pushViewController(profile, animated: true)
            }
            if index == 2 {
                Helper.showOKCancelAlertWithCompletion(onVC: self!, title: "Logout", message: "Are you sure you want to logout?", btnOkTitle: "Logout", btnCancelTitle: "Cancel") {
                    Helper.delPREF("userId")
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    if let login = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
                        //self.navigationController?.pushViewController(signup, animated: true)
                        self?.present(login, animated:true, completion:nil)
                    }
                }
            }
        }
        menuDropDown.bottomOffset = CGPoint(x: 0, y:44)
    }
    
    @IBAction func settingClicked(_ sender: UIBarButtonItem) {
        menuDropDown.show()
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
extension ChatListViewController : UICollectionViewDataSource,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return quechatUserList.count
        }else{
            return archiveUserList1.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
            
            let newDict : MessageUserList
                   newDict = quechatUserList[indexPath.row]
                   
                   ref.child("users").child(newDict.assignUserId).observeSingleEvent(of: .value, with: { (snapshot) in
                       // Get user value
                       
                       if (snapshot.childrenCount > 0 ){
                           var value = snapshot.value as? NSDictionary
                           //UserModel
                           cell.lblName.titleLabel?.textAlignment = .center
                           if let name = value?["name"] as? String {
                               cell.lblName.setTitle(name.firstCharacterUpperCase(), for: .normal)
                           }
                          
                           if let image = value?["image"] as? String{
                               
                               if let images = cell.imgUser {
                                   let block: SDExternalCompletionBlock? = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) -> Void in
                                       //print(image)
                                       if (image == nil) {
                                           images.image = #imageLiteral(resourceName: "ic_avatar")
                                           return
                                       }
                                   }
                                   
                                   if let url = URL(string: newDict.image) {
                                       //images.roundedImage()
                                       images.sd_setImage(with: url, completed: block)
                                       //cell.imgUser.maskCircle(anyImage: images)
                                   }
                               }
                               
                           }else{
                              cell.imgUser.image = UIImage(named: "ic_avatar")
                           }
                       }
                       
                   }) { (error) in
                       print(error.localizedDescription)
                       
                   }
                   
                   cell.lblName.tag = indexPath.row
                   cell.lblName.isUserInteractionEnabled = true
                   cell.lblName.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
            
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCollectionViewCell", for: indexPath) as! UserCollectionViewCell
            
            let newDict : MessageUserList
                   newDict = archiveUserList1[indexPath.row]
                   
                   ref.child("users").child(newDict.assignUserId).observeSingleEvent(of: .value, with: { (snapshot) in
                       // Get user value
                       
                       if (snapshot.childrenCount > 0 ){
                           var value = snapshot.value as? NSDictionary
                           //UserModel
                           cell.lblName.titleLabel?.textAlignment = .center
                           if let name = value?["name"] as? String {
                               cell.lblName.setTitle(name.firstCharacterUpperCase(), for: .normal)
                           }
                          
                           if let image = value?["image"] as? String{
                               
                               if let images = cell.imgUser {
                                   let block: SDExternalCompletionBlock? = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) -> Void in
                                       //print(image)
                                       if (image == nil) {
                                           images.image = #imageLiteral(resourceName: "ic_avatar")
                                           return
                                       }
                                   }
                                   
                                   if let url = URL(string: newDict.image) {
                                       //images.roundedImage()
                                       images.sd_setImage(with: url, completed: block)
                                       //cell.imgUser.maskCircle(anyImage: images)
                                   }
                               }
                               
                           }else{
                              cell.imgUser.image = UIImage(named: "ic_avatar")
                           }
                       }
                       
                   }) { (error) in
                       print(error.localizedDescription)
                       
                   }
                   
                   cell.lblName.tag = indexPath.row
                   cell.lblName.isUserInteractionEnabled = true
                   cell.lblName.addTarget(self, action: #selector(buttonClicked1), for: .touchUpInside)
            
                    return cell
        }
         
//        let newDict : UserModel
//        newDict = userList[indexPath.row]
//        //cell.Namelabel.text = folder.url
//        cell.lblName.text = newDict.name.firstCharacterUpperCase()
//        if newDict.image.isEmpty != true || newDict.image != nil{
//
//            if let images = cell.imgUser {
//                let block: SDExternalCompletionBlock? = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) -> Void in
//                    //print(image)
//                    if (image == nil) {
//                        images.image = #imageLiteral(resourceName: "ic_avatar")
//                        return
//                    }
//                }
//                if let url = URL(string: newDict.image) {
//                    images.roundedImage()
//                    images.sd_setImage(with: url, completed: block)
//                    //cell.imgUser.maskCircle(anyImage: images)
//                }
//            }
//
//        }else{
//            cell.imgUser.image = #imageLiteral(resourceName: "ic_avatar")
//        }
        
    }
    
    
    @objc func buttonClicked1(sender:UIButton) {
        let buttonRow = sender.tag
        print(buttonRow)
        let newDict: MessageUserList
        if archiveUserList1.count > 0{
            newDict = archiveUserList1[buttonRow]
            if newDict != nil {
                print(newDict.assignUserId)
                var selectedUserId = newDict.assignUserId
                
                if userType == "Mentor" {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                               if let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileMenteeViewController") as? ProfileMenteeViewController{
                                                   profile.isFrom = "userList"
                                                profile.selectedUserId = selectedUserId ?? ""
                                                   self.navigationController?.pushViewController(profile, animated: true)
                                               }
                
                        } else{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                if let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileMentorViewController") as? ProfileMentorViewController{
                                               profile.isFrom = "userList"
                                                profile.selectedUserId = selectedUserId ?? ""
                                                self.navigationController?.pushViewController(profile, animated: true)
                                    }
                            }
                
            }
        }
    }
    
    
    @objc func buttonClicked(sender:UIButton) {
        let buttonRow = sender.tag
        print(buttonRow)
        let newDict: MessageUserList
        if quechatUserList.count > 0{
            newDict = quechatUserList[buttonRow]
            if newDict != nil {
                print(newDict.assignUserId)
                var selectedUserId = newDict.assignUserId
                
                if userType == "Mentor" {
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                               if let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileMenteeViewController") as? ProfileMenteeViewController{
                                                   profile.isFrom = "userList"
                                                profile.selectedUserId = selectedUserId ?? ""
                                                   self.navigationController?.pushViewController(profile, animated: true)
                                               }
                
                        } else{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                if let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileMentorViewController") as? ProfileMentorViewController{
                                               profile.isFrom = "userList"
                                                profile.selectedUserId = selectedUserId ?? ""
                                                self.navigationController?.pushViewController(profile, animated: true)
                                    }
                            }
                
            }
        }
    }
    
    
//    @objc func tapFunction(sender: UISwipeGestureRecognizer) {
//        //self.dismiss(animated: true, completion:nil)
//        //callUser()
//        var selectedUserId = sender. ?? 0
//        print(selectedUserId)
//        if userType == "Mentor" {
//
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                               if let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileMenteeViewController") as? ProfileMenteeViewController{
//                                   profile.isFrom = "userList"
//                                //profile.selectedUserId = selectedUserId!
//                                   self.navigationController?.pushViewController(profile, animated: true)
//                               }
//
//        } else{
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                if let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileMentorViewController") as? ProfileMentorViewController{
//                                   profile.isFrom = "userList"
//                                    //profile.selectedUserId = selectedUserId!
//                                   self.navigationController?.pushViewController(profile, animated: true)
//                    }
//            }
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
       return CGSize(width: 130, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
       //Today Comment
        if self.userType == "Mentee" {
            let newDict : MessageUserList
            newDict = quechatUserList[indexPath.row]

            var isQueue = newDict.isQueue ?? "0"

            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if let chatview = storyBoard.instantiateViewController(withIdentifier: "ChatViewController") as? ChatViewController{
                chatview.receiver_Id = newDict.assignUserId
                chatview.receiverName = newDict.name
                chatview.chatStatus = newDict.chatStatus ?? "0"
                chatview.onCompletion = {(action) -> Void in
                    self.getUserList()
                }
                self.present(chatview, animated:true, completion:nil)
            }
        }
        
        //Old comment
//        let newDict : UserModel
//        newDict = userList[indexPath.row]
//        print(newDict.userType)
//
//        if newDict.userType == "Mentor" {
//
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                       if let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileMenteeViewController") as? ProfileMenteeViewController{
//                           profile.isFrom = "userList"
//                           profile.selectedUserId = newDict.userId
//                           self.navigationController?.pushViewController(profile, animated: true)
//                       }
//
//        } else{
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                       if let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileMentorViewController") as? ProfileMentorViewController{
//                           profile.isFrom = "userList"
//                           profile.selectedUserId = newDict.userId
//                           self.navigationController?.pushViewController(profile, animated: true)
//                       }
//        }
        
        
    }
    
}

// MARK: - CARBONKIT DELEGATE
extension ChatListViewController : CarbonTabSwipeNavigationDelegate {
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        var viewController = UIViewController()
        //return viewController
        switch index {
        case 0:
            if let userlist = storyboard?.instantiateViewController(withIdentifier: "UserListViewController") as?  UserListViewController{
                viewController = userlist
            }
            return viewController
        case 1:
            if let userlist = storyboard?.instantiateViewController(withIdentifier: "ArchiveQueueViewController") as? ArchiveQueueViewController {
                userlist.isFrom = "Listing"
                viewController = userlist
            }
            return viewController
        case 2:
            if let userlist = storyboard?.instantiateViewController(withIdentifier: "ArchiveQueueViewController") as? ArchiveQueueViewController {
                userlist.isFrom = "Archive"
                viewController = userlist
            }
            return viewController
            
        default:
            return storyboard?.instantiateViewController(withIdentifier: "UserListViewController") as! UserListViewController
        }
    }
    
    
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, didMoveAt index: UInt) {
        
    }
}
   



