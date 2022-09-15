//
//  SwipeUserViewController.swift
//  Mentea
//
//  Created by Apple on 23/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import TinderSwipeView
import FirebaseDatabase
import FirebaseAuth

let names = ["Adam Gontier","Matt Walst","Brad Walst","Neil Sanderson","Barry Stock","Nicky Patson"]


class SwipeUserViewController: UIViewController {
    
    var userList = [UserModel]()
    var isFrom = ""
    var ref: DatabaseReference!
    var userName = ""
    var userLocation = ""
    var userImageUrl = ""
    var latestest : UserModel? = nil
    var position = 0
    

    
    private var swipeView: TinderSwipeView<UserModel>!{
        didSet{
            self.swipeView.delegate = self
        }
    }

    @IBOutlet weak var viewContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Find your match"
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
        if let id = Helper.getPREF("userId") {
            ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let name = value?["name"] as? String {
                    self.userName = name
                }
                if let currentCity = value?["currentCity"] as? String {
                    self.userLocation = currentCity
                }
                if let image = value?["image"] as? String{
                    self.userImageUrl = image
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        userList.remove(at: position)
        userList.insert(latestest!, at: 0)
        
        // Dynamically create view for each tinder card
        let contentView: (Int, CGRect, UserModel) -> (UIView) = { (index: Int ,frame: CGRect , userModel: UserModel) -> (UIView) in
            
              let customView = CustomView(frame: frame)
                customView.userModel = userModel
//            customView.cornerRadius = 10
//            customView.shadow = true
                //customView.buttonAction.addTarget(self, action: #selector(self.customViewButtonSelected), for: UIControl.Event.touchUpInside)
                return customView
            
        }
        //let x = viewContainer.frame.origin.x
        //let y = viewContainer.frame.origin.y
        let newViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 32, height: viewContainer.bounds.height-60)
        swipeView = TinderSwipeView<UserModel>(frame: newViewFrame, contentView: contentView)
        viewContainer.addSubview(swipeView)
        swipeView.showTinderCards(with: userList ,isDummyShow: false)
        
    }
    
    @objc func customViewButtonSelected(button:UIButton){
        
//        if let customView = button.superview(of: CustomView.self) , let userModel = customView.userModel{
//            print("button selected for \(userModel.name!)")
//        }
        
    }
    
    func addMenteeToMentor(menteeId:String,name: String,image:String,currentCity:String, isQueue : String){
        
        var userID = ""
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        let params : [String:Any] = ["menteeUserId":menteeId,
                                     "name" : name,
                                     "image":image,
                                     "reportedStatus":"0",
                                     "currentCity":currentCity,
                                     "chatStatus":"0",
                                     "isQueue":isQueue]
        ref.child("mentorAssignUsers").child(userID).child(menteeId).updateChildValues(params) { (Error, DatabaseReference) in
            
            if Error != nil{
                print(Error?.localizedDescription ?? "")
                
            }else{
                print("Added user")
                self.addMentorToMentee(menteeId: menteeId , name: self.userName, image: self.userImageUrl, currentCity: self.userLocation,isQueue: isQueue)
            }
            
        }
        
    }
    
    func addMentorToMentee(menteeId:String,name: String,image:String,currentCity:String, isQueue : String){
           
           var userID = ""
           
           if Auth.auth().currentUser != nil {
               userID = Auth.auth().currentUser?.uid ?? ""
           }
           
           let params : [String:Any] = ["mentorUserId":userID,
                                        "name" : name,
                                        "image":image,
                                        "reportedStatus":"0",
                                        "currentCity": currentCity,
                                        "chatStatus":"0",
                                        "isQueue":isQueue]
           ref.child("mentorAssignUsers").child(menteeId).child(userID).updateChildValues(params) { (Error, DatabaseReference) in
               
               if Error != nil{
                   print(Error?.localizedDescription ?? "")
               }else{
                   print("Added user")
               }
               
           }
           
    }
    
//    func addMenteeToMentor(mentorId:String,name: String,image:String,currentCity:String){
//
//        var userID = ""
//
//        if Auth.auth().currentUser != nil {
//            userID = Auth.auth().currentUser?.uid ?? ""
//        }
//
//        let params : [String:Any] = ["mentorUserId":userID,
//                                     "name" : name,
//                                     "image":image,
//                                     "reportedStatus":"0",
//                                     "currentCity":currentCity]
//        ref.child("mentorAssignUsers").child(mentorId).child(userID).updateChildValues(params) { (Error, DatabaseReference) in
//
//            if Error != nil{
//                print(Error?.localizedDescription ?? "")
//            }else{
//                print("Added user")
//            }
//
//        }
//
//    }
    
    
    
}
extension SwipeUserViewController : TinderSwipeViewDelegate{
    
    func dummyAnimationDone() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveLinear, animations: {
            //self.viewNavigation.alpha = 1.0
        }, completion: nil)
        print("Watch out shake action")
    }
    
    func didSelectCard(model: Any) {
        print("Selected card")
    }
    
    func fallbackCard(model: Any) {
        let userModel = model as! UserModel
        print("Cancelling \(userModel.name!)")
    }
    
    func cardGoesLeft(model: Any) {
        
        let userModel = model as! UserModel
        print("Watchout Left \(userModel.name!)")
       
    }
    
    func cardGoesRight(model : Any) {
        
        let userModel = model as! UserModel
        print("Watchout Right \(userModel.name!)")
        //here
        self.updateMenteeCount(menteeId: userModel.userId, name: userModel.name, image: userModel.image, currentCity: userModel.currentCity ?? "")
        //self.addMenteeToMentor(menteeId: userModel.userId, name: userModel.name, image: userModel.image, currentCity:userModel.currentCity ?? "")
    }
    
    func undoCardsDone(model: Any) {
        let userModel = model as! UserModel
        print("Reverting done \(userModel.name!)")
    }
    
    func endOfCardsReached() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            //self.viewNavigation.alpha = 0.0
        }, completion: nil)
         print("End of all cards")
    }
    
    func currentCardStatus(card object: Any, distance: CGFloat) {
        if distance == 0 {
            //emojiView.rateValue =  2.5
        }else{
            let value = Float(min(abs(distance/100), 1.0) * 5)
            let sorted = distance > 0  ? 2.5 + (value * 5) / 10  : 2.5 - (value * 5) / 10
            //emojiView.rateValue =  sorted
        }
        print(distance)
    }
    
    
    func updateMenteeCount(menteeId: String, name: String, image: String, currentCity:String){
        
        var userID = ""
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        ref.child("users").child(userID).observeSingleEvent(of: .value) { (snapshot) in
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
                
                if (Int(noMenteeadded) ?? 0 < Int(noMentee) ?? 0) {
                    self.updateCount(countstr: noMenteeadded, menteeId: menteeId, name: name, image: image, currentCity:currentCity,isQueue:"0")
                } else {
                    self.updateCount(countstr: noMenteeadded, menteeId: menteeId, name: name, image: image, currentCity:currentCity,isQueue:"1")
                    Helper.showOKAlert(onVC: self, title: "", message: "You have added maximum number of mentees")
                }
            }
        }
   
    }

    func updateCount(countstr: String,menteeId: String, name: String, image: String, currentCity:String, isQueue : String){
        
        var userID = ""
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        let like = "\((Int(countstr) ?? 0) + 1)"
           //guard let key = self.ref.child("blogs").child(blogId).child("likes").childByAutoId().key else { return }

        let params = ["no_of_menteeadded" : like]

        self.ref.child("users").child(userID).updateChildValues([
               "no_of_menteeadded": like
        ])
        self.addMenteeToMentor(menteeId: menteeId, name: name, image: image, currentCity:currentCity ,isQueue: isQueue)
        
    }
    
    
}
