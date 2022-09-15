//
//  MenuViewController.swift
//  Mentea
//
//  Created by Apple on 15/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MenuViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
     var ref: DatabaseReference!
    
    
     var items = ["Home", "Messages", "Blog", "My Blog", "Profile", "About Us", "Logout"]
     var itemImages = [UIImage.init(named: "home"),UIImage.init(named: "chat_neww"),UIImage.init(named: "myblog"),UIImage.init(named: "group"),UIImage.init(named: "profile_new"), UIImage.init(named: "help"),UIImage.init(named: "logout_new1")]
    
    var userType : String = ""
    var userName : String?
    var userImageUrl : String?
    var userLocation : String?
    var userImage : UIImage?
    var email = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userType = Helper.getPREF("userType") ?? ""
        ref = Database.database().reference()
        tableView.tableHeaderView = headerView()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           DispatchQueue.main.async {
            self.showData()
               self.tableView.reloadData()
           }
       }
       
       override func viewDidDisappear(_ animated: Bool) {
           super.viewDidDisappear(animated)
           DispatchQueue.main.async {
               self.tableView.reloadData()
           }
       }
    
    
    func showData(){
        
               if let id = Helper.getPREF("userId") {
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
                           self.userImageUrl = image
                       }
                    if let email = value?["email"] as? String{
                        self.email = email
                    }
                    
                    self.tableView.tableHeaderView = self.headerView()
                       
                   }) { (error) in
                       print(error.localizedDescription)
                   }
               }
    }
    
    
       func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return items.count
        }
        
        
    //    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return 20//items.count
    //    }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as! MenuTableViewCell
            
            
            cell.lblText.text = NSLocalizedString(self.items[indexPath.row], comment: "")
            
            cell.imgLogo.image = itemImages[indexPath.row]
            
            //cell.textLabel?.text = NSLocalizedString(self.items[indexPath.row], comment: "")
            
            
            
            //cell.imageView?.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            //cell.imageView?.image = itemImages[indexPath.row]
                    
            
            
            //let bgView = UIView()
            //bgView.backgroundColor = UIColor.clear
            //cell.selectedBackgroundView = bgView
            
            
            
            return cell
        }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           if let cell = tableView.cellForRow(at: indexPath) {
               let bgView = UIView()
            bgView.backgroundColor = .darkGray
               cell.selectedBackgroundView = bgView
           }
             let navigationController = revealViewController().frontViewController as! UINavigationController

           switch indexPath.row {

            case 0:
                    
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                var home = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                     navigationController.pushViewController(home, animated: false)
                revealViewController().pushFrontViewController(navigationController, animated: true)
            
            case 1:
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                var home = storyboard.instantiateViewController(withIdentifier: "ChatListViewController") as! ChatListViewController
                      navigationController.pushViewController(home, animated: false)
                revealViewController().pushFrontViewController(navigationController, animated: true)
            
            case 2:
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                var home = storyboard.instantiateViewController(withIdentifier: "BlogViewController") as! BlogViewController
                        navigationController.pushViewController(home, animated: false)
                revealViewController().pushFrontViewController(navigationController, animated: true)
            
            case 3:
                           let storyboard = UIStoryboard(name: "Main", bundle: nil)
                           var home = storyboard.instantiateViewController(withIdentifier: "MyBlogsVC") as! MyBlogsVC
                                   navigationController.pushViewController(home, animated: false)
                           revealViewController().pushFrontViewController(navigationController, animated: true)
            //
           case 4:
            
            if self.userType == "Mentee"{
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                               var profile = storyboard.instantiateViewController(withIdentifier: "MenteeProfileVC2ViewController") as! MenteeProfileVC2ViewController
                                   navigationController.pushViewController(profile, animated: false)
                               revealViewController().pushFrontViewController(navigationController, animated: true)
                
            } else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                               var profile = storyboard.instantiateViewController(withIdentifier: "ProfileNewViewController") as! ProfileNewViewController
                                   navigationController.pushViewController(profile, animated: false)
                               revealViewController().pushFrontViewController(navigationController, animated: true)
            }
               
           case 5:
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                var about = storyboard.instantiateViewController(withIdentifier: "AboutViewController") as! AboutViewController
                navigationController.pushViewController(about, animated: false)
                revealViewController().pushFrontViewController(navigationController, animated: true)
            
           case 6:
            Helper.showOKCancelAlertWithCompletion(onVC: self, title: "Logout", message: "Are you sure you want to logout?", btnOkTitle: "Logout", btnCancelTitle: "Cancel") {
                Helper.delPREF("userId")
                Helper.setPREF("", key: "isTutoClick")
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                 DispatchQueue.main.async {
                    if let login = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
                        //self.navigationController?.pushViewController(login, animated: true)
                        self.present(login, animated:true, completion:nil)
                    }
                }
            }
           
            

           default:
                break
        }
    }
    
    
    func headerView() -> UIView? {
           let headerCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! HeaderCell
        
        headerCell.lblName.text = self.userName
        headerCell.lblEmail.text = self.email
        headerCell.lblUserType.text = self.userType
        
        if self.userImageUrl != nil ||  self.userImageUrl?.isEmpty == false{
            if let url = URL(string: self.userImageUrl ?? "") {
                var img = UIImageView(frame: CGRect.zero)
                img.sd_setImage(with: url) { (image, error, type, url) in
                    self.userImage = image
                }
                
               headerCell.imgUser.sd_setImage(with: url) { (image, error, type, url) in
                    self.userImage = image
                }
                
            }
        }else{
            headerCell.imgUser.image = UIImage.init(named: "circle_dp")
        }
        
           //headerCell.lblMemberSince.text = memberSince
//           headerCell.lblEmail.text = email
//           headerCell.lblName.text = userName.uppercased()
//           //headerCell.imgProfile
//
//           if image.isEmpty == false{
//                                  let block: SDExternalCompletionBlock? = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) -> Void in
//                                      //print(image)
//                                      if (image == nil) {
//                                          headerCell.imgProfile.image = #imageLiteral(resourceName: "ic_avatar")
//                                      }
//                                  }
//                                  var urlString = ""
//               if self.image.contains(Strings.TNOTEBOOKAPP) {
//                                   urlString = "\(WebService.imageUrl)\(self.image)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//                                  } else {
//                                   urlString = "\(WebService.newImageUrl)\(self.image)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//                                  }
//                                  let url = URL(string: urlString as String)
//                                  headerCell.imgProfile.sd_setImage(with: url, completed: block)
//                              } else{
//               headerCell.imgProfile.image = #imageLiteral(resourceName: "ic_avatar")
//                              }
                              
           
           return headerCell.contentView
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
