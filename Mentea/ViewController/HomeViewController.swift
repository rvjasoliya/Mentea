//
//  HomeViewController.swift
//  Mentea
//
//  Created by Apple on 15/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import DropDown
import TinderSwipeView
import FirebaseDatabase
import Firebase
import SDWebImage
import CoreLocation
import GeoFire

protocol HomeViewDelegate {
    func getDataForFilter(hobby:String,hobby2: String,hobby3:String,kindOfMember:String,gender:[String],age:Int,age2: Int, distance:Int, keyword: String)
    func loadViewCon(userID:String)
    func onClear()
}

var homeViewDelegate : HomeViewDelegate?


class HomeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    var menuDropDown = DropDown()
    var userType = ""
    var ref: DatabaseReference!
    var userList = [UserModel]()
    var userList1 = [UserModel]()
    
    var email = ""
    var firstname = ""
    var lastName = ""
    var fun = ""
    var gender = ""
    var islive = ""
    var key_accomplishment = ""
    var kindofMember = ""
    var userGender = ""
    var name = ""
    var occupation = ""
    var password = ""
    var school = ""
    var no_of_mentee = ""
    
    var feild_of_study = ""
    var hobbies = ""
    var longterm = ""
    var currentCity = ""
    var memberdo = ""
    var objective = ""
    var shortterm = ""
    var image = ""
    var userType1 = ""
    var userId = ""
    var areaOfExpertise = ""
    var latitude = ""
    var longitude = ""
    var birthday = ""
    var userIdd = ""
    var genderPref = [String]()

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    private var swipeView: TinderSwipeView<UserModel>!
    {
        didSet{
            self.swipeView.delegate = self
        }
    }
    
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var viewNoData: UIView!
    
    var locationManager = CLLocationManager()
    
    var callerId = ""
    var callSenderImage = ""
    var callSenderName = ""
    var callType = ""
    
    var userName = ""
    var userLocation = ""
    var userImageUrl = ""
    var isComplete = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = "Home"
        //loadDummy();
        homeViewDelegate = self
        ref = Database.database().reference()
        Helper.setPREF("yes", key: "isTutoClick")
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        //self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        //self.revealViewController()?.rearViewRevealWidth = 280
        // Do any additional setup after loading the view.
        //loadSwipe()
        userType = Helper.getPREF("userType") ?? ""
        print(userType)
        userList = []
        userList1 = []
        if userType == "Mentee" {
            viewContainer.isHidden = false
            collectionView.isHidden = true
            
        } else {
            viewContainer.isHidden = true
            collectionView.isHidden = false
        }
        
        //viewContainer.isHidden = false
        //collectionView.isHidden = true
        //self.swipeView.showTinderCards(with: self.userList1 ,isDummyShow: false)
        
        locationSetup()
        setRightBarButton()
        getIncomingCall()
        
        if let id = Helper.getPREF("userId") {
            
            print(id)
            ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                if let name = value?["name"] as? String {
                    self.userName = name
                }
                if let currentCity = value?["currentCity"] as? String {
                    self.userLocation = currentCity
                }
                if let image = value?["image"] as? String {
                    self.userImageUrl = image
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        checkIsProfleComplete()
        if userType == "Mentee" {
            getDataFromDatabaseMentee()
        }
        else {
            getDataFromDatabase()
        }
    }
    
    
    
    func checkIsProfleComplete() {
        if userType == "Mentee" {
            
            ref.child("users").child(Auth.auth().currentUser?.uid ?? "").observe(.value) { (snapshot) in
                if snapshot.exists(){
                    if let value = snapshot.value as? [String: AnyObject]{
                        
                        let about = value["about"] as? String ?? ""
                        let birthday = value["birthday"] as? String ?? ""
                        let currentCity = value["currentCity"] as? String ?? ""
                        let feild_of_study = value["feild_of_study"] as? String ?? ""
                        let firstName = value["firstName"] as? String ?? ""
                        let hobbies = value["hobbies"] as? String ?? ""
                        let image = value["image"] as? String ?? ""
                        let kindofMember = value["kindofMember"] as? String ?? ""
                        let lastName = value["lastName"] as? String ?? ""
                        
                        let latitude = value["latitude"] as? String ?? ""
                        let longitude = value["longitude"] as? String ?? ""
                        let longterm = value["longterm"] as? String ?? ""
                        let memberdo = value["memberdo"] as? String ?? ""
                        let name = value["name"] as? String ?? ""
                        
                        let no_of_mentee = value["no_of_mentee"] as? String ?? ""
                        let objective = value["objective"] as? String ?? ""
                        let school = value["school"] as? String ?? ""
                        let shortterm = value["shortterm"] as? String ?? ""
                        let userGender = value["userGender"] as? String ?? ""
                        
                        if userGender.isEmpty == true {
                            self.isComplete = false
                        }
                        
                        if birthday.isEmpty == true{
                            self.isComplete = false
                        }
                        
//                        if kindofMember.isEmpty == true{
//                            self.isComplete = false
//                        }
                        
                        if hobbies.isEmpty == true{
                            self.isComplete = false
                        }
                        
                        if school.isEmpty == true{
                            self.isComplete = false
                        }
                        
                        if image.isEmpty == true{
                            self.isComplete = false
                        }
                        
                        if (!self.isComplete){
                            self.showPopUp()
                        }
                        
                    }
                }
            }
            
        }else {
            ref.child("users").child(Auth.auth().currentUser?.uid ?? "").observe(.value) { (snapshot) in
                if snapshot.exists(){
                    if let value = snapshot.value as? [String: AnyObject]{
                        let about = value["about"] as? String ?? ""
                        let areaOfExpertise =  value["areaOfExpertise"] as? String ?? ""
                        let birthday = value["birthday"] as? String ?? ""
                        let currentCity = value["currentCity"] as? String ?? ""
                        let email = value["email"] as? String ?? ""
                        let firstName = value["firstName"] as? String ?? ""
                        let fun = value["fun"] as? String ?? ""
                        let image = value["image"] as? String ?? ""
                        let islive = value["islive"] as? String ?? ""
                        let key_accomplishment = value["key_accomplishment"] as? String ?? ""
                        let kindofMember = value["kindofMember"] as? String ?? ""
                        let lastName = value["lastName"] as? String ?? ""
                        let latitude = value["latitude"] as? String ?? ""
                        let longitude = value["longitude"] as? String ?? ""
                        let name = value["name"] as? String ?? ""
                        let no_of_mentee = value["no_of_mentee"] as? String ?? ""
                        let occupation = value["occupation"] as? String ?? ""
                        let school = value["school"] as? String ?? ""
                        let userGender = value["userGender"] as? String ?? ""
                        
                        if userGender.isEmpty == true {
                            self.isComplete = false
                        }
                        
                        if birthday.isEmpty == true{
                            self.isComplete = false
                        }
                        
                        if kindofMember.isEmpty == true{
                            self.isComplete = false
                        }
                        
                        if fun.isEmpty == true{
                            self.isComplete = false
                        }
                        
                        if occupation.isEmpty == true{
                            self.isComplete = false
                        }
                        
                        if image.isEmpty == true{
                            self.isComplete = false
                        }
                        if (!self.isComplete){
                            self.showPopUp()
                        }
                        
                    }
                }
            }
        }
    }
    
    func showPopUp(){
        let storyboard : UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        if let pop = storyboard.instantiateViewController(withIdentifier: "PopViewController") as? PopViewController{
            pop.modalPresentationStyle = .overCurrentContext
            self.present(pop, animated: true, completion: nil)
        }
    }
    
    @IBAction func handleDoneButton(_ sender: Any) {
        callToAnother(callReceiverId: "abccc", callSenderName: "test", callSenderImage: "errorrooor")
    }
    
    func callToAnother(callReceiverId : String,callSenderName : String, callSenderImage : String){
        
        let params : [String:Any] = ["senderName":callSenderName,
                                     "senderImage":callSenderImage]
        
        ref.child("calls").child(callReceiverId).updateChildValues(params) { (error, databaseReference) in
            if error != nil{
                print("updated")
            }else{
                print(error?.localizedDescription ?? "Error in update")
            }
        }
    }
    
    
    func getIncomingCall(){
        
        var userID = "uxmb-trfghertyuer"
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        ref.child("calls").child(userID).observe(.value) { (snapshot) in
            if (snapshot.exists()) {
                let keyId = snapshot.key
                print(keyId)
                let objects = snapshot.value as! [String: AnyObject]
                print(objects)
                if let senderName = objects["senderName"] as? String{
                    self.callSenderName = senderName
                }
                
                if let senderImage = objects["senderImage"] as? String{
                    self.callSenderImage = senderImage
                }
                
                if let callType = objects["callType"] as? String {
                    self.callType = callType
                }
                
                if let isIncomingCall = objects["isIncomingCall"] as? String , isIncomingCall == "yes" {
                    print(isIncomingCall)
                    self.getCall()
                }
            }
        }
    }
    
//    ["senderName":callSenderName,
//    "senderImage":callSenderName]
    
    func getCall(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if let incoming = storyBoard.instantiateViewController(withIdentifier: "IncomingCallViewController") as? IncomingCallViewController {
            incoming.callReceiverId = self.callerId
            incoming.callSenderName = self.callSenderName
            incoming.callSenderImage = self.callSenderImage
            incoming.callType = self.callType
            incoming.modalPresentationStyle = .overCurrentContext
            self.present(incoming, animated: true, completion: nil);
            //self.navigationController?.pushViewController(signup, animated: true)
                   
            print("click_click11")
        }
    }
    
    func setRightBarButton() {
        let timerBarButton = UIBarButtonItem.init(image: UIImage.init(named: "_filter"), style: .plain, target: self, action: #selector(settingClicked(_:)))
        timerBarButton.width=30
        
        //let addBarButton = UIBarButtonItem.init(image: UIImage.init(named: "plus"), style: .plain, target: self, action: #selector(plusClicked(_:)))
        
        self.navigationItem.rightBarButtonItems = [timerBarButton]

        menuDropDown.bottomOffset = CGPoint(x: 0, y:44)
    }
    
    func loadDummy(){
        let user = UserModel(email : self.email,
        firstname : self.firstname ,
        lastName : self.lastName,
        fun : self.fun,
        gender : self.gender,
        islive : self.islive,
        key_accomplishment : self.key_accomplishment,
        kindofMember : self.kindofMember,
        name : self.name ,
        occupation : self.occupation,
        password : self.password,
        school : self.school,
        userType :self.userType,
        no_of_mentee : self.no_of_mentee,
        feild_of_study :self.feild_of_study,
        hobbies : self.hobbies,
        longterm : self.longterm,
        memberdo : self.memberdo,
        objective : self.objective,
        shortterm : self.shortterm,
        image: self.image,
        userId: self.userId,
        currentCity: self.currentCity,
        areaOfExpertise: self.areaOfExpertise,
        latitude: self.latitude,
        longitude: self.longitude,
        birthday: self.birthday,
        userGender: self.userGender)
        userList1.append(user)
        userList1.append(user)
        userList1.append(user)
        userList1.append(user)
        userList1.append(user)
        userList1.append(user)
        userList1.append(user)
        userList1.append(user)
        
       
    }

    

   func locationSetup() {
               locationManager = CLLocationManager()
               locationManager.desiredAccuracy = kCLLocationAccuracyBest
               locationManager.requestAlwaysAuthorization()
               locationManager.distanceFilter = 100
               locationManager.startUpdatingLocation()
               locationManager.delegate = self
           }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    func getDataFromDatabase(){
        
        var arrayTemp = [String]()
        ref.child("mentorAssignUsers").child(Helper.getPREF("userId")!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                if snapshot.childrenCount > 0{
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let name = snap.key
                        arrayTemp.append(name)
                        print("\(name) :iddddd")
                    }
                }
                
            }
            self.getData(arrayTemp: arrayTemp)
        })
        
        
    }
        
    func getData(arrayTemp : [String])
    {
        self.userList = []
        self.userList1 = []
        var funStr = ""
        var userGender = ""
        var kindofMember = ""
        var areaOfExpertise = ""
        
        ref.child("users").child(Helper.getPREF("userId")!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                let value = snapshot.value as! [String: AnyObject]
                if let name = value["name"] as? String {
                    print("name: ",name)
                }
                if let gender = value["gender"] as? [String]{
                    self.genderPref = gender
                    print("\(gender)generrrrrrr")
                }
                
                funStr = value["fun"] as? String ?? ""
                userGender = value["userGender"] as? String ?? ""
                kindofMember = value["kindofMember"] as? String  ?? ""
                areaOfExpertise = value["areaOfExpertise"] as? String ?? ""
                
            }else{
                print("no data")
            }
        })
        // Helper.showLoader(onVC: self, message: NSLocalizedString("LOADING", comment: ""))
        
        Helper.showLoader(onVC: self, message: "")
        ref.child("users").observeSingleEvent(of:.value, with: { snapshot in
            Helper.hideLoader(onVC: self)
            if snapshot.childrenCount > 0 {
                self.userList.removeAll()
                for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                    let objects = nutrition.value as! [String: AnyObject]
                    print(objects)
                    
                    if let userType = objects["userType"] as? String{
                        self.userType1 = userType
                    }
                    
                    if let userIdd = objects["userId"] as? String{
                        self.userIdd = userIdd
                    }
                    
                    if let hobbies = objects["hobbies"] as? String{
                        self.hobbies = hobbies
                        print(hobbies)
                    }
                    else{
                        self.hobbies = ""
                    }
                    if let gender = objects["userGender"] as? String{
                        self.gender = gender
                    }
                    else
                    {
                        self.gender = ""
                    }
                    
                    if let kindofMember = objects["kindofMember"] as? String{
                        self.kindofMember = kindofMember
                    }else{
                        self.kindofMember = ""
                    }
                    
                    if let userGender = objects["userGender"] as? String{
                        self.userGender = userGender
                    }else{
                        self.userGender = ""
                    }
                    
                    if let feild_of_study = objects["feild_of_study"] as? String{
                        self.feild_of_study = feild_of_study
                    }else{
                        self.feild_of_study = ""
                    }
                    
                    
                    print("\(self.userType1) sssss\(funStr) aaaa \(self.hobbies)")
                    
                    if self.userType1 == "Mentee" {
                        if funStr.contains(self.hobbies) || areaOfExpertise.contains( self.feild_of_study)  || self.kindofMember.contains(kindofMember){
                            
                            if (!arrayTemp.contains(self.userIdd))
                            {
                                print("\(self.genderPref) : genderPref")
                                if(!self.genderPref.isEmpty)
                                {
                                    if(self.genderPref.contains(self.gender))
                                    {
                                        print("\(self.gender) : gender")
                                        
                                        if let email = objects["email"] as? String{
                                            self.email = email
                                        }
                                        
                                        if let hobbies = objects["hobbies"] as? String{
                                            self.hobbies = hobbies
                                        }
                                        
                                        if let firstname = objects["firstname"] as? String{
                                            self.firstname = firstname
                                        }
                                        if let lastName = objects["lastName"] as? String{
                                            self.lastName = lastName
                                        }
                                        if let fun = objects["fun"] as? String{
                                            self.fun = fun
                                        }
                                        if let gender = objects["gender"] as? String{
                                            self.gender = gender
                                        }
                                        if let gender = objects["userGender"] as? String{
                                            self.userGender = gender
                                        }
                                        
                                        if let islive = objects["islive"] as? String{
                                            self.islive = islive
                                        }
                                        if let key_accomplishment = objects["key_accomplishment"] as? String{
                                            self.key_accomplishment = key_accomplishment
                                        }
                                        if let kindofMember = objects["kindofMember"] as? String{
                                            self.kindofMember = kindofMember
                                        }
                                        if let name = objects["name"] as? String{
                                            self.name = name
                                        }
                                        else{
                                            self.name = ""
                                        }
                                        if let no_of_mentee = objects["no_of_mentee"] as? String{
                                            self.no_of_mentee = no_of_mentee
                                        }
                                        if let occupation = objects["occupation"] as? String{
                                            self.occupation = occupation
                                        }
                                        if let password = objects["password"] as? String{
                                            self.password = password
                                        }
                                        if let school = objects["school"] as? String{
                                            self.school = school
                                        }
                                        if let userType = objects["userType"] as? String{
                                            self.userType1 = userType
                                        }
                                        if let feild_of_study = objects["feild_of_study"] as? String{
                                            self.feild_of_study = feild_of_study
                                        }
                                        if let hobbies = objects["hobbies"] as? String{
                                            self.hobbies = hobbies
                                        }
                                        if let memberdo = objects["memberdo"] as? String{
                                            self.memberdo = memberdo
                                        }
                                        if let objective = objects["objective"] as? String{
                                            self.objective = objective
                                        }
                                        if let shortterm = objects["shortterm"] as? String{
                                            self.shortterm = shortterm
                                        }
                                        if let userId = objects["userId"] as? String{
                                            self.userId = userId
                                        }
                                        
                                        if let longterm = objects["longterm"] as? String{
                                            self.longterm = longterm
                                        }
                                        if let currentCity = objects["currentCity"] as? String{
                                            self.currentCity = currentCity
                                        }
                                        if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                            self.areaOfExpertise = areaOfExpertise
                                        }
                                        if let birthday = objects[" birthday"] as? String{
                                            self.birthday = birthday
                                        }
                                        if let image = objects["image"] as? String{
                                            self.image = image
                                        }else{
                                            self.image = ""
                                        }
                                        
                                        if let userGender = objects["userGender"] as? String{
                                            self.userGender = userGender
                                        }
                                        
                                        let user = UserModel(email : self.email,
                                                             firstname : self.firstname ,
                                                             lastName : self.lastName,
                                                             fun : self.fun,
                                                             gender : self.gender,
                                                             islive : self.islive,
                                                             key_accomplishment : self.key_accomplishment,
                                                             kindofMember : self.kindofMember,
                                                             name : self.name ,
                                                             occupation : self.occupation,
                                                             password : self.password,
                                                             school : self.school,
                                                             userType :self.userType1,
                                                             no_of_mentee : self.no_of_mentee,
                                                             feild_of_study :self.feild_of_study,
                                                             hobbies : self.hobbies,
                                                             longterm : self.longterm,
                                                             memberdo : self.memberdo,
                                                             objective : self.objective,
                                                             shortterm : self.shortterm,
                                                             image: self.image,
                                                             userId: self.userId,
                                                             currentCity: self.currentCity,
                                                             areaOfExpertise: self.areaOfExpertise,
                                                             latitude: self.latitude,
                                                             longitude: self.longitude,
                                                             birthday: self.birthday,
                                                             userGender: self.userGender)
                                        
                                        self.userList.append(user)
                                        
                                        //print(self.nutritions)
                                    }
                                    
                                }
                                else{
                                    if let email = objects["email"] as? String{
                                        self.email = email
                                    }
                                    
                                    if let hobbies = objects["hobbies"] as? String{
                                        self.hobbies = hobbies
                                    }
                                    
                                    if let firstname = objects["firstname"] as? String{
                                        self.firstname = firstname
                                    }
                                    if let lastName = objects["lastName"] as? String{
                                        self.lastName = lastName
                                    }
                                    if let fun = objects["fun"] as? String{
                                        self.fun = fun
                                    }
                                    if let gender = objects["gender"] as? String{
                                        self.gender = gender
                                    }
                                    
                                    if let islive = objects["islive"] as? String{
                                        self.islive = islive
                                    }
                                    if let key_accomplishment = objects["key_accomplishment"] as? String{
                                        self.key_accomplishment = key_accomplishment
                                    }
                                    if let kindofMember = objects["kindofMember"] as? String{
                                        self.kindofMember = kindofMember
                                    }
                                    if let name = objects["name"] as? String{
                                        self.name = name
                                    }
                                    else{
                                        self.name = ""
                                    }
                                    if let no_of_mentee = objects["no_of_mentee"] as? String{
                                        self.no_of_mentee = no_of_mentee
                                    }
                                    if let occupation = objects["occupation"] as? String{
                                        self.occupation = occupation
                                    }
                                    if let password = objects["password"] as? String{
                                        self.password = password
                                    }
                                    if let school = objects["school"] as? String{
                                        self.school = school
                                    }
                                    if let userType = objects["userType"] as? String{
                                        self.userType1 = userType
                                    }
                                    if let feild_of_study = objects["feild_of_study"] as? String{
                                        self.feild_of_study = feild_of_study
                                    }
                                    if let hobbies = objects["hobbies"] as? String{
                                        self.hobbies = hobbies
                                    }
                                    if let memberdo = objects["memberdo"] as? String{
                                        self.memberdo = memberdo
                                    }
                                    if let objective = objects["objective"] as? String{
                                        self.objective = objective
                                    }
                                    if let shortterm = objects["shortterm"] as? String{
                                        self.shortterm = shortterm
                                    }
                                    if let userId = objects["userId"] as? String{
                                        self.userId = userId
                                    }
                                    
                                    if let longterm = objects["longterm"] as? String{
                                        self.longterm = longterm
                                    }
                                    if let currentCity = objects["currentCity"] as? String{
                                        self.currentCity = currentCity
                                    }
                                    if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                        self.areaOfExpertise = areaOfExpertise
                                    }
                                    if let birthday = objects[" birthday"] as? String{
                                        self.birthday = birthday
                                    }
                                    if let image = objects["image"] as? String{
                                        self.image = image
                                    }else{
                                        self.image = ""
                                    }
                                    
                                    let user = UserModel(email : self.email,
                                                         firstname : self.firstname ,
                                                         lastName : self.lastName,
                                                         fun : self.fun,
                                                         gender : self.gender,
                                                         islive : self.islive,
                                                         key_accomplishment : self.key_accomplishment,
                                                         kindofMember : self.kindofMember,
                                                         name : self.name ,
                                                         occupation : self.occupation,
                                                         password : self.password,
                                                         school : self.school,
                                                         userType :self.userType1,
                                                         no_of_mentee : self.no_of_mentee,
                                                         feild_of_study :self.feild_of_study,
                                                         hobbies : self.hobbies,
                                                         longterm : self.longterm,
                                                         memberdo : self.memberdo,
                                                         objective : self.objective,
                                                         shortterm : self.shortterm,
                                                         image: self.image,
                                                         userId: self.userId,
                                                         currentCity: self.currentCity,
                                                         areaOfExpertise: self.areaOfExpertise,
                                                         latitude: self.latitude,
                                                         longitude: self.longitude,
                                                         birthday: self.birthday,
                                                         userGender: self.userGender)
                                    self.userList.append(user)
                                    //print(self.nutritions)
                                }
                            }
                        }
                        else{
                            print("something is wrong")
                        }
                    }
                }
                if self.userList.count > 0 {
                    self.collectionView.isHidden = false
                    self.viewNoData.isHidden = true
                    print(self.userList.count)
                    self.collectionView.reloadData()
                }else{
                    self.collectionView.isHidden = true
                    self.viewNoData.isHidden = false
                    self.collectionView.reloadData()
                }
                
            }
            
        })
    }
        
    func getDataFromDatabaseMentee(){
        
        self.userList = []
        self.userList1 = []
        var hobbiesStr = ""
        var userGender = ""
        var kindOfMember = ""
        var feild_of_study = ""
        var arrayTemp = [String]()
        ref.child("mentorAssignUsers").child(Helper.getPREF("userId")!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                if snapshot.childrenCount > 0{
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let name = snap.key
                        arrayTemp.append(name)
                        print(name)
                    }
                }
            }
            self.getDataMentee(arrayTemp: arrayTemp)
            
        })
         
    }
    
    
    func removeSubview(){
        print("Start remove sibview")
        if let viewWithTag = self.view.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }else{
            print("No!")
        }
    }
    
    
    func getDataMentee(arrayTemp : [String]){
        self.userList = []
        self.userList1 = []
        var hobbiesStr = ""
        var userGender = ""
        var kindOfMember = ""
        var feild_of_study = ""
        ref.child("users").child(Helper.getPREF("userId")!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                let value = snapshot.value as! [String: AnyObject]
                if let name = value["name"] as? String {
                    print("name: ",name)
                }
                
                hobbiesStr = value["hobbies"] as? String ?? ""
                userGender = value["userGender"] as? String ?? ""
                kindOfMember = value["kindofMember"] as? String ?? ""
                feild_of_study = value["feild_of_study"] as? String ?? ""
                print(hobbiesStr)
                
            }
        })
        
        Helper.showLoader(onVC: self, message: "")
        ref.child("users").observeSingleEvent(of:.value, with: { snapshot in
            Helper.hideLoader(onVC: self)
            if snapshot.childrenCount > 0 {
                self.userList1.removeAll()
                
                for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                    let objects = nutrition.value as! [String: AnyObject]
                    
                    if let userType = objects["userType"] as? String{
                        self.userType1 = userType
                    }
                    if let userId = objects["userId"] as? String{
                        self.userIdd = userId
                    }
                    
                    if let fun = objects["fun"] as? String{
                        self.fun = fun
                        print(fun)
                    }
                    else
                    {
                        self.fun = ""
                    }
                    
                    if let islive = objects["islive"] as? String{
                        self.islive = islive
                        print(self.islive)
                    }
                    else
                    {
                        self.islive = ""
                    }
                    
                    if let userGender = objects["userGender"] as? String{
                        self.userGender = userGender
                    }
                    
                    if let kindofMember = objects["kindofMember"] as? String{
                        self.kindofMember = kindofMember
                    }
                    
                    if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                        self.areaOfExpertise = areaOfExpertise
                    }
                    
                    
                    
                    if self.userType1 == "Mentor"  {
                        
                        if(self.islive == "yes")
                        {
                            if(!arrayTemp.contains(self.userIdd))
                            {
                                if hobbiesStr.contains(self.fun) || feild_of_study.contains(self.areaOfExpertise) || kindOfMember.contains(self.kindofMember) {
                                    print(self.userType1)
                                    if let email = objects["email"] as? String{
                                        self.email = email
                                    }
                                    
                                    if let firstname = objects["firstname"] as? String{
                                        self.firstname = firstname
                                    }
                                    if let lastName = objects["lastName"] as? String{
                                        self.lastName = lastName
                                    }
                                    if let fun = objects["fun"] as? String{
                                        self.fun = fun
                                        print(fun)
                                    }
                                    if let gender = objects["gender"] as? String{
                                        self.gender = gender
                                        print(gender)
                                    }
                                    if let islive = objects["islive"] as? String{
                                        self.islive = islive
                                    }
                                    if let key_accomplishment = objects["key_accomplishment"] as? String{
                                        self.key_accomplishment = key_accomplishment
                                    }
                                    if let kindofMember = objects["kindofMember"] as? String{
                                        self.kindofMember = kindofMember
                                    }
                                    if let name = objects["name"] as? String{
                                        self.name = name
                                    }
                                    else{
                                        self.name = ""
                                    }
                                    if let no_of_mentee = objects["no_of_mentee"] as? String{
                                        self.no_of_mentee = no_of_mentee
                                    }
                                    if let occupation = objects["occupation"] as? String{
                                        self.occupation = occupation
                                    }
                                    if let password = objects["password"] as? String{
                                        self.password = password
                                    }
                                    if let school = objects["school"] as? String{
                                        self.school = school
                                    }
                                    if let userType = objects["userType"] as? String{
                                        self.userType1 = userType
                                    }
                                    if let feild_of_study = objects["feild_of_study"] as? String{
                                        self.feild_of_study = feild_of_study
                                    }
                                    if let hobbies = objects["hobbies"] as? String{
                                        self.hobbies = hobbies
                                    }
                                    if let memberdo = objects["memberdo"] as? String{
                                        self.memberdo = memberdo
                                    }
                                    if let objective = objects["objective"] as? String{
                                        self.objective = objective
                                    }
                                    if let shortterm = objects["shortterm"] as? String{
                                        self.shortterm = shortterm
                                    }
                                    if let longterm = objects["longterm"] as? String{
                                        self.longterm = longterm
                                    }
                                    
                                    if let birthday = objects[" birthday"] as? String{
                                        self.birthday = birthday
                                    }
                                    
                                    if let image = objects["image"] as? String{
                                        self.image = image
                                    }else{
                                        self.image = ""
                                    }
                                    if let currentCity = objects["currentCity"] as? String{
                                        self.currentCity = currentCity
                                    }
                                    if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                        self.areaOfExpertise = areaOfExpertise
                                    }
                                    if let userId = objects["userId"] as? String{
                                        self.userId = userId
                                    }
                                    
                                    if let userGender = objects["userGender"] as? String{
                                        self.userGender = userGender
                                    }
                                    
                                    
                                    let user = UserModel( email : self.email,
                                                          firstname : self.firstname ,
                                                          lastName : self.lastName,
                                                          fun : self.fun,
                                                          gender : self.gender,
                                                          islive : self.islive,
                                                          key_accomplishment : self.key_accomplishment,
                                                          kindofMember : self.kindofMember,
                                                          name : self.name ,
                                                          occupation : self.occupation,
                                                          password : self.password,
                                                          school : self.school,
                                                          userType :self.userType1,
                                                          no_of_mentee : self.no_of_mentee,
                                                          feild_of_study :self.feild_of_study,
                                                          hobbies : self.hobbies,
                                                          longterm : self.longterm,
                                                          memberdo : self.memberdo,
                                                          objective : self.objective,
                                                          shortterm : self.shortterm,
                                                          image: self.image,
                                                          userId: self.userId,
                                                          currentCity: self.currentCity,
                                                          areaOfExpertise: self.areaOfExpertise,
                                                          latitude: self.latitude,
                                                          longitude: self.longitude,
                                                          birthday: self.birthday,
                                                          userGender: self.userGender)
                                    self.userList1.append(user)
                                    
                                    //print(self.nutritions)
                                }
                            }
                        }
                        
                    }
                    
                }
                
                print(self.userList1)
                
                if  self.userList1.count > 0 {
                    self.viewNoData.isHidden = true
                    DispatchQueue.main.async {
                        self.removeSubview()
                        let contentView: (Int, CGRect, UserModel) -> (UIView) = { (index: Int ,frame: CGRect , userModel: UserModel) -> (UIView) in
                            
                            let customView = CustomView(frame: frame)
                            customView.userModel = userModel
                            //customView.buttonAction.addTarget(self, action: #selector(self.customViewButtonSelected), for: UIControl.Event.touchUpInside)
                            return customView
                        }
                        self.swipeView = TinderSwipeView<UserModel>(frame: self.viewContainer.bounds, contentView: contentView)
                        self.swipeView.tag = 100
                        self.swipeView.showTinderCards(with: self.userList1)
                        self.swipeView.setNeedsDisplay()
                        self.swipeView.layoutIfNeeded()
                        self.viewContainer.addSubview(UIView())
                        self.viewContainer.addSubview(self.swipeView)
                        //raaaaaaaaaa
                        self.swipeView.isHidden = false
                    }
                    print(String(self.userList1.count))
                } else{
                    self.viewNoData.isHidden = false
                }
                
                //     let url: URL! = URL(string: self.folderMenuModel[0].url ?? "http://www.google.com")
                //        self.webView.loadRequest(URLRequest(url: url))
                
                //self.tableView.reloadData()
            }
            else{
                print("hlo remo")
            }
        })
    }
    
    
        
        func loadSwipe() {
            // Dynamically create view for each tinder card
            let contentView: (Int, CGRect, UserModel) -> (UIView) = { (index: Int ,frame: CGRect , userModel: UserModel) -> (UIView) in
                
                let customView = CustomView(frame: frame)
                customView.userModel = userModel
                //customView.buttonAction.addTarget(self, action: #selector(self.customViewButtonSelected), for: UIControl.Event.touchUpInside)
                return customView
            }
            
            //let x = viewContainer.frame.origin.x
            //let y = viewContainer.frame.origin.y
            
            let newViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 10, height: viewContainer.bounds.height+90)
           // let newViewFrame = CGRect(x: x, y: y, width: viewContainer.bounds.width, height: viewContainer.bounds.height)
            swipeView = TinderSwipeView<UserModel>(frame: newViewFrame, contentView: contentView)
            swipeView.delegate = self
            
            viewContainer.addSubview(swipeView)
        }
    
        
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.userList.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsersCollectionViewCell", for: indexPath) as! UsersCollectionViewCell
            let newDict : UserModel
            newDict = userList[indexPath.row]
            print(newDict)
            //cell.Namelabel.text = folder.url
            cell.lblName.text = newDict.name.firstCharacterUpperCase()
            cell.lblLocation.text = newDict.currentCity
            if newDict.image.isEmpty != true || newDict.image != nil{
                
                if let images = cell.imgUser {
                    let block: SDExternalCompletionBlock? = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) -> Void in
                        //print(image)
                        if (image == nil) {
                            images.image = #imageLiteral(resourceName: "ic_avatar")
                            return
                        }
                    }
                    if let url = URL(string: newDict.image) {
                        images.roundedImage()
                        images.sd_setImage(with: url, completed: block)
                        //cell.imgUser.maskCircle(anyImage: images)
                    }
                }else{
                    cell.imgUser.image = #imageLiteral(resourceName: "ic_avatar")
                }
                
            }else{
                cell.imgUser.image = #imageLiteral(resourceName: "ic_avatar")
            }
            
            return cell
            
        }
    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            //return CGSize(width: 110, height: 110)
            return CGSize(width: collectionView.bounds.size.width / 3-10, height: collectionView.bounds.size.width / 3)
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let newDict : UserModel
            newDict = userList[indexPath.row]
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            if let swipeee = storyBoard.instantiateViewController(withIdentifier: "SwipeUserViewController") as? SwipeUserViewController{
                swipeee.position = indexPath.row
                swipeee.userList = self.userList
                swipeee.latestest = newDict
                self.navigationController?.pushViewController(swipeee, animated: true)
                //self.present(signup, animated:true, completion:nil)
            }
            
        }
        
        
        @IBAction func settingClicked(_ sender: UIBarButtonItem) {
            print("im in settinsclicked")
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            if userType == "Mentor"
            {
                if let login = storyBoard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController{
                    login.fromWhere = "Mentor"
                    self.present(login, animated:true, completion:nil)
                }
            }
            else{
                
                if let login = storyBoard.instantiateViewController(withIdentifier: "FilterViewController") as? FilterViewController{
                    login.fromWhere = "Mentee"
                    self.present(login, animated:true, completion:nil)
                }
                
//                if let login = storyBoard.instantiateViewController(withIdentifier: "MenteeFilterViewController") as? MenteeFilterViewController{
//                   self.present(login, animated:true, completion:nil)
//                }
            }
         

           
        }
    }


extension HomeViewController : TinderSwipeViewDelegate{
    
    func dummyAnimationDone() {
        
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
        self.getMenteeCount(userID: userModel.userId , mentorId: userModel.userId, name: userModel.name, image: userModel.image, currentCity: userModel.currentCity ?? "")
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
        self.viewNoData.isHidden = false
        
    }
    
    func currentCardStatus(card object: Any, distance: CGFloat) {
        if distance == 0 {
            //emojiView.rateValue =  2.5
        }else{
            let value = Float(min(abs(distance/100), 1.0) * 5)
            _ = distance > 0  ? 2.5 + (value * 5) / 10  : 2.5 - (value * 5) / 10
            //emojiView.rateValue =  sorted
        }
        print(distance)
    }
    
    func getMenteeCount(userID : String,mentorId: String , name: String, image: String, currentCity: String){
        var userIDD = ""
        if Auth.auth().currentUser != nil {
            userIDD = Auth.auth().currentUser?.uid ?? ""
        }
        
        ref.child("users").child(userIDD).observeSingleEvent(of: .value) { (snapshot) in
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
                
                self.ref.child("mentorAssignUsers").child(Auth.auth().currentUser?.uid ?? "").child(mentorId).observe(.value, with: { (snapshot) in
                    if(snapshot.exists()) {
                        if (Int(noMenteeadded) ?? 0 < Int(noMentee) ?? 0) {
                            self.addMentorToMentee(mentorId: mentorId, name: name, image: image, currentCity: currentCity ,isQueue: "0")
                        }
                    } else {
                        self.updateCount(countstr: noMenteeadded,userId:userID)
                        self.updateMenteeCount(countstr: noMenteeadded,userId:userIDD)
                        if (Int(noMenteeadded) ?? 0 < Int(noMentee) ?? 0) {
                            self.addMentorToMentee(mentorId: mentorId, name: name, image: image, currentCity: currentCity ,isQueue: "0")
                        } else {
                            Helper.showOKAlert(onVC: self, title: "", message: "You have already added required mentees. Next one will be added in the Queue")
                            self.addMentorToMentee(mentorId: mentorId, name: name, image: image, currentCity: currentCity ,isQueue:"1")
                            //self.addMentorToQueue(mentorId: mentorId, name: name, image: image, currentCity: currentCity)
                        }
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func updateMenteeCount(countstr: String,userId: String){
        
        let like = "\((Int(countstr) ?? 0) + 1)"
        //guard let key = self.ref.child("blogs").child(blogId).child("likes").childByAutoId().key else { return }
        
        let params = ["no_of_menteeadded" : like]
        
        self.ref.child("users").child(userId).updateChildValues([
            "no_of_menteeadded": like
        ])
        
    }
    
    func updateCount(countstr: String,userId: String){
        
        let like = "\((Int(countstr) ?? 0) + 1)"
        //guard let key = self.ref.child("blogs").child(blogId).child("likes").childByAutoId().key else { return }
        
        let params = ["no_of_menteeadded" : like]
        
        self.ref.child("users").child(userId).updateChildValues([
            "no_of_menteeadded": like
        ])
        
    }
    
    
    func addMentorToQueue(mentorId:String,name: String,image:String,currentCity:String){
        
        var userID = ""
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        let params : [String:Any] = ["mentorUserId":mentorId,
                                     "name" : name,
                                     "image":image,
                                     "reportedStatus":"0",
                                     "currentCity": currentCity,
                                     "chatStatus":"0",
                                     "isQueue":"1"]
        ref.child("mentorAssignUsers").child(userID).child(mentorId).updateChildValues(params) { (Error, DatabaseReference) in
            
            if Error != nil{
                print(Error?.localizedDescription ?? "")
                
            }else{
                print("Added user")
            }
            
        }
        
    }
    
    
    func addMentorToMentee(mentorId:String,name: String,image:String,currentCity:String, isQueue: String){
        
        var userID = ""
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        let params : [String:Any] = ["mentorUserId":mentorId,
                                     "name" : name,
                                     "image":image,
                                     "reportedStatus":"0",
                                     "currentCity": currentCity,
                                     "chatStatus":"0",
                                     "isQueue":isQueue]
        ref.child("mentorAssignUsers").child(userID).child(mentorId).updateChildValues(params) { (Error, DatabaseReference) in
            if Error != nil{
                print(Error?.localizedDescription ?? "")
            }else{
                print("Added user")
                self.addMenteeToMentor(mentorId:mentorId , name: self.userName, image: self.userImageUrl, currentCity: self.userLocation, isQueue:isQueue)
            }
            
        }
        
    }
    
    func addMenteeToMentor(mentorId:String,name: String,image:String,currentCity:String, isQueue: String){
        
        var userID = ""
        
        if Auth.auth().currentUser != nil {
            userID = Auth.auth().currentUser?.uid ?? ""
        }
        
        let params : [String:Any] = ["menteeUserId":userID,
                                     "name" : name,
                                     "image":image,
                                     "reportedStatus":"0",
                                     "currentCity":currentCity,
                                     "chatStatus":"0",
                                     "isQueue":isQueue]
        ref.child("mentorAssignUsers").child(mentorId).child(userID).updateChildValues(params) { (Error, DatabaseReference) in
            
            if Error != nil{
                print(Error?.localizedDescription ?? "")
            }else{
                print("Added user")
            }
        }
    }
    
}

extension HomeViewController : CLLocationManagerDelegate {
    
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


extension HomeViewController : HomeViewDelegate{
    
    func onClear() {
         if userType == "Mentee" {
            getDataFromDatabaseMentee()
        }else {
            getDataFromDatabase()
                          
        }
    }
    
    func loadViewCon(userID: String) {
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        if Helper.getPREF("userType") == "Mentor"
        {
            let newvc = storyBoard.instantiateViewController(withIdentifier: "SuggestedMenteeProfileVC") as! SuggestedMenteeProfileVC
            newvc.selectedUserId = userID
            self.navigationController?.pushViewController(newvc, animated: true)
        }
        else
        {
            let newvc = storyBoard.instantiateViewController(withIdentifier: "SuggestedMentorProfileVC") as! SuggestedMentorProfileVC
                       newvc.selectedUserId = userID
            self.navigationController?.pushViewController(newvc, animated: true)
        }
    }
    
    func getDataForFilter(hobby: String,hobby2: String,hobby3: String, kindOfMember: String, gender: [String], age: Int, age2: Int,distance:Int, keyword:String) {
        if self.userType == "Mentee" {
            getFilteredDataFromDatabaseMentee(filterHobby: hobby,hobby2: hobby2,hobby3: hobby3, kindOfMember: kindOfMember, gender: gender, age: age, age2: age2, distance:distance, keyword: keyword)
         }else{
            getFilteredDataFromDatabaseMentor(filterHobby: hobby,hobby2:hobby2,hobby3:hobby3, kindOfMember: kindOfMember, gender: gender, age: age, age2: age2, distance:distance, keyword: keyword)
        }
    }
    
    func getFilteredDataFromDatabaseMentee(filterHobby: String, hobby2: String,hobby3: String,kindOfMember: String, gender: [String], age: Int, age2: Int, distance: Int, keyword: String){
        self.userList1.removeAll()
        self.userList = []
        self.userList1 = []
        print(filterHobby)
        print(kindOfMember)
        print(gender)
        print(age2)
        print(age)
        print(distance)
                   //var hobbiesStr = ""
                   //var userGender = ""
                   var arrayTemp = [String]()
                   ref.child("mentorAssignUsers").child(Helper.getPREF("userId")!).observeSingleEvent(of: .value, with: { (snapshot) in
                       if snapshot.exists(){
                             if snapshot.childrenCount > 0{
                               for child in snapshot.children {
                                   let snap = child as! DataSnapshot
                                   let name = snap.key
                                   arrayTemp.append(name)
                                   print(name)
                               }
                            }
                       }
                   })
                   
                   ref.child("users").child(Helper.getPREF("userId")!).observeSingleEvent(of: .value, with: { (snapshot) in
                       
                       if snapshot.childrenCount > 0 {
                       let value = snapshot.value as! [String: AnyObject]
                        if let name = value["name"] as? String {
                               print("name: \(name)")
                           }
                           
                           //hobbiesStr = value["hobbies"] as? String ?? ""
                           //userGender = value["userGender"] as? String ?? ""
                           
                       }
                   })
        
        Helper.showLoader(onVC: self, message: "")
        ref.child("users").observeSingleEvent(of: .value, with: { snapshot in
            Helper.hideLoader(onVC: self)
            if snapshot.childrenCount > 0 {
                self.userList1.removeAll()
                
                for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                    let objects = nutrition.value as! [String: AnyObject]
                    
                    if let userType = objects["userType"] as? String{
                        self.userType1 = userType
                    }
                    self.fun = objects["fun"] as? String ?? ""
                    var fun1 = objects["fun1"] as? String ?? ""
                    var fun2 = objects["fun2"] as? String ?? ""

                    self.firstname = objects["firstname"] as? String ?? ""
                    
                    let birthDay = objects["birthday"] as? String ?? "0"
                    
                    let ageInt = Int(birthDay) ?? 0
                    
                    self.islive = objects["islive"] as? String ?? ""
                
                    let kindofMemb = objects["kindofMember"] as? String ?? ""
                    
                    self.email = objects["email"] as? String ?? ""
                    self.firstname = objects["firstname"] as? String ?? ""
                    self.lastName = objects["lastName"] as? String ?? ""
                    self.gender = objects["gender"] as? String ?? ""
                    self.islive = objects["islive"] as? String ?? ""
                    self.key_accomplishment = objects["key_accomplishment"] as? String ?? ""
                    self.kindofMember = objects["kindofMember"] as? String ?? ""
                    self.name = objects["name"] as? String ?? ""
                    self.no_of_mentee = objects["no_of_mentee"] as? String ?? ""
                    self.occupation = objects["occupation"] as? String ?? ""
                    self.password = objects["password"] as? String ?? ""
                    self.school = objects["school"] as? String ?? ""
                    if let userType = objects["userType"] as? String{
                      self.userType1 = userType
                    }
                    self.feild_of_study = objects["feild_of_study"] as? String ?? ""
                    self.hobbies = objects["hobbies"] as? String ?? ""
                    self.memberdo = objects["memberdo"] as? String ?? ""
                    self.objective = objects["objective"] as? String ?? ""
                    self.shortterm = objects["shortterm"] as? String ?? ""
                    self.longterm = objects["longterm"] as? String ?? ""
                                                                                                     
                    self.image = objects["image"] as? String ?? ""
                    self.currentCity = objects["currentCity"] as? String ?? ""
                    self.areaOfExpertise = objects["areaOfExpertise"] as? String ?? ""
                                                                                                
                    self.birthday = objects["birthday"] as? String ?? ""
    
                    if let userGender = objects["userGender"] as? String{
                        self.userGender = userGender
                    }else{
                        self.userGender = ""
                    }
                    
                    if self.userType1 == "Mentor"  {
                        if(!keyword.isEmpty)
                                               {
                                                   if(self.hobbies.contains(keyword) || self.email.contains(keyword) || self.firstname.contains(keyword) || self.lastName.contains(keyword) || self.gender.contains(keyword) || self.key_accomplishment.contains(keyword) || self.kindofMember.contains(keyword) ||
                                                            self.name.contains(keyword) || self.occupation.contains(keyword) || self.school.contains(keyword) || self.feild_of_study.contains(keyword) || self.memberdo.contains(keyword) || self.shortterm.contains(keyword) ||
                                                                     self.longterm.contains(keyword) || self.currentCity.contains(keyword) || self.areaOfExpertise.contains(keyword) )
                                                   {
                                                    print(self.userType1)
                                                                                                                                                                             
                                                                                if let email = objects["email"] as? String{
                                                                                         self.email = email
                                                                                }
                                                                                if let firstname = objects["firstname"] as? String{
                                                                                        self.firstname = firstname
                                                                                }
                                                                                if let lastName = objects["lastName"] as? String{
                                                                                         self.lastName = lastName
                                                                                }
                                                                                if let fun = objects["fun"] as? String{
                                                                                         self.fun = fun
                                                                               }
                                                                               else{
                                                                                         self.fun = ""
                                                                                }
                                                                                if let gender = objects["gender"] as? String{
                                                                                   self.gender = gender
                                                                               }
                                                                               if let islive = objects["islive"] as? String{
                                                                                   self.islive = islive
                                                                               }
                                                                               if let key_accomplishment = objects["key_accomplishment"] as? String{
                                                                                self.key_accomplishment = key_accomplishment
                                                                                   }
                                                                                   if let kindofMember = objects["kindofMember"] as? String{
                                                                                       self.kindofMember = kindofMember
                                                                                   }
                                                                                   if let name = objects["name"] as? String{
                                                                                       self.name = name
                                                                                   }
                                                                                   if let no_of_mentee = objects["no_of_mentee"] as? String{
                                                                                       self.no_of_mentee = no_of_mentee
                                                                                   }
                                                                                   if let occupation = objects["occupation"] as? String{
                                                                                       self.occupation = occupation
                                                                                   }
                                                                                   if let password = objects["password"] as? String{
                                                                                       self.password = password
                                                                                   }
                                                                                   if let school = objects["school"] as? String{
                                                                                       self.school = school
                                                                                   }
                                                                                   if let userType = objects["userType"] as? String{
                                                                                       self.userType1 = userType
                                                                                   }
                                                                                   if let feild_of_study = objects["feild_of_study"] as? String{
                                                                                       self.feild_of_study = feild_of_study
                                                                                   }
                                                                                   if let hobbies = objects["hobbies"] as? String{
                                                                                       self.hobbies = hobbies
                                                                                   }
                                                                                   else {
                                                                                       self.hobbies = ""
                                                                                   }
                                                                                   if let memberdo = objects["memberdo"] as? String{
                                                                                       self.memberdo = memberdo
                                                                                   }
                                                                                   if let objective = objects["objective"] as? String{
                                                                                       self.objective = objective
                                                                                   }
                                                                                   if let shortterm = objects["shortterm"] as? String{
                                                                                       self.shortterm = shortterm
                                                                                   }
                                                                                   if let longterm = objects["longterm"] as? String{
                                                                                       self.longterm = longterm
                                                                                   }
                                                                                   
                                                                                   if let image = objects["image"] as? String{
                                                                                       self.image = image
                                                                                   }else{
                                                                                       self.image = ""
                                                                                   }
                                                                                   if let currentCity = objects["currentCity"] as? String{
                                                                                       self.currentCity = currentCity
                                                                                   }
                                                                                   if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                                                                       self.areaOfExpertise = areaOfExpertise
                                                                                   }
                                                                              
                                                                                  if let birthday = objects[" birthday"] as? String{
                                                                                       self.birthday = birthday
                                                                                   }
                                                                               
                                                                                   if let userId = objects["userId"] as? String{
                                                                                       self.userId = userId
                                                                                   }
                                                                                   
                                                                                   
                                                                                   let user = UserModel( email : self.email,
                                                                                                         firstname : self.firstname ,
                                                                                                         lastName : self.lastName,
                                                                                                         fun : self.fun,
                                                                                                         gender : self.gender,
                                                                                                         islive : self.islive,
                                                                                                         key_accomplishment : self.key_accomplishment,
                                                                                                         kindofMember : self.kindofMember,
                                                                                                         name : self.name ,
                                                                                                         occupation : self.occupation,
                                                                                                         password : self.password,
                                                                                                         school : self.school,
                                                                                                         userType :self.userType1,
                                                                                                         no_of_mentee : self.no_of_mentee,
                                                                                                         feild_of_study :self.feild_of_study,
                                                                                                         hobbies : self.hobbies,
                                                                                                         longterm : self.longterm,
                                                                                                         memberdo : self.memberdo,
                                                                                                         objective : self.objective,
                                                                                                         shortterm : self.shortterm,
                                                                                                         image: self.image,
                                                                                                         userId: self.userId,
                                                                                                         currentCity: self.currentCity,
                                                                                                         areaOfExpertise: self.areaOfExpertise,
                                                                                                         latitude: self.latitude,
                                                                                                         longitude: self.longitude,
                                                                                                         birthday: self.birthday,
                                                                                                         userGender: self.userGender)
                                                                                   self.userList1.append(user)
                                                                                                                                   
                                                }
                        }
                        else{
                            if (age != 0) && (ageInt != 0) {
                                if (ageInt  < age) && (ageInt  > age2) {
                                    if let email = objects["email"] as? String{
                                        self.email = email
                                    }
                                    if let firstname = objects["firstname"] as? String{
                                        self.firstname = firstname
                                    }
                                    if let lastName = objects["lastName"] as? String{
                                        self.lastName = lastName
                                    }
                                    if let fun = objects["fun"] as? String{
                                        self.fun = fun
                                    }
                                    else{
                                        self.fun = ""
                                    }
                                    if let gender = objects["gender"] as? String{
                                        self.gender = gender
                                    }
                                    if let islive = objects["islive"] as? String{
                                        self.islive = islive
                                    }
                                    if let key_accomplishment = objects["key_accomplishment"] as? String{
                                        self.key_accomplishment = key_accomplishment
                                    }
                                    if let kindofMember = objects["kindofMember"] as? String{
                                        self.kindofMember = kindofMember
                                    }
                                    if let name = objects["name"] as? String{
                                        self.name = name
                                    }
                                    if let no_of_mentee = objects["no_of_mentee"] as? String{
                                        self.no_of_mentee = no_of_mentee
                                    }
                                    if let occupation = objects["occupation"] as? String{
                                        self.occupation = occupation
                                    }
                                    if let password = objects["password"] as? String{
                                        self.password = password
                                    }
                                    if let school = objects["school"] as? String{
                                        self.school = school
                                    }
                                    if let userType = objects["userType"] as? String{
                                        self.userType1 = userType
                                    }
                                    if let feild_of_study = objects["feild_of_study"] as? String{
                                        self.feild_of_study = feild_of_study
                                    }
                                    if let hobbies = objects["hobbies"] as? String{
                                        self.hobbies = hobbies
                                    }
                                    else {
                                        self.hobbies = ""
                                    }
                                    if let memberdo = objects["memberdo"] as? String{
                                        self.memberdo = memberdo
                                    }
                                    if let objective = objects["objective"] as? String{
                                        self.objective = objective
                                    }
                                    if let shortterm = objects["shortterm"] as? String{
                                        self.shortterm = shortterm
                                    }
                                    if let longterm = objects["longterm"] as? String{
                                        self.longterm = longterm
                                    }
                                    
                                    if let image = objects["image"] as? String{
                                        self.image = image
                                    }else{
                                        self.image = ""
                                    }
                                    if let currentCity = objects["currentCity"] as? String{
                                        self.currentCity = currentCity
                                    }
                                    if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                        self.areaOfExpertise = areaOfExpertise
                                    }
                                    
                                    if let birthday = objects[" birthday"] as? String{
                                        self.birthday = birthday
                                    }
                                    
                                    if let userId = objects["userId"] as? String{
                                        self.userId = userId
                                    }
                                    
                                    
                                    let user = UserModel( email : self.email,
                                                          firstname : self.firstname ,
                                                          lastName : self.lastName,
                                                          fun : self.fun,
                                                          gender : self.gender,
                                                          islive : self.islive,
                                                          key_accomplishment : self.key_accomplishment,
                                                          kindofMember : self.kindofMember,
                                                          name : self.name ,
                                                          occupation : self.occupation,
                                                          password : self.password,
                                                          school : self.school,
                                                          userType :self.userType1,
                                                          no_of_mentee : self.no_of_mentee,
                                                          feild_of_study :self.feild_of_study,
                                                          hobbies : self.hobbies,
                                                          longterm : self.longterm,
                                                          memberdo : self.memberdo,
                                                          objective : self.objective,
                                                          shortterm : self.shortterm,
                                                          image: self.image,
                                                          userId: self.userId,
                                                          currentCity: self.currentCity,
                                                          areaOfExpertise: self.areaOfExpertise,
                                                          latitude: self.latitude,
                                                          longitude: self.longitude,
                                                          birthday: self.birthday,
                                                          userGender: self.userGender)
                                    self.userList1.append(user)
                                }
                            } else
                            if(self.islive == "yes")
                            {
                                //Remo
                                print("Mfrom \(gender) usergender\(self.userGender)")
                                if(!gender.isEmpty){
                                    if(gender.contains(self.userGender) || gender.contains(self.userGender) || gender.contains(self.userGender))
                                    {
                                        if let email = objects["email"] as? String{
                                            self.email = email
                                        }
                                        if let firstname = objects["firstname"] as? String{
                                            self.firstname = firstname
                                        }
                                        if let lastName = objects["lastName"] as? String{
                                            self.lastName = lastName
                                        }
                                        if let fun = objects["fun"] as? String{
                                            self.fun = fun
                                        }
                                        else{
                                            self.fun = ""
                                        }
                                        if let gender = objects["gender"] as? String{
                                            self.gender = gender
                                        }
                                        if let islive = objects["islive"] as? String{
                                            self.islive = islive
                                        }
                                        if let key_accomplishment = objects["key_accomplishment"] as? String{
                                            self.key_accomplishment = key_accomplishment
                                        }
                                        if let kindofMember = objects["kindofMember"] as? String{
                                            self.kindofMember = kindofMember
                                        }
                                        if let name = objects["name"] as? String{
                                            self.name = name
                                        }
                                        if let no_of_mentee = objects["no_of_mentee"] as? String{
                                            self.no_of_mentee = no_of_mentee
                                        }
                                        if let occupation = objects["occupation"] as? String{
                                            self.occupation = occupation
                                        }
                                        if let password = objects["password"] as? String{
                                            self.password = password
                                        }
                                        if let school = objects["school"] as? String{
                                            self.school = school
                                        }
                                        if let userType = objects["userType"] as? String{
                                            self.userType1 = userType
                                        }
                                        if let feild_of_study = objects["feild_of_study"] as? String{
                                            self.feild_of_study = feild_of_study
                                        }
                                        if let hobbies = objects["hobbies"] as? String{
                                            self.hobbies = hobbies
                                        }
                                        else {
                                            self.hobbies = ""
                                        }
                                        if let memberdo = objects["memberdo"] as? String{
                                            self.memberdo = memberdo
                                        }
                                        if let objective = objects["objective"] as? String{
                                            self.objective = objective
                                        }
                                        if let shortterm = objects["shortterm"] as? String{
                                            self.shortterm = shortterm
                                        }
                                        if let longterm = objects["longterm"] as? String{
                                            self.longterm = longterm
                                        }
                                        
                                        if let image = objects["image"] as? String{
                                            self.image = image
                                        }else{
                                            self.image = ""
                                        }
                                        if let currentCity = objects["currentCity"] as? String{
                                            self.currentCity = currentCity
                                        }
                                        if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                            self.areaOfExpertise = areaOfExpertise
                                        }
                                        
                                        if let birthday = objects[" birthday"] as? String{
                                            self.birthday = birthday
                                        }
                                        
                                        if let userId = objects["userId"] as? String{
                                            self.userId = userId
                                        }
                                        
                                        
                                        let user = UserModel( email : self.email,
                                                              firstname : self.firstname ,
                                                              lastName : self.lastName,
                                                              fun : self.fun,
                                                              gender : self.gender,
                                                              islive : self.islive,
                                                              key_accomplishment : self.key_accomplishment,
                                                              kindofMember : self.kindofMember,
                                                              name : self.name ,
                                                              occupation : self.occupation,
                                                              password : self.password,
                                                              school : self.school,
                                                              userType :self.userType1,
                                                              no_of_mentee : self.no_of_mentee,
                                                              feild_of_study :self.feild_of_study,
                                                              hobbies : self.hobbies,
                                                              longterm : self.longterm,
                                                              memberdo : self.memberdo,
                                                              objective : self.objective,
                                                              shortterm : self.shortterm,
                                                              image: self.image,
                                                              userId: self.userId,
                                                              currentCity: self.currentCity,
                                                              areaOfExpertise: self.areaOfExpertise,
                                                              latitude: self.latitude,
                                                              longitude: self.longitude,
                                                              birthday: self.birthday,
                                                              userGender: self.userGender)
                                        self.userList1.append(user)
                                    }
                                }
                                else if(!kindOfMember.isEmpty){
                                    if kindOfMember.caseInsensitiveCompare(kindofMemb)  == .orderedSame{
                                        if let email = objects["email"] as? String{
                                            self.email = email
                                        }
                                        if let firstname = objects["firstname"] as? String{
                                            self.firstname = firstname
                                        }
                                        if let lastName = objects["lastName"] as? String{
                                            self.lastName = lastName
                                        }
                                        if let fun = objects["fun"] as? String{
                                            self.fun = fun
                                        }
                                        else{
                                            self.fun = ""
                                        }
                                        if let gender = objects["gender"] as? String{
                                            self.gender = gender
                                        }
                                        if let islive = objects["islive"] as? String{
                                            self.islive = islive
                                        }
                                        if let key_accomplishment = objects["key_accomplishment"] as? String{
                                            self.key_accomplishment = key_accomplishment
                                        }
                                        if let kindofMember = objects["kindofMember"] as? String{
                                            self.kindofMember = kindofMember
                                        }
                                        if let name = objects["name"] as? String{
                                            self.name = name
                                        }
                                        if let no_of_mentee = objects["no_of_mentee"] as? String{
                                            self.no_of_mentee = no_of_mentee
                                        }
                                        if let occupation = objects["occupation"] as? String{
                                            self.occupation = occupation
                                        }
                                        if let password = objects["password"] as? String{
                                            self.password = password
                                        }
                                        if let school = objects["school"] as? String{
                                            self.school = school
                                        }
                                        if let userType = objects["userType"] as? String{
                                            self.userType1 = userType
                                        }
                                        if let feild_of_study = objects["feild_of_study"] as? String{
                                            self.feild_of_study = feild_of_study
                                        }
                                        if let hobbies = objects["hobbies"] as? String{
                                            self.hobbies = hobbies
                                        }
                                        else {
                                            self.hobbies = ""
                                        }
                                        if let memberdo = objects["memberdo"] as? String{
                                            self.memberdo = memberdo
                                        }
                                        if let objective = objects["objective"] as? String{
                                            self.objective = objective
                                        }
                                        if let shortterm = objects["shortterm"] as? String{
                                            self.shortterm = shortterm
                                        }
                                        if let longterm = objects["longterm"] as? String{
                                            self.longterm = longterm
                                        }
                                        
                                        if let image = objects["image"] as? String{
                                            self.image = image
                                        }else{
                                            self.image = ""
                                        }
                                        if let currentCity = objects["currentCity"] as? String{
                                            self.currentCity = currentCity
                                        }
                                        if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                            self.areaOfExpertise = areaOfExpertise
                                        }
                                        
                                        if let birthday = objects[" birthday"] as? String{
                                            self.birthday = birthday
                                        }
                                        
                                        if let userId = objects["userId"] as? String{
                                            self.userId = userId
                                        }
                                        
                                        
                                        let user = UserModel( email : self.email,
                                                              firstname : self.firstname ,
                                                              lastName : self.lastName,
                                                              fun : self.fun,
                                                              gender : self.gender,
                                                              islive : self.islive,
                                                              key_accomplishment : self.key_accomplishment,
                                                              kindofMember : self.kindofMember,
                                                              name : self.name ,
                                                              occupation : self.occupation,
                                                              password : self.password,
                                                              school : self.school,
                                                              userType :self.userType1,
                                                              no_of_mentee : self.no_of_mentee,
                                                              feild_of_study :self.feild_of_study,
                                                              hobbies : self.hobbies,
                                                              longterm : self.longterm,
                                                              memberdo : self.memberdo,
                                                              objective : self.objective,
                                                              shortterm : self.shortterm,
                                                              image: self.image,
                                                              userId: self.userId,
                                                              currentCity: self.currentCity,
                                                              areaOfExpertise: self.areaOfExpertise,
                                                              latitude: self.latitude,
                                                              longitude: self.longitude,
                                                              birthday: self.birthday,
                                                              userGender: self.userGender)
                                        self.userList1.append(user)
                                    }
                                }
                                else if (!filterHobby.isEmpty){
                                    //let joined = filterHobby.joined(separator: ",")
                                    print("filter \(filterHobby) \(self.fun)")
                                    //                                                        if (self.fun.contains(",")){
                                    //                                                            var arr = self.fun.components(separatedBy: ",")
                                    //                                                            if arr.count>0{
                                    //                                                                for str in arr{
                                    //                                                                    funStr = str
                                    //                                                                    print("filter1 \(funStr)")
                                    //                                                                }
                                    //                                                            }else{
                                    //                                                                funStr = self.fun
                                    //                                                            }
                                    //                                                        }else{
                                    //                                                            funStr = self.fun
                                    //                                                        }
                                    //filterHobby.contains(self.fun)
                                    
                                    if (filterHobby.contains(self.fun) || hobby2.contains(fun1) || hobby3.contains(fun2)){
                                        if let email = objects["email"] as? String{
                                            self.email = email
                                        }
                                        if let firstname = objects["firstname"] as? String{
                                            self.firstname = firstname
                                        }
                                        if let lastName = objects["lastName"] as? String{
                                            self.lastName = lastName
                                        }
                                        if let fun = objects["fun"] as? String{
                                            self.fun = fun
                                        }
                                        else{
                                            self.fun = ""
                                        }
                                        if let gender = objects["gender"] as? String{
                                            self.gender = gender
                                        }
                                        if let islive = objects["islive"] as? String{
                                            self.islive = islive
                                        }
                                        if let key_accomplishment = objects["key_accomplishment"] as? String{
                                            self.key_accomplishment = key_accomplishment
                                        }
                                        if let kindofMember = objects["kindofMember"] as? String{
                                            self.kindofMember = kindofMember
                                        }
                                        if let name = objects["name"] as? String{
                                            self.name = name
                                        }
                                        if let no_of_mentee = objects["no_of_mentee"] as? String{
                                            self.no_of_mentee = no_of_mentee
                                        }
                                        if let occupation = objects["occupation"] as? String{
                                            self.occupation = occupation
                                        }
                                        if let password = objects["password"] as? String{
                                            self.password = password
                                        }
                                        if let school = objects["school"] as? String{
                                            self.school = school
                                        }
                                        if let userType = objects["userType"] as? String{
                                            self.userType1 = userType
                                        }
                                        if let feild_of_study = objects["feild_of_study"] as? String{
                                            self.feild_of_study = feild_of_study
                                        }
                                        if let hobbies = objects["hobbies"] as? String{
                                            self.hobbies = hobbies
                                        }
                                        else {
                                            self.hobbies = ""
                                        }
                                        if let memberdo = objects["memberdo"] as? String{
                                            self.memberdo = memberdo
                                        }
                                        if let objective = objects["objective"] as? String{
                                            self.objective = objective
                                        }
                                        if let shortterm = objects["shortterm"] as? String{
                                            self.shortterm = shortterm
                                        }
                                        if let longterm = objects["longterm"] as? String{
                                            self.longterm = longterm
                                        }
                                        
                                        if let image = objects["image"] as? String{
                                            self.image = image
                                        }else{
                                            self.image = ""
                                        }
                                        if let currentCity = objects["currentCity"] as? String{
                                            self.currentCity = currentCity
                                        }
                                        if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                            self.areaOfExpertise = areaOfExpertise
                                        }
                                        
                                        if let birthday = objects[" birthday"] as? String{
                                            self.birthday = birthday
                                        }
                                        
                                        if let userId = objects["userId"] as? String{
                                            self.userId = userId
                                        }
                                        
                                        
                                        let user = UserModel( email : self.email,
                                                              firstname : self.firstname ,
                                                              lastName : self.lastName,
                                                              fun : self.fun,
                                                              gender : self.gender,
                                                              islive : self.islive,
                                                              key_accomplishment : self.key_accomplishment,
                                                              kindofMember : self.kindofMember,
                                                              name : self.name ,
                                                              occupation : self.occupation,
                                                              password : self.password,
                                                              school : self.school,
                                                              userType :self.userType1,
                                                              no_of_mentee : self.no_of_mentee,
                                                              feild_of_study :self.feild_of_study,
                                                              hobbies : self.hobbies,
                                                              longterm : self.longterm,
                                                              memberdo : self.memberdo,
                                                              objective : self.objective,
                                                              shortterm : self.shortterm,
                                                              image: self.image,
                                                              userId: self.userId,
                                                              currentCity: self.currentCity,
                                                              areaOfExpertise: self.areaOfExpertise,
                                                              latitude: self.latitude,
                                                              longitude: self.longitude,
                                                              birthday: self.birthday,
                                                              userGender: self.userGender)
                                        self.userList1.append(user)
                                    }
                                }
                                
                                else if (distance != 0) {
                                    print("Im in else condition dis")
                                    var ref: DatabaseReference!
                                    ref = Database.database().reference()
                                    var geoFireRef: DatabaseReference?
                                    var geoFire: GeoFire?
                                    var myQuery: GFQuery?
                                    geoFireRef = ref.child("Geolocs")
                                    
                                    if let geoFireRef = geoFireRef {
                                        geoFire = GeoFire(firebaseRef: geoFireRef)
                                        if let id = Helper.getPREF("userId") {
                                            var arrayTemp = [String]()
                                            ref.child("mentorAssignUsers").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                                                if snapshot.exists(){
                                                    if snapshot.childrenCount > 0{
                                                        for child in snapshot.children {
                                                            let snap = child as! DataSnapshot
                                                            let name = snap.key
                                                            arrayTemp.append(name)
                                                            print(name)
                                                        }
                                                    }
                                                }
                                            })
                                            
                                            ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                                                
                                                let value = snapshot.value as? NSDictionary
                                                print(value)
                                                var lat = ""
                                                var long = ""
                                                var ageInt = 0
                                                
                                                if (lat != "" && lat != "0") && (long != "" && long != "0") {
                                                    let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(lat) ?? 0), longitude: CLLocationDegrees(Double(long) ?? 0))
                                                    myQuery = geoFire?.query(at: location, withRadius: Double(distance))
                                                    myQuery?.observe(.keyEntered, with: { (key, location) in
                                                        if key != Auth.auth().currentUser?.uid
                                                        {
                                                            let ref = ref.child("users").child(key)
                                                            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                                                                
                                                                if snapshot.childrenCount > 0{
                                                                    let value = snapshot.value as! [String: AnyObject]
                                                                    if let name = value["name"] as? String {
                                                                        print("name: ",name)
                                                                    }
                                                                    
                                                                    if let userType = value["userType"] as? String{
                                                                        
                                                                        if userType == "Mentor" {
                                                                            print("userType: ",userType)
                                                                            let userId = value["userId"] as? String ?? ""
                                                                            let fun = value["fun"] as? String ?? ""
                                                                            let areaOfExpertise = value["areaOfExpertise"] as? String ?? ""
                                                                            let birthDay = value["birthay"] as? String ?? "0"
                                                                            let kind_of_member = value ["kindofMember"] as? String ?? "0"
                                                                            let name = value ["firstName"] as? String ?? "0"
                                                                            ageInt = Int(birthDay) ?? 0
                                                                            
                                                                            if !arrayTemp.contains(userId) || kindOfMember.caseInsensitiveCompare(kind_of_member) == .orderedSame || filterHobby.contains(fun) || ageInt  < age{
                                                                                print(name)
                                                                                print(kind_of_member)
                                                                                let userDetail = UserModel(email: (value["email"] as? String) ?? "", firstname: (value["firstName"] as? String) ?? "", lastName: (value["lastName"] as? String) ?? "", fun: (value["fun"] as? String) ?? "", gender: "", islive: (value["islive"] as? String) ?? "", key_accomplishment: (value["key_accomplishment"] as? String) ?? "", kindofMember: (value["kindofMember"] as? String) ?? "", name: (value["name"] as? String) ?? "", occupation: (value["occupation"] as? String) ?? "", password: (value["password"] as? String) ?? "", school: (value["school"] as? String) ?? "", userType: (value["userType"] as? String) ?? "", no_of_mentee: (value["no_of_mentee"] as? String) ?? "", feild_of_study: (value["feild_of_study"] as? String) ?? "", hobbies: (value["hobbies"] as? String) ?? "", longterm: (value["longterm"] as? String) ?? "", memberdo: (value["memberdo"] as? String) ?? "", objective: (value["objective"] as? String) ?? "", shortterm: (value["shortterm"] as? String) ?? "", image: (value["image"] as? String) ?? "", userId: (value["userId"] as? String) ?? "", currentCity: (value["currentCity"] as? String) ?? "", areaOfExpertise: (value["areaOfExpertise"] as? String) ?? "", latitude: (value["latitude"] as? String) ?? "", longitude: (value["longitude"] as? String) ?? "", birthday: (value["birthday"] as? String) ?? "", userGender:(value["userGender"] as? String))
                                                                                self.userList1.append(userDetail)
                                                                                
                                                                                
                                                                            }
                                                                            
                                                                        }
                                                                        
                                                                    }
                                                                }else{
                                                                    
                                                                }
                                                            })
                                                        }
                                                    })
                                                } else{
                                                    
                                                }
                                            })
                                        } else{
                                            
                                        }
                                    } else{
                                        
                                    }
                                }
                                else {
                                }
                                //                                                    MARK: SOURABH
                                //                                                      if distance == 0{
                                //                                                          print("Im in distance == 0 condition")
                                //                                                          print(kindofMemb)
                                //                                                          print(self.firstname)
                                //
                                //                                                          if(kindOfMember.caseInsensitiveCompare(kindofMemb)  == .orderedSame || filterHobby.contains(self.fun) || ageInt  < age ){
                                //                                                               print(self.userType1)
                                //
                                //                                                              if let email = objects["email"] as? String{
                                //                                                                       self.email = email
                                //                                                              }
                                //                                                              if let firstname = objects["firstname"] as? String{
                                //                                                                      self.firstname = firstname
                                //                                                              }
                                //                                                              if let lastName = objects["lastName"] as? String{
                                //                                                                       self.lastName = lastName
                                //                                                              }
                                //                                                              if let fun = objects["fun"] as? String{
                                //                                                                       self.fun = fun
                                //                                                             }
                                //                                                             else{
                                //                                                                       self.fun = ""
                                //                                                              }
                                //                                                              if let gender = objects["gender"] as? String{
                                //                                                                 self.gender = gender
                                //                                                             }
                                //                                                             if let islive = objects["islive"] as? String{
                                //                                                                 self.islive = islive
                                //                                                             }
                                //                                                             if let key_accomplishment = objects["key_accomplishment"] as? String{
                                //                                                              self.key_accomplishment = key_accomplishment
                                //                                                                 }
                                //                                                                 if let kindofMember = objects["kindofMember"] as? String{
                                //                                                                     self.kindofMember = kindofMember
                                //                                                                 }
                                //                                                                 if let name = objects["name"] as? String{
                                //                                                                     self.name = name
                                //                                                                 }
                                //                                                                 if let no_of_mentee = objects["no_of_mentee"] as? String{
                                //                                                                     self.no_of_mentee = no_of_mentee
                                //                                                                 }
                                //                                                                 if let occupation = objects["occupation"] as? String{
                                //                                                                     self.occupation = occupation
                                //                                                                 }
                                //                                                                 if let password = objects["password"] as? String{
                                //                                                                     self.password = password
                                //                                                                 }
                                //                                                                 if let school = objects["school"] as? String{
                                //                                                                     self.school = school
                                //                                                                 }
                                //                                                                 if let userType = objects["userType"] as? String{
                                //                                                                     self.userType1 = userType
                                //                                                                 }
                                //                                                                 if let feild_of_study = objects["feild_of_study"] as? String{
                                //                                                                     self.feild_of_study = feild_of_study
                                //                                                                 }
                                //                                                                 if let hobbies = objects["hobbies"] as? String{
                                //                                                                     self.hobbies = hobbies
                                //                                                                 }
                                //                                                                 else {
                                //                                                                     self.hobbies = ""
                                //                                                                 }
                                //                                                                 if let memberdo = objects["memberdo"] as? String{
                                //                                                                     self.memberdo = memberdo
                                //                                                                 }
                                //                                                                 if let objective = objects["objective"] as? String{
                                //                                                                     self.objective = objective
                                //                                                                 }
                                //                                                                 if let shortterm = objects["shortterm"] as? String{
                                //                                                                     self.shortterm = shortterm
                                //                                                                 }
                                //                                                                 if let longterm = objects["longterm"] as? String{
                                //                                                                     self.longterm = longterm
                                //                                                                 }
                                //
                                //                                                                 if let image = objects["image"] as? String{
                                //                                                                     self.image = image
                                //                                                                 }else{
                                //                                                                     self.image = ""
                                //                                                                 }
                                //                                                                 if let currentCity = objects["currentCity"] as? String{
                                //                                                                     self.currentCity = currentCity
                                //                                                                 }
                                //                                                                 if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                //                                                                     self.areaOfExpertise = areaOfExpertise
                                //                                                                 }
                                //
                                //                                                                if let birthday = objects[" birthday"] as? String{
                                //                                                                     self.birthday = birthday
                                //                                                                 }
                                //
                                //                                                                 if let userId = objects["userId"] as? String{
                                //                                                                     self.userId = userId
                                //                                                                 }
                                //
                                //
                                //                                                                 let user = UserModel( email : self.email,
                                //                                                                                       firstname : self.firstname ,
                                //                                                                                       lastName : self.lastName,
                                //                                                                                       fun : self.fun,
                                //                                                                                       gender : self.gender,
                                //                                                                                       islive : self.islive,
                                //                                                                                       key_accomplishment : self.key_accomplishment,
                                //                                                                                       kindofMember : self.kindofMember,
                                //                                                                                       name : self.name ,
                                //                                                                                       occupation : self.occupation,
                                //                                                                                       password : self.password,
                                //                                                                                       school : self.school,
                                //                                                                                       userType :self.userType1,
                                //                                                                                       no_of_mentee : self.no_of_mentee,
                                //                                                                                       feild_of_study :self.feild_of_study,
                                //                                                                                       hobbies : self.hobbies,
                                //                                                                                       longterm : self.longterm,
                                //                                                                                       memberdo : self.memberdo,
                                //                                                                                       objective : self.objective,
                                //                                                                                       shortterm : self.shortterm,
                                //                                                                                       image: self.image,
                                //                                                                                       userId: self.userId,
                                //                                                                                       currentCity: self.currentCity,
                                //                                                                                       areaOfExpertise: self.areaOfExpertise,
                                //                                                                                       latitude: self.latitude,
                                //                                                                                       longitude: self.longitude,
                                //                                                                                       birthday: self.birthday,
                                //                                                                                       userGender: self.userGender)
                                //                                                                 self.userList1.append(user)
                                //
                                //                                                                                                                 //print(self.nutritions)
                                //                                                         }
                                //                                                   }
                                //
                                //                                                   else{
                                //                                                       print("Im in else condition")
                                //                                                       var ref: DatabaseReference!
                                //                                                       ref = Database.database().reference()
                                //                                                       var geoFireRef: DatabaseReference?
                                //                                                       var geoFire: GeoFire?
                                //                                                       var myQuery: GFQuery?
                                //                                                       geoFireRef = ref.child("Geolocs")
                                //
                                //                                                       if let geoFireRef = geoFireRef {
                                //                                                           geoFire = GeoFire(firebaseRef: geoFireRef)
                                //                                                           if let id = Helper.getPREF("userId") {
                                //                                                           var arrayTemp = [String]()
                                //                                                           ref.child("mentorAssignUsers").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                                //                                                                   if snapshot.exists(){
                                //                                                                              if snapshot.childrenCount > 0{
                                //                                                                                for child in snapshot.children {
                                //                                                                                    let snap = child as! DataSnapshot
                                //                                                                                    let name = snap.key
                                //                                                                                    arrayTemp.append(name)
                                //                                                                                    print(name)
                                //                                                                                }
                                //                                                                             }
                                //                                                                        }
                                //                                                                    })
                                //
                                //                                                                    ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                                //
                                //                                                                        let value = snapshot.value as? NSDictionary
                                //                                                                        print(value)
                                //                                                                        var lat = ""
                                //                                                                        var long = ""
                                //                                                                        var ageInt = 0
                                //
                                //                                                                        if (lat != "" && lat != "0") && (long != "" && long != "0") {
                                //                                                                            let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(lat) ?? 0), longitude: CLLocationDegrees(Double(long) ?? 0))
                                //                                                                           myQuery = geoFire?.query(at: location, withRadius: Double(distance))
                                //                                                                            myQuery?.observe(.keyEntered, with: { (key, location) in
                                //                                                                                if key != Auth.auth().currentUser?.uid
                                //                                                                                {
                                //                                                                                    let ref = ref.child("users").child(key)
                                //                                                                                    ref.observeSingleEvent(of: .value, with: { (snapshot) in
                                //
                                //                                                                                        if snapshot.childrenCount > 0{
                                //                                                                                        let value = snapshot.value as! [String: AnyObject]
                                //                                                                                        if let name = value["name"] as? String {
                                //                                                                                            print("name: ",name)
                                //                                                                                        }
                                //
                                //                                                                                        if let userType = value["userType"] as? String{
                                //
                                //                                                                                            if userType == "Mentor" {
                                //                                                                                                print("userType: ",userType)
                                //                                                                                                let userId = value["userId"] as? String ?? ""
                                //                                                                                                let fun = value["fun"] as? String ?? ""
                                //                                                                                                let areaOfExpertise = value["areaOfExpertise"] as? String ?? ""
                                //                                                                                                let birthDay = value["birthay"] as? String ?? "0"
                                //                                                                                                let kind_of_member = value ["kindofMember"] as? String ?? "0"
                                //                                                                                                let name = value ["firstName"] as? String ?? "0"
                                //                                                                                                ageInt = Int(birthDay) ?? 0
                                //
                                //                                                                                                if !arrayTemp.contains(userId) || kindOfMember.caseInsensitiveCompare(kind_of_member) == .orderedSame || filterHobby.contains(fun) || ageInt  < age{
                                //                                                                                                   print(name)
                                //                                                                                                   print(kind_of_member)
                                //                                                                                                   let userDetail = UserModel(email: (value["email"] as? String) ?? "", firstname: (value["firstName"] as? String) ?? "", lastName: (value["lastName"] as? String) ?? "", fun: (value["fun"] as? String) ?? "", gender: "", islive: (value["islive"] as? String) ?? "", key_accomplishment: (value["key_accomplishment"] as? String) ?? "", kindofMember: (value["kindofMember"] as? String) ?? "", name: (value["name"] as? String) ?? "", occupation: (value["occupation"] as? String) ?? "", password: (value["password"] as? String) ?? "", school: (value["school"] as? String) ?? "", userType: (value["userType"] as? String) ?? "", no_of_mentee: (value["no_of_mentee"] as? String) ?? "", feild_of_study: (value["feild_of_study"] as? String) ?? "", hobbies: (value["hobbies"] as? String) ?? "", longterm: (value["longterm"] as? String) ?? "", memberdo: (value["memberdo"] as? String) ?? "", objective: (value["objective"] as? String) ?? "", shortterm: (value["shortterm"] as? String) ?? "", image: (value["image"] as? String) ?? "", userId: (value["userId"] as? String) ?? "", currentCity: (value["currentCity"] as? String) ?? "", areaOfExpertise: (value["areaOfExpertise"] as? String) ?? "", latitude: (value["latitude"] as? String) ?? "", longitude: (value["longitude"] as? String) ?? "", birthday: (value["birthday"] as? String) ?? "", userGender:(value["userGender"] as? String))
                                //                                                                                                   self.userList1.append(userDetail)
                                //
                                //
                                //                                                                                                }
                                //
                                //                                                                                            }
                                //
                                //                                                                                        }
                                //                                                                                        }else{
                                //
                                //                                                                                        }
                                //                                                                                    })
                                //                                                                                }
                                //                                                                            })
                                //                                                                        } else{
                                //
                                //                                                                        }
                                //                                                                    })
                                //                                                                } else{
                                //
                                //                                                                }
                                //                                                            } else{
                                //
                                //                                                            }
                                //                                                       }
                                
                            }
                        }
                    }
                }
                print("\(self.userList1.count) dwjdhjkhd")
                
                if  self.userList1.count > 0 {
                    
                    self.viewNoData.isHidden = true
                   
                    DispatchQueue.main.async {
                        self.removeSubview()
                        let contentView: (Int, CGRect, UserModel) -> (UIView) = { (index: Int ,frame: CGRect , userModel: UserModel) -> (UIView) in
                            
                            let customView = CustomView(frame: frame)
                            customView.userModel = userModel
                            //customView.buttonAction.addTarget(self, action: #selector(self.customViewButtonSelected), for: UIControl.Event.touchUpInside)
                            return customView
                        }
                        self.swipeView = TinderSwipeView<UserModel>(frame: self.viewContainer.bounds, contentView: contentView)
                        self.swipeView.tag = 100
                        self.swipeView.showTinderCards(with: self.userList1)
                        self.swipeView.setNeedsDisplay()
                        self.swipeView.layoutIfNeeded()
                        self.viewContainer.addSubview(self.swipeView)
                        //raaaaaaaaaa
                        self.swipeView.isHidden = false
                    }
                    print(String(self.userList1.count))
                    self.collectionView.isHidden = true
                    
                } else{
                    self.collectionView.isHidden = true
                    if self.swipeView != nil{
                        self.swipeView.isHidden = true
                    }
                    self.viewNoData.isHidden = false
                }
            }
        })
    }
    

    func getFilteredDataFromDatabaseMentor(filterHobby: String,hobby2: String,hobby3: String, kindOfMember: String, gender: [String], age: Int, age2: Int, distance:Int, keyword: String){
        self.userList = []
        self.userList1 = []
        print(filterHobby)
        print(kindOfMember)
        print(gender)
        print(age2)
        print(age)
        print(distance)
        
        var funStr = ""
        var arrayTemp = [String]()
        ref.child("mentorAssignUsers").child(Helper.getPREF("userId")!).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                  if snapshot.childrenCount > 0{
                    for child in snapshot.children {
                        let snap = child as! DataSnapshot
                        let name = snap.key
                        arrayTemp.append(name)
                        print(name)
                    }
                 }
            }
        })
        
        ref.child("users").child(Helper.getPREF("userId")!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
            let value = snapshot.value as! [String: AnyObject]
                if let name = value["name"] as? String {
                    print("name: ",name)
                }
                if let gender = value["gender"] as? [String]{
                    self.genderPref = gender
                }
                else
                {
                    self.genderPref = []
                }
                funStr = value["fun"] as? String ?? ""
            }
        })
        
        Helper.showLoader(onVC: self, message: "")
        ref.child("users").observeSingleEvent(of: .value, with: { snapshot in
            Helper.hideLoader(onVC: self)
            if snapshot.childrenCount > 0 {
                self.userList.removeAll()
                for nutrition in snapshot.children.allObjects as! [DataSnapshot] {
                    let objects = nutrition.value as! [String: AnyObject]
                    print(objects)
                    
                    self.userType1 = objects["userType"] as? String ?? ""
                    self.hobbies = objects["hobbies"] as? String ?? ""
                    var hobbies1 = objects["hobbies1"] as? String ?? ""
                    var hobbies2 = objects["hobbies2"] as? String ?? ""
                    self.kindofMember = objects["kindofMember"] as? String ?? ""
                    if let userGender = objects["userGender"] as? String{
                         self.userGender = userGender
                    }else{
                        self.userGender = ""
                    }
                    self.email = objects["email"] as? String ?? ""
                    self.firstname = objects["firstname"] as? String ?? ""
                    self.lastName = objects["lastName"] as? String ?? ""
                    self.fun = objects["hobbies"] as? String ?? ""
                    if let gender = objects["gender"] as? String{
                        self.gender = gender
                    }
                    
                    self.islive = objects["islive"] as? String ?? ""
                    self.key_accomplishment = objects["key_accomplishment"] as? String ?? ""
                                                             
                    self.name = objects["name"] as? String ?? ""
                    self.no_of_mentee = objects["no_of_mentee"] as? String ?? ""
                    self.occupation = objects["occupation"] as? String ?? ""
                    self.password = objects["password"] as? String ?? ""
                    self.school = objects["school"] as? String ?? ""
                                                          
                    self.feild_of_study = objects["feild_of_study"] as? String ?? ""
                    self.hobbies = objects["hobbies"] as? String ?? ""
                    self.memberdo = objects["memberdo"] as? String ?? ""
                    self.objective = objects["objective"] as? String ?? ""
                    self.shortterm = objects["shortterm"] as? String ?? ""
                    self.userId = objects["userId"] as? String ?? ""
                                                                                    
                    self.longterm = objects["longterm"] as? String ?? ""
                    self.currentCity = objects["currentCity"] as? String ?? ""
                    self.areaOfExpertise = objects["areaOfExpertise"] as? String ?? ""
                    self.currentCity = objects["currentCity"] as? String ?? ""
                    self.areaOfExpertise = objects["areaOfExpertise"] as? String ?? ""
                    self.birthday = objects[" birthday"] as? String ?? ""
                    let birthDay = objects["birthday"] as? String ?? "0"
                    let ageInt = Int(birthDay) ?? 0
                    
                    print("\(self.userType1) sssss\(funStr) aaaa \(self.hobbies)")
                    
                    if self.userType1 == "Mentee" {
                        if(!keyword.isEmpty)
                        {
                            if(self.hobbies.contains(keyword) || self.email.contains(keyword) || self.firstname.contains(keyword) || self.lastName.contains(keyword) || self.gender.contains(keyword) || self.key_accomplishment.contains(keyword) || self.kindofMember.contains(keyword) ||
                                                    self.name.contains(keyword) || self.occupation.contains(keyword) || self.school.contains(keyword) || self.feild_of_study.contains(keyword) || self.memberdo.contains(keyword) || self.shortterm.contains(keyword) ||
                                                    self.longterm.contains(keyword) || self.currentCity.contains(keyword) || self.areaOfExpertise.contains(keyword) )
                                                {
                                                    if let email = objects["email"] as? String{
                                                                                                 self.email = email
                                                                                             }
                                                                                             if let hobbies = objects["hobbies"] as? String{
                                                                                                 self.hobbies = hobbies
                                                                                             }
                                                                                             if let firstname = objects["firstname"] as? String{
                                                                                                 self.firstname = firstname
                                                                                             }
                                                                                             if let lastName = objects["lastName"] as? String{
                                                                                                 self.lastName = lastName
                                                                                             }
                                                                                             if let fun = objects["hobbies"] as? String{
                                                                                                 self.fun = fun
                                                                                             }
                                                                                             else{
                                                                                                 self.fun = ""
                                                                                             }
                                                                                             if let gender = objects["gender"] as? String{
                                                                                                 self.gender = gender
                                                                                             }
                                                                                             if let islive = objects["islive"] as? String{
                                                                                                 self.islive = islive
                                                                                             }
                                                                                             if let key_accomplishment = objects["key_accomplishment"] as? String{
                                                                                                 self.key_accomplishment = key_accomplishment
                                                                                             }
                                                                                             if let kindofMember = objects["kindofMember"] as? String{
                                                                                                 self.kindofMember = kindofMember
                                                                                             }
                                                                                             if let name = objects["name"] as? String{
                                                                                                 self.name = name
                                                                                             }
                                                                                             if let no_of_mentee = objects["no_of_mentee"] as? String{
                                                                                                 self.no_of_mentee = no_of_mentee
                                                                                             }
                                                                                             if let occupation = objects["occupation"] as? String{
                                                                                                 self.occupation = occupation
                                                                                             }
                                                                                             if let password = objects["password"] as? String{
                                                                                                 self.password = password
                                                                                             }
                                                                                             if let school = objects["school"] as? String{
                                                                                                self.school = school
                                                                                             }
                                                                                            if let userType = objects["userType"] as? String{
                                                                                                self.userType1 = userType
                                                                                             }
                                                                                            if let feild_of_study = objects["feild_of_study"] as? String{
                                                                                                 self.feild_of_study = feild_of_study
                                                                                             }
                                                                                            if let hobbies = objects["hobbies"] as? String{
                                                                                                 self.hobbies = hobbies
                                                                                             }
                                                                                            if let memberdo = objects["memberdo"] as? String{
                                                                                                 self.memberdo = memberdo
                                                                                             }
                                                                                             if let objective = objects["objective"] as? String{
                                                                                                 self.objective = objective
                                                                                             }
                                                                                             if let shortterm = objects["shortterm"] as? String{
                                                                                                 self.shortterm = shortterm
                                                                                             }
                                                                                             if let userId = objects["userId"] as? String{
                                                                                                 self.userId = userId
                                                                                             }
                                                                                                                   
                                                                                             if let longterm = objects["longterm"] as? String{
                                                                                                 self.longterm = longterm
                                                                                             }
                                                                                             if let currentCity = objects["currentCity"] as? String{
                                                                                                  self.currentCity = currentCity
                                                                                             }
                                                                                             if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                                                                                 self.areaOfExpertise = areaOfExpertise
                                                                                             }
                                                                                             if let currentCity = objects["currentCity"] as? String{
                                                                                                 self.currentCity = currentCity
                                                                                             }
                                                                                             if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                                                                                 self.areaOfExpertise = areaOfExpertise
                                                                                              }
                                                                                             if let birthday = objects[" birthday"] as? String{
                                                                                                 self.birthday = birthday
                                                                                             }
                                                                                             if let usergender = objects[" userGender"] as? String{
                                                                                                 self.userGender = usergender
                                                                                             }
                                                                                             if let image = objects["image"] as? String{
                                                                                                self.image = image
                                                                                             }else
                                                                                             {
                                                                                                 self.image = ""
                                                                                             }
                                                                                             let user = UserModel(email : self.email,
                                                                                                                 firstname : self.firstname ,
                                                                                                                 lastName : self.lastName,
                                                                                                                 fun : self.fun,
                                                                                                                 gender : self.gender,
                                                                                                                 islive : self.islive,
                                                                                                                 key_accomplishment : self.key_accomplishment,
                                                                                                                 kindofMember : self.kindofMember,
                                                                                                                 name : self.name ,
                                                                                                                 occupation : self.occupation,
                                                                                                                 password : self.password,
                                                                                                                 school : self.school,
                                                                                                                 userType :self.userType1,
                                                                                                                 no_of_mentee : self.no_of_mentee,
                                                                                                                 feild_of_study :self.feild_of_study,
                                                                                                                 hobbies : self.hobbies,
                                                                                                                 longterm : self.longterm,
                                                                                                                 memberdo : self.memberdo,
                                                                                                                 objective : self.objective,
                                                                                                                 shortterm : self.shortterm,
                                                                                                                 image: self.image,
                                                                                                                 userId: self.userId,
                                                                                                                 currentCity: self.currentCity,
                                                                                                                 areaOfExpertise: self.areaOfExpertise,
                                                                                                                 latitude: self.latitude,
                                                                                                                 longitude: self.longitude,
                                                                                                                 birthday: self.birthday,
                                                                                                                 userGender: self.userGender)
                                                                                                                   
                                                                                                     self.userList.append(user)
                                                }
                        }
                    
                        else{
                            //self.genderPref.contains(self.userGender) sourav
//                            filterHobby: [String], kindOfMember: String, gender: [String], age: Int, distance:Int, keyword: String
                            print("from \(gender) usergender\(self.userGender)")
                            if (age != 0) && (ageInt != 0) {
                                                           if  (ageInt  < age) && (ageInt  > age2) {
                                                               if let email = objects["email"] as? String{
                                                                    self.email = email
                                                                }
                                                                if let hobbies = objects["hobbies"] as? String{
                                                                    self.hobbies = hobbies
                                                                }
                                                                if let firstname = objects["firstname"] as? String{
                                                                    self.firstname = firstname
                                                                }
                                                                if let lastName = objects["lastName"] as? String{
                                                                    self.lastName = lastName
                                                                }
                                                                if let fun = objects["hobbies"] as? String{
                                                                    self.fun = fun
                                                                }
                                                                else{
                                                                    self.fun = ""
                                                                }
                                                                if let gender = objects["gender"] as? String{
                                                                    self.gender = gender
                                                                }
                                                                if let islive = objects["islive"] as? String{
                                                                    self.islive = islive
                                                                }
                                                                if let key_accomplishment = objects["key_accomplishment"] as? String{
                                                                    self.key_accomplishment = key_accomplishment
                                                                }
                                                                if let kindofMember = objects["kindofMember"] as? String{
                                                                    self.kindofMember = kindofMember
                                                                }
                                                                if let name = objects["name"] as? String{
                                                                    self.name = name
                                                                }
                                                                if let no_of_mentee = objects["no_of_mentee"] as? String{
                                                                    self.no_of_mentee = no_of_mentee
                                                                }
                                                                if let occupation = objects["occupation"] as? String{
                                                                    self.occupation = occupation
                                                                }
                                                                if let password = objects["password"] as? String{
                                                                    self.password = password
                                                                }
                                                                if let school = objects["school"] as? String{
                                                                   self.school = school
                                                                }
                                                               if let userType = objects["userType"] as? String{
                                                                   self.userType1 = userType
                                                                }
                                                               if let feild_of_study = objects["feild_of_study"] as? String{
                                                                    self.feild_of_study = feild_of_study
                                                                }
                                                               if let hobbies = objects["hobbies"] as? String{
                                                                    self.hobbies = hobbies
                                                                }
                                                               if let memberdo = objects["memberdo"] as? String{
                                                                    self.memberdo = memberdo
                                                                }
                                                                if let objective = objects["objective"] as? String{
                                                                    self.objective = objective
                                                                }
                                                                if let shortterm = objects["shortterm"] as? String{
                                                                    self.shortterm = shortterm
                                                                }
                                                                if let userId = objects["userId"] as? String{
                                                                    self.userId = userId
                                                                }
                                                                                      
                                                                if let longterm = objects["longterm"] as? String{
                                                                    self.longterm = longterm
                                                                }
                                                                if let currentCity = objects["currentCity"] as? String{
                                                                     self.currentCity = currentCity
                                                                }
                                                                if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                                                    self.areaOfExpertise = areaOfExpertise
                                                                }
                                                                if let currentCity = objects["currentCity"] as? String{
                                                                    self.currentCity = currentCity
                                                                }
                                                                if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                                                    self.areaOfExpertise = areaOfExpertise
                                                                 }
                                                                if let birthday = objects[" birthday"] as? String{
                                                                    self.birthday = birthday
                                                                }
                                                                if let usergender = objects[" userGender"] as? String{
                                                                    self.userGender = usergender
                                                                }
                                                                if let image = objects["image"] as? String{
                                                                   self.image = image
                                                                }else
                                                                {
                                                                    self.image = ""
                                                                }
                                                                let user = UserModel(email : self.email,
                                                                                    firstname : self.firstname ,
                                                                                    lastName : self.lastName,
                                                                                    fun : self.fun,
                                                                                    gender : self.gender,
                                                                                    islive : self.islive,
                                                                                    key_accomplishment : self.key_accomplishment,
                                                                                    kindofMember : self.kindofMember,
                                                                                    name : self.name ,
                                                                                    occupation : self.occupation,
                                                                                    password : self.password,
                                                                                    school : self.school,
                                                                                    userType :self.userType1,
                                                                                    no_of_mentee : self.no_of_mentee,
                                                                                    feild_of_study :self.feild_of_study,
                                                                                    hobbies : self.hobbies,
                                                                                    longterm : self.longterm,
                                                                                    memberdo : self.memberdo,
                                                                                    objective : self.objective,
                                                                                    shortterm : self.shortterm,
                                                                                    image: self.image,
                                                                                    userId: self.userId,
                                                                                    currentCity: self.currentCity,
                                                                                    areaOfExpertise: self.areaOfExpertise,
                                                                                    latitude: self.latitude,
                                                                                    longitude: self.longitude,
                                                                                    birthday: self.birthday,
                                                                                    userGender: self.userGender)
                                                                                      
                                                                        self.userList.append(user)
                                                           }
                                                       } else
                            if(!gender.isEmpty){
                                if(gender.contains(self.userGender) || gender.contains(self.userGender) || gender.contains(self.userGender))
                                {
                                    if let email = objects["email"] as? String{
                                                                                                            self.email = email
                                                                                                        }
                                                                                                        if let hobbies = objects["hobbies"] as? String{
                                                                                                            self.hobbies = hobbies
                                                                                                        }
                                                                                                        if let firstname = objects["firstname"] as? String{
                                                                                                            self.firstname = firstname
                                                                                                        }
                                                                                                        if let lastName = objects["lastName"] as? String{
                                                                                                            self.lastName = lastName
                                                                                                        }
                                                                                                        if let fun = objects["hobbies"] as? String{
                                                                                                            self.fun = fun
                                                                                                        }
                                                                                                        else{
                                                                                                            self.fun = ""
                                                                                                        }
                                                                                                        if let gender = objects["gender"] as? String{
                                                                                                            self.gender = gender
                                                                                                        }
                                                                                                        if let islive = objects["islive"] as? String{
                                                                                                            self.islive = islive
                                                                                                        }
                                                                                                        if let key_accomplishment = objects["key_accomplishment"] as? String{
                                                                                                            self.key_accomplishment = key_accomplishment
                                                                                                        }
                                                                                                        if let kindofMember = objects["kindofMember"] as? String{
                                                                                                            self.kindofMember = kindofMember
                                                                                                        }
                                                                                                        if let name = objects["name"] as? String{
                                                                                                            self.name = name
                                                                                                        }
                                                                                                        if let no_of_mentee = objects["no_of_mentee"] as? String{
                                                                                                            self.no_of_mentee = no_of_mentee
                                                                                                        }
                                                                                                        if let occupation = objects["occupation"] as? String{
                                                                                                            self.occupation = occupation
                                                                                                        }
                                                                                                        if let password = objects["password"] as? String{
                                                                                                            self.password = password
                                                                                                        }
                                                                                                        if let school = objects["school"] as? String{
                                                                                                           self.school = school
                                                                                                        }
                                                                                                       if let userType = objects["userType"] as? String{
                                                                                                           self.userType1 = userType
                                                                                                        }
                                                                                                       if let feild_of_study = objects["feild_of_study"] as? String{
                                                                                                            self.feild_of_study = feild_of_study
                                                                                                        }
                                                                                                       if let hobbies = objects["hobbies"] as? String{
                                                                                                            self.hobbies = hobbies
                                                                                                        }
                                                                                                       if let memberdo = objects["memberdo"] as? String{
                                                                                                            self.memberdo = memberdo
                                                                                                        }
                                                                                                        if let objective = objects["objective"] as? String{
                                                                                                            self.objective = objective
                                                                                                        }
                                                                                                        if let shortterm = objects["shortterm"] as? String{
                                                                                                            self.shortterm = shortterm
                                                                                                        }
                                                                                                        if let userId = objects["userId"] as? String{
                                                                                                            self.userId = userId
                                                                                                        }
                                                                                                                              
                                                                                                        if let longterm = objects["longterm"] as? String{
                                                                                                            self.longterm = longterm
                                                                                                        }
                                                                                                        if let currentCity = objects["currentCity"] as? String{
                                                                                                             self.currentCity = currentCity
                                                                                                        }
                                                                                                        if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                                                                                            self.areaOfExpertise = areaOfExpertise
                                                                                                        }
                                                                                                        if let currentCity = objects["currentCity"] as? String{
                                                                                                            self.currentCity = currentCity
                                                                                                        }
                                                                                                        if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                                                                                            self.areaOfExpertise = areaOfExpertise
                                                                                                         }
                                                                                                        if let birthday = objects[" birthday"] as? String{
                                                                                                            self.birthday = birthday
                                                                                                        }
                                                                                                        if let usergender = objects[" userGender"] as? String{
                                                                                                            self.userGender = usergender
                                                                                                        }
                                                                                                        if let image = objects["image"] as? String{
                                                                                                           self.image = image
                                                                                                        }else
                                                                                                        {
                                                                                                            self.image = ""
                                                                                                        }
                                                                                                        let user = UserModel(email : self.email,
                                                                                                                            firstname : self.firstname ,
                                                                                                                            lastName : self.lastName,
                                                                                                                            fun : self.fun,
                                                                                                                            gender : self.gender,
                                                                                                                            islive : self.islive,
                                                                                                                            key_accomplishment : self.key_accomplishment,
                                                                                                                            kindofMember : self.kindofMember,
                                                                                                                            name : self.name ,
                                                                                                                            occupation : self.occupation,
                                                                                                                            password : self.password,
                                                                                                                            school : self.school,
                                                                                                                            userType :self.userType1,
                                                                                                                            no_of_mentee : self.no_of_mentee,
                                                                                                                            feild_of_study :self.feild_of_study,
                                                                                                                            hobbies : self.hobbies,
                                                                                                                            longterm : self.longterm,
                                                                                                                            memberdo : self.memberdo,
                                                                                                                            objective : self.objective,
                                                                                                                            shortterm : self.shortterm,
                                                                                                                            image: self.image,
                                                                                                                            userId: self.userId,
                                                                                                                            currentCity: self.currentCity,
                                                                                                                            areaOfExpertise: self.areaOfExpertise,
                                                                                                                            latitude: self.latitude,
                                                                                                                            longitude: self.longitude,
                                                                                                                            birthday: self.birthday,
                                                                                                                            userGender: self.userGender)
                                                                                                                              
                                                                                                                self.userList.append(user)
                                }
                            }
                            else if(!filterHobby.isEmpty){
                                //let joined = filterHobby.joined(separator: ",")
                                if filterHobby.contains(funStr) || hobby2.contains(hobbies1) || hobby2.contains(hobbies2){
                                    if let email = objects["email"] as? String{
                                                                                                            self.email = email
                                                                                                        }
                                                                                                        if let hobbies = objects["hobbies"] as? String{
                                                                                                            self.hobbies = hobbies
                                                                                                        }
                                                                                                        if let firstname = objects["firstname"] as? String{
                                                                                                            self.firstname = firstname
                                                                                                        }
                                                                                                        if let lastName = objects["lastName"] as? String{
                                                                                                            self.lastName = lastName
                                                                                                        }
                                                                                                        if let fun = objects["hobbies"] as? String{
                                                                                                            self.fun = fun
                                                                                                        }
                                                                                                        else{
                                                                                                            self.fun = ""
                                                                                                        }
                                                                                                        if let gender = objects["gender"] as? String{
                                                                                                            self.gender = gender
                                                                                                        }
                                                                                                        if let islive = objects["islive"] as? String{
                                                                                                            self.islive = islive
                                                                                                        }
                                                                                                        if let key_accomplishment = objects["key_accomplishment"] as? String{
                                                                                                            self.key_accomplishment = key_accomplishment
                                                                                                        }
                                                                                                        if let kindofMember = objects["kindofMember"] as? String{
                                                                                                            self.kindofMember = kindofMember
                                                                                                        }
                                                                                                        if let name = objects["name"] as? String{
                                                                                                            self.name = name
                                                                                                        }
                                                                                                        if let no_of_mentee = objects["no_of_mentee"] as? String{
                                                                                                            self.no_of_mentee = no_of_mentee
                                                                                                        }
                                                                                                        if let occupation = objects["occupation"] as? String{
                                                                                                            self.occupation = occupation
                                                                                                        }
                                                                                                        if let password = objects["password"] as? String{
                                                                                                            self.password = password
                                                                                                        }
                                                                                                        if let school = objects["school"] as? String{
                                                                                                           self.school = school
                                                                                                        }
                                                                                                       if let userType = objects["userType"] as? String{
                                                                                                           self.userType1 = userType
                                                                                                        }
                                                                                                       if let feild_of_study = objects["feild_of_study"] as? String{
                                                                                                            self.feild_of_study = feild_of_study
                                                                                                        }
                                                                                                       if let hobbies = objects["hobbies"] as? String{
                                                                                                            self.hobbies = hobbies
                                                                                                        }
                                                                                                       if let memberdo = objects["memberdo"] as? String{
                                                                                                            self.memberdo = memberdo
                                                                                                        }
                                                                                                        if let objective = objects["objective"] as? String{
                                                                                                            self.objective = objective
                                                                                                        }
                                                                                                        if let shortterm = objects["shortterm"] as? String{
                                                                                                            self.shortterm = shortterm
                                                                                                        }
                                                                                                        if let userId = objects["userId"] as? String{
                                                                                                            self.userId = userId
                                                                                                        }
                                                                                                                              
                                                                                                        if let longterm = objects["longterm"] as? String{
                                                                                                            self.longterm = longterm
                                                                                                        }
                                                                                                        if let currentCity = objects["currentCity"] as? String{
                                                                                                             self.currentCity = currentCity
                                                                                                        }
                                                                                                        if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                                                                                            self.areaOfExpertise = areaOfExpertise
                                                                                                        }
                                                                                                        if let currentCity = objects["currentCity"] as? String{
                                                                                                            self.currentCity = currentCity
                                                                                                        }
                                                                                                        if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                                                                                            self.areaOfExpertise = areaOfExpertise
                                                                                                         }
                                                                                                        if let birthday = objects[" birthday"] as? String{
                                                                                                            self.birthday = birthday
                                                                                                        }
                                                                                                        if let usergender = objects[" userGender"] as? String{
                                                                                                            self.userGender = usergender
                                                                                                        }
                                                                                                        if let image = objects["image"] as? String{
                                                                                                           self.image = image
                                                                                                        }else
                                                                                                        {
                                                                                                            self.image = ""
                                                                                                        }
                                                                                                        let user = UserModel(email : self.email,
                                                                                                                            firstname : self.firstname ,
                                                                                                                            lastName : self.lastName,
                                                                                                                            fun : self.fun,
                                                                                                                            gender : self.gender,
                                                                                                                            islive : self.islive,
                                                                                                                            key_accomplishment : self.key_accomplishment,
                                                                                                                            kindofMember : self.kindofMember,
                                                                                                                            name : self.name ,
                                                                                                                            occupation : self.occupation,
                                                                                                                            password : self.password,
                                                                                                                            school : self.school,
                                                                                                                            userType :self.userType1,
                                                                                                                            no_of_mentee : self.no_of_mentee,
                                                                                                                            feild_of_study :self.feild_of_study,
                                                                                                                            hobbies : self.hobbies,
                                                                                                                            longterm : self.longterm,
                                                                                                                            memberdo : self.memberdo,
                                                                                                                            objective : self.objective,
                                                                                                                            shortterm : self.shortterm,
                                                                                                                            image: self.image,
                                                                                                                            userId: self.userId,
                                                                                                                            currentCity: self.currentCity,
                                                                                                                            areaOfExpertise: self.areaOfExpertise,
                                                                                                                            latitude: self.latitude,
                                                                                                                            longitude: self.longitude,
                                                                                                                            birthday: self.birthday,
                                                                                                                            userGender: self.userGender)
                                                                                                                              
                                                                                                                self.userList.append(user)
                                }
                            }
                            else if (!kindOfMember.isEmpty){
                                if kindOfMember.caseInsensitiveCompare(self.kindofMember) == .orderedSame {
                                    if let email = objects["email"] as? String{
                                         self.email = email
                                     }
                                     if let hobbies = objects["hobbies"] as? String{
                                         self.hobbies = hobbies
                                     }
                                     if let firstname = objects["firstname"] as? String{
                                         self.firstname = firstname
                                     }
                                     if let lastName = objects["lastName"] as? String{
                                         self.lastName = lastName
                                     }
                                     if let fun = objects["hobbies"] as? String{
                                         self.fun = fun
                                     }
                                     else{
                                         self.fun = ""
                                     }
                                     if let gender = objects["gender"] as? String{
                                         self.gender = gender
                                     }
                                     if let islive = objects["islive"] as? String{
                                         self.islive = islive
                                     }
                                     if let key_accomplishment = objects["key_accomplishment"] as? String{
                                         self.key_accomplishment = key_accomplishment
                                     }
                                     if let kindofMember = objects["kindofMember"] as? String{
                                         self.kindofMember = kindofMember
                                     }
                                     if let name = objects["name"] as? String{
                                         self.name = name
                                     }
                                     if let no_of_mentee = objects["no_of_mentee"] as? String{
                                         self.no_of_mentee = no_of_mentee
                                     }
                                     if let occupation = objects["occupation"] as? String{
                                         self.occupation = occupation
                                     }
                                     if let password = objects["password"] as? String{
                                         self.password = password
                                     }
                                     if let school = objects["school"] as? String{
                                        self.school = school
                                     }
                                    if let userType = objects["userType"] as? String{
                                        self.userType1 = userType
                                     }
                                    if let feild_of_study = objects["feild_of_study"] as? String{
                                         self.feild_of_study = feild_of_study
                                     }
                                    if let hobbies = objects["hobbies"] as? String{
                                         self.hobbies = hobbies
                                     }
                                    if let memberdo = objects["memberdo"] as? String{
                                         self.memberdo = memberdo
                                     }
                                     if let objective = objects["objective"] as? String{
                                         self.objective = objective
                                     }
                                     if let shortterm = objects["shortterm"] as? String{
                                         self.shortterm = shortterm
                                     }
                                     if let userId = objects["userId"] as? String{
                                         self.userId = userId
                                     }
                                                           
                                     if let longterm = objects["longterm"] as? String{
                                         self.longterm = longterm
                                     }
                                     if let currentCity = objects["currentCity"] as? String{
                                          self.currentCity = currentCity
                                     }
                                     if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                         self.areaOfExpertise = areaOfExpertise
                                     }
                                     if let currentCity = objects["currentCity"] as? String{
                                         self.currentCity = currentCity
                                     }
                                     if let areaOfExpertise = objects["areaOfExpertise"] as? String{
                                         self.areaOfExpertise = areaOfExpertise
                                      }
                                     if let birthday = objects[" birthday"] as? String{
                                         self.birthday = birthday
                                     }
                                     if let usergender = objects[" userGender"] as? String{
                                         self.userGender = usergender
                                     }
                                     if let image = objects["image"] as? String{
                                        self.image = image
                                     }else
                                     {
                                         self.image = ""
                                     }
                                     let user = UserModel(email : self.email,
                                                         firstname : self.firstname ,
                                                         lastName : self.lastName,
                                                         fun : self.fun,
                                                         gender : self.gender,
                                                         islive : self.islive,
                                                         key_accomplishment : self.key_accomplishment,
                                                         kindofMember : self.kindofMember,
                                                         name : self.name ,
                                                         occupation : self.occupation,
                                                         password : self.password,
                                                         school : self.school,
                                                         userType :self.userType1,
                                                         no_of_mentee : self.no_of_mentee,
                                                         feild_of_study :self.feild_of_study,
                                                         hobbies : self.hobbies,
                                                         longterm : self.longterm,
                                                         memberdo : self.memberdo,
                                                         objective : self.objective,
                                                         shortterm : self.shortterm,
                                                         image: self.image,
                                                         userId: self.userId,
                                                         currentCity: self.currentCity,
                                                         areaOfExpertise: self.areaOfExpertise,
                                                         latitude: self.latitude,
                                                         longitude: self.longitude,
                                                         birthday: self.birthday,
                                                         userGender: self.userGender)
                                                           
                                             self.userList.append(user)
                                }
                            }
                           
                            else if(distance != 0){
                                print(#function)
                                                                                      var ref: DatabaseReference!
                                                                                      ref = Database.database().reference()
                                                                                      
                                                                                      var geoFireRef: DatabaseReference?
                                                                                      var geoFire: GeoFire?
                                                                                      var myQuery: GFQuery?
                                                                                      geoFireRef = ref.child("Geolocs")
                                                                          
                                                                                      if let geoFireRef = geoFireRef {
                                                                                          geoFire = GeoFire(firebaseRef: geoFireRef)
                                                                                          if let id = Helper.getPREF("userId") {
                                                                                              
                                                                                              var arrayTemp = [String]()
                                                                                              ref.child("mentorAssignUsers").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                                                                                                  if snapshot.exists(){
                                                                                                        if snapshot.childrenCount > 0{
                                                                                                          for child in snapshot.children {
                                                                                                              let snap = child as! DataSnapshot
                                                                                                              let name = snap.key
                                                                                                              arrayTemp.append(name)
                                                                                                              print(name)
                                                                                                          }
                                                                                                       }
                                                                                                  }
                                                                                              })
                                                                                              
                                                                                              ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
                                                                                      
                                                                                                  let value = snapshot.value as? NSDictionary
                                                                                                  var lat = ""
                                                                                                  var long = ""
                                                                                                  var funStr = ""
                                                                                                  var areaOfExpertisee = ""
                                                                                                  var ageInt = 0
                                                                                                  
                                                                                                  if let latitude = value?["latitude"] as? String {
                                                                                                      lat = latitude
                                                                                                  }
                                                                                                  if let longitude = value?["longitude"] as? String{
                                                                                                      long = longitude
                                                                                                  }
                                                                                                  
                                                                                                  if let fun = value?["fun"] as? String{
                                                                                                      funStr = fun
                                                                                                  }
                                                                                                  
                                                                                                  if let areaOfExpertise = value?["areaOfExpertise"] as? String{
                                                                                                      areaOfExpertisee = areaOfExpertise
                                                                                                  }
                                                                                                  
                                                                                                  if (lat != "" && lat != "0") && (long != "" && long != "0") {
                                                                                                      let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(lat) ?? 0), longitude: CLLocationDegrees(Double(long) ?? 0))
                                                                                                      myQuery = geoFire?.query(at: location, withRadius: 100)
                                                                                                      myQuery?.observe(.keyEntered, with: { (key, location) in
                                                                                                          if key != Auth.auth().currentUser?.uid
                                                                                                          {
                                                                                                              let ref = ref.child("users").child(key)
                                                                                                              ref.observeSingleEvent(of: .value, with: { (snapshot) in
                                                                                                                  
                                                                                                                  if snapshot.childrenCount > 0 {
                                                                                                                  let value = snapshot.value as! [String: AnyObject]
                                                                                                                  if let name = value["name"] as? String {
                                                                                                                      print("name: ",name)
                                                                                                                  }
                                                                                                                  
                                                                                                                  if let userType = value["userType"] as? String{
                                                                                                                      if userType == "Mentee"{
                                                                                                                      let userId = value["userId"] as? String ?? ""
                                                                                                                      let hobbies = value["hobbies"] as? String ?? ""
                                                                                                                      let feild_of_study = value["feild_of_study"] as? String ?? ""
                                                                                                                      let birthDay = value["birthay"] as? String ?? "0"
                                                                                                                      let kind_of_member = value [""] as? String ?? "0"
                                                                                                                      ageInt = Int(birthDay) ?? 0
                                                                                                                          
                                                                                                                          if !arrayTemp.contains(userId) || kindOfMember.caseInsensitiveCompare(kind_of_member) == .orderedSame || filterHobby.contains(hobbies) || ageInt  < age{
                                                                                                                              let userDetail = UserModel(email: (value["email"] as? String) ?? "", firstname: (value["firstName"] as? String) ?? "", lastName: (value["lastName"] as? String) ?? "", fun: (value["fun"] as? String) ?? "", gender: "", islive: (value["islive"] as? String) ?? "", key_accomplishment: (value["key_accomplishment"] as? String) ?? "", kindofMember: (value["kindofMember"] as? String) ?? "", name: (value["name"] as? String) ?? "", occupation: (value["occupation"] as? String) ?? "", password: (value["password"] as? String) ?? "", school: (value["school"] as? String) ?? "", userType: (value["userType"] as? String) ?? "", no_of_mentee: (value["no_of_mentee"] as? String) ?? "", feild_of_study: (value["feild_of_study"] as? String) ?? "", hobbies: (value["hobbies"] as? String) ?? "", longterm: (value["longterm"] as? String) ?? "", memberdo: (value["memberdo"] as? String) ?? "", objective: (value["objective"] as? String) ?? "", shortterm: (value["shortterm"] as? String) ?? "", image: (value["image"] as? String) ?? "", userId: (value["userId"] as? String) ?? "", currentCity: (value["currentCity"] as? String) ?? "", areaOfExpertise: (value["areaOfExpertise"] as? String) ?? "", latitude: (value["latitude"] as? String) ?? "", longitude: (value["longitude"] as? String) ?? "", birthday: (value["birthday"] as? String) ?? "", userGender:(value["userGender"] as? String) ?? "")
                                                                                                                              self.userList.append(userDetail)
                                                                                                                              
                                                                                                                          }
                                                                                                                          
                                                                                                                      }
                                                                                                                  }
                                                                                                                  }else{
                                                                                                                      
                                                                                                                  }
                                                                                                              })
                                                                                                          }
                                                                                                      })
                                                                                                  } else{
                                                                                                      
                                                                                                  }
                                                                                              })
                                                                                          } else{
                                                                                              
                                                                                          }
                                                                                      } else{
                                                                                          
                                                                                      }
                            }else{
                                
                            }
                            
                            
                            print(gender)
//                            MARK : SOURAV
//                            if(gender.contains("Male") || gender.contains("Female") || gender.contains("Other"))
//                                                   {
//                                                       if(kindOfMember.caseInsensitiveCompare(self.kindofMember)  == .orderedSame || filterHobby.contains(funStr) || ageInt ?? 0 < age || gender.contains(self.userGender))
//                                                              {
//                                                              if(distance==0)
//                                                              {
//                                                                      if let email = objects["email"] as? String{
//                                                                          self.email = email
//                                                                      }
//                                                                      if let hobbies = objects["hobbies"] as? String{
//                                                                          self.hobbies = hobbies
//                                                                      }
//                                                                      if let firstname = objects["firstname"] as? String{
//                                                                          self.firstname = firstname
//                                                                      }
//                                                                      if let lastName = objects["lastName"] as? String{
//                                                                          self.lastName = lastName
//                                                                      }
//                                                                      if let fun = objects["hobbies"] as? String{
//                                                                          self.fun = fun
//                                                                      }
//                                                                      else{
//                                                                          self.fun = ""
//                                                                      }
//                                                                      if let gender = objects["gender"] as? String{
//                                                                          self.gender = gender
//                                                                      }
//                                                                      if let islive = objects["islive"] as? String{
//                                                                          self.islive = islive
//                                                                      }
//                                                                      if let key_accomplishment = objects["key_accomplishment"] as? String{
//                                                                          self.key_accomplishment = key_accomplishment
//                                                                      }
//                                                                      if let kindofMember = objects["kindofMember"] as? String{
//                                                                          self.kindofMember = kindofMember
//                                                                      }
//                                                                      if let name = objects["name"] as? String{
//                                                                          self.name = name
//                                                                      }
//                                                                      if let no_of_mentee = objects["no_of_mentee"] as? String{
//                                                                          self.no_of_mentee = no_of_mentee
//                                                                      }
//                                                                      if let occupation = objects["occupation"] as? String{
//                                                                          self.occupation = occupation
//                                                                      }
//                                                                      if let password = objects["password"] as? String{
//                                                                          self.password = password
//                                                                      }
//                                                                      if let school = objects["school"] as? String{
//                                                                         self.school = school
//                                                                      }
//                                                                     if let userType = objects["userType"] as? String{
//                                                                         self.userType1 = userType
//                                                                      }
//                                                                     if let feild_of_study = objects["feild_of_study"] as? String{
//                                                                          self.feild_of_study = feild_of_study
//                                                                      }
//                                                                     if let hobbies = objects["hobbies"] as? String{
//                                                                          self.hobbies = hobbies
//                                                                      }
//                                                                     if let memberdo = objects["memberdo"] as? String{
//                                                                          self.memberdo = memberdo
//                                                                      }
//                                                                      if let objective = objects["objective"] as? String{
//                                                                          self.objective = objective
//                                                                      }
//                                                                      if let shortterm = objects["shortterm"] as? String{
//                                                                          self.shortterm = shortterm
//                                                                      }
//                                                                      if let userId = objects["userId"] as? String{
//                                                                          self.userId = userId
//                                                                      }
//
//                                                                      if let longterm = objects["longterm"] as? String{
//                                                                          self.longterm = longterm
//                                                                      }
//                                                                      if let currentCity = objects["currentCity"] as? String{
//                                                                           self.currentCity = currentCity
//                                                                      }
//                                                                      if let areaOfExpertise = objects["areaOfExpertise"] as? String{
//                                                                          self.areaOfExpertise = areaOfExpertise
//                                                                      }
//                                                                      if let currentCity = objects["currentCity"] as? String{
//                                                                          self.currentCity = currentCity
//                                                                      }
//                                                                      if let areaOfExpertise = objects["areaOfExpertise"] as? String{
//                                                                          self.areaOfExpertise = areaOfExpertise
//                                                                       }
//                                                                      if let birthday = objects[" birthday"] as? String{
//                                                                          self.birthday = birthday
//                                                                      }
//                                                                      if let usergender = objects[" userGender"] as? String{
//                                                                          self.userGender = usergender
//                                                                      }
//                                                                      if let image = objects["image"] as? String{
//                                                                         self.image = image
//                                                                      }else
//                                                                      {
//                                                                          self.image = ""
//                                                                      }
//                                                                      let user = UserModel(email : self.email,
//                                                                                          firstname : self.firstname ,
//                                                                                          lastName : self.lastName,
//                                                                                          fun : self.fun,
//                                                                                          gender : self.gender,
//                                                                                          islive : self.islive,
//                                                                                          key_accomplishment : self.key_accomplishment,
//                                                                                          kindofMember : self.kindofMember,
//                                                                                          name : self.name ,
//                                                                                          occupation : self.occupation,
//                                                                                          password : self.password,
//                                                                                          school : self.school,
//                                                                                          userType :self.userType1,
//                                                                                          no_of_mentee : self.no_of_mentee,
//                                                                                          feild_of_study :self.feild_of_study,
//                                                                                          hobbies : self.hobbies,
//                                                                                          longterm : self.longterm,
//                                                                                          memberdo : self.memberdo,
//                                                                                          objective : self.objective,
//                                                                                          shortterm : self.shortterm,
//                                                                                          image: self.image,
//                                                                                          userId: self.userId,
//                                                                                          currentCity: self.currentCity,
//                                                                                          areaOfExpertise: self.areaOfExpertise,
//                                                                                          latitude: self.latitude,
//                                                                                          longitude: self.longitude,
//                                                                                          birthday: self.birthday,
//                                                                                          userGender: self.userGender)
//
//                                                                              self.userList.append(user)
//                                                              }
//                                                              else{
//                                                                  print(#function)
//                                                                  var ref: DatabaseReference!
//                                                                  ref = Database.database().reference()
//
//                                                                  var geoFireRef: DatabaseReference?
//                                                                  var geoFire: GeoFire?
//                                                                  var myQuery: GFQuery?
//                                                                  geoFireRef = ref.child("Geolocs")
//
//                                                                  if let geoFireRef = geoFireRef {
//                                                                      geoFire = GeoFire(firebaseRef: geoFireRef)
//                                                                      if let id = Helper.getPREF("userId") {
//
//                                                                          var arrayTemp = [String]()
//                                                                          ref.child("mentorAssignUsers").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
//                                                                              if snapshot.exists(){
//                                                                                    if snapshot.childrenCount > 0{
//                                                                                      for child in snapshot.children {
//                                                                                          let snap = child as! DataSnapshot
//                                                                                          let name = snap.key
//                                                                                          arrayTemp.append(name)
//                                                                                          print(name)
//                                                                                      }
//                                                                                   }
//                                                                              }
//                                                                          })
//
//                                                                          ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
//
//                                                                              let value = snapshot.value as? NSDictionary
//                                                                              var lat = ""
//                                                                              var long = ""
//                                                                              var funStr = ""
//                                                                              var areaOfExpertisee = ""
//                                                                              var ageInt = 0
//
//                                                                              if let latitude = value?["latitude"] as? String {
//                                                                                  lat = latitude
//                                                                              }
//                                                                              if let longitude = value?["longitude"] as? String{
//                                                                                  long = longitude
//                                                                              }
//
//                                                                              if let fun = value?["fun"] as? String{
//                                                                                  funStr = fun
//                                                                              }
//
//                                                                              if let areaOfExpertise = value?["areaOfExpertise"] as? String{
//                                                                                  areaOfExpertisee = areaOfExpertise
//                                                                              }
//
//                                                                              if (lat != "" && lat != "0") && (long != "" && long != "0") {
//                                                                                  let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(lat) ?? 0), longitude: CLLocationDegrees(Double(long) ?? 0))
//                                                                                  myQuery = geoFire?.query(at: location, withRadius: 100)
//                                                                                  myQuery?.observe(.keyEntered, with: { (key, location) in
//                                                                                      if key != Auth.auth().currentUser?.uid
//                                                                                      {
//                                                                                          let ref = ref.child("users").child(key)
//                                                                                          ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//                                                                                              if snapshot.childrenCount > 0 {
//                                                                                              let value = snapshot.value as! [String: AnyObject]
//                                                                                              if let name = value["name"] as? String {
//                                                                                                  print("name: ",name)
//                                                                                              }
//
//                                                                                              if let userType = value["userType"] as? String{
//                                                                                                  if userType == "Mentee"{
//                                                                                                  let userId = value["userId"] as? String ?? ""
//                                                                                                  let hobbies = value["hobbies"] as? String ?? ""
//                                                                                                  let feild_of_study = value["feild_of_study"] as? String ?? ""
//                                                                                                  let birthDay = value["birthay"] as? String ?? "0"
//                                                                                                  let kind_of_member = value [""] as? String ?? "0"
//                                                                                                  ageInt = Int(birthDay) ?? 0
//
//                                                                                                      if !arrayTemp.contains(userId) || kindOfMember.caseInsensitiveCompare(kind_of_member) == .orderedSame || filterHobby.contains(hobbies) || ageInt  < age{
//                                                                                                          let userDetail = UserModel(email: (value["email"] as? String) ?? "", firstname: (value["firstName"] as? String) ?? "", lastName: (value["lastName"] as? String) ?? "", fun: (value["fun"] as? String) ?? "", gender: "", islive: (value["islive"] as? String) ?? "", key_accomplishment: (value["key_accomplishment"] as? String) ?? "", kindofMember: (value["kindofMember"] as? String) ?? "", name: (value["name"] as? String) ?? "", occupation: (value["occupation"] as? String) ?? "", password: (value["password"] as? String) ?? "", school: (value["school"] as? String) ?? "", userType: (value["userType"] as? String) ?? "", no_of_mentee: (value["no_of_mentee"] as? String) ?? "", feild_of_study: (value["feild_of_study"] as? String) ?? "", hobbies: (value["hobbies"] as? String) ?? "", longterm: (value["longterm"] as? String) ?? "", memberdo: (value["memberdo"] as? String) ?? "", objective: (value["objective"] as? String) ?? "", shortterm: (value["shortterm"] as? String) ?? "", image: (value["image"] as? String) ?? "", userId: (value["userId"] as? String) ?? "", currentCity: (value["currentCity"] as? String) ?? "", areaOfExpertise: (value["areaOfExpertise"] as? String) ?? "", latitude: (value["latitude"] as? String) ?? "", longitude: (value["longitude"] as? String) ?? "", birthday: (value["birthday"] as? String) ?? "", userGender:(value["userGender"] as? String) ?? "")
//                                                                                                          self.userList.append(userDetail)
//
//                                                                                                      }
//
//                                                                                                  }
//                                                                                              }
//                                                                                              }else{
//
//                                                                                              }
//                                                                                          })
//                                                                                      }
//                                                                                  })
//                                                                              } else{
//
//                                                                              }
//                                                                          })
//                                                                      } else{
//
//                                                                      }
//                                                                  } else{
//
//                                                                  }
//                                                              }
//
//                                                          }
//                                                   }
//                                                   else{
//                                                       if(kindOfMember.caseInsensitiveCompare(self.kindofMember)  == .orderedSame || filterHobby.contains(funStr) || ageInt ?? 0 < age || gender.contains(self.userGender))
//                                                          {
//                                                          if(distance==0)
//                                                          {
//                                                                  if let email = objects["email"] as? String{
//                                                                      self.email = email
//                                                                  }
//                                                                  if let hobbies = objects["hobbies"] as? String{
//                                                                      self.hobbies = hobbies
//                                                                  }
//                                                                  if let firstname = objects["firstname"] as? String{
//                                                                      self.firstname = firstname
//                                                                  }
//                                                                  if let lastName = objects["lastName"] as? String{
//                                                                      self.lastName = lastName
//                                                                  }
//                                                                  if let fun = objects["hobbies"] as? String{
//                                                                      self.fun = fun
//                                                                  }
//                                                                  else{
//                                                                      self.fun = ""
//                                                                  }
//                                                                  if let gender = objects["gender"] as? String{
//                                                                      self.gender = gender
//                                                                  }
//                                                                  if let islive = objects["islive"] as? String{
//                                                                      self.islive = islive
//                                                                  }
//                                                                  if let key_accomplishment = objects["key_accomplishment"] as? String{
//                                                                      self.key_accomplishment = key_accomplishment
//                                                                  }
//                                                                  if let kindofMember = objects["kindofMember"] as? String{
//                                                                      self.kindofMember = kindofMember
//                                                                  }
//                                                                  if let name = objects["name"] as? String{
//                                                                      self.name = name
//                                                                  }
//                                                                  if let no_of_mentee = objects["no_of_mentee"] as? String{
//                                                                      self.no_of_mentee = no_of_mentee
//                                                                  }
//                                                                  if let occupation = objects["occupation"] as? String{
//                                                                      self.occupation = occupation
//                                                                  }
//                                                                  if let password = objects["password"] as? String{
//                                                                      self.password = password
//                                                                  }
//                                                                  if let school = objects["school"] as? String{
//                                                                     self.school = school
//                                                                  }
//                                                                 if let userType = objects["userType"] as? String{
//                                                                     self.userType1 = userType
//                                                                  }
//                                                                 if let feild_of_study = objects["feild_of_study"] as? String{
//                                                                      self.feild_of_study = feild_of_study
//                                                                  }
//                                                                 if let hobbies = objects["hobbies"] as? String{
//                                                                      self.hobbies = hobbies
//                                                                  }
//                                                                 if let memberdo = objects["memberdo"] as? String{
//                                                                      self.memberdo = memberdo
//                                                                  }
//                                                                  if let objective = objects["objective"] as? String{
//                                                                      self.objective = objective
//                                                                  }
//                                                                  if let shortterm = objects["shortterm"] as? String{
//                                                                      self.shortterm = shortterm
//                                                                  }
//                                                                  if let userId = objects["userId"] as? String{
//                                                                      self.userId = userId
//                                                                  }
//
//                                                                  if let longterm = objects["longterm"] as? String{
//                                                                      self.longterm = longterm
//                                                                  }
//                                                                  if let currentCity = objects["currentCity"] as? String{
//                                                                       self.currentCity = currentCity
//                                                                  }
//                                                                  if let areaOfExpertise = objects["areaOfExpertise"] as? String{
//                                                                      self.areaOfExpertise = areaOfExpertise
//                                                                  }
//                                                                  if let currentCity = objects["currentCity"] as? String{
//                                                                      self.currentCity = currentCity
//                                                                  }
//                                                                  if let areaOfExpertise = objects["areaOfExpertise"] as? String{
//                                                                      self.areaOfExpertise = areaOfExpertise
//                                                                   }
//                                                                  if let birthday = objects[" birthday"] as? String{
//                                                                      self.birthday = birthday
//                                                                  }
//                                                                  if let usergender = objects[" userGender"] as? String{
//                                                                      self.userGender = usergender
//                                                                  }
//                                                                  if let image = objects["image"] as? String{
//                                                                     self.image = image
//                                                                  }else
//                                                                  {
//                                                                      self.image = ""
//                                                                  }
//                                                                  let user = UserModel(email : self.email,
//                                                                                      firstname : self.firstname ,
//                                                                                      lastName : self.lastName,
//                                                                                      fun : self.fun,
//                                                                                      gender : self.gender,
//                                                                                      islive : self.islive,
//                                                                                      key_accomplishment : self.key_accomplishment,
//                                                                                      kindofMember : self.kindofMember,
//                                                                                      name : self.name ,
//                                                                                      occupation : self.occupation,
//                                                                                      password : self.password,
//                                                                                      school : self.school,
//                                                                                      userType :self.userType1,
//                                                                                      no_of_mentee : self.no_of_mentee,
//                                                                                      feild_of_study :self.feild_of_study,
//                                                                                      hobbies : self.hobbies,
//                                                                                      longterm : self.longterm,
//                                                                                      memberdo : self.memberdo,
//                                                                                      objective : self.objective,
//                                                                                      shortterm : self.shortterm,
//                                                                                      image: self.image,
//                                                                                      userId: self.userId,
//                                                                                      currentCity: self.currentCity,
//                                                                                      areaOfExpertise: self.areaOfExpertise,
//                                                                                      latitude: self.latitude,
//                                                                                      longitude: self.longitude,
//                                                                                      birthday: self.birthday,
//                                                                                      userGender: self.userGender)
//
//                                                                          self.userList.append(user)
//                                                          }
//                                                          else{
//                                                              print(#function)
//                                                              var ref: DatabaseReference!
//                                                              ref = Database.database().reference()
//
//                                                              var geoFireRef: DatabaseReference?
//                                                              var geoFire: GeoFire?
//                                                              var myQuery: GFQuery?
//                                                              geoFireRef = ref.child("Geolocs")
//
//                                                              if let geoFireRef = geoFireRef {
//                                                                  geoFire = GeoFire(firebaseRef: geoFireRef)
//                                                                  if let id = Helper.getPREF("userId") {
//
//                                                                      var arrayTemp = [String]()
//                                                                      ref.child("mentorAssignUsers").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
//                                                                          if snapshot.exists(){
//                                                                                if snapshot.childrenCount > 0{
//                                                                                  for child in snapshot.children {
//                                                                                      let snap = child as! DataSnapshot
//                                                                                      let name = snap.key
//                                                                                      arrayTemp.append(name)
//                                                                                      print(name)
//                                                                                  }
//                                                                               }
//                                                                          }
//                                                                      })
//
//                                                                      ref.child("users").child(id).observeSingleEvent(of: .value, with: { (snapshot) in
//
//                                                                          let value = snapshot.value as? NSDictionary
//                                                                          var lat = ""
//                                                                          var long = ""
//                                                                          var funStr = ""
//                                                                          var areaOfExpertisee = ""
//                                                                          var ageInt = 0
//
//                                                                          if let latitude = value?["latitude"] as? String {
//                                                                              lat = latitude
//                                                                          }
//                                                                          if let longitude = value?["longitude"] as? String{
//                                                                              long = longitude
//                                                                          }
//
//                                                                          if let fun = value?["fun"] as? String{
//                                                                              funStr = fun
//                                                                          }
//
//                                                                          if let areaOfExpertise = value?["areaOfExpertise"] as? String{
//                                                                              areaOfExpertisee = areaOfExpertise
//                                                                          }
//
//                                                                          if (lat != "" && lat != "0") && (long != "" && long != "0") {
//                                                                              let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(lat) ?? 0), longitude: CLLocationDegrees(Double(long) ?? 0))
//                                                                              myQuery = geoFire?.query(at: location, withRadius: 100)
//                                                                              myQuery?.observe(.keyEntered, with: { (key, location) in
//                                                                                  if key != Auth.auth().currentUser?.uid
//                                                                                  {
//                                                                                      let ref = ref.child("users").child(key)
//                                                                                      ref.observeSingleEvent(of: .value, with: { (snapshot) in
//
//                                                                                          if snapshot.childrenCount > 0 {
//                                                                                          let value = snapshot.value as! [String: AnyObject]
//                                                                                          if let name = value["name"] as? String {
//                                                                                              print("name: ",name)
//                                                                                          }
//
//                                                                                          if let userType = value["userType"] as? String{
//                                                                                              if userType == "Mentee"{
//                                                                                              let userId = value["userId"] as? String ?? ""
//                                                                                              let hobbies = value["hobbies"] as? String ?? ""
//                                                                                              let feild_of_study = value["feild_of_study"] as? String ?? ""
//                                                                                              let birthDay = value["birthay"] as? String ?? "0"
//                                                                                              let kind_of_member = value [""] as? String ?? "0"
//                                                                                              ageInt = Int(birthDay) ?? 0
//
//                                                                                                  if !arrayTemp.contains(userId) || kindOfMember.caseInsensitiveCompare(kind_of_member) == .orderedSame || filterHobby.contains(hobbies) || ageInt  < age{
//                                                                                                      let userDetail = UserModel(email: (value["email"] as? String) ?? "", firstname: (value["firstName"] as? String) ?? "", lastName: (value["lastName"] as? String) ?? "", fun: (value["fun"] as? String) ?? "", gender: "", islive: (value["islive"] as? String) ?? "", key_accomplishment: (value["key_accomplishment"] as? String) ?? "", kindofMember: (value["kindofMember"] as? String) ?? "", name: (value["name"] as? String) ?? "", occupation: (value["occupation"] as? String) ?? "", password: (value["password"] as? String) ?? "", school: (value["school"] as? String) ?? "", userType: (value["userType"] as? String) ?? "", no_of_mentee: (value["no_of_mentee"] as? String) ?? "", feild_of_study: (value["feild_of_study"] as? String) ?? "", hobbies: (value["hobbies"] as? String) ?? "", longterm: (value["longterm"] as? String) ?? "", memberdo: (value["memberdo"] as? String) ?? "", objective: (value["objective"] as? String) ?? "", shortterm: (value["shortterm"] as? String) ?? "", image: (value["image"] as? String) ?? "", userId: (value["userId"] as? String) ?? "", currentCity: (value["currentCity"] as? String) ?? "", areaOfExpertise: (value["areaOfExpertise"] as? String) ?? "", latitude: (value["latitude"] as? String) ?? "", longitude: (value["longitude"] as? String) ?? "", birthday: (value["birthday"] as? String) ?? "", userGender:(value["userGender"] as? String) ?? "")
//                                                                                                      self.userList.append(userDetail)
//
//                                                                                                  }
//
//                                                                                              }
//                                                                                          }
//                                                                                          }else{
//
//                                                                                          }
//                                                                                      })
//                                                                                  }
//                                                                              })
//                                                                          } else{
//
//                                                                          }
//                                                                      })
//                                                                  } else{
//
//                                                                  }
//                                                              } else{
//
//                                                              }
//                                                          }
//
//                                                      }
//                                                   }
                        }
                       
                }
                }
                if self.userList.count > 0 {
                    self.viewNoData.isHidden = true
                    print(self.userList.count)
                    self.collectionView.isHidden = false
                    self.collectionView.reloadData()
                }else{
                    self.collectionView.isHidden = true
                    self.viewNoData.isHidden = false
                     self.collectionView.reloadData()
                }
               
            }
            
        })
    }
    
    
    
}


