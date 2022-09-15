//
//  IncomingCallViewController.swift
//  Mentea
//
//  Created by Apple on 18/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Firebase

class IncomingCallViewController: UIViewController {
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblIncomingtext: UILabel!
    
    var callReceiverId = ""
    var callSenderImage = ""
    var callSenderName = ""
    var callType = ""
     
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        print(callReceiverId)
        print(callSenderImage)
        print(callSenderName)
        print(callType)
        
        
    }
    
    
    @IBAction func handleCall(_ sender: Any) {
        self.getCall()
    }
    
    
    
    @IBAction func handleEnd(_ sender: Any) {
        self.callEnd()
    }
    
    func callEnd() {
        
        ref.child("calls").child(callReceiverId).removeValue { (error, databaseReference) in
            if error != nil{
                print("delete successfully")
            }else{
                print(error?.localizedDescription ?? "Error in delete")
            }
        }
        
    }
    
    
    func getCall(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if self.callType == "Audio" {
            
            if let voice = storyBoard.instantiateViewController(withIdentifier: "VoiceChatViewController") as? VoiceChatViewController {
                voice.modalPresentationStyle = .overCurrentContext
                self.present(voice, animated: true, completion: nil);
            }
            
        } else {
            
            if let video = storyBoard.instantiateViewController(withIdentifier: "VideoChatViewController") as? VideoChatViewController {
                video.modalPresentationStyle = .overCurrentContext
                self.present(video, animated: true, completion: nil);
            }
            
        }
        
      
    }
    
    func callToAnother(callType: String) {
        
        let params : [String:Any] = ["senderName":callSenderName,
                                     "senderImage":callSenderName,
                                     "callType":callType,
                                     "isIncomingCall" : "yes"]
        
        ref.child("calls").child(callReceiverId).updateChildValues(params) { (error, databaseReference) in
            
            if error != nil{
                print("updated")
            }else{
                print(error?.localizedDescription ?? "Error in update")
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
