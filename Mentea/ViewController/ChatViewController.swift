//
//  ChatViewController.swift
//  Mentea
//
//  Created by Apple on 23/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import IQKeyboardManagerSwift
import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import GrowingTextView
import SDWebImage
import SafariServices
import DropDown
import MobileCoreServices

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    //@IBOutlet weak var lblUserName: UILabel!
    
    @IBOutlet weak var txtMessage: GrowingTextView!
    //@IBOutlet weak var img_Flag: UIImageView!
    //@IBOutlet weak var img_Vcall: UIImageView!
    
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    //@IBOutlet weak var ivMore: UIImageView!
    
    
    @IBOutlet weak var lblNoData: UILabel!
    
    var menuDropDown = DropDown()
     var images = [String]()
    
    
    var ref: DatabaseReference!
    var messageList = [MessageModel]()
    
    var senderId = ""
    var receiverId = ""
    var message = ""
    var attachFile = ""
    var date = ""
    var userID = ""
    var receiver_Id = ""
    var which = ""
    
    var imagePath = ""
    
    var receiverName = ""
    
    var userName : String?
    var userImageUrl : String?
    var userLocation : String?
    var userTypeFrom = ""
    
    
    var imagePickerController = UIImagePickerController()
    //var videoURL : NSURL?
    //var videoUrlPath: String?
    
    typealias CompletionBlock = (_ isUpdate: Bool) -> Void
    var onCompletion:CompletionBlock?
    var userType = ""
    var chatStatus = ""
    var callSenderImage = ""
    var callSenderName = ""
    var isFrom = ""
    var fileName = ""
    
    @IBOutlet weak var vwBottom: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = receiverName ?? "Chat"
        lblNoData.isHidden = true
        userType = Helper.getPREF("userType") ?? ""
        ref = Database.database().reference()
        txtMessage.inputAccessoryView = UIView()
        txtMessage.autocorrectionType = .no
        print(chatStatus)
        if (isFrom == "chat"){
            vwBottom.isHidden = false
            setRightBarButton()
        }else{
            //vwBottom.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0))
            vwBottom.isHidden = true
        }
        
        
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        if let id = Helper.getPREF("userId") {
            ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let name = value?["name"] as? String {
                    self.callSenderName = name
                }
                
                if let image = value?["image"] as? String{
                    self.callSenderImage = image
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
        
        //lblUserName.text = receiverName.capitalized
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName:
            "LeftChatWithDoelseCell", bundle: nil), forCellReuseIdentifier: "LeftChatWithDoelseCell")
        tableView.register(UINib.init(nibName:"RightChatWithDoelseCell", bundle: nil), forCellReuseIdentifier: "RightChatWithDoelseCell")
        //Imagesss
        tableView.register(UINib.init(nibName:
            "LeftChatImageCell", bundle: nil), forCellReuseIdentifier: "LeftChatImageCell")
        tableView.register(UINib.init(nibName: "RightChatImageCell" , bundle: nil), forCellReuseIdentifier: "RightChatImageCell")
        //ALL Media
        
        tableView.register(UINib.init(nibName:
            "LeftChaFileCell", bundle: nil), forCellReuseIdentifier: "LeftChaFileCell")
        tableView.register(UINib.init(nibName: "RightChatFileCell" , bundle: nil), forCellReuseIdentifier: "RightChatFileCell")
        
        
        //img_Flag.isUserInteractionEnabled = true
        //img_Flag.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleFlagTap(_:))))
        //img_Vcall.isUserInteractionEnabled = true
        //img_Vcall.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleCallTap(_:))))
        
        //ivMore.isUserInteractionEnabled = true
        //ivMore.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(settingClicked(_:))))
        
        if let id = Helper.getPREF("userId") {
            ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let name = value?["name"] as? String {
                    self.userName = name
                }
                if let currentCity = value?["currentCity"] as? String {
                    self.userLocation = currentCity
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        //lblUserName.isUserInteractionEnabled = true
        //let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        
        //lblUserName.addGestureRecognizer(tap)
        
    }
    
    func updateChatStatus(){
        
        if (self.chatStatus == "0"){
            if userType == "Mentee" {
                self.ref.child("mentorAssignUsers").child(userID).child(receiver_Id).updateChildValues([
                    "chatStatus": "1"
                ])
                
                self.ref.child("mentorAssignUsers").child(receiver_Id).child(userID).updateChildValues([
                    "chatStatus": "1"
                ])
            }else{
                //chatId = receiver_Id+"_"+userID
                self.ref.child("mentorAssignUsers").child(receiver_Id).child(userID).updateChildValues([
                    "chatStatus": "1"
                ])
                
                self.ref.child("mentorAssignUsers").child(userID).child(receiver_Id).updateChildValues([
                    "chatStatus": "1"
                ])
            }
        }
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        //self.dismiss(animated: true, completion:nil)
        //callUser()
        print("call function")
    }
    
    func callUser(){
        print(userType)
        if userType == "Mentor" {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileMenteeViewController") as? ProfileMenteeViewController{
                profile.isFrom = "userList"
                profile.selectedUserId = receiver_Id
                self.navigationController?.pushViewController(profile, animated: true)
            }
            
        } else{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if let profile = storyBoard.instantiateViewController(withIdentifier: "ProfileMentorViewController") as? ProfileMentorViewController{
                profile.isFrom = "userList"
                profile.selectedUserId = receiver_Id
                self.navigationController?.pushViewController(profile, animated: true)
            }
        }
    }
    
    func callToAnother(callType: String) {
        
        let params : [String:Any] = ["senderName":callSenderName,
                                     "senderImage":callSenderName,
                                     "callType":callType,
                                     "isIncomingCall" : "yes"]
        
        print("\(params) \(receiver_Id)")
        
        
        ref.child("calls").child(receiver_Id).updateChildValues(params) { (error, databaseReference) in
            
            if error == nil {
                print("updated")
                
                if callType == "audio" {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    if let voice = storyBoard.instantiateViewController(withIdentifier: "VoiceChatViewController") as? VoiceChatViewController {
                        voice.receiver_Id = self.receiver_Id
                        voice.modalPresentationStyle = .overCurrentContext
                        self.present(voice, animated: true, completion: nil);
                    }
                    
                } else {
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    if let video = storyBoard.instantiateViewController(withIdentifier: "VideoChatViewController") as? VideoChatViewController {
                        video.receiver_Id = self.receiver_Id
                        video.modalPresentationStyle = .overCurrentContext
                        self.present(video, animated: true, completion: nil);
                    }
                }
                
            } else{
                print(error?.localizedDescription ?? "Error update")
            }
            
        }
        
        
    }
    
    func setRightBarButton() {
        let timerBarButton = UIBarButtonItem.init(image: UIImage.init(named: "more"), style: .plain, target: self, action: #selector(settingClicked(_:)))
        self.navigationItem.rightBarButtonItems = [timerBarButton]
        menuDropDown.anchorView = timerBarButton
        
        menuDropDown.dataSource = [NSLocalizedString("Audio Call", comment: ""),NSLocalizedString("Video Call", comment: ""), NSLocalizedString("Report", comment: "") ,NSLocalizedString("End Chat", comment: "")]
        menuDropDown.cellNib = UINib(nibName: "MyCell1", bundle: nil)
        //Old
        //menuDropDown.backgroundColor = UIColor(hexString: "7be2e7")
        menuDropDown.backgroundColor = UIColor(hexString: "10c2f0")
        menuDropDown.selectionBackgroundColor = UIColor(hexString: "10c2f0") ?? UIColor.blue
        menuDropDown.textColor = .white
        menuDropDown.selectedTextColor = .white
        menuDropDown.customCellConfiguration = { (index:Index,text: String,cell: DropDownCell) -> Void in
            guard let cell = cell as? MyCell1 else { return }
            //cell.contentView.backgroundColor = UIColor(hexString: "#5EDBD0")
            cell.optionLabel.textColor = .white
            if text == "Audio Call" {
                cell.logoImageView.image = UIImage(named: "audio_icon")
            } else if text == "Video Call" {
                cell.logoImageView.image = UIImage(named: "video_icon-1")
            } else if text == "Report" {
                cell.logoImageView.image = UIImage(named: "flag_icon")
            }else if text == "End Chat" {
                cell.logoImageView.image = UIImage(named: "block")
            }
        }
        
        menuDropDown.selectionAction = { [weak self] (index, item) in
            
            if index == 0 {
                self?.callToAnother(callType: "audio")
            }
            
            if index == 1 {
                self?.callToAnother(callType: "video")
            }
            
            if index == 2 {
                
                Helper.showOKCancelAlertWithCompletion(onVC: self!, title: "Report", message: "Are you sure want to report this Mentee? You will not be able to interact with him", btnOkTitle: "Yes", btnCancelTitle: "No") {
                    if self?.userType == "Mentor"{
                        
                        self?.ref.child("mentorAssignUsers").child(Auth.auth().currentUser?.uid ?? "").child(self?.receiver_Id ?? "").updateChildValues([
                            "reportedStatus": "1"
                        ])
                        
                        self?.ref.child("mentorAssignUsers").child(self?.receiver_Id ?? "").child(Auth.auth().currentUser?.uid ?? "").updateChildValues([
                            "reportedStatus": "1"
                        ])
                        
                        self?.getCount(userId: Auth.auth().currentUser?.uid ?? "")
                        self?.getCount(userId: self?.receiver_Id ?? "")
                    } else{
                        
                        self?.ref.child("mentorAssignUsers").child(Auth.auth().currentUser?.uid ?? "").child(self?.receiver_Id ?? "").updateChildValues([
                            "reportedStatus": "1"
                        ])
                        
                        self?.ref.child("mentorAssignUsers").child(self?.receiver_Id ?? "").child(Auth.auth().currentUser?.uid ?? "").updateChildValues([
                            "reportedStatus": "1"
                        ])
                        self?.getCount(userId: Auth.auth().currentUser?.uid ?? "")
                        self?.getCount(userId: self?.receiver_Id ?? "")
                        
                    }
                    
                    if let isCompletion = self?.onCompletion {
                        isCompletion(true)
                    }
                    if let nav = self?.navigationController {
                        nav.popViewController(animated: true)
                    } else {
                        self?.dismiss(animated: true, completion: nil)
                    }
                    
                }
                
                
            }
            if index == 3 {
                
                Helper.showOKCancelAlertWithCompletion(onVC: self!, title: "End Chat", message: "Are you sure want to end your conversation with this Mentee? You will not be able to interact with him", btnOkTitle: "Yes", btnCancelTitle: "No") {
                    if self?.userType == "Mentor"{
                        
                        self?.ref.child("mentorAssignUsers").child(Auth.auth().currentUser?.uid ?? "").child(self?.receiver_Id ?? "").updateChildValues([
                            "reportedStatus": "1"
                        ])
                        
                        self?.ref.child("mentorAssignUsers").child(self?.receiver_Id ?? "").child(Auth.auth().currentUser?.uid ?? "").updateChildValues([
                            "reportedStatus": "1"
                        ])
                        
                        self?.getCount(userId: Auth.auth().currentUser?.uid ?? "")
                        self?.getCount(userId: self?.receiver_Id ?? "")
                    } else{
                        self?.ref.child("mentorAssignUsers").child(Auth.auth().currentUser?.uid ?? "").child(self?.receiver_Id ?? "").updateChildValues([
                            "reportedStatus": "1"
                        ])
                        
                        self?.ref.child("mentorAssignUsers").child(self?.receiver_Id ?? "").child(Auth.auth().currentUser?.uid ?? "").updateChildValues([
                            "reportedStatus": "1"
                        ])
                        self?.getCount(userId: Auth.auth().currentUser?.uid ?? "")
                        self?.getCount(userId: self?.receiver_Id ?? "")
                        
                    }
                    
                    if let isCompletion = self?.onCompletion {
                        isCompletion(true)
                    }
                    if let nav = self?.navigationController {
                        nav.popViewController(animated: true)
                    } else {
                        self?.dismiss(animated: true, completion: nil)
                    }
                    
                }
            }
        }
        menuDropDown.bottomOffset = CGPoint(x: 0, y:44)
    }
    
    @IBAction func settingClicked(_ sender: UIBarButtonItem) {
        menuDropDown.show()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addObserver()
        getAllConversation()
        
        tabBarController?.tabBar.isHidden = true
        edgesForExtendedLayout = UIRectEdge.bottom
        extendedLayoutIncludesOpaqueBars = true
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.removeObserver()
    }
    
    // MARK:- NOTIFICATIONCENTER
    func addObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleFlagTap(_ sender: UITapGestureRecognizer) {
        Helper.showOKCancelAlertWithCompletion(onVC: self, title: "Report", message: "Are you sure want to report this Mentee?", btnOkTitle: "Yes", btnCancelTitle: "No") {
            self.ref.child("mentorAssignUsers").child(Auth.auth().currentUser?.uid ?? "").child(self.receiver_Id).updateChildValues([
                "reportedStatus": "1"
            ])
            if let isCompletion = self.onCompletion {
                isCompletion(true)
            }
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func handleCallTap(_ sender: UITapGestureRecognizer) {
        
        let email = Helper.getPREF("userEmail") ?? ""
        facetime(phoneNumber: email)
    }
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        //IQKeyboardManager.sharedManager().enable = false
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            print(keyboardRectangle)
            let keyboardHeight = keyboardRectangle.height
            print(keyboardHeight)
            UIView.animate(withDuration: 0.2, animations: {
                if CurrentDevice.iPhoneX || CurrentDevice.iPhoneXS_MAX {
                    self.viewBottomConstraint.constant = -keyboardHeight + 34
                } else {
                    self.viewBottomConstraint.constant = -keyboardHeight
                }
                self.view.setNeedsLayout()
                self.view.layoutIfNeeded()
            })
            
            DispatchQueue.main.async {
                self.scrollToBottom()
            }
        }
    }
    
    
    func scrollToBottom() {
//        let lastSectionIndex = tableView.numberOfSections - 1
//        let lastRowIndex = tableView.numberOfRows(inSection: lastSectionIndex) - 1
//        let pathToLastRow = IndexPath.init(row: lastRowIndex, section: lastSectionIndex)
//        tableView.scrollToRow(at: pathToLastRow, at: .none, animated: false)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) {

        let numberOfSections = self.tableView.numberOfSections
        let numberOfRows = self.tableView.numberOfRows(inSection: numberOfSections-1)
               if numberOfRows > 0 {
                   let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: false)
               }
           }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        //IQKeyboardManager.sharedManager().enable = false
        UIView.animate(withDuration: 0.2, animations: {
            self.viewBottomConstraint.constant = 0
            self.view.setNeedsLayout()
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func handleRecord(_ sender: Any) {
        
//        if (UIImagePickerController.isSourceTypeAvailable(.camera) == false) {
//            Helper.showOKAlert(onVC: self, title: "Alert", message: "Camera permission required")
//        }else{
            self.showActionAlert(onVC: self, onTakePhoto:
            self.takeNewPhotoFromCamera , onChooseFromGallery: self.choosePhotoFromExistingImages)
            //imagePickerController.sourceType = .camera
            ///imagePickerController.delegate = self
            //imagePickerController.mediaTypes = ["public.movie"]
            //present(imagePickerController, animated: true, completion: nil)
        //}
    }
     
    @available(iOS 11.0, *)
    @objc func handleViewVideo(_ sender: UITapGestureRecognizer) {
        let tappedImage = sender.view as! UIImageView
        var newDict = self.messageList[tappedImage.tag]
        if let url = URL(string: newDict.attachFile) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    func getAllConversation(){
        
        //var chatId = userID+"_"+receiver_Id
        var chatId = ""
        print(userType)
        if userType == "Mentee" {
            chatId = userID+"_"+receiver_Id
        }else{
            chatId = receiver_Id+"_"+userID
        }
        
        
        print(chatId)
        ref.child("messages").child(chatId).observe(.value, with: { snapshot in
            Helper.hideLoader(onVC: self)
            self.messageList.removeAll()
            if snapshot.childrenCount > 0 {
                self.lblNoData.isHidden = true
                self.tableView.isHidden = false
                //self.userList.removeAll()
                print(snapshot.key)
                
                for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                    let objects = nutrition.value as! [String: AnyObject]
                    print(objects)
                    
                    //                    if let dsenderId = objects["senderId"] as? String{
                    //
                    //                        if let dreceiverId = objects["receiverId"] as? String{
                    //                            if (dsenderId == self.userID && dreceiverId == self.receiver_Id || dsenderId == self.receiver_Id && dreceiverId == self.userID){
                    
                    //logic here
                    if let senderId = objects["senderId"] as? String{
                        self.senderId = senderId
                    }
                    if let receiverId = objects["receiverId"] as? String{
                        self.receiverId = receiverId
                    }
                    
                    if let message = objects["message"] as? String{
                        self.message = message
                    }
                    
                    if let attachFile = objects["attachFile"] as? String{
                        self.attachFile = attachFile
                        print(attachFile)
                    }
                    
                    if let date = objects["date"] as? String{
                        self.date = date
                    }
                    if let fileName = objects["fileName"] as? String{
                        self.fileName = fileName
                    }
                    
                    
                    let dataObj = MessageModel(senderId: self.senderId, receiverId: self.receiverId, message: self.message, attachFile: self.attachFile, date: self.date, fileName: self.fileName)
                    self.messageList.append(dataObj)
                    
                }
                //logic end here
                //                        }
                //                    }
                
            }else{
                if (self.isFrom == "chat")
                {
                    self.lblNoData.text = "No Chat Found. Be the first one to start conversation"
                }
                else
                {
                    self.lblNoData.text = "Sorry!! No Chat Found"
                }
                self.lblNoData.isHidden = false
                self.tableView.isHidden = true
            }
            if(self.messageList.count > 0){
                //self.tableView.isHidden = false
                self.lblNoData.isHidden = true
                self.tableView.reloadData()
            } else {
                if (self.isFrom == "chat")
                {
                    self.lblNoData.text = "No Chat Found. Be the first one to start conversation"
                }
                else
                {
                    self.lblNoData.text = "Sorry!! No Chat Found"
                }
                self.lblNoData.isHidden = false
                //self.tableView.isHidden = true
            }
        })
    }
    
    
    

    
    func getCount(userId: String) {
           ref.child("users").child(userId).observeSingleEvent(of: .value) { (snapshot) in
               if snapshot.childrenCount > 0{
                   let objects = snapshot.value as! [String: AnyObject]
                   print(objects)
                   var noOfmenteeadded = "0"
                   var noOfmentee = "0"
                   if let no_of_menteeadded = objects["no_of_menteeadded"] as? String{
                       noOfmenteeadded = no_of_menteeadded
                   }
                   
                   if let no_of_mentee = objects["no_of_mentee"] as? String{
                       noOfmentee = no_of_mentee
                   }
                   
                   let noMentee = "\((Int(noOfmentee) ?? 0))"
                   let noMenteeadded = "\((Int(noOfmenteeadded) ?? 0))"
                   
                   print(noMentee)
                   print(noMenteeadded)
                
                   if (noMenteeadded != "0") {
                       self.updateCount(countstr: noMenteeadded, menteeId: userId)
                   }
               }
           }
       }

       func updateCount(countstr: String,menteeId: String){
           
           var userID = ""
           if Auth.auth().currentUser != nil {
               userID = Auth.auth().currentUser?.uid ?? ""
           }
           
           let like = "\((Int(countstr) ?? 0) - 1)"
              //guard let key = self.ref.child("blogs").child(blogId).child("likes").childByAutoId().key else { return }

           let params = ["no_of_menteeadded" : like]

           self.ref.child("users").child(menteeId).updateChildValues([
                  "no_of_menteeadded": like
           ])
           
       }
    
    
    @IBAction func handleSend(_ sender: Any) {
        self.view.endEditing(true)
        let message = self.txtMessage.text ?? ""
        if message.isEmpty == true {
            Helper.showOKAlert(onVC: self, title: "Alert", message: "Please write something")
        } else {
            sendMessage(message: message)
            self.txtMessage.text = ""
        }
        
    }
    
    @IBAction func handleBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        if indexPath.row % 2 == 0{
        //               let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell") as! ReceiverTableViewCell
        //            return cell
        //        }else{
        //            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell") as! SenderTableViewCell
        //                       return cell
        //        }
        
        
        let newDict : MessageModel
        newDict = messageList[indexPath.row]
        
        let sender_id = newDict.senderId ?? ""
        let attachFile = newDict.attachFile ?? ""
        let fileNamee = newDict.fileName ?? ""
        print ("\(attachFile) :attachFileee")
        
        if (userID == sender_id ){
            
            if (attachFile.contains(".jpg") || attachFile.contains(".jpeg") || attachFile.contains(".png")) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightChatImageCell", for: indexPath) as! RightChatImageCell
                cell.selectionStyle = .none
                let image = attachFile
                print(image)
                if let image = attachFile as? String {
                
                    if let url = URL(string: image) {
                        cell.imgRight.sd_setImage(with: url, completed: nil)
                    } else {
                        cell.imgRight.image = UIImage(named: "ic_avatar")
                    }
                }
                
                
                if let sDate =  newDict.date{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let myDate = dateFormatter.date(from: sDate)!
                    
                    dateFormatter.dateFormat = "hh mm a"
                    let somedateString = dateFormatter.string(from: myDate)
                    cell.lblDate.text = somedateString
                }
                //cell.lblDate.text = ""
                return cell
            } else if (attachFile.contains(".mov")  || attachFile.contains(".mp4") || attachFile.contains(".3gp")){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightChatFileCell", for: indexPath) as! RightChatFileCell
                cell.imgFileType.image = UIImage.init(named: "video_icon")
                cell.imgFileType.tag = indexPath.row
                cell.imgFileType.isUserInteractionEnabled = true
                if #available(iOS 11.0, *) {
                   // cell.imgFileType.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleViewVideo(_:))))
                } else {
                    // Fallback on earlier versions
                }
                cell.selectionStyle = .none
                
                if let atFile = attachFile as? String{
                    //cell.lblText.text = atFile.lastPathComponent
                }
                
                if let sDate =  newDict.date {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let myDate = dateFormatter.date(from: sDate)!
                    
                    dateFormatter.dateFormat = "hh mm a"
                    let somedateString = dateFormatter.string(from: myDate)
                    cell.lblDate.text = somedateString
                }
                 cell.lblText.text = newDict.fileName ?? "Video"
                //cell.lblDate.text = ""
                return cell
            } else if (attachFile.contains(".pdf") || attachFile.contains(".doc") || attachFile.contains(".docx") || attachFile.contains(".ppt") || attachFile.contains(".pptx") || attachFile.contains(".xls") || attachFile.contains(".xlsx")){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "RightChatFileCell", for: indexPath) as! RightChatFileCell
                cell.selectionStyle = .none
                
                if let atFile = attachFile as? String{
                    //cell.lblText.text = atFile.lastPathComponent
                    let fullName = String(atFile.lastPathComponent)
                    let fullNameArr = fullName.components(separatedBy: "_")
                    // or simply:
                    // let fullNameArr = fullName.characters.split{" "}.map(String.init)
                    
                    //fullNameArr[0] // First
                    //fullNameArr[1]
                    var lastName: String? = fullNameArr.count > 2 ? fullNameArr[2] : atFile.lastPathComponent
                    cell.lblText.text = fileNamee
                    
                    
                }
                
                //                        if let atFile = attachFile as? String{
                //                            cell.lblText.text = atFile.lastPathComponent
                //                        }
                
                if (attachFile.contains(".pdf")){
                    cell.imgFileType.image = UIImage.init(named: "pdf_ison")
                }else if (attachFile.contains(".doc")){
                    cell.imgFileType.image = UIImage.init(named: "msword_icon")
                } else if (attachFile.contains(".docx")){
                    cell.imgFileType.image = UIImage.init(named: "msword_icon")
                } else if (attachFile.contains(".ppt")){
                    cell.imgFileType.image = UIImage.init(named: "ppt_icon")
                } else if (attachFile.contains(".pptx")){
                    cell.imgFileType.image = UIImage.init(named: "ppt_icon")
                } else if (attachFile.contains(".xls")){
                    cell.imgFileType.image = UIImage.init(named: "excel_icon")
                } else if (attachFile.contains(".xlsx")){
                    cell.imgFileType.image = UIImage.init(named: "excel_icon")
                } else {
                    cell.imgFileType.image = UIImage.init(named: "doc_icon")
                }
                
                if let sDate =  newDict.date{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let myDate = dateFormatter.date(from: sDate)!
                    
                    dateFormatter.dateFormat = "hh mm a"
                    let somedateString = dateFormatter.string(from: myDate)
                    cell.lblDate.text = somedateString
                }
                //cell.lblDate.text = ""
                return cell
                
            }
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "RightChatWithDoelseCell", for: indexPath) as! RightChatWithDoelseCell
            cell.selectionStyle = .none
            
            if let message = newDict.message{
                cell.lblMessage.text = message
            }
            
            if let sDate =  newDict.date{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let myDate = dateFormatter.date(from: sDate)!
                
                dateFormatter.dateFormat = "hh mm a"
                let somedateString = dateFormatter.string(from: myDate)
                cell.lblDate.text = somedateString
            }
            //cell.lblDate.text = ""
            return cell
        } else {
            if (attachFile.contains(".jpg") || attachFile.contains(".jpeg") || attachFile.contains(".png")) {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "LeftChatImageCell", for: indexPath) as! LeftChatImageCell
                cell.selectionStyle = .none
                
                if let image = attachFile as? String {
                    if let url = URL(string: image) {
                                        cell.imgLeft.sd_setImage(with: url, completed: nil)
                                    } else {
                                        cell.imgLeft.image = UIImage(named: "ic_avatar")
                                    }
                }
                if let sDate =  newDict.date{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let myDate = dateFormatter.date(from: sDate)!
                    
                    dateFormatter.dateFormat = "hh mm a"
                    let somedateString = dateFormatter.string(from: myDate)
                    cell.lblDate.text = somedateString
                }
                
                return cell
            }else if (attachFile.contains(".mov")  || attachFile.contains(".mp4") || attachFile.contains(".3gp")){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "LeftChaFileCell", for: indexPath) as! LeftChaFileCell
                cell.selectionStyle = .none
                
                if let atFile = attachFile as? String{
                    //                    cell.lblText.text = atFile.lastPathComponent
                }
                
                cell.imgFileType.image = UIImage.init(named: "video_icon")
                cell.imgFileType.tag = indexPath.row
                cell.imgFileType.isUserInteractionEnabled = true
                if #available(iOS 11.0, *) {
                    //cell.imgFileType.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleViewVideo(_:))))
                } else {
                    // Fallback on earlier versions
                }
                
                if let sDate =  newDict.date{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let myDate = dateFormatter.date(from: sDate)!
                    
                    dateFormatter.dateFormat = "hh mm a"
                    let somedateString = dateFormatter.string(from: myDate)
                    cell.lblDate.text = somedateString
                }
                cell.lblText.text = newDict.fileName ?? "Video"
                
                return cell
                
            } else if (attachFile.contains(".pdf") || attachFile.contains(".doc") || attachFile.contains(".docx") || attachFile.contains(".ppt") || attachFile.contains(".pptx") || attachFile.contains(".xls") || attachFile.contains(".xlsx")){
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "LeftChaFileCell", for: indexPath) as! LeftChaFileCell
                cell.selectionStyle = .none
                
                
                if let atFile = attachFile as? String{
                    //cell.lblText.text = atFile.lastPathComponent
                    let fullName = atFile.lastPathComponent
                    let fullNameArr = fullName.components(separatedBy: "_")
                    // or simply:
                    // let fullNameArr = fullName.characters.split{" "}.map(String.init)
                    
                    //fullNameArr[0] // First
                    //fullNameArr[1]
                    let lastName: String? = fullNameArr.count > 2 ? fullNameArr[2] : atFile.lastPathComponent
                    cell.lblText.text = fileNamee
                    
                }
                
                //                        if let atFile = attachFile as? String{
                //                            cell.lblText.text = atFile.lastPathComponent
                //                        }
                
                if (attachFile.contains(".pdf")){
                    cell.imgFileType.image = UIImage.init(named: "pdf_ison")
                }else if (attachFile.contains(".doc")){
                    cell.imgFileType.image = UIImage.init(named: "msword_icon")
                } else if (attachFile.contains(".docx")){
                    cell.imgFileType.image = UIImage.init(named: "msword_icon")
                } else if (attachFile.contains(".ppt")){
                    cell.imgFileType.image = UIImage.init(named: "ppt_icon")
                } else if (attachFile.contains(".pptx")){
                    cell.imgFileType.image = UIImage.init(named: "ppt_icon")
                } else if (attachFile.contains(".xls")){
                    cell.imgFileType.image = UIImage.init(named: "excel_icon")
                } else if (attachFile.contains(".xlsx")){
                    cell.imgFileType.image = UIImage.init(named: "excel_icon")
                } else {
                    cell.imgFileType.image = UIImage.init(named: "doc_icon")
                }
                
                if let sDate =  newDict.date{
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let myDate = dateFormatter.date(from: sDate)!
                    
                    dateFormatter.dateFormat = "hh mm a"
                    let somedateString = dateFormatter.string(from: myDate)
                    cell.lblDate.text = somedateString
                }
                
                return cell
                
            }
            
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LeftChatWithDoelseCell", for: indexPath) as! LeftChatWithDoelseCell
            cell.selectionStyle = .none
            
            if let message = newDict.message{
                cell.lblMessage.text = message
            }
            
            if let sDate =  newDict.date{
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let myDate = dateFormatter.date(from: sDate)!
                
                dateFormatter.dateFormat = "hh mm a"
                let somedateString = dateFormatter.string(from: myDate)
                cell.lblDate.text = somedateString
            }
            
            return cell
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newDict : MessageModel
               newDict = messageList[indexPath.row]
               
               //let newDict = chatList[indexPath.row]
               
               if let attFile = newDict.attachFile as? String{
                   
                   if (attFile.contains(".jpg") || attFile.contains(".jpeg") || attFile.contains(".png")) {
                       self.images.removeAll()
                       self.images.append(attFile)
                       
                       let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                       
                       let zoom = storyBoard.instantiateViewController(withIdentifier: "FullImageViewController") as! FullImageViewController
                       zoom.selectedIndex = 0 //indexPath.row
                       zoom.arrImages = self.images
                       self.navigationController?.pushViewController(zoom, animated: true)
                       
                   } else if(attFile.contains(".mov")  || attFile.contains(".mp4") || attFile.contains(".3gp") || attFile.contains(".MOV") || attFile.contains(".MP4") || attFile.contains(".3GP")){
                       
                       let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                       
                       let video = storyBoard.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
                       video.videoUrl = attFile //indexPath.row
                       
                       self.navigationController?.pushViewController(video, animated: true)
                       
                   } else {
                       
                       if attFile != nil && attFile.isEmpty != true{
                           UIApplication.shared.openURL(NSURL(string: attFile)! as URL)
                       }
                       
                   }
                   
                   
               }
    }
    
    func sendMessage(message : String)  {
        var userID = ""
        self.lblNoData.isHidden = true
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        
        var chatId = ""
        print(userType)
        if userType == "Mentee" {
            chatId = userID+"_"+receiver_Id
        }else{
            chatId = receiver_Id+"_"+userID
        }
        
        var messageId = ref.childByAutoId().key ?? ""
        
        
        
        let params : [String:Any] = ["senderId":userID,
                                     "receiverId" : receiver_Id,
                                     "messageId" : messageId,
                                     "message":message,
                                     "attachFile" : "",
                                     "date": dateString,
                                     "fileName":""]
        ref.child("messages").child(chatId).child(messageId).updateChildValues(params) { (Error, DatabaseReference) in
            
            if Error != nil{
                print(Error?.localizedDescription ?? "")
            }else{
                print("message sent")
                self.updateChatStatus()
            }
        }
    }
    
    func sendVideoMessage(videoUrl : String)  {
           var userID = ""
        self.lblNoData.isHidden = true
           
           if Auth.auth().currentUser != nil {
               userID = Auth.auth().currentUser?.uid ?? ""
           }
           
           let dateFormatter : DateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           let date = Date()
           let dateString = dateFormatter.string(from: date)
        
           var chatId = ""
            print(userType)
            if userType == "Mentee" {
                chatId = userID+"_"+receiver_Id
            }else{
                chatId = receiver_Id+"_"+userID
            }
        
            var messageId = ref.childByAutoId().key ?? ""
           
           let params : [String:Any] = ["senderId":userID,
                                        "receiverId" : receiver_Id,
                                        "messageId" : messageId,
                                        "attachFile" : videoUrl,
                                        "date": dateString]
        ref.child("messages").child(chatId).child(messageId).updateChildValues(params) { (Error, DatabaseReference) in
               
               if Error != nil{
                   print(Error?.localizedDescription ?? "")
               }else{
                   print("message sent")
                self.updateChatStatus()
               }
           }
       }
    
    func createUpload(for videoURL: URL) {
         DispatchQueue.main.async {
            Helper.showLoader(onVC: self, message: "")
        }
        let date = Date().timeIntervalSince1970 //string(format: "yyyy-MM-dd HH:mm:ss")
        
        let storageReference = Storage.storage().reference().child("videoMessages/"+"\(date)"+".mp4")
        storageReference.putFile(from: videoURL, metadata: nil) { (metadata, error) in
             DispatchQueue.main.async {
                Helper.hideLoader(onVC: self)
            }
//            if error == nil {
//
//                print(metadata?.path ?? "")
//                let videoUrlPath = metadata?.path
//                print("Successful video upload")
//                self.sendVideoMessage(videoUrl: videoUrlPath ?? "")
//            }
            
            if error == nil {
            
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    return
                }
                // Metadata contains file metadata such as size, content-type.
                let size = metadata.size
                // You can also access to download URL after upload.
                storageReference.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    
                    print(downloadURL.absoluteString ?? "")
                    let videoUrlPath = downloadURL
                    print("Successful document upload")
                    self.sendVideoMessage(videoUrl: downloadURL.absoluteString ?? "")
                    //self.sendImageFir(url: downloadURL.absoluteString ?? "" ,fileName: "\(date)"+".mov")
                    //self.sendImageFir(url: downloadURL.absoluteString ?? "",fileName: filename)
                    
                }
            }else {
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    
    
    
    
}

extension ChatViewController : UIImagePickerControllerDelegate , UINavigationControllerDelegate,UIDocumentMenuDelegate,UIDocumentPickerDelegate{
    
    
    
    
    
        func showActionAlert(onVC viewController: UIViewController, onTakePhoto:@escaping ()->(), onChooseFromGallery:@escaping ()->()) {
            DispatchQueue.main.async {
                let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
                
                let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                    print("Cancel")
                }
                actionSheetControllerIOS8.addAction(cancelActionButton)
                
                let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
                    print("Take Photo")
                    self.which = "image"
                    onTakePhoto()
                }
                actionSheetControllerIOS8.addAction(saveActionButton)
                
                let deleteActionButton: UIAlertAction = UIAlertAction(title: "Choose from library", style: .default) { action -> Void in
                    print("Choose from library")
                    self.which = "image"
                    onChooseFromGallery()
                }
                actionSheetControllerIOS8.addAction(deleteActionButton)
                
                let makeVideoActionButton: UIAlertAction = UIAlertAction(title: "Make Video", style: .default) { action -> Void in
                    print("Take Photo")
                    self.which = "video"
                    self.takeNewVideoFromCamera()
                }
                actionSheetControllerIOS8.addAction(makeVideoActionButton)
                
                let chooseVideoActionButton: UIAlertAction = UIAlertAction(title: "Choose Video", style: .default) { action -> Void in
                    print("Choose from library")
                    self.which = "video"
                    self.chooseVideoFromExistingVideos()
                }
                 actionSheetControllerIOS8.addAction(chooseVideoActionButton)
                
                let fileActionButton: UIAlertAction = UIAlertAction(title: "Choose File", style: .default) { action -> Void in
                    print("Choose file")
                    
                    self.clickFunction()
                }
                actionSheetControllerIOS8.addAction(fileActionButton)
                
                if let popoverPresentationController = actionSheetControllerIOS8.popoverPresentationController {
                    popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                    
                    var rect = viewController.view.frame;
                    
                    rect.origin.x = viewController.view.frame.size.width / 20;
                    rect.origin.y = viewController.view.frame.size.height / 20;
                    
                    popoverPresentationController.sourceView = viewController.view
                    popoverPresentationController.sourceRect = rect
                }
                
                actionSheetControllerIOS8.view.tintColor = UIColor.black
                viewController.present(actionSheetControllerIOS8, animated: true, completion: nil)
            }
        }
    
    
    func takeNewVideoFromCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        picker.allowsEditing = false
        picker.mediaTypes = [kUTTypeMovie as String]
        self.present(picker, animated: true, completion: nil)
    }
    
    func chooseVideoFromExistingVideos() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)!
        picker.mediaTypes = ["public.movie"]
        
        picker.allowsEditing = false
        present(picker, animated: true, completion: nil)
    }
    
    func takeNewPhotoFromCamera() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerController.SourceType.camera
        //picker.mediaTypes = ["",""]
        self.present(picker, animated: true, completion: nil)
    }
    
    func choosePhotoFromExistingImages() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    
    func clickFunction(){
        
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.text", "public.data","public.pdf", "public.doc","com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document",kUTTypePDF as String], in: .import)
        
        //let importMenu = UIDocumentMenuViewController(documentTypes: ["com.microsoft.word.doc","org.openxmlformats.wordprocessingml.document",kUTTypePDF as String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //
      
        
            if (self.which == "image" ){

                guard let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return  }
                DispatchQueue.main.async {
                    self.createUploadFir(for: editedImage)
                }

            } else if(self.which == "video"){

                if let meadiaUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
                    print(meadiaUrl)
                    meadiaUrl.videoFileSizeInMB()

                    let videoData : Data!
                    do {
                        try videoData = Data(contentsOf: meadiaUrl as URL)
                        var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
                        let documentsDirectory = paths[0]
                        let tempPath = documentsDirectory.appendingFormat("/vid1.mp4")
                        let url = URL(fileURLWithPath: tempPath)
                        do {
                            try _ = videoData.write(to: url, options: [])
                        }
                        //uploadVideoToAPI(tempPath)

                        //self.sendFileVideo(url)
                        DispatchQueue.main.async {
                                            print(meadiaUrl)
                                              url.videoFileSizeInMB()
                                              //self.sendFileVideo(url)
                        self.createUploadVideo(for: url)
                                        }

                    } catch {
                        //handle error
                        print(error)
                    }


            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //document
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print("import result : \(myURL)")
        self.downloadfile(URL: myURL as NSURL)
        
    }
    
    
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    
     func createUploadFir(for image: UIImage) {
               
               let dateFormatter : DateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
               let date = Date()
               let dateString = dateFormatter.string(from: date)
               
            Helper.showLoader(onVC: self, message: "")
               
               let imageRef = Storage.storage().reference().child("userImage/"+"user"+dateString+"user.jpg")
               StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
                Helper.hideLoader(onVC: self)
                   guard let downloadURL = downloadURL else {
                       return
                   }
                   
                   let urlString = downloadURL.absoluteString
                   print("image url: \(urlString)")
                   self.imagePath = urlString
                   self.sendImageFir(url: self.imagePath,fileName: "")
               }
           }
           
           func createUploadVideo(for videoURL: URL) {
               let date = Date().timeIntervalSince1970 //string(format: "yyyy-MM-dd HH:mm:ss")
            Helper.showLoader(onVC: self, message: "")
               let storageReference = Storage.storage().reference().child("videoMessages/"+"\(date)"+".mov")
               storageReference.putFile(from: videoURL, metadata: nil) { (metadata, error) in
                
                Helper.hideLoader(onVC: self)
                if error == nil {
                    
                    guard let metadata = metadata else {
                        // Uh-oh, an error occurred!
                        return
                    }
                    // Metadata contains file metadata such as size, content-type.
                    let size = metadata.size
                    // You can also access to download URL after upload.
                    storageReference.downloadURL { (url, error) in
                        guard let downloadURL = url else {
                            // Uh-oh, an error occurred!
                            return
                        }
                        
                        print(downloadURL.absoluteString ?? "")
                        let videoUrlPath = downloadURL
                        print("Successful document upload")
                        self.sendImageFir(url: downloadURL.absoluteString ?? "" ,fileName: "\(date)"+".mov")
                        //self.sendImageFir(url: downloadURL.absoluteString ?? "",fileName: filename)
                        
                    }
                    
                    //print(metadata?.path ?? "")
                    //let videoUrlPath = metadata?.path
                    //print("Successful video upload")
                    //self.sendImageFir(url: videoUrlPath ?? "",fileName: "\(date)"+".mov")
                } else {
                    print(error?.localizedDescription ?? "")
                }
                
                
    //               if error == nil {
    //                   print(metadata?.path ?? "")
    //                   let videoUrlPath = metadata?.path
    //                   print("Successful video upload")
    //                   self.sendImageFir(url: videoUrlPath ?? "",fileName: "\(date)"+".mov")
    //               } else {
    //                   print(error?.localizedDescription ?? "")
    //               }
               }
           }
           
           
           func sendImageFir(url : String,fileName : String)  {
               
            
            if Auth.auth().currentUser != nil {
                   userID = Auth.auth().currentUser?.uid ?? ""
               }
               
               let dateFormatter : DateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
               let date = Date()
               let dateString = dateFormatter.string(from: date)
            
               var chatId = ""
                print(userType)
                if userType == "Mentee" {
                    chatId = userID+"_"+receiver_Id
                }else{
                    chatId = receiver_Id+"_"+userID
                }
            
                var messageId = ref.childByAutoId().key ?? ""
               
               let params : [String:Any] = ["senderId":userID,
                                            "receiverId" : receiver_Id,
                                            "messageId" : messageId,
                                            "attachFile" : url,
                                            "date": dateString,
                                            "fileName" : fileName]
            
            
            
            
            Helper.showLoader(onVC: self, message: "")
               
               ref.child("messages").child(chatId).child(messageId).updateChildValues(params) { (Error, DatabaseReference) in
                Helper.hideLoader(onVC: self)
                   if Error != nil{
                       print(Error?.localizedDescription ?? "")
                   }else{
                       print("message sent")
                   }
               }
           }
    
    func downloadfile(URL: NSURL) {
           let sessionConfig = URLSessionConfiguration.default
           let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
           var request = URLRequest(url: URL as URL)
           request.httpMethod = "GET"
           let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
               if (error == nil) {
                   // Success
                   let statusCode = response?.mimeType
                   print("Success: \(String(describing: statusCode))")
                   DispatchQueue.main.async(execute: {
                       self.createUploadDoument(for: data!,filename: URL.lastPathComponent!)
                   })
                   
                   // This is your file-variable:
                   // data
               }
               else {
                   // Failure
                   print("Failure: %@", error!.localizedDescription)
               }
           })
           task.resume()
       }
       
       func createUploadDoument(for videoURL: Data,filename : String) {
              let date = Date().timeIntervalSince1970 //string(format: "yyyy-MM-dd HH:mm:ss")
              Helper.showLoader(onVC: self, message: "")
              let storageReference = Storage.storage().reference().child("docMessages/"+"\(filename)")
              storageReference.putData(videoURL, metadata: nil) { (metadata, error) in
               Helper.hideLoader(onVC: self)
                  if error == nil {
                      
                      guard let metadata = metadata else {
                          // Uh-oh, an error occurred!
                          return
                      }
                      // Metadata contains file metadata such as size, content-type.
                      let size = metadata.size
                      // You can also access to download URL after upload.
                      storageReference.downloadURL { (url, error) in
                          guard let downloadURL = url else {
                              // Uh-oh, an error occurred!
                              return
                          }
                          
                          print(downloadURL.absoluteString ?? "")
                          let videoUrlPath = downloadURL
                          print("Successful document upload")
                          self.sendImageFir(url: downloadURL.absoluteString ?? "",fileName: filename)
                          
                      }
                      
                      
                  } else {
                      print(error?.localizedDescription ?? "")
                  }
              }
          }
    
}

//extension ChatViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
//
//
//    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
////        guard let url = info[.mediaURL] as? URL else {
////            return
////        }
////        print(url)
//
//        if let meadiaUrl = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
//                           print(meadiaUrl)
//                           //meadiaUrl.videoFileSizeInMB()
//
//                           let videoData : Data!
//                           do {
//                               try videoData = Data(contentsOf: meadiaUrl as URL)
//                               var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
//                               let documentsDirectory = paths[0]
//                               let tempPath = documentsDirectory.appendingFormat("/vid1.mp4")
//                               let url = URL(fileURLWithPath: tempPath)
//                               do {
//                                   try _ = videoData.write(to: url, options: [])
//                               }
//                               //uploadVideoToAPI(tempPath)
//
//                               //self.sendFileVideo(url)
//                               DispatchQueue.main.async {
//                                    print(url)
//
//                                                     //self.sendFileVideo(url)
//                                self.createUpload(for: url)
//
//                            }
//
//                           } catch {
//                               //handle error
//                               print(error)
//                           }
//
//
//                   }
//
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        picker.dismiss(animated: true, completion: nil)
//    }
//
//
//
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        self.dismiss(animated: true, completion: nil)
//    }
//
//}

extension String {
    var fileURL: URL {
        return URL(fileURLWithPath: self)
    }
    var pathExtension: String {
        return fileURL.pathExtension
    }
    var lastPathComponent: String {
        return fileURL.lastPathComponent
    }
}

extension URL {
    func videoFileSizeInMB() {
        let p = self.path
        
        let attr = try? FileManager.default.attributesOfItem(atPath: p)
        
        if let attr = attr {
            let fileSize = Float(attr[FileAttributeKey.size] as! UInt64) / (1024.0 * 1024.0)
            
            print(String(format: "FILE SIZE: %.2f MB", fileSize))
        } else {
            print("No file")
        }
    }
}
