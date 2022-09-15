//
//  VoiceChatViewController.swift
//  Agora-iOS-Voice-Tutorial
//
//  Created by GongYuhua on 2017/4/10.
//  Copyright © 2017年 Agora. All rights reserved.
//

import UIKit
import AgoraRtcKit
import FirebaseDatabase

class VoiceChatViewController: UIViewController {

    var ref: DatabaseReference!
    
    @IBOutlet weak var controlButtonsView: UIView!
    
    @IBOutlet weak var imgUSer: UIImageView!
    var receiver_Id = ""
    var userName = ""
    var userLocation = ""
    var userImageUrl = ""
    var email = ""
    
    
    var agoraKit: AgoraRtcEngineKit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        initializeAgoraEngine()
        joinChannel()
        print(receiver_Id)
        
    }
    
    func showData(){
            
                   if let id = receiver_Id as? String{
                       ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                           let value = snapshot.value as? NSDictionary
                        
                           //"firstName" : firstName,
                           //"lastName":
                        if let firstName = value?["firstName"] as? String {
                            if let lastName = value?["lastName"] as? String{
                                self.userName = firstName+" "+lastName
                            }else{
                                self.userName = firstName
                            }
                        }
                        
                        
                        
                        
    //                       if let name = value?["name"] as? String {
    //                           self.userName = name
    //                       }
                        
                           if let currentCity = value?["currentCity"] as? String {
                               self.userLocation = currentCity
                           }
                        
                        if let image = value?["image"] as? String{
                            if let url = URL(string: image) {
                                self.imgUSer.sd_setImage(with: url, completed: nil)
                            } else{
                                self.imgUSer.image = UIImage(named: "ic_avatar")
                            }
                            //self.imgUSer.image = self.userImageUrl
                        }else{
                           self.imgUSer.image = UIImage(named: "ic_avatar")
                        }
                        
//                           if let image = value?["image"] as? String{
//                               self.userImageUrl = image
//                           }
                        if let email = value?["email"] as? String{
                            self.email = email
                        }
                        
                           
                       }) { (error) in
                           print(error.localizedDescription)
                       }
                   }
        }
    
    
    func callEnd() {
        
        ref.child("calls").child(receiver_Id).removeValue { (error, databaseReference) in
            if error == nil{
                print("delete successfully")
            }else{
                print(error?.localizedDescription ?? "Error in delete")
            }
        }
        
    }
    
    
    func initializeAgoraEngine() {
        // Initializes the Agora engine with your app ID.
        agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
          callEnd()
      }
    
    
    func joinChannel() {
        // Allows a user to join a channel.
        agoraKit.joinChannel(byToken: Token, channelId: "demoChannel", info:nil, uid:0) {[unowned self] (sid, uid, elapsed) -> Void in
            // Joined channel "demoChannel"
            self.agoraKit.setEnableSpeakerphone(true)
            UIApplication.shared.isIdleTimerDisabled = true
        }
    }
    
    @IBAction func didClickHangUpButton(_ sender: UIButton) {
        leaveChannel()
        callEnd()
        self.dismiss(animated: true, completion: nil)
    }
    
    func leaveChannel() {
        agoraKit.leaveChannel(nil)
        hideControlButtons()
        
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    func hideControlButtons() {
        controlButtonsView.isHidden = true
    }
    
    @IBAction func didClickMuteButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // Stops/Resumes sending the local audio stream.
        agoraKit.muteLocalAudioStream(sender.isSelected)
    }
    
    @IBAction func didClickSwitchSpeakerButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        // Enables/Disables the audio playback route to the speakerphone.
        //
        // This method sets whether the audio is routed to the speakerphone or earpiece. After calling this method, the SDK returns the onAudioRouteChanged callback to indicate the changes.
        agoraKit.setEnableSpeakerphone(sender.isSelected)
    }
}
