//
//  loginPasswordView.swift
//  Mentea
//
//  Created by Rv on 13/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class loginPasswordView: UIViewController {
    
    @IBOutlet weak var lblheader: UILabel!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtRePassword: UITextField!
    @IBOutlet weak var img_password: UIImageView!
    @IBOutlet weak var img_password2: UIImageView!
    
    @IBOutlet weak var password2View: UIView!
    
    var isSecureText = true
    var isSecureText2 = true
    
    var isOnlyPassword = false

    var headerText: String?
    
    typealias CompletionBlock = (_ password: String) -> Void
    var onCompletion:CompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtPassword.delegate = self
        txtRePassword.delegate = self
        txtPassword.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        txtRePassword.addBottomBorderWithColor(color: UIColor.lightGray, width: 0.5)
        img_password.isUserInteractionEnabled = true
        img_password.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTap(_:))))
        
        img_password2.isUserInteractionEnabled = true
        img_password2.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTap2(_:))))
        
        if (isOnlyPassword) {
            password2View.isHidden = true
        } else{
            lblheader.text = headerText
        }
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if isSecureText {
            img_password.image = #imageLiteral(resourceName: "ic_password")
            txtPassword.isSecureTextEntry = false
            isSecureText = false
        } else {
            img_password.image = UIImage.init(named: "ic_hide_password")
            txtPassword.isSecureTextEntry = true
            isSecureText = true
        }
    }
    
    @objc func handleTap2(_ sender: UITapGestureRecognizer) {
        if isSecureText2 {
            img_password2.image = #imageLiteral(resourceName: "ic_password")
            txtRePassword.isSecureTextEntry = false
            isSecureText2 = false
        } else {
            img_password2.image = UIImage.init(named: "ic_hide_password")
            txtRePassword.isSecureTextEntry = true
            isSecureText2 = true
        }
    }
    
    @IBAction func handleSubmit(_ sender: Any) {
        let password = self.txtPassword.text
        if (isOnlyPassword) {
            if (password?.isEmpty == true){
                Helper.showOKAlert(onVC: self, title: "Alert", message: "Enter Password")
                return
            }
            if let isCompletion = self.onCompletion {
                isCompletion(password ?? "")
                self.dismiss(animated: true, completion: nil)
            }
        } else{
            let password2 = self.txtRePassword.text
            if (password?.isEmpty == true) && (password2?.isEmpty == true) {
                Helper.showOKAlert(onVC: self, title: "Alert", message: "All feilds are required")
                return
            }
            if (password == password2){
                if let isCompletion = self.onCompletion {
                    isCompletion(password ?? "")
                    self.dismiss(animated: true, completion: nil)
                }
            } else{
                Helper.showOKAlert(onVC: self, title: "Alert", message: "Password not match")
            }
        }
    }
    
    
}

extension loginPasswordView: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtPassword {
            txtRePassword.becomeFirstResponder()
        } else{
            txtPassword.resignFirstResponder()
        }
        return true
    }
    
}
