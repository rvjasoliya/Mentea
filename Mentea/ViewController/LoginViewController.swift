//
//  LoginViewController.swift
//  Mentea
//
//  Created by Apple on 21/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase
import WebKit
import PopupDialog
import CoreLocation
import FBSDKLoginKit
import GeoFire
//import FBSDKShareKit

class LoginViewController: UIViewController {
    
    
    //@IBOutlet weak var vwLogin: UIScrollView!
    
    //@IBOutlet weak var vwFirst: UIView!
    
    @IBOutlet weak var vwLogin: UIScrollView!
    @IBOutlet weak var vwFirst: UIView!
    
    @IBOutlet weak var textEmail: UITextField!
    @IBOutlet weak var textPassword: UITextField!
    @IBOutlet weak var img_password: UIImageView!
    
    @IBOutlet weak var vwSignUp: UIView!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var imgMentor: UIImageView!
    @IBOutlet weak var imgMentee: UIImageView!
    
    @IBOutlet weak var agreeBtn: UIImageView!
    
    
    var ref: DatabaseReference!
    var isSecureText = true
    var webView = WKWebView()
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var imgCkeckMentor: UIImageView!
    
    @IBOutlet weak var imgCheckMentee: UIImageView!
    var userType = ""
    var agree = "checkbox"
    var geoFire: GeoFire?
    
    @IBOutlet weak var lblAgree: UILabel!
    
    
    @IBOutlet weak var btnAgree: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        ref = Database.database().reference()
        geoFire = GeoFire(firebaseRef: ref.child("Geolocs"))
        // Do any additional setup after loading the view.
        textEmail.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        textPassword.addBottomBorderWithColor(color: UIColor.white, width: 0.5)
        self.loadLocation()
        imgCkeckMentor.isHidden = true
        imgCheckMentee.isHidden = true
        
        img_password.isUserInteractionEnabled = true
        imgMentor.isUserInteractionEnabled = true
        imgMentee.isUserInteractionEnabled = true
        img_password.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleTap(_:))))
        
        imgMentor.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickMentor)))
        
        imgMentee.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(clickMentee)))
        
//        var main_string = "Don't have an account? SignUp"
//        var string_to_color = " SignUp"
//
//        var range = (main_string as NSString).range(of: string_to_color)
//        
//        var attributedString = NSMutableAttributedString(string:main_string)
//        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(hexString: "3b5998") , range: range)
//        
//        btnSignUp.setAttributedTitle(attributedString, for: .selected)
        
        self.vwSignUp.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        self.vwSignUp.addGestureRecognizer(gesture)
        
        self.agreeBtn.isUserInteractionEnabled = true
        let gestures = UITapGestureRecognizer(target: self, action:  #selector(self.onClick))
        self.agreeBtn.addGestureRecognizer(gestures)
        
        let myAttribute = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0) ]
        let myString = NSMutableAttributedString(string: "I agree to Terms of service & privacy policy", attributes: myAttribute )
        var myRange = NSRange(location: 11, length: 16) // range starting at location 17 with a lenth of 7: "Strings"
              var myRange1 = NSRange(location: 29, length: 15)
        
        myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: myRange)
         myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: myRange1)
        
        lblAgree.attributedText = myString
        
        btnAgree.setImage(UIImage(named: "checkbox"), for: .normal)
        agree = "checkbox"
        
        let myAttribute1 = [ NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14.0) ]
        let myString1 = NSMutableAttributedString(string: "Don't have an account? SignUp", attributes: myAttribute1 )
        var myRange2 = NSRange(location: 11, length: 16) // range starting at location 17 with a lenth of 7: "Strings"
        myString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: myRange2)
        
        lblAgree.attributedText = myString
        
    }
    
   
    @IBAction func handleAgreeBtn(_ sender: UIButton) {
        if sender.currentImage == UIImage(named: "checkbox"){
        
        sender.setImage(UIImage(named: "blankCheckbox"), for: .normal)
             agree = "blankCheckbox"
        }
        else
        {
          sender.setImage(UIImage(named: "checkbox"), for: .normal)
             agree = "checkbox"
        }
        
        
    }
    
    @objc func onClick(sender : UITapGestureRecognizer)
    {
        let img = sender.view as! UIImageView
        if img.image == UIImage(named: "checkbox"){
            img.image = UIImage.init(named: "blankCheckbox")
            agree = "blankCheckbox"
           
        }
          else{
            img.image = UIImage.init(named: "checkbox")
            agree = "checkbox"
        }
       
    }
    
    
    @IBAction func handleFacebook(_ sender: Any) {
         if userType == "" {
            Helper.showOKAlert(onVC: self, title: "", message: "Please select user type")
        }
         else if agree == "blankCheckbox" {
            
             Helper.showOKAlert(onVC: self, title: "", message: "Please accept terms & conditions")
                        
        }
         else {
            handleFB()
        }
    }
    
    func handleFB(){
        if WSManager.isConnectedToInternet() {
               let loginManager = LoginManager()
                
                loginManager.logIn(permissions: ["email"], from: self, handler: { result, error in

                    guard let result = result else {
                        print("No result found")
                        return
                    }
                    if result.isCancelled {
        //                print("Cancelled \(error?.localizedDescription)")
                    } else if let error = error {
                        print("Process error \(error.localizedDescription)")
                    } else {
                        print("Logged in")
                        self.getFBUserData()
                    }
                })
            } else {
            let alert : UIAlertController = UIAlertController(title: "Alert", message: "No Internet Connection", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style:.cancel, handler: nil))
                
               self.present(alert, animated: true, completion: nil)
            }
    }
    
    // MARK: GET DATA FROM FACEBOOK
        func getFBUserData() {
            if((AccessToken.current) != nil) {
                GraphRequest(graphPath: "me", parameters: ["fields": "id, gender, email, name, picture.width(400).height(400)"]).start(completionHandler: { (connection, result, error) -> Void in
                    if (error == nil) {
                        print(result ?? [:])
                        var firstName = ""
                        var lastName = ""
                        var email = ""
                        var fbId = ""
                        var image = ""
                        //var country = ""
                        
                        if let result = result as? [String: AnyObject] {
                            
                            print(result)
                            if let name = result["name"] as? String {
                                let completeName = name.split(separator: " ")
                                firstName = String(completeName[0])
                                lastName = (completeName.count > 1 ? String(completeName[1]) : nil) ?? ""
                            }
                            
                            if let _fbId = result["id"] as? String {
                                fbId = _fbId
                            }
                            
                            if let _email = result["email"] as? String {
                                email = _email
                                print(email)
                            }
                            
                            if let picture = result["picture"] as? Dictionary<String,Any> {
                                if let data = picture["data"] as? Dictionary<String,Any> {
                                    if let pictureUrl = data["url"] as? String {
                                        print(pictureUrl)
                                        image = pictureUrl
                                    }
                                }
                            }
                            
                            
    //                        if let _country = result["country"] as? String {
    //                            print(_country)
    //                            country = _country
    //                        }
    //
                            //Helper.showLoader(onVC: self, message: NSLocalizedString("LOADING", comment: ""))
                            //self.facebookLogin(firstName, lastName, email, fbId)
                              Auth.auth().fetchSignInMethods(forEmail: email) { (list, error) in
                                                if (list == nil) {
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                                        let customV2 = loginPasswordView(nibName: "loginPasswordView", bundle: nil)
                                                        let popup = PopupDialog(viewController: customV2, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false)
                                                        customV2.onCompletion = {(password) -> Void in
                                                            self.signUp(firstName: firstName, lastName: lastName, email: email, password: password, userType: self.userType,image:image)
                                                        }
                                                        DispatchQueue.main.async {
                                                            self.present(popup, animated: true, completion: nil)
                                                        }
                                                    }
                                                    
                                                } else{
                                                    let customV = loginPasswordView(nibName: "loginPasswordView", bundle: nil)
                                                    customV.isOnlyPassword = true
                                                    customV.headerText = "Login"
                                                    let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false)
                                                    customV.onCompletion = {(password) -> Void in
                                                        self.onLogin(email: email, password: password)
                                                    }
                                                    DispatchQueue.main.async {
                                                        self.present(popup, animated: true, completion: nil)
                                                    }
                                                }
                                            }
                            
                        }
                    }
                })
            }
        }
    
    
    @IBAction func btnLoginTextClick(_ sender: Any) {
        self.vwFirst.isHidden = true
        self.vwLogin.isHidden = false
        
    }
    
    
    
    
    @objc func clickMentor(sender : UITapGestureRecognizer) {
        self.userType = "Mentor"
        self.imgCkeckMentor.isHidden = false
        self.imgCheckMentee.isHidden = true
    }
    
    @objc func clickMentee(sender : UITapGestureRecognizer) {
         self.userType = "Mentee"
         self.imgCkeckMentor.isHidden = true
         self.imgCheckMentee.isHidden = false
    }
    
    
    
    @IBAction func handleClick(_ sender: Any) {
        if userType == "" {
            
            Helper.showOKAlert(onVC: self, title: "", message: "Please select user type")
            
        }
            else if agree == "blankCheckbox" {
                
                Helper.showOKAlert(onVC: self, title: "", message: "Please accept terms & conditions")
                
            }
        else {
            print("click_click")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if let signup = storyBoard.instantiateViewController(withIdentifier: "SignupStep1MrViewController") as? SignupStep1MrViewController {
                //self.navigationController?.pushViewController(signup, animated: true)
                signup.isFrom = "quick"
                signup.userType = self.userType
                //signup.
                signup.modalPresentationStyle = .overFullScreen
                self.present(signup, animated: true, completion: nil);
                //self.navigationController?.pushViewController(signup, animated: true)
                       
                print("click_click11")
            }else{
                print("click_click22")
            }
            
        }
    }
    
    
    
    @IBAction func handleLinkedin(_ sender: Any) {
        if userType == "" {
            
            Helper.showOKAlert(onVC: self, title: "", message: "Please select user type")
            
        } else if agree == "blankCheckbox" {
                 Helper.showOKAlert(onVC: self, title: "", message: "Please accept terms & conditions")
            }
        else{
         linkedInAuthVC()
        }
    }
    
    
    
    @IBAction func handleSignup(_ sender: Any) {
        
        if userType == "" {
                   
                   Helper.showOKAlert(onVC: self, title: "", message: "Please select user type")
                   
               }
        else if agree == "blankCheckbox" {
        Helper.showOKAlert(onVC: self, title: "", message: "Please accept terms & conditions")
                       
        }
        else {
            
                    
            
                   let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                   if let signup = storyBoard.instantiateViewController(withIdentifier: "SignupStep1MrViewController") as? SignupStep1MrViewController{
                       //self.navigationController?.pushViewController(signup, animated: true)
                        signup.isFrom = "complete"
                        signup.userType = self.userType
                        //navigationController?.pushViewController(signup, animated: true)
                        self.present(signup, animated: true, completion: nil)
                   }
                   
               }
        
        //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
           //let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            //self.present(nextViewController, animated:true, completion:nil)
        
//        if let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
//            self.present(tabbar, animated: true, completion: nil)
//        }
    }
    
    
    
    @objc func checkAction(sender : UITapGestureRecognizer) {
        
        self.vwFirst.isHidden = false
        self.vwLogin.isHidden = true
        
//          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//          if let signup = storyBoard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController{
//              //self.navigationController?.pushViewController(signup, animated: true)
//              self.present(signup, animated:true, completion:nil)
//          }
    }
       
    
//    func locationSetup() {
//        locationManager = CLLocationManager()
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestAlwaysAuthorization()
//        locationManager.distanceFilter = 100
//        locationManager.startUpdatingLocation()
//        locationManager.delegate = self
//    }
    
    func loadLocation() {
           if CLLocationManager.locationServicesEnabled() {
               print("Location services are enabled")
               locationManager.requestAlwaysAuthorization()
               locationManager.requestWhenInUseAuthorization()
               if CLLocationManager.locationServicesEnabled() {
                   locationManager.delegate = self
                   locationManager.desiredAccuracy = 100
                   locationManager.startUpdatingLocation()
                   
               } else {
                   print("Location services are not enabled")
               }
               
           } else {
                print("Location services are not enabled")
               let alert = UIAlertController(title: "", message: "Location services are not enabled, please go to Settings and turn on Location Service for this app.", preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { (alert: UIAlertAction!) in
                  
                   if let url = URL(string:UIApplication.openSettingsURLString) {
                       if UIApplication.shared.canOpenURL(url) {
                           if #available(iOS 10.0, *) {
                               UIApplication.shared.open(url, options: [:], completionHandler: nil)
                           } else {
                               UIApplication.shared.openURL(url)
                           }
                       }
                   } //UIApplication.shared.openURL(NSURL(string:UIApplicationOpenSettingsURLString)! as URL)
               }))
               alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil
               ))
               
               present(alert, animated: true, completion: nil)
              
           }
          
       }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        if isSecureText {
            img_password.image = UIImage.init(named: "visible")
            textPassword.isSecureTextEntry = false
            isSecureText = false
        } else {
            img_password.image = UIImage.init(named: "hidden")
            textPassword.isSecureTextEntry = true
            isSecureText = true
        }
    }
    
    @IBAction func handleForgotPassword(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        if let signup = storyBoard.instantiateViewController(withIdentifier: "ForgetViewController") as? ForgetViewController{
            //self.navigationController?.pushViewController(signup, animated: true)
            self.present(signup, animated:true, completion:nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        setInitialViewController()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    func setInitialViewController() {
        if Helper.getPREF("userId") != nil {
            print("login yes")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as? SWRevealViewController{
                  DispatchQueue.main.async {
                        nextViewController.modalPresentationStyle = .overFullScreen
                        self.present(nextViewController, animated:true, completion:nil)
                }
            }
            
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            if let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
//
//                DispatchQueue.main.async {
//                    tabbar.modalPresentationStyle = .overFullScreen
//                    self.present(tabbar, animated: true, completion: nil)
//                }
//            }
        }else{
            print("login no")
            self.loadLocation()
        }
    }
    
    
    @IBAction func handleLogin(_ sender: Any) {
                //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                //if let tabbar = storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
                   // self.present(tabbar, animated: true, completion: nil)
             //  }
        let email = textEmail.text
        let password = textPassword.text
        onLogin(email: email ?? "" , password: password ?? "")
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func onLogin(email:String,password:String) {
        Helper.showLoader(onVC: self,message: "")
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            Helper.hideLoader(onVC: self)
            if let error = error {
                print(error.localizedDescription)
                Helper.showOKAlert(onVC: self, title: "Alert", message: error.localizedDescription)
            }
            else if let user = user {
                print(user)
                print(user.user.uid)
                let userId = user.user.uid
                self.getUserDetail(userID: userId)
                Helper.setPREF(userId, key: "userId")
            }
        }
        
        
    }
    
    func getUserDetail(userID:String){
        ref.child("users").child(userID).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            if let firstname = value?["firstname"] as? String{
                print(firstname)
            }
            if let userType = value?["userType"] as? String{
                print(userType)
                Helper.setPREF(userType, key: "userType")
            }
            
            //let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//            if let tabbar = self.storyboard?.instantiateViewController(withIdentifier: "tabbar") as? UITabBarController {
//                self.present(tabbar, animated: true, completion: nil)
//            }
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                           let nextViewController = storyBoard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
                           self.present(nextViewController, animated:true, completion:nil)
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
   
    @IBAction func handleRegister(_ sender: Any) {
        self.vwFirst.isHidden = false
        self.vwLogin.isHidden = true
        
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

extension LoginViewController: WKNavigationDelegate {
    
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
                    linkedinProfilePic = ""
                }
                print("LinkedIn Profile Avatar URL: \(linkedinProfilePic ?? "")")
                
                // Get user's email address
                self.fetchLinkedInEmailAddress(accessToken: accessToken, firstName: linkedinFirstName, lastName: linkedinLastName, linkedinProfilePic: linkedinProfilePic)
            }
        }
        task.resume()
    }
    
    func signUp(firstName:String,lastName:String,email:String,password:String,userType:String,image:String){
        Helper.showLoader(onVC: self,message: "")
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
             Helper.hideLoader(onVC: self)
            if let error = error {
                print(error.localizedDescription)
                Helper.showOKAlert(onVC: self, title: "Alert", message: error.localizedDescription)
            }
            else if let user = authResult?.user {
                print(user)
                self.AddSignUpData1(firstName: firstName, lastName: lastName, email: email, password: password, userType: userType,image:image)
            }
            
        }
    }
    
     func AddSignUpData(firstName:String,lastName:String,email:String,password:String,userType:String){
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
//           if userType == "Mentor" {
//                if let signupmentor = storyBoard.instantiateViewController(withIdentifier: "SignupStep2MrViewController") as? SignupStep2MrViewController {
//                        signupmentor.name = firstName + " " + lastName
//                    signupmentor.firstname = firstName
//                    signupmentor.lastName = lastName
//                    signupmentor.email = email
//                    signupmentor.password = password
//                    signupmentor.userType = userType
//
//                        //self.present(signupmentor, animated:true, completion:nil)
//                    navigationController?.pushViewController(signupmentor, animated: true)
//
//                    }
//                } else {
//                        if let signupmentee = storyBoard.instantiateViewController(withIdentifier: "SignupStep2MenteeViewController") as? SignupStep2MenteeViewController {
//                                signupmentee.name = firstName + " " + lastName
//                            signupmentee.firstname = firstName
//                            signupmentee.lastName = lastName
//                            signupmentee.email = email
//                            signupmentee.password = password
//                            signupmentee.userType = userType
//
//                            navigationController?.pushViewController(signupmentee, animated: true)
//
//
//                                //self.present(signupmentee, animated:true, completion:nil)
//                        }
//                }
            
            
        }
    
    
    
    func AddSignUpData1(firstName:String,lastName:String,email:String,password:String,userType:String,image:String) {
        //self.ref.child("users").child(user.uid).setValue(["username": ""])
        let location = userCurrentLocation
               let latitude = "\(location?.coordinate.latitude ?? 0)"
               let longitude = "\(location?.coordinate.longitude ?? 0)"
        
        let params = ["firstName" : firstName,
                      "lastName": lastName,
                      "email":email,
                      "password" : password,
                      "userType": userType,
                      "currentCity": globalcurrentCity,
                      "latitude":latitude == "0" ? "" : latitude,
                      "longitude":longitude == "0" ? "" : longitude,
                      "image":image,
                      "no_of_mentee":"3"]
        
        
    self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").setValue(params) { (Error, DatabaseReference) in
            if Error == nil{
                print("successfull")
                
                let userId = Auth.auth().currentUser?.uid ?? ""
                
                self.ref.child("users").child(Auth.auth().currentUser?.uid ?? "").updateChildValues(["userId":userId])
                
                Helper.setPREF(userId, key: "userId")
                Helper.setPREF(userType, key: "userType")
                
                if let location = userCurrentLocation {
                    self.geoFire?.setLocation(location, forKey:Auth.auth().currentUser?.uid ?? "")
                }
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                       
                       if userType == "Mentor" {
                           if let signupmentor = storyBoard.instantiateViewController(withIdentifier: "SignUpMentor1VC") as? SignUpMentor1VC {
                                    signupmentor.firstName = firstName
                                    signupmentor.lastName = lastName
                                      self.present(signupmentor, animated:true, completion:nil)
                               }
                       } else {
                           if let signupmentee = storyBoard.instantiateViewController(withIdentifier: "SignupMentee1ViewController") as? SignupMentee1ViewController {
                                    signupmentee.firstName = firstName
                                    signupmentee.lastName = lastName
                                  self.present(signupmentee, animated:true, completion:nil)
                           }
                       }
            }else{
                print(Error.debugDescription)
            }
        }
        
    }
    
    func fetchLinkedInEmailAddress(accessToken: String,firstName: String,lastName: String,linkedinProfilePic:String) {
        let tokenURLFull = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInEmailModel = try? JSONDecoder().decode(LinkedInEmailModel.self, from: data!)
                
                // LinkedIn Email
                let linkedinEmail: String! = linkedInEmailModel?.elements[0].elementHandle.emailAddress
                print("LinkedIn Email: \(linkedinEmail ?? "")")
                
                Auth.auth().fetchSignInMethods(forEmail: linkedinEmail) { (list, error) in
                    if (list == nil) {
                        
                        //self.signUp(firstName: firstName, lastName: lastName, email: linkedinEmail, password: password, userType:userType)
                        
                        //let customV = LoginTypeView(nibName: "LoginTypeView", bundle: nil)
//                        let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false)
//                        customV.onCompletion = {(isMentor) -> Void in
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                let customV2 = loginPasswordView(nibName: "loginPasswordView", bundle: nil)
//                                customV2.headerText = isMentor == true ? "Mentor" : "Mentee"
//                                let popup = PopupDialog(viewController: customV2, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false)
//                                customV2.onCompletion = {(password) -> Void in
//                                    self.signUp(firstName: firstName, lastName: lastName, email: linkedinEmail, password: password, userType: isMentor == true ? "Mentor" : "Mentee")
//                                }
//                                DispatchQueue.main.async {
//                                    self.present(popup, animated: true, completion: nil)
//                                }
//                            }
//                        }
//                        DispatchQueue.main.async {
//                            self.present(popup, animated: true, completion: nil)
//                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            let customV2 = loginPasswordView(nibName: "loginPasswordView", bundle: nil)
                            let popup = PopupDialog(viewController: customV2, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false)
                            customV2.onCompletion = {(password) -> Void in
                                self.signUp(firstName: firstName, lastName: lastName, email: linkedinEmail, password: password, userType: self.userType,image: linkedinProfilePic)
                            }
                            DispatchQueue.main.async {
                                self.present(popup, animated: true, completion: nil)
                            }
                        }
                        
                    } else{
                        let customV = loginPasswordView(nibName: "loginPasswordView", bundle: nil)
                        customV.isOnlyPassword = true
                        customV.headerText = "Login"
                        let popup = PopupDialog(viewController: customV, buttonAlignment: .horizontal, transitionStyle: .bounceDown, tapGestureDismissal: false)
                        customV.onCompletion = {(password) -> Void in
                            self.onLogin(email: linkedinEmail, password: password)
                        }
                        DispatchQueue.main.async {
                            self.present(popup, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        task.resume()
    }
}

extension LoginViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textEmail {
            self.textPassword.becomeFirstResponder()
        } else{
            self.textPassword.resignFirstResponder()
        }
        return true
    }
}


extension LoginViewController: CLLocationManagerDelegate {

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
func getProfPic(fid: String) -> String? {
    if (fid != "") {
        var imgURLString = "http://graph.facebook.com/" + fid + "/picture?type=large" //type=normal
        return imgURLString
    }
    return ""
}
