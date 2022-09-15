//
//  CreatePostVC.swift
//  Mentea
//
//  Created by Rv on 12/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase


class UpdateCommentVC: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var lblUserName: UILabel!
       @IBOutlet weak var userImage: UIImageView!
       @IBOutlet weak var txtPostText: UITextView!
    
    
    var userName : String?
    var userImg : UIImage?
    var placeholderLabel : UILabel!
    var userImageUrl : String?
    var userLocation : String?
    typealias CompletionBlock = (_ isAdd: Bool) -> Void
    var onCompletion:CompletionBlock?
    var ref: DatabaseReference!
    var commentId = ""
    var commentText = ""
    var blogId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.title = "Comment"
        userImage.image = userImg
        lblUserName.text = userName 
        
        txtPostText.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = ""
        placeholderLabel.font = UIFont.systemFont(ofSize: (txtPostText.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        txtPostText.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (txtPostText.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.isHidden = !txtPostText.text.isEmpty
        txtPostText.text = commentText.firstCharacterUpperCase()
    }
    
    @IBAction func actionPost(_ sender: Any) {
        if (txtPostText.text?.trimmingCharacters(in: .whitespaces).count ?? 0) > 0 {
            updateCommentText()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
    }
    
    func updateCommentText() {
               let ref = Database.database().reference()
        ref.child("blogs").child(blogId).child("comments").child(commentId).updateChildValues([
                       "commentText":
                        self.txtPostText.text ?? ""]) { (error, ref) in
                       
                       if error != nil {
                           print("error \(error)")
                       }else{
                           print("success")
                        Helper.showOKAlert(onVC: self, title: "Successfull", message: "Comment updated successfully.")
                        commentListVCDelegate?.onRefreshData()
                        //self.dismiss(animated: true, completion: nil)
                        //self.dismiss(animated: true, completion: nil)
                        
                       }
                   }
               
               
           
       }
    
    
    
//    func addPost(text: String) {
//        guard let key = self.ref.child("blogs").childByAutoId().key else { return }
//        let date = Date().string(format: "yyyy-MM-dd HH:mm:ss")
//
//        let params = ["blogId" : key,
//                      "blogText":text,"bloggerId":Helper.getPREF("userId") ?? "","bloggerImage":userImageUrl ?? "",
//                      "bloggerName": userName ?? "","createdDate":date,"currentCity":self.userLocation ?? "","commentCount":"0","likesCount":"0"]
//
//        self.ref.child("blogs").child(key).setValue(params) { (Error, DatabaseReference) in
//            if Error == nil{
//            }else{
//                print(Error.debugDescription)
//            }
//            if let isCompletion = self.onCompletion {
//                isCompletion(true)
//                self.navigationController?.popViewController(animated: true)
//            }
//        }
//    }
    
}
