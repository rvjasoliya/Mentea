//
//  SignupStep1ViewController.swift
//  Mentea
//
//  Created by Apple on 22/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import PopupDialog
import WebKit
import CoreLocation
import GeoFire


class SignupStep1MrViewController : UIViewController {
    
    
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtLastName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblWhich: UILabel!
    @IBOutlet weak var img_password: UIImageView!
    
    var isFrom = ""
    var isSecureText = true
    var webView = WKWebView()
    var userType = ""
    var locationManager = CLLocationManager()
    
    var ref: DatabaseReference!
    var geoFire: GeoFire?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: ref.child("Geolocs"))
        txtFirstName.delegate = self
        txtLastName.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        
        
        if isFrom == "quick"{
            lblWhich.text = "Quick Registration"
        }else{
             lblWhich.text = "Registration"
        }
        
        // Do any additional setup after loading the view.
        
        img_password.isUserInteractionEnabled = true
        img_password.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTap(_:))))
        locationSetup()
        
    }
    
    override func viewWillLayoutSubviews() {
        txtFirstName.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        txtLastName.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        txtEmail.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        txtPassword.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
    }
    
    func locationSetup() {
           locationManager = CLLocationManager()
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestAlwaysAuthorization()
           locationManager.distanceFilter = 100
           locationManager.startUpdatingLocation()
           locationManager.delegate = self
       }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if isSecureText {
                   img_password.image = UIImage.init(named: "visible")
                   txtPassword.isSecureTextEntry = false
                   isSecureText = false
               } else {
                   img_password.image = UIImage.init(named: "hidden")
                   txtPassword.isSecureTextEntry = true
                   isSecureText = true
               }
    }
    
    
    
    
    
    @IBAction func handleBack(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)

        if let login = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
            //self.navigationController?.pushViewController(signup, animated: true)
            self.present(login, animated:true, completion:nil)
        }
        //self.callToAnother(callReceiverId: "abctext", callSenderName: "name", callSenderImage: "image")
        //callEnd()
    }
    
    
    @IBAction func handleNext(_ sender: Any) {
        
        //         let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        //
        //        if let signupmentor = storyBoard.instantiateViewController(withIdentifier: "SignupStep2MrViewController") as? SignupStep2MrViewController {
        //                                             self.present(signupmentor, animated:true, completion:nil)
        //                                      }
        
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
       // let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        //self.present(nextViewController, animated:true, completion:nil)
        
        let firstName = self.txtFirstName.text
        let lastName = self.txtLastName.text
        let email =  self.txtEmail.text
        let password = self.txtPassword.text
        
        if (firstName?.isEmpty == true || lastName?.isEmpty == true || email?.isEmpty == true || password?.isEmpty == true){
            Helper.showOKAlert(onVC: self, title: "Alert", message: "All feilds are required")
        }else if (!isValidEmail(emailStr: email ?? "")){
            Helper.showOKAlert(onVC: self, title: "Alert", message: "Please enter valid email")
        }else{
            if (isFrom == "quick"){
                quickSignUp(firstName: firstName!, lastName: lastName!, email: email!, password: password!, userType: userType)
            }else{
                signUp(firstName: firstName!, lastName: lastName!, email: email!, password: password!, userType: userType)
            }
            
        }
    
    }
    
    func quickSignUp(firstName:String,lastName:String,email:String,password:String,userType:String){
                Helper.showLoader(onVC: self,message: "")
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    Helper.hideLoader(onVC: self)
                    if let error = error {
                        print(error.localizedDescription)
                        Helper.showOKAlert(onVC: self, title: "Alert", message: error.localizedDescription)
                    }
                    else if let user = authResult?.user {
                        print(user)
                        self.AddSignUpData(firstName: firstName, lastName: lastName, email: email, password: password, userType: userType)
                    }
        
                }
    }
    
    func isValidEmail(emailStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailStr)
    }
    
    func signUp(firstName:String,lastName:String,email:String,password:String,userType:String){
        
        Helper.showLoader(onVC: self,message: "")
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    Helper.hideLoader(onVC: self)
                    if let error = error {
                        print(error.localizedDescription)
                        Helper.showOKAlert(onVC: self, title: "Alert", message: error.localizedDescription)
                    }
                    else if let user = authResult?.user {
                        print(user)
                        self.AddSignUpDataProcess(firstName: firstName, lastName: lastName, email: email, password: password, userType: userType)
                    }
        
                }
    }
    
     func AddSignUpDataProcess(firstName:String,lastName:String,email:String,password:String,userType:String) {
            //self.ref.child("users").child(user.uid).setValue(["username": ""])
        
        let location = userCurrentLocation
                      let latitude = "\(location?.coordinate.latitude ?? 0)"
                      let longitude = "\(location?.coordinate.longitude ?? 0)"
        
            let params = ["firstName" : firstName,
                          "lastName": lastName,
                          "email":email,
                          "password" : password,
                          "userType": userType,
                          "latitude":latitude == "0" ? "" : latitude,
                          "longitude":longitude == "0" ? "" : longitude,
                          "no_of_mentee":"3"]
            
            
            self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").setValue(params) { (Error, DatabaseReference) in
                if Error == nil{
                    print("successfull")
                    
                    let userId = Auth.auth().currentUser?.uid ?? ""
                    self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["userId":userId])
                    Helper.setPREF(userId, key: "userId")
                    Helper.setPREF(userType,key:"userType")
                    
                    if let location = userCurrentLocation {
                        self.geoFire?.setLocation(location, forKey:Auth.auth().currentUser?.uid ?? "")
                    }
                    
                    if userType == "Mentor" {
                    
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        if let signup = storyBoard.instantiateViewController(withIdentifier: "SignUpMentor1VC") as? SignUpMentor1VC{
                            signup.firstName = firstName
                            signup.lastName = lastName
                             self.present(signup, animated: true, completion: nil)
                        }
                    
                    } else {
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        if let signup = storyBoard.instantiateViewController(withIdentifier: "SignupMentee1ViewController") as? SignupMentee1ViewController{
                            signup.firstName = firstName
                            signup.lastName = lastName
                             self.present(signup, animated: true, completion: nil)
                        }
                    }
                   
                    
                   
                }else{
                    print(Error.debugDescription)
                }
            }
            
        }
    
    func AddSignUpData(firstName:String,lastName:String,email:String,password:String,userType:String) {
        //self.ref.child("users").child(user.uid).setValue(["username": ""])
        
        let location = userCurrentLocation
        let latitude = "\(location?.coordinate.latitude ?? 0)"
        let longitude = "\(location?.coordinate.longitude ?? 0)"
        
        let params = ["firstName" : firstName,
                      "lastName": lastName,
                      "email":email,
                      "password" : password,
                      "userType": userType,
                      "latitude":latitude == "0" ? "" : latitude,
                      "longitude":longitude == "0" ? "" : longitude,
                      "no_of_mentee":"3"]
        
        
        self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").setValue(params) { (Error, DatabaseReference) in
            if Error == nil{
                print("successfull")
                
                let userId = Auth.auth().currentUser?.uid ?? ""
                self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["userId":userId])
                Helper.setPREF(userId, key: "userId")
                Helper.setPREF(userType,key:"userType")
                
                if let location = userCurrentLocation {
                    self.geoFire?.setLocation(location, forKey:Auth.auth().currentUser?.uid ?? "")
                }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                self.present(nextViewController, animated:true, completion:nil)
                
            }else{
                print(Error.debugDescription)
            }
        }
        
    }
    
    
    @IBAction func handleLinkedIn(_ sender: Any) {
        linkedInAuthVC()
    }
    
    func linkedInAuthVC() {
        // Create linkedIn Auth ViewController
        let linkedInVC = UIViewController()
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        linkedInVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: linkedInVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: linkedInVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: linkedInVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: linkedInVC.view.trailingAnchor)
        ])
        
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        let authURLFull = LinkedInConstants.AUTHURL + "?response_type=code&client_id=" + LinkedInConstants.CLIENT_ID + "&scope=" + LinkedInConstants.SCOPE + "&state=" + state + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI
        
        
        let urlRequest = URLRequest.init(url: URL.init(string: authURLFull)!)
        webView.load(urlRequest)
        
        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: linkedInVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        linkedInVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        linkedInVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        linkedInVC.navigationItem.title = "linkedin.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        navController.navigationBar.barTintColor = UIColor.black
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical
        
        self.present(navController, animated: true, completion: nil)
    }
    
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshAction() {
        self.webView.reload()
    }
    
}


extension SignupStep1MrViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        RequestForCallbackURL(request: navigationAction.request)
        
        //Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("?code=") {
                self.dismiss(animated: true, completion: nil)
            }
        }
        decisionHandler(.allow)
    }
    
    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(LinkedInConstants.REDIRECT_URI) {
            if requestURLString.contains("?code=") {
                if let range = requestURLString.range(of: "=") {
                    let linkedinCode = requestURLString[range.upperBound...]
                    if let range = linkedinCode.range(of: "&state=") {
                        let linkedinCodeFinal = linkedinCode[..<range.lowerBound]
                        handleAuth(linkedInAuthorizationCode: String(linkedinCodeFinal))
                    }
                }
            }
        }
    }
    
    func handleAuth(linkedInAuthorizationCode: String) {
        linkedinRequestForAccessToken(authCode: linkedInAuthorizationCode)
    }
    
    func linkedinRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"
        
        // Set the POST parameters.
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&redirect_uri=" + LinkedInConstants.REDIRECT_URI + "&client_id=" + LinkedInConstants.CLIENT_ID + "&client_secret=" + LinkedInConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: LinkedInConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                
                let accessToken = results?["access_token"] as! String
                print("accessToken is: \(accessToken)")
                
                let expiresIn = results?["expires_in"] as! Int
                print("expires in: \(expiresIn)")
                
                // Get user's id, first name, last name, profile pic url
                self.fetchLinkedInUserProfile(accessToken: accessToken)
            }
        }
        task.resume()
    }
    
    func fetchLinkedInUserProfile(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInProfileModel = try? JSONDecoder().decode(LinkedInProfileModel.self, from: data!)
                
                //AccessToken
                print("LinkedIn Access Token: \(accessToken)")
                
                // LinkedIn Id
                let linkedinId: String! = linkedInProfileModel?.id
                print("LinkedIn Id: \(linkedinId ?? "")")
                
                // LinkedIn First Name
                let linkedinFirstName: String! = linkedInProfileModel?.firstName.localized.enUS
                print("LinkedIn First Name: \(linkedinFirstName ?? "")")
                
                // LinkedIn Last Name
                let linkedinLastName: String! = linkedInProfileModel?.lastName.localized.enUS
                print("LinkedIn Last Name: \(linkedinLastName ?? "")")
                
                // LinkedIn Profile Picture URL
                let linkedinProfilePic: String!
                
                if let pictureUrls = linkedInProfileModel?.profilePicture.displayImage.elements[2].identifiers[0].identifier {
                    linkedinProfilePic = pictureUrls
                } else {
                    linkedinProfilePic = "Not exists"
                }
                print("LinkedIn Profile Avatar URL: \(linkedinProfilePic ?? "")")
                
                // Get user's email address
                self.fetchLinkedInEmailAddress(accessToken: accessToken, firstName: linkedinFirstName, lastName: linkedinLastName)
            }
        }
        task.resume()
    }
    
    func fetchLinkedInEmailAddress(accessToken: String,firstName: String,lastName: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInEmailModel = try? JSONDecoder().decode(LinkedInEmailModel.self, from: data!)
                // LinkedIn Email
                let linkedinEmail: String! = linkedInEmailModel?.elements[0].elementHandle.emailAddress
                print("LinkedIn Email: \(linkedinEmail ?? "")")
                let customV = loginPasswordView(nibName: "loginPasswordView", bundle: nil)
                customV.headerText = self.isFrom == "Mentor" ? "Mentor" : "Mentee"
                let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false)
                customV.onCompletion = {(password) -> Void in
                    self.signUp(firstName: firstName, lastName: lastName, email: linkedinEmail, password: password, userType: self.isFrom == "Mentor" ? "Mentor" : "Mentee")
                }
                DispatchQueue.main.async {
                    self.present(popup, animated: true, completion: nil)
                }
            }
        }
        task.resume()
    }
}

extension SignupStep1MrViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtFirstName {
            txtLastName.becomeFirstResponder()
        } else if textField == txtLastName {
            txtEmail.becomeFirstResponder()
        } else if textField == txtEmail{
            txtPassword.becomeFirstResponder()
        }else{
            txtPassword.resignFirstResponder()
        }
        return true
    }
    
}

extension SignupStep1MrViewController : CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        manager.stopUpdatingLocation()
        userCurrentLocation = location
        userCurrentLocation?.fetchCityAndCountry{ city, country, error in
            guard let city = city, let country = country, error == nil else { return }
            print(city + ", " + country)  // Rio de Janeiro, Brazil
            globalcurrentCity = city
        }
        
    }

}
