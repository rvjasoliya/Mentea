//
//  ForgetViewController.swift
//  Mentea
//
//  Created by Apple on 29/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ForgetViewController: UIViewController {
    
    
    @IBOutlet weak var txtEmail: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        txtEmail.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func handleSubmit(_ sender: Any) {
        var email = txtEmail.text ?? ""
        if  email.isEmpty == true{
            Helper.showOKAlert(onVC: self, title: "Alert", message: "Please enter your email")
        }else if (!isValidEmail(emailStr: email)){
             Helper.showOKAlert(onVC: self, title: "Alert", message: "Please enter valid email")
        }else{
            onForget(email: email)
        }
    }
    
    func onForget(email:String){
        Helper.showLoader(onVC: self, message: "")
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            Helper.hideLoader(onVC: self)
            if error != nil{
                Helper.showOKAlert(onVC: self, title: "Alert", message: error?.localizedDescription ?? "Reset Failed")
            }else {
                Helper.showOKAlert(onVC: self, title: "Forgot Password", message: "Reset email sent successfully, Check your email")
            }
            
        }
    }
    
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    
    @IBAction func handleBack(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
               
               if let login = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
                   //self.navigationController?.pushViewController(signup, animated: true)
                   self.present(login, animated:true, completion:nil)
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
extension ForgetViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            self.txtEmail.resignFirstResponder()
        } else{
            self.txtEmail.resignFirstResponder()
        }
        return true
    }
    
}

