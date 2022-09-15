//
//  SignUpViewController.swift
//  Mentea
//
//  Created by Apple on 22/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    var ref: DatabaseReference!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func handleBack(_ sender: Any) {
         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if let login = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
            //self.navigationController?.pushViewController(signup, animated: true)
            self.present(login, animated:true, completion:nil)
        }
    }
    
    @IBAction func handleMentor(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let signup = storyBoard.instantiateViewController(withIdentifier: "SignupStep1MrViewController") as? SignupStep1MrViewController{
            //self.navigationController?.pushViewController(signup, animated: true)
            signup.isFrom = "Mentor"
            self.present(signup, animated:true, completion:nil)
        }
        
    }
    
    
    @IBAction func hanleMentee(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let signup = storyBoard.instantiateViewController(withIdentifier: "SignupStep1MrViewController") as? SignupStep1MrViewController{
            //self.navigationController?.pushViewController(signup, animated: true)
            signup.isFrom = "Mentee"
            self.present(signup, animated:true, completion:nil)
        }
        
    }
    
    
    

}
