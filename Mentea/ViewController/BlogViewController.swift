//
//  BlogViewController.swift
//  Mentea
//
//  Created by Apple on 23/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import DropDown
import FirebaseDatabase
import Firebase
import FBSDKShareKit

class BlogViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,SharingDelegate{
    
    var menuDropDown = DropDown()
     
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var addPostConst: NSLayoutConstraint!
    var ref: DatabaseReference!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var lblNoData: UILabel!
    
    var blogsList :[BlogsModel] = []
    var likeList :[LikesData] = []
    var userName : String?
    var userImageUrl : String?
    var userLocation : String?
    var userType = ""
    var onLikeClick = ""
    var attachFileName = ""
    var attachFileUrl = ""
    var images = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Blog"
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.lblNoData.isHidden = true
        ref = Database.database().reference()
        //setRightBarButton()
        
        //lblNoData.isHidden = false
        
        userType = Helper.getPREF("userType") ?? ""
        
        if let id = Helper.getPREF("userId") {
            print(id)
            ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let name = value?["name"] as? String {
                    self.userName = name
                }
                if let currentCity = value?["currentCity"] as? String {
                    //self.userLocation = currentCity
                }
                if let image = value?["image"] as? String{
                    self.userImageUrl = image
                    if let url = URL(string: image) {
                        //self.userImage.sd_setImage(with: url, completed: nil)
                    }
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        tableView.register(UINib.init(nibName:"TextTableViewCell", bundle: nil), forCellReuseIdentifier: "TextTableViewCell")
        tableView.register(UINib.init(nibName:"ImageTableViewCell", bundle: nil), forCellReuseIdentifier: "ImageTableViewCell")
        tableView.register(UINib.init(nibName:"DocumentTableViewCell", bundle: nil), forCellReuseIdentifier: "DocumentTableViewCell")
               
               
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
           super.viewDidAppear(animated)
           getDataFromDatabaseblogs()
       }
    
    //Facebook Code
    func shareTextOnFaceBook( text : String) {
       let shareContent = ShareLinkContent()
        shareContent.contentURL = URL.init(string: "https://www.doelse.com/mentea/")!
       shareContent.quote = text
    ShareDialog(fromViewController: self, content: shareContent, delegate: self).show()
   }

   func sharer(_ sharer: Sharing, didCompleteWithResults results: [String : Any]) {
    
       if sharer.shareContent.pageID != nil {
           print("Share: Success")
       }
   }
   func sharer(_ sharer: Sharing, didFailWithError error: Error) {
       print("Share: Fail")
   }
    
   func sharerDidCancel(_ sharer: Sharing) {
       print("Share: Cancel")
   }
    
    
    
    @IBAction func handleAddBtn(_ sender: Any) {
        let newvc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostVC") as! CreatePostVC
        newvc.userName = self.userName
        //newvc.userImg = self.userImage.image
        newvc.userImageUrl = self.userImageUrl
        newvc.userLocation = self.userLocation
        newvc.onCompletion = {(action) -> Void in
            DispatchQueue.main.async {
                self.getDataFromDatabaseblogs()
            }
        }
        self.navigationController?.pushViewController(newvc, animated: true)
    }

     
       
       func setRightBarButton() {
           let timerBarButton = UIBarButtonItem.init(image: UIImage.init(named: "settings"), style: .plain, target: self, action: #selector(settingClicked(_:)))
           
           //let addBarButton = UIBarButtonItem.init(image: UIImage.init(named: "plus"), style: .plain, target: self, action: #selector(plusClicked(_:)))
           
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
               //cell.contentView.backgroundColor = UIColor(hexString: "#5EDBD0")
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
       
       
   //    @IBAction func plusClicked(_ sender: UIBarButtonItem) {
   //
   //    }
       
       @IBAction func actionAddPost(_ sender: Any) {
           let newvc = self.storyboard?.instantiateViewController(withIdentifier: "CreatePostVC") as! CreatePostVC
           newvc.userName = self.userName
           newvc.userImg = self.userImage.image
           newvc.userImageUrl = self.userImageUrl
           newvc.userLocation = self.userLocation
           newvc.onCompletion = {(action) -> Void in
               DispatchQueue.main.async {
                   self.getDataFromDatabaseblogs()
               }
           }
           self.navigationController?.pushViewController(newvc, animated: true)
       }
       
       @IBAction func settingClicked(_ sender: UIBarButtonItem) {
           menuDropDown.show()
       }
       
       func getDataFromDatabaseblogs() {
           //Helper.showLoader(onVC: self, message: "")
           blogsList = []
           ref.child("blogs").observe(.value, with: { snapshot in
               //Helper.hideLoader(onVC: self)
               if snapshot.childrenCount > 0 {
                   self.blogsList = []
                   for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                       let objects = nutrition.value as! [String: AnyObject]
                       print(objects)
                       let blogId = objects["blogId"] as? String
                       let blogText = objects["blogText"] as? String
                       let bloggerId = objects["bloggerId"] as? String
                       let attachFileUrl = objects["attachFileUrl"] as? String
                       let attachFileName = objects["attachFileName"] as? String
                       let bloggerImage = objects["bloggerImage"] as? String
                       let bloggerName = objects["bloggerName"] as? String
                       let commentCount = objects["commentCount"] as? String
                       let createdDate = objects["createdDate"] as? String
                       let currentCity = objects["currentCity"] as? String
                       let likesCount = objects["likesCount"] as? String
                       let comments = objects["comments"] as? [String: AnyObject]
                       var commentsArray: [Comment] = []
                       for item in comments ?? [:] {
                           let comment = item.value
                           let blogId = comment["blogId"] as? String
                           let commentId = comment["commentId"] as? String
                           let commentText = comment["commentText"] as? String
                           let commentorId = comment["commentorId"] as? String
                           let commentorImage = comment["commentorImage"] as? String
                           let commentorName = comment["commentorName"] as? String
                           let createdDate = comment["createdDate"] as? String
                           let currentCity = comment["currentCity"] as? String
                           commentsArray.append(Comment(blogId: blogId ?? "", commentId: commentId ?? "", commentText: commentText ?? "", commentorId: commentorId ?? "", commentorImage: commentorImage ?? "", commentorName: commentorName ?? "", createdDate: createdDate ?? "", currentCity: currentCity ?? ""))
                       }
                       let likes = objects["likes"] as? [String: AnyObject]
                       let report = objects["reportedBlogs"] as? [String: AnyObject]
                       if !(report?.keys.contains(Helper.getPREF("userId") ?? "") ?? false) {
                           var likesArray: [Like] = []
                           for item in likes ?? [:] {
                               let like = item.value
                               let blogId = like["blogId"] as? String
                               let likeId = like["likeId"] as? String
                               let like_status = like["like_status"] as? String
                               let userId = like["userId"] as? String
                               let userName = like["userName"] as? String
                               likesArray.append(Like(blogId: blogId ?? "", likeId: likeId ?? "", like_status: like_status ?? "", userId: userId ?? "", userName: userName ?? ""))
                           }
                           let blog = BlogsModel(blogId: blogId ?? "", blogText: blogText ?? "", bloggerId: bloggerId ?? "", bloggerImage: bloggerImage ?? "", bloggerName: bloggerName ?? "", commentCount: commentCount ?? "", createdDate: createdDate ?? "", currentCity: currentCity ?? "",
                                                 likesCount: likesCount ?? "", attachFileName : attachFileName ?? "", attachFileUrl : attachFileUrl ?? "", comment: commentsArray, like: likesArray)
                           self.blogsList.append(blog)
                       }
                   }
                   self.blogsList = self.blogsList.reversed()
                   if  self.blogsList.count > 0{
                       self.lblNoData.isHidden = true
                   }else{
                       self.lblNoData.isHidden = false
                   }
                   
                   self.getDataFromDatabaseLike()
                   self.getDataFromDatabaseReport()
                   self.tableView.reloadData()
               }
           })
       }
       
       func getDataFromDatabaseLike() {
           //Helper.showLoader(onVC: self, message: "")
           likeList = []
           ref.child("likes").observe(.value, with: { snapshot in
               Helper.hideLoader(onVC: self)
               if snapshot.childrenCount > 0 {
                   self.likeList = []
                   for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                       let objects = nutrition.value as! [String: AnyObject]
                       print(objects)
                       for item in objects {
                           let likes = item.value as? NSObject
                           let blogId = likes?.value(forKey: "blogId") as? String
                           let userId = likes?.value(forKey: "userId") as? String
                           let userName = likes?.value(forKey: "userName") as? String
                           self.likeList.append(LikesData(blogId: blogId ?? "", userId: userId ?? "", userName: userName ?? ""))
                       }
                   }
                   self.tableView.reloadData()
               }
           })
       }
       
       func getDataFromDatabaseReport() {
           //Helper.showLoader(onVC: self, message: "")
           likeList = []
           ref.child("likes").observe(.value, with: { snapshot in
               Helper.hideLoader(onVC: self)
               if snapshot.childrenCount > 0 {
                   self.likeList = []
                   for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                       let objects = nutrition.value as! [String: AnyObject]
                       print(objects)
                       for item in objects {
                           let likes = item.value as? NSObject
                           let blogId = likes?.value(forKey: "blogId") as? String
                           let userId = likes?.value(forKey: "userId") as? String
                           let userName = likes?.value(forKey: "userName") as? String
                           self.likeList.append(LikesData(blogId: blogId ?? "", userId: userId ?? "", userName: userName ?? ""))
                       }
                   }
                   self.tableView.reloadData()
               }
           })
       }
       
       func AddLikeData(likesCount:String,userId:String,blogId:String,like_status:String,userName:String) {
           self.onLikeClick = "yes"
           //Helper.showLoader(onVC: self, message: "")
           let like = "\((Int(likesCount) ?? 0) + 1)"
           //guard let key = self.ref.child("blogs").child(blogId).child("likes").childByAutoId().key else { return }
           
           let params = ["blogId" : blogId,
                         "userId":userId,
                         "userName": userName]
           
           self.ref.child("blogs").child(blogId).updateChildValues([
               "likesCount": like
           ])
           self.ref.child("likes").child(blogId).child(userId).setValue(params) { (Error, DatabaseReference) in
                //Helper.hideLoader(onVC: self)
               self.onLikeClick = ""
               if Error == nil{
               }else{
                   print(Error.debugDescription)
               }
               //self.getDataFromDatabaseblogs()
           }
       }
       
       func AddReportData(blogId:String,index:Int) {
           //Helper.showLoader(onVC: self, message: "")
           //guard let key = self.ref.child("reportedBlogs").childByAutoId().key else { return }
           
           let params = ["userId":Helper.getPREF("userId")]
           
   //        let reportParams = ["blogId" : blogId,
   //                            "reportId":key,
   //                            "userId":Helper.getPREF("userId"),
   //                            "userName": userName]
           
           self.ref.child("blogs").child(blogId).child("reportedBlogs").child(Helper.getPREF("userId") ?? "").setValue(params) { (Error, DatabaseReference) in
               Helper.hideLoader(onVC: self)
               if Error == nil{
               }else{
                   print(Error.debugDescription)
               }
           }
           //self.blogsList.remove(at: index)
           //self.tableView.reloadData()
           /*self.ref.child("reportedBlogs").child(key).setValue(reportParams) { (Error, DatabaseReference) in
               Helper.hideLoader(onVC: self)
               if Error == nil{
               }else{
                   print(Error.debugDescription)
               }
               self.getDataFromDatabaseblogs()
           }*/
       }
       
       
       func removeLikeData(likesCount:String,blogId:String, userId: String) {
           self.onLikeClick = "yes"
           let like = "\((Int(likesCount) ?? 0) - 1)"
           self.ref.child("blogs").child(blogId).updateChildValues([
               "likesCount": like
           ])
           self.ref.child("likes").child(blogId).child(userId).removeValue { error, _ in
               self.onLikeClick = ""
              if error == nil{
               print("successfully")
               }else{
                   print(error.debugDescription)
               }
               //self.getDataFromDatabaseblogs()
           }
       }
    
    func deletPost(postId: String) {

        let ref = Database.database().reference()

        ref.child("blogs").child(postId).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }else{
                self.getDataFromDatabaseblogs()
            }
        }
        
    }
       
       
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if blogsList.count == 0 {
              // self.tableView.setEmptyMessage("No Blog. Please write about your experience.")
           } else {
               self.tableView.restore()
           }
           return blogsList.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var fileName = blogsList[indexPath.row].attachFileName;
        
        
        if fileName.contains(".jpg") {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageTableViewCell") as! ImageTableViewCell
            cell.selectionStyle = .none
            if(blogsList[indexPath.row].bloggerId == Helper.getPREF("userId") ?? "")
            {
                cell.flagImage.image = UIImage(named: "delete")
                
            }
            else{
                
                cell.flagImage.image = UIImage(named: "nation")
                
            }
            
            if(indexPath.row > blogsList.count-1){
                return UITableViewCell()
            }else{
                
                let createdDate = self.blogsList[indexPath.row].createdDate
                print(blogsList[indexPath.row].bloggerId)
                if let bloggerId = blogsList[indexPath.row].bloggerId as? String{
                    ref.child("users").child(blogsList[indexPath.row].bloggerId).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        if snapshot.childrenCount > 0{
                            var value = snapshot.value as? NSDictionary
                            //UserModel
                            if let currentCity = value?["currentCity"] as? String{
                                cell.lblLocation.text = self.convertDateFormater(createdDate)+"\n"+currentCity
                                
                            }
                            
                            if let name = value?["name"] as? String {
                                cell.lblName.text = name.firstCharacterUpperCase()
                            }
                            
                            
                            if let image = value?["image"] as? String{
                                if let url = URL(string: image) {
                                    cell.imgView.sd_setImage(with: url, completed: nil)
                                    cell.imgUser.sd_setImage(with: url, completed: nil)
                                } else{
                                    cell.imgView.image = UIImage(named: "ic_avatar")
                                    cell.imgUser.image = UIImage(named: "ic_avatar")
                                }
                                //cell.userImage.image = self.userImage.image
                            }else{
                                cell.imgView.image = UIImage(named: "ic_avatar")
                                cell.imgUser.image = UIImage(named: "ic_avatar")
                            }
                        }
                        
                        
                        
                        
                    }) { (error) in
                        print(error.localizedDescription)
                        
                        
                    }
                }
                
                
                
                
                
                //cell.lblDesc.text = blogsList[indexPath.row].blogText.firstCharacterUpperCase()?? ""
                
                
                let like = blogsList[indexPath.row].likesCount  ?? "0"
                print(like)
                
                if(like == "0")
                {
                    cell.btnLike.setTitle("Like", for: .normal)
                }
                else if(like == "1")
                {
                    cell.btnLike.setTitle("\(like) Like", for: .normal)
                }
                else
                {
                    cell.btnLike.setTitle("\(like) Likes", for: .normal)
                }
                
                let urll = blogsList[indexPath.row].attachFileUrl
                
                if let url = URL(string: urll) {
                    cell.postImg.sd_setImage(with: url, completed: nil)
                } else{
                    cell.imgView.image = UIImage(named: "ic_avatar")
                    cell.imgUser.image = UIImage(named: "ic_avatar")
                }
                
                
                
                let comment = blogsList[indexPath.row].commentCount  ?? "0"
                print("\(comment):comment_count")
                
                if(comment == "0")
                {
                    cell.btnComment.setTitle("Comment", for: .normal)
                }
                if(comment == "1")
                {
                    cell.btnComment.setTitle("\(comment) Comment", for: .normal)
                }
                else
                {
                    cell.btnComment.setTitle("\(comment) Comments", for: .normal)
                }
                
                
                let result = likeList.contains { (like) -> Bool in
                    return ((like.userId == Helper.getPREF("userId")) && (like.blogId == blogsList[indexPath.row].blogId))
                }
                if result == true {
                    cell.likeImg.tintColor = UIColor.blue
                } else{
                    cell.likeImg.tintColor = .darkGray
                }
                
                cell.postImg.tag = indexPath.row
                cell.postImg.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClick))
                cell.postImg.addGestureRecognizer(tap)
                cell.buttonReport = {
                    
                    if self.blogsList[indexPath.row].bloggerId == Helper.getPREF("userId") ?? ""
                    {
                        Helper.showOKCancelAlertWithCompletion(onVC: self, title: "Alert", message: "Are you sure want to delete this post?", btnOkTitle: "Yes", btnCancelTitle: "No") {
                            self.deletPost(postId: self.blogsList[indexPath.row].blogId)
                        }
                    }
                    else {
                        Helper.showOKCancelAlertWithCompletion(onVC: self, title: "Report", message: "Are you sure want to report this post?", btnOkTitle: "Yes", btnCancelTitle: "No") {
                            self.AddReportData(blogId: self.blogsList[indexPath.row].blogId, index: indexPath.row)
                        }
                    }
                    
                    
                }
                
                cell.buttonLike = {
                    if self.onLikeClick != "yes"{
                        if result == false {
                            self.AddLikeData(likesCount: self.blogsList[indexPath.row].likesCount, userId: Helper.getPREF("userId") ?? "", blogId: self.blogsList[indexPath.row].blogId, like_status: "1", userName: self.userName ?? "")
                        } else{
                            self.removeLikeData(likesCount: self.blogsList[indexPath.row].likesCount, blogId: self.blogsList[indexPath.row].blogId, userId: Helper.getPREF("userId") ?? "")
                        }
                    }
                }
                cell.buttonComment = {
                    let newvc = self.storyboard?.instantiateViewController(withIdentifier: "CommentListVC") as! CommentListVC
                    newvc.commentList = self.blogsList[indexPath.row].comment
                    newvc.blogDetail = self.blogsList[indexPath.row]
                    newvc.userName = self.userName
                    newvc.userImageUrl = self.userImageUrl
                    newvc.userLocation = self.userLocation
                    newvc.modalPresentationStyle = .fullScreen
                    newvc.onCompletion = {(action) -> Void in
                        DispatchQueue.main.async {
                            self.getDataFromDatabaseblogs()
                        }
                    }
                    //self.navigationController?.popToRootViewController(animated: true)
                    self.navigationController?.pushViewController(newvc, animated: true)
                    //self.present(newvc, animated: true, completion: nil)
                }
                cell.buttonShare = {
                    
                    
                    let text = self.blogsList[indexPath.row].blogText ?? ""
                    self.shareTextOnFaceBook(text: text)
                    
                    //               set up activity view controller
                    //               let textToShare = [ text ]
                    //               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                    //               activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                    //
                    //               self.present(activityViewController, animated: true, completion: nil)
                }
            }
            return cell
        }
        if (!fileName.contains(".jpg") && !fileName.isEmpty)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentTableViewCell") as! DocumentTableViewCell
            cell.selectionStyle = .none
            cell.btnPlay.tag = indexPath.row
            cell.btnPlay.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClickVideo(sender:)))
            cell.btnPlay.addGestureRecognizer(tap)
            if(blogsList[indexPath.row].bloggerId == Helper.getPREF("userId") ?? "")
            {
                cell.flagImage.image = UIImage(named: "delete")
                
            }
            else{
                
                cell.flagImage.image = UIImage(named: "nation")
                
            }
            
            if(indexPath.row > blogsList.count-1){
                return UITableViewCell()
            }else{
                
                let createdDate = self.blogsList[indexPath.row].createdDate
                print(blogsList[indexPath.row].bloggerId)
                if let bloggerId = blogsList[indexPath.row].bloggerId as? String{
                    ref.child("users").child(blogsList[indexPath.row].bloggerId).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        if snapshot.childrenCount > 0{
                            var value = snapshot.value as? NSDictionary
                            //UserModel
                            if let currentCity = value?["currentCity"] as? String{
                                cell.lblLocation.text = self.convertDateFormater(createdDate)+"\n"+currentCity
                                
                            }
                            
                            if let name = value?["name"] as? String {
                                cell.lblName.text = name.firstCharacterUpperCase()
                            }
                            
                            
                            if let image = value?["image"] as? String{
                                if let url = URL(string: image) {
                                    cell.imgView.sd_setImage(with: url, completed: nil)
                                    cell.imgUser.sd_setImage(with: url, completed: nil)
                                } else{
                                    cell.imgView.image = UIImage(named: "ic_avatar")
                                    cell.imgUser.image = UIImage(named: "ic_avatar")
                                }
                                //cell.userImage.image = self.userImage.image
                            }else{
                                cell.imgView.image = UIImage(named: "ic_avatar")
                                cell.imgUser.image = UIImage(named: "ic_avatar")
                            }
                        }
                        
                        
                        
                        
                    }) { (error) in
                        print(error.localizedDescription)
                        
                        
                    }
                }
                
                
                
                
                
                //cell.lblDesc.text = blogsList[indexPath.row].blogText.firstCharacterUpperCase()?? ""
                
                
                let like = blogsList[indexPath.row].likesCount  ?? "0"
                print(like)
                
                if(like == "0")
                {
                    cell.btnLike.setTitle("Like", for: .normal)
                }
                else if(like == "1")
                {
                    cell.btnLike.setTitle("\(like) Like", for: .normal)
                }
                else
                {
                    cell.btnLike.setTitle("\(like) Likes", for: .normal)
                }
                if(fileName.contains("mov"))
                {
                    cell.postImg.image = UIImage.init(named: "video")
                }
                else
                {
                    cell.postImg.image = UIImage.init(named: "document")
                }
                
                cell.lblDesc.text = blogsList[indexPath.row].attachFileName ?? ""
                
                
                let comment = blogsList[indexPath.row].commentCount  ?? "0"
                print("\(comment):comment_count")
                
                if(comment == "0")
                {
                    cell.btnComment.setTitle("Comment", for: .normal)
                }
                if(comment == "1")
                {
                    cell.btnComment.setTitle("\(comment) Comment", for: .normal)
                }
                else
                {
                    cell.btnComment.setTitle("\(comment) Comments", for: .normal)
                }
                
                
                let result = likeList.contains { (like) -> Bool in
                    return ((like.userId == Helper.getPREF("userId")) && (like.blogId == blogsList[indexPath.row].blogId))
                }
                if result == true {
                    cell.likeImg.tintColor = UIColor.blue
                } else{
                    cell.likeImg.tintColor = .darkGray
                }
                
                cell.buttonReport = {
                    
                    if self.blogsList[indexPath.row].bloggerId == Helper.getPREF("userId") ?? ""
                    {
                        Helper.showOKCancelAlertWithCompletion(onVC: self, title: "Report", message: "Are you sure want to delete this post?", btnOkTitle: "Yes", btnCancelTitle: "No") {
                            self.deletPost(postId: self.blogsList[indexPath.row].blogId)
                        }
                    }
                    else {
                        Helper.showOKCancelAlertWithCompletion(onVC: self, title: "Report", message: "Are you sure want to report this post?", btnOkTitle: "Yes", btnCancelTitle: "No") {
                            self.AddReportData(blogId: self.blogsList[indexPath.row].blogId, index: indexPath.row)
                        }
                    }
                    
                    
                }
                
                cell.buttonLike = {
                    if self.onLikeClick != "yes"{
                        if result == false {
                            self.AddLikeData(likesCount: self.blogsList[indexPath.row].likesCount, userId: Helper.getPREF("userId") ?? "", blogId: self.blogsList[indexPath.row].blogId, like_status: "1", userName: self.userName ?? "")
                        } else{
                            self.removeLikeData(likesCount: self.blogsList[indexPath.row].likesCount, blogId: self.blogsList[indexPath.row].blogId, userId: Helper.getPREF("userId") ?? "")
                        }
                    }
                }
                cell.buttonComment = {
                    let newvc = self.storyboard?.instantiateViewController(withIdentifier: "CommentListVC") as! CommentListVC
                    newvc.commentList = self.blogsList[indexPath.row].comment
                    newvc.blogDetail = self.blogsList[indexPath.row]
                    newvc.userName = self.userName
                    newvc.userImageUrl = self.userImageUrl
                    newvc.userLocation = self.userLocation
                    newvc.modalPresentationStyle = .fullScreen
                    newvc.onCompletion = {(action) -> Void in
                        DispatchQueue.main.async {
                            self.getDataFromDatabaseblogs()
                        }
                    }
                    //self.navigationController?.popToRootViewController(animated: true)
                    self.navigationController?.pushViewController(newvc, animated: true)
                    //self.present(newvc, animated: true, completion: nil)
                }
                cell.buttonShare = {
                    
                    
                    let text = self.blogsList[indexPath.row].blogText ?? ""
                    self.shareTextOnFaceBook(text: text)
                    
                    //               set up activity view controller
                    //               let textToShare = [ text ]
                    //               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                    //               activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                    //
                    //               self.present(activityViewController, animated: true, completion: nil)
                }
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextTableViewCell") as! TextTableViewCell
        cell.selectionStyle = .none
        if(blogsList[indexPath.row].bloggerId == Helper.getPREF("userId") ?? "")
        {
            cell.flagImage.image = UIImage(named: "delete")
            
        }
        else{
            
            cell.flagImage.image = UIImage(named: "nation")
            
        }
        
        if(indexPath.row > blogsList.count-1){
            return UITableViewCell()
        }else{
            
            let createdDate = self.blogsList[indexPath.row].createdDate
            print(blogsList[indexPath.row].bloggerId)
            if let bloggerId = blogsList[indexPath.row].bloggerId as? String{
                ref.child("users").child(blogsList[indexPath.row].bloggerId).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    if snapshot.childrenCount > 0{
                        var value = snapshot.value as? NSDictionary
                        //UserModel
                        if let currentCity = value?["currentCity"] as? String{
                            cell.lblLocation.text = self.convertDateFormater(createdDate)+"\n"+currentCity
                            
                        }
                        
                        if let name = value?["name"] as? String {
                            cell.lblName.text = name.firstCharacterUpperCase()
                        }
                        
                        
                        if let image = value?["image"] as? String{
                            if let url = URL(string: image) {
                                cell.imgView.sd_setImage(with: url, completed: nil)
                                cell.imgUser.sd_setImage(with: url, completed: nil)
                            } else{
                                cell.imgView.image = UIImage(named: "ic_avatar")
                                cell.imgUser.image = UIImage(named: "ic_avatar")
                            }
                            //cell.userImage.image = self.userImage.image
                        }else{
                            cell.imgView.image = UIImage(named: "ic_avatar")
                            cell.imgUser.image = UIImage(named: "ic_avatar")
                        }
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            
            cell.lblDesc.text = blogsList[indexPath.row].blogText.firstCharacterUpperCase()
            
            
            let like = blogsList[indexPath.row].likesCount  ?? "0"
            print(like)
            
            if(like == "0")
            {
                cell.btnLike.setTitle("Like", for: .normal)
            }
            else if(like == "1")
            {
                cell.btnLike.setTitle("\(like) Like", for: .normal)
            }
            else
            {
                cell.btnLike.setTitle("\(like) Likes", for: .normal)
            }
            
            
            let comment = blogsList[indexPath.row].commentCount  ?? "0"
            print("\(comment):comment_count")
            
            if(comment == "0")
            {
                cell.btnComment.setTitle("Comment", for: .normal)
            }
            if(comment == "1")
            {
                cell.btnComment.setTitle("\(comment) Comment", for: .normal)
            }
            else
            {
                cell.btnComment.setTitle("\(comment) Comments", for: .normal)
            }
            
            
            let result = likeList.contains { (like) -> Bool in
                return ((like.userId == Helper.getPREF("userId")) && (like.blogId == blogsList[indexPath.row].blogId))
            }
            if result == true {
                cell.likeImg.tintColor = UIColor.blue
            } else{
                cell.likeImg.tintColor = .darkGray
            }
            
            cell.buttonReport = {
                
                if self.blogsList[indexPath.row].bloggerId == Helper.getPREF("userId") ?? ""
                {
                    Helper.showOKCancelAlertWithCompletion(onVC: self, title: "Report", message: "Are you sure want to delete this post?", btnOkTitle: "Yes", btnCancelTitle: "No") {
                        self.deletPost(postId: self.blogsList[indexPath.row].blogId)
                    }
                }
                else {
                    Helper.showOKCancelAlertWithCompletion(onVC: self, title: "Report", message: "Are you sure want to report this post?", btnOkTitle: "Yes", btnCancelTitle: "No") {
                        self.AddReportData(blogId: self.blogsList[indexPath.row].blogId, index: indexPath.row)
                    }
                }
            }
            
            cell.buttonLike = {
                if self.onLikeClick != "yes"{
                    if result == false {
                        self.AddLikeData(likesCount: self.blogsList[indexPath.row].likesCount, userId: Helper.getPREF("userId") ?? "", blogId: self.blogsList[indexPath.row].blogId, like_status: "1", userName: self.userName ?? "")
                    } else{
                        self.removeLikeData(likesCount: self.blogsList[indexPath.row].likesCount, blogId: self.blogsList[indexPath.row].blogId, userId: Helper.getPREF("userId") ?? "")
                    }
                }
            }
            cell.buttonComment = {
                let newvc = self.storyboard?.instantiateViewController(withIdentifier: "CommentListVC") as! CommentListVC
                newvc.commentList = self.blogsList[indexPath.row].comment
                newvc.blogDetail = self.blogsList[indexPath.row]
                newvc.userName = self.userName
                newvc.userImageUrl = self.userImageUrl
                newvc.userLocation = self.userLocation
                newvc.modalPresentationStyle = .fullScreen
                newvc.onCompletion = {(action) -> Void in
                    DispatchQueue.main.async {
                        self.getDataFromDatabaseblogs()
                    }
                }
                //self.navigationController?.popToRootViewController(animated: true)
                self.navigationController?.pushViewController(newvc, animated: true)
                //self.present(newvc, animated: true, completion: nil)
            }
            cell.buttonShare = {
                
                
                let text = self.blogsList[indexPath.row].blogText ?? ""
                self.shareTextOnFaceBook(text: text)
                
                //               set up activity view controller
                //               let textToShare = [ text ]
                //               let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                //               activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                //
                //               self.present(activityViewController, animated: true, completion: nil)
            }
        }
        return cell
    }
    @objc func onClick(sender : UITapGestureRecognizer)
       {
          let imgVieww = sender.view as! UIImageView
          var position = imgVieww.tag
          print(position)
        
        if let attFile = blogsList[position].attachFileUrl as? String{
        
        if (attFile.contains(".jpg") || attFile.contains(".jpeg") || attFile.contains(".png")) {
            self.images.removeAll()
            self.images.append(attFile)
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let zoom = storyBoard.instantiateViewController(withIdentifier: "FullImageViewController") as! FullImageViewController
            zoom.selectedIndex = 0 //indexPath.row
            zoom.arrImages = self.images
            self.navigationController?.pushViewController(zoom, animated: true)
            
        }
       }
    }
        
        @objc func onClickVideo(sender : UITapGestureRecognizer)
        {
           let imgVieww = sender.view as! UIView
           var position = imgVieww.tag
           print(position)
         
         if let attFile = blogsList[position].attachFileUrl as? String{
         
         if(attFile.contains(".mov")  || attFile.contains(".mp4") || attFile.contains(".3gp") || attFile.contains(".MOV") || attFile.contains(".MP4") || attFile.contains(".3GP")){
             
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         var fileName = blogsList[indexPath.row].attachFileName;
        if (fileName.contains(".jpg"))
        {
            return 324
        }
        else if (!fileName.contains(".jpg") && !fileName.isEmpty)
        {
            return 240
        }
        else
        {
            return 223
        }
    }
       
       func shareLinkedIn(blogText : String){
           let urlWhats = "linkedin://#profile=\(blogText)"
                       if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                             if let whatsappURL = NSURL(string: urlString) {
                                   if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                                        UIApplication.shared.open(whatsappURL as URL)
                                    }
                                    else {
                                        print("please install watsapp")
                                    }
                             }
                       }
                   
       }
       
       
   //    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   //        return 170
   //    }
       
      
       func convertDateFormater(_ date: String) -> String {
           
           if(date.isEmpty != true || date != nil){
               //let dateFormatter = DateFormatter()
               //2020-06-23 18:10:25
               //dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
               //let date = dateFormatter.date(from: date)
               //dateFormatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
               //return  dateFormatter.string(from: date!)
               
               let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
               let myDate = dateFormatter.date(from: date)!
               dateFormatter.dateFormat = "dd-MMMM-yyyy hh:mm a"
               let somedateString = dateFormatter.string(from: myDate)
               dateFormatter.dateFormat = "hh:mm a"
               let sometimeString = dateFormatter.string(from: myDate)
               if getCurrentShortDate("dd-MMMM-yyyy hh:mm a") == somedateString{
                  return "Today "+sometimeString
               }
               else if getYesterday(someDate: myDate) {
                   return "Yesterday "+sometimeString
               }
               else{
                   return somedateString
               }
               
           }
           else{
               return ""
           }
           
       }
       
       func getCurrentShortDate(_ dateFormat: String) -> String {
           var todaysDate = NSDate()
           var dateFormatter = DateFormatter()
           dateFormatter.dateFormat = dateFormat
           let DateInFormat = dateFormatter.string(from: todaysDate as Date)

           return DateInFormat
       }
       
       func getYesterday(someDate : Date) -> Bool {
           let calendar = Calendar.current
           //let date = Date()
           return calendar.isDateInYesterday(someDate)
       }
       
       func getUserDetail(userId : String) {
          
               ref.child("users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                   // Get user value
                   var value = snapshot.value as? NSDictionary
                   //UserModel
                   if let currentCity = value?["currentCity"] as? String{
                       //self.lblcity.text = currentCity
                   }
                   if let name = value?["name"] as? String {
                       //self.lblName.text = name.firstCharacterUpperCase()
                   }
                  
                   if let image = value?["image"] as? String{
                       if let url = URL(string: image) {
                           //self.imgUser.sd_setImage(with: url, completed: nil)
                           //self.imgUser.roundedImage()
                       }
                   }
               }) { (error) in
                   print(error.localizedDescription)
               }
           
       }
    
}
