//
//  Global.swift
//  Mentea
//
//  Created by Rv on 13/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//
import Foundation
import UIKit
import CoreLocation
import FirebaseDatabase
import Firebase
import GeoFire
import MapKit
import Alamofire

class WSManager {
   class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}


struct AppConstants {
    static let PORTRAIT_SCREEN_WIDTH  = UIScreen.main.bounds.size.width
    static let PORTRAIT_SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    static let CURRENT_IOS_VERSION    = UIDevice.current.systemVersion
}

var userCurrentLocation : CLLocation?
var globalcurrentCity = ""

func facetime(phoneNumber:String) {
  if let facetimeURL:NSURL = NSURL(string: "facetime://\(phoneNumber)") {
    let application:UIApplication = UIApplication.shared
    
    if (application.canOpenURL(facetimeURL as URL)) {
        application.openURL(facetimeURL as URL);
    }
    
  }
}

func nearbyMentor(completion: @escaping ([UserModel]) -> Void) {
    print(#function)
    var ref: DatabaseReference!
    ref = Database.database().reference()
    
    
    
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    var myQuery: GFQuery?
    geoFireRef = ref.child("Geolocs")
    var userList: [UserModel] = []
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
                userList = []
                let value = snapshot.value as? NSDictionary
                print(value)
                var lat = ""
                var long = ""
                var hobby = ""
                var feildOfStudy = ""
                if let latitude = value?["latitude"] as? String {
                    lat = latitude
                }
                if let longitude = value?["longitude"] as? String{
                    long = longitude
                }
                if let hobbies = value?["hobbies"] as? String{
                    hobby = hobbies
                }
                if let feild_of_study = value?["feild_of_study"] as? String{
                    feildOfStudy = feild_of_study
                }
                
                if (lat != "" && lat != "0") && (long != "" && long != "0") {
                    let location:CLLocation = CLLocation(latitude: CLLocationDegrees(Double(lat) ?? 0), longitude: CLLocationDegrees(Double(long) ?? 0))
                    myQuery = geoFire?.query(at: location, withRadius: 100)
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
                                        
                                        if !arrayTemp.contains(userId) || fun.caseInsensitiveCompare(hobby) == .orderedSame || feildOfStudy.caseInsensitiveCompare(areaOfExpertise) == .orderedSame{
                                            let userDetail = UserModel(email: (value["email"] as? String) ?? "", firstname: (value["firstName"] as? String) ?? "", lastName: (value["lastName"] as? String) ?? "", fun: (value["fun"] as? String) ?? "", gender: "", islive: (value["islive"] as? String) ?? "", key_accomplishment: (value["key_accomplishment"] as? String) ?? "", kindofMember: (value["kindofMember"] as? String) ?? "", name: (value["name"] as? String) ?? "", occupation: (value["occupation"] as? String) ?? "", password: (value["password"] as? String) ?? "", school: (value["school"] as? String) ?? "", userType: (value["userType"] as? String) ?? "", no_of_mentee: (value["no_of_mentee"] as? String) ?? "", feild_of_study: (value["feild_of_study"] as? String) ?? "", hobbies: (value["hobbies"] as? String) ?? "", longterm: (value["longterm"] as? String) ?? "", memberdo: (value["memberdo"] as? String) ?? "", objective: (value["objective"] as? String) ?? "", shortterm: (value["shortterm"] as? String) ?? "", image: (value["image"] as? String) ?? "", userId: (value["userId"] as? String) ?? "", currentCity: (value["currentCity"] as? String) ?? "", areaOfExpertise: (value["areaOfExpertise"] as? String) ?? "", latitude: (value["latitude"] as? String) ?? "", longitude: (value["longitude"] as? String) ?? "",  birthday: (value["birthday"] as? String) ?? "", userGender: (value["userGender"] as? String ?? ""))
                                            userList.append(userDetail)
                                            completion(userList)
                                        }
                                        
                                    }
                                    
                                }
                                }else{
                                     completion([])
                                }
                            })
                        }
                    })
                } else{
                    completion([])
                }
            })
        } else{
            completion([])
        }
    } else{
        completion([])
    }
}

func nearbyMantee(completion: @escaping ([UserModel]) -> Void) {
    print(#function)
    var ref: DatabaseReference!
    ref = Database.database().reference()
    
    var geoFireRef: DatabaseReference?
    var geoFire: GeoFire?
    var myQuery: GFQuery?
    geoFireRef = ref.child("Geolocs")
    var userList: [UserModel] = []
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
                userList = []
                let value = snapshot.value as? NSDictionary
                var lat = ""
                var long = ""
                var funStr = ""
                var areaOfExpertisee = ""
                
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
                                        
                                        if !arrayTemp.contains(userId) || funStr.caseInsensitiveCompare(hobbies) == .orderedSame || areaOfExpertisee.caseInsensitiveCompare(feild_of_study) == .orderedSame {
                                            let userDetail = UserModel(email: (value["email"] as? String) ?? "", firstname: (value["firstName"] as? String) ?? "", lastName: (value["lastName"] as? String) ?? "", fun: (value["fun"] as? String) ?? "", gender: "", islive: (value["islive"] as? String) ?? "", key_accomplishment: (value["key_accomplishment"] as? String) ?? "", kindofMember: (value["kindofMember"] as? String) ?? "", name: (value["name"] as? String) ?? "", occupation: (value["occupation"] as? String) ?? "", password: (value["password"] as? String) ?? "", school: (value["school"] as? String) ?? "", userType: (value["userType"] as? String) ?? "", no_of_mentee: (value["no_of_mentee"] as? String) ?? "", feild_of_study: (value["feild_of_study"] as? String) ?? "", hobbies: (value["hobbies"] as? String) ?? "", longterm: (value["longterm"] as? String) ?? "", memberdo: (value["memberdo"] as? String) ?? "", objective: (value["objective"] as? String) ?? "", shortterm: (value["shortterm"] as? String) ?? "", image: (value["image"] as? String) ?? "", userId: (value["userId"] as? String) ?? "", currentCity: (value["currentCity"] as? String) ?? "", areaOfExpertise: (value["areaOfExpertise"] as? String) ?? "", latitude: (value["latitude"] as? String) ?? "", longitude: (value["longitude"] as? String) ?? "",  birthday: (value["birthday"] as? String) ?? "", userGender: (value["userGender"] as? String ?? ""))
                                            userList.append(userDetail)
                                            completion(userList)
                                        }
                                        
                                    }
                                }
                                }else{
                                    completion([])
                                }
                            })
                        }
                    })
                } else{
                    completion([])
                }
            })
        } else{
            completion([])
        }
    } else{
        completion([])
    }
}

struct LinkedInConstants {
    static let CLIENT_ID = "86vkbgyh6kil92"
    static let CLIENT_SECRET = "U0SQX0UomL1rSgFX"
    static let REDIRECT_URI = "https://aweentechnologies.com/"
    static let SCOPE = "r_liteprofile%20r_emailaddress" //Get lite profile info and e-mail address
    
    static let AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
    static let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"
}

struct LinkedInEmailModel: Codable {
    let elements: [Element]
}

// MARK: - Element
struct Element: Codable {
    let elementHandle: Handle
    let handle: String

    enum CodingKeys: String, CodingKey {
        case elementHandle = "handle~"
        case handle
    }
}

// MARK: - Handle
struct Handle: Codable {
    let emailAddress: String
}

struct LinkedInProfileModel: Codable {
    let firstName, lastName: StName
    let profilePicture: ProfilePicture
    let id: String
}

// MARK: - StName
struct StName: Codable {
    let localized: Localized
}

// MARK: - Localized
struct Localized: Codable {
    let enUS: String

    enum CodingKeys: String, CodingKey {
        case enUS = "en_US"
    }
}

// MARK: - ProfilePicture
struct ProfilePicture: Codable {
    let displayImage: DisplayImage

    enum CodingKeys: String, CodingKey {
        case displayImage = "displayImage~"
    }
}

// MARK: - DisplayImage
struct DisplayImage: Codable {
    let elements: [ProfilePicElement]
}

// MARK: - Element
struct ProfilePicElement: Codable {
    let identifiers: [ProfilePicIdentifier]
}

// MARK: - Identifier
struct ProfilePicIdentifier: Codable {
    let identifier: String
}
extension String {
    func firstCharacterUpperCase() -> String? {
        guard !isEmpty else { return "" }
        let lowerCasedString = self.lowercased()
        return lowerCasedString.replacingCharacters(in: lowerCasedString.startIndex...lowerCasedString.startIndex, with: String(lowerCasedString[lowerCasedString.startIndex]).uppercased())
    }
}
extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
}

extension UITabBarController {
    func setTabBarVisible(visible:Bool, duration: TimeInterval, animated:Bool) {
        if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)

        // animation
        UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.tabBar.frame.offsetBy(dx:0, dy:offsetY)
            self.view.frame = CGRect(x:0,y:0,width: self.view.frame.width, height: self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }.startAnimation()
    }

    func tabBarIsVisible() ->Bool {
        return self.tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}
extension UIImageView {
    func roundedImage() {
        self.layer.cornerRadius = (self.frame.size.width) / 2;
        self.clipsToBounds = true
        self.layer.borderWidth = 0
        self.layer.borderColor = UIColor.white.cgColor
    }
}

