//
//  CommentListVC.swift
//  Mentea
//
//  Created by Rv on 12/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import DropDown
import FirebaseDatabase
import Firebase
import IQKeyboardManagerSwift

protocol CommentListVCDelegate {
    func onRefreshData()
}
var commentListVCDelegate : CommentListVCDelegate?



class CommentListVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var ivBack: UIImageView!
    @IBOutlet weak var viewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var txtComment: UITextField!
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var lblNoCommentt: UILabel!
    
    var blogDetail:BlogsModel?
    var commentList: [Comment] = []
    var userImageUrl : String?
    var ref: DatabaseReference!
    var userLocation : String?
    
    var userName : String?
    typealias CompletionBlock = (_ isAdd: Bool) -> Void
    var onCompletion:CompletionBlock?
    var userId = ""
    var comment = "0"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = false
        UIApplication.shared.keyWindow?.backgroundColor = UIColor.white
        txtComment.inputAccessoryView = UIView()
        txtComment.autocorrectionType = .no
        tblView.delegate = self
        tblView.dataSource = self
        //IQKeyboardManager.shared.enableAutoToolbar = false
        commentListVCDelegate = self
        ref = Database.database().reference()
        self.title = "Comments"
        self.userId = Helper.getPREF("userId") ?? ""
        //self.tabBarController?.setTabBarVisible(visible: false, duration: 0.3, animated: true)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
       // ivBack.isUserInteractionEnabled = true
        //ivBack.addGestureRecognizer(tapGestureRecognizer)
        
        print(blogDetail?.bloggerId ?? "fff")
        self.upComment()
        self.getComment()
        
    }
    func upComment(){
        ref.child("blogs").child(blogDetail?.blogId ?? "").child("commentCount").observe(.value) { (snapshot) in
                  if(snapshot.exists())
                  {
                    self.comment = "\((Int(snapshot.value as! String ?? "0") ?? 0) + 1)"
                      
                  }
              }
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addComment(text: String) {
        
      
        self.ref.child("blogs").child(self.blogDetail?.blogId ?? "").updateChildValues([
            "commentCount": comment
        ])
        
        guard let key = self.ref.child("blogs").child(blogDetail?.blogId ?? "").child("comments").childByAutoId().key else { return }
       
        let date = Date().string(format: "yyyy-MM-dd HH:mm:ss")
        
        let params = ["blogId" : blogDetail?.blogId ?? "",
                      "commentId":key,"commentText":txtComment.text ?? "","commentorId":Helper.getPREF("userId") ?? "","commentorImage":userImageUrl ?? "",
                      "commentorName": userName ?? "","createdDate":date,"currentCity":self.userLocation ?? ""]
        
        self.ref.child("blogs").child(blogDetail?.blogId ?? "").child("comments").child(key).setValue(params) { (Error, DatabaseReference) in
            if Error == nil{
            }else{
                print(Error.debugDescription)
            }
            if let isCompletion = self.onCompletion {
                isCompletion(true)
            }
            self.txtComment.text = ""
            
        }
        self.getComment()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
           addObserver()
        
        //tabBarController?.tabBar.isHidden = true
       // edgesForExtendedLayout = UIRectEdge.bottom
        //extendedLayoutIncludesOpaqueBars = true
       
           
       }
       
       
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(true)
           self.removeObserver()
         //self.tabBarController?.setTabBarVisible(visible: true, duration: 0.3, animated: true)
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

            let numberOfSections = self.tblView.numberOfSections
            let numberOfRows = self.tblView.numberOfRows(inSection: numberOfSections-1)
                   if numberOfRows > 0 {
                       let indexPath = IndexPath(row: numberOfRows-1, section: (numberOfSections-1))
                    self.tblView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.bottom, animated: false)
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
        
    
    func getComment() {
        ref.child("blogs").child(blogDetail?.blogId ?? "").child("comments").observe(.value, with: { snapshot in
            Helper.hideLoader(onVC: self)
            self.commentList.removeAll()
            if snapshot.childrenCount > 0 {
                
                for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                    let comment = nutrition.value as! [String: AnyObject]
                    
                    let blogId = comment["blogId"] as? String
                    let commentId = comment["commentId"] as? String
                    let commentText = comment["commentText"] as? String
                    print(commentText)
                    let commentorId = comment["commentorId"] as? String
                    let commentorImage = comment["commentorImage"] as? String
                    let commentorName = comment["commentorName"] as? String
                    let createdDate = comment["createdDate"] as? String
                    let currentCity = comment["currentCity"] as? String
                    self.commentList.append(Comment(blogId: blogId ?? "", commentId: commentId ?? "", commentText: commentText ?? "", commentorId: commentorId ?? "", commentorImage: commentorImage ?? "", commentorName: commentorName ?? "", createdDate: createdDate ?? "", currentCity: currentCity ?? ""))
                }
            
                
            }
            if (self.commentList.count > 0)
                        {
                            self.tblView.isHidden = false
                            self.lblNoCommentt.isHidden = true
                        }
                        else
                        {

                            self.tblView.isHidden = true
                            self.lblNoCommentt.isHidden = false
                            
                        }
            self.tblView.reloadData()
        })
    }
    
    @IBAction func actionSend(_ sender: Any) {
          self.view.endEditing(true)
        if (txtComment.text?.trimmingCharacters(in: .whitespaces).count ?? 0) > 0 {
            addComment(text: txtComment.text ?? "")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentListCell") as! CommentListCell
        cell.lblUserName.text = commentList[indexPath.row].commentorName.firstCharacterUpperCase()
        cell.lblMessage.text = commentList[indexPath.row].commentText.firstCharacterUpperCase()
        let image = commentList[indexPath.row].commentorImage
        if let url = URL(string: image) {
            cell.userImage.sd_setImage(with: url, completed: nil)
        } else{
            cell.userImage.image = UIImage(named: "ic_avatar")
        }
        return cell
    }
    
    func setupLongPressGesture() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0 // 1 second press
        longPressGesture.delegate = self
        self.tblView.addGestureRecognizer(longPressGesture)
    }

    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {

        if longPressGestureRecognizer.state == UIGestureRecognizer.State.began {

            let touchPoint = longPressGestureRecognizer.location(in: self.view)
            if let indexPath = tblView.indexPathForRow(at: touchPoint) {

                // your code here, get the row for the indexPath or do whatever you want
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if commentList != nil{
            let dict = commentList[indexPath.row]
            let commentorId = dict.commentorId as? String
            if self.userId == commentorId {
                return true
            }else{
                return false
            }
        }else{
            return false
        }
    }
    
    
      func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
            
                let dict = self.commentList[indexPath.row]
            
            let edit = UITableViewRowAction.init(style: .normal, title: "Edit", handler: { (action, index) in
                
                let newvc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateCommentVC") as! UpdateCommentVC
                newvc.commentId = dict.commentId as? String ?? ""
                newvc.commentText = dict.commentText as? String ?? ""
                newvc.blogId = self.blogDetail?.blogId ?? ""
                    self.navigationController?.pushViewController(newvc, animated: true)
                
                })
                
                
                
                let delete = UITableViewRowAction.init(style: .normal, title: "Delete", handler: { (action, index) in
                    
                    var refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)

                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        
                         let commentId = dict.commentId as? String
                         self.deleteComment(commentId: commentId ?? "")
                        
                      }))

                    refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))

                    self.present(refreshAlert, animated: true, completion: nil)
                    
                })
                
               
                
                return [delete, edit]
        }
        
        
        @available(iOS 11.0, *)
        func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
            
                let frame = tableView.rectForRow(at: indexPath)
            
                let dict = self.commentList[indexPath.row]
            
                var backColor = UIColor.white
            
                
                let edit = UIContextualAction.init(style: .normal, title: "", handler: { (action, view, completion) in
                    
                    let newvc = self.storyboard?.instantiateViewController(withIdentifier: "UpdateCommentVC") as! UpdateCommentVC
                    newvc.commentId = dict.commentId as? String ?? ""
                    newvc.commentText = dict.commentText as? String ?? ""
                    newvc.blogId = self.blogDetail?.blogId ?? ""
                            self.navigationController?.pushViewController(newvc, animated: true)
                    
                })

            
                if frame.size.height > 64.0 {
                    edit.image = UIImage(named: "ic_edit_white_bigger")
                    edit.backgroundColor = .white
                    //used.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "ic_edit_yellow_bigger") ?? UIImage())
                    
                } else {
                    
                    edit.image = UIImage(named: "ic_edit_white_bigger")
                    edit.backgroundColor = .white
    //                used.backgroundColor = UIColor.init(patternImage: UIImage.init(named: "ic_edit_yellow") ?? UIImage())
                    
                }
                
                
            
                let delete = UIContextualAction.init(style: .normal, title: "", handler: { (action, view, completion) in
                    
                    var refreshAlert = UIAlertController(title: "Alert", message: "Are you sure you want to delete?", preferredStyle: UIAlertController.Style.alert)

                                       refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                        let commentId = dict.commentId as? String
                                        self.deleteComment(commentId: commentId ?? "")
                                           
                                         }))

                                       refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))

                                       self.present(refreshAlert, animated: true, completion: nil)
                  
                })
                if frame.size.height > 64.0 {
                    
                    delete.image = UIImage(named: "ic_delete_white_bigger")
                    delete.backgroundColor = .white
                    
                } else {
                    
                    delete.image = UIImage(named: "ic_delete_white_bigger")
                    delete.backgroundColor = .white
                    
                }
            
               
            
            let actions = UISwipeActionsConfiguration.init(actions: [delete, edit])
                actions.performsFirstActionWithFullSwipe = false
                return actions
    }
    
    func deleteComment(commentId: String) {

        let ref = Database.database().reference()

        ref.child("blogs").child(blogDetail?.blogId ?? "").child("comments").child(commentId).removeValue { (error, ref) in
            if error != nil {
                print("error \(error)")
            }else{
                self.updateCommentCount()
                self.getComment()
            }
        }
        
    }
    
    func updateCommentCount() {
    
        let count = "\((Int(self.comment as! String ?? "0") ?? 0) - 1)"
           
        var newCommentCount = "\(self.commentList.count)"
                print("\(newCommentCount):count")

                ref.child("blogs").child(blogDetail?.blogId ?? "").updateChildValues([
                    "commentCount": newCommentCount
                ]) { (error, ref) in

                    if error != nil {
                        print("error \(error)")
                    }else{
                        print("success")
                    }
                }
            
            
    }
    
    
}
extension CommentListVC : CommentListVCDelegate{
    func onRefreshData() {
        self.getComment()
    }
    
    
}

