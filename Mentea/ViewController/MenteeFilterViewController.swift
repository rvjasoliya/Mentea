//
//  MenteeFilterViewController.swift
//  Mentea
//
//  Created by apple on 27/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import DropDown
import TTRangeSlider

class MenteeFilterViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TTRangeSliderDelegate   {

    @IBOutlet weak var btnHobbies: UIButton!
    
    @IBOutlet weak var btnConsiderate: UIButton!
    
    @IBOutlet weak var btnWise: UIButton!
    
    @IBOutlet weak var btnFunny: UIButton!
    
    @IBOutlet weak var btnBold: UIButton!
    
    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBOutlet weak var lblDistance: UILabel!
    
    @IBOutlet weak var ageSlider: UISlider!
    
    @IBOutlet weak var lblAge: UILabel!
    
    @IBOutlet weak var hobbiesCollectionView: UICollectionView!
   
    @IBOutlet weak var txtSearcKeyboard: UITextField!
    
    @IBOutlet weak var HobbiesButton: UIButton!
    
    @IBOutlet weak var rengeSlider: TTRangeSlider!
    
    var currentValue = 0
    
    var distance = 0

    var kindofMember = ""
     
    var keyword = ""

    var isMale = false

    var isFemale = false

    var isOther = false

    var genderList = [String]()

    let dropDown = DropDown()

    var hobbies = [String]()
    var userType = ""
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.rengeSlider.delegate = self

             dropDownHobbies()

             hobbiesCollectionView.delegate = self

             hobbiesCollectionView.dataSource = self
        
        self.txtSearcKeyboard.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
              NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidShow(notification:)),
                           name: UIResponder.keyboardDidShowNotification, object: nil)
          }
          
          override func viewWillDisappear(_ animated: Bool) {
              NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidShow(notification:)),
                           name: UIResponder.keyboardDidHideNotification, object: nil)
          }
    
    
    @IBAction func RengeSlider(_ sender: TTRangeSlider) {
        
//        currentValue = Int(sender.value)
//
//        lblAge.text = "\(currentValue)"
//
//        print("\(currentValue)")`
        
    }

          //MARK: Methods to manage keybaord
          @objc func keyboardDidShow(notification: NSNotification) {
              var info = notification.userInfo
              let keyBoardSize = info![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
              scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
              scrollView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyBoardSize.height, right: 0.0)
          }

          @objc func keyboardDidHide(notification: NSNotification) {

              scrollView.contentInset = UIEdgeInsets.zero
              scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
          }
    
    
    @IBAction func Hobbiesbutton(_ sender: Any) {
        self.dropDown.show()
    }
    
    @IBAction func handleConsiderateBtn(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "circle-1"){
            
            sender.setImage(UIImage(named: "radio-on-button"), for: .normal)
            
            btnBold.setImage(UIImage.init(named: "circle-1"), for: .normal)
            
            btnFunny.setImage(UIImage.init(named: "circle-1"), for: .normal)
            
            btnWise.setImage(UIImage.init(named: "circle-1"), for: .normal)
            
            kindofMember = btnConsiderate.titleLabel?.text ?? ""
            
        }
        else{
            sender.setImage(UIImage(named: "circle-1"), for: .normal)
        }
    }
    
    @IBAction func handleBackBtn(_ sender: Any) {
    
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signup = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.dismiss(animated: true, completion: nil)
        
    
    }
    
    
    @IBAction func handleHobbiesBtn(_ sender: UIButton) {
         self.dropDown.show()
    }
    
    @IBAction func handleBtnApply(_ sender: UIButton) {
        
        print(rengeSlider.maxValue)
        
        keyword = self.txtSearcKeyboard.text ?? ""
        
        homeViewDelegate?.getDataForFilter(hobby:"",hobby2: "",hobby3: "", kindOfMember:self.kindofMember, gender:self.genderList, age:currentValue,age2:0,distance :self.distance, keyword: self.keyword )
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func handleBtnClear(_ sender: UIButton) {
       let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signup = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.dismiss(animated: true, completion: nil)
    }
    

     func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbiesCollectionViewCell", for: indexPath) as! HobbiesCollectionViewCell

         cell.lblHobby.text = self.hobbies[indexPath.row]
        cell.imgCross.tag = indexPath.row
        cell.imgCross.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onClick))
        cell.imgCross.addGestureRecognizer(tap)

         print(indexPath.row)
         return cell
     }
    
    @objc func onClick(sender : UITapGestureRecognizer)
    {
        let imgVieww = sender.view as! UIImageView
        var position = imgVieww.tag
        print(position)
        hobbies.remove(at: position)
        hobbiesCollectionView.reloadData()
    }

     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
         return hobbies.count
     }


     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

                //return CGSize(width: 110, height: 110)

                return CGSize(width: collectionView.bounds.size.width / 3-10, height: collectionView.bounds.size.width / 3)

            }


     func dropDownHobbies()

     {

         // The view to which the drop down will appear on

         dropDown.anchorView = HobbiesButton // UIView or UIBarButtonItem
         
         // The list of items to display. Can be changed dynamically

         dropDown.dataSource = ["Adventure", "Blogging", "Cooking", "Dancing", "Fitness", "Painting", "Photography", "Singing", "Sports", "Study", "Singing", "Yoga"]

         DropDown.appearance().textColor = UIColor.black

         DropDown.appearance().selectedTextColor = UIColor.black

         DropDown.appearance().textFont = UIFont.systemFont(ofSize: 17)

         DropDown.appearance().backgroundColor = UIColor.init(hexString: "#0279de")

         DropDown.appearance().selectionBackgroundColor = UIColor.white

         DropDown.appearance().cellHeight = 40

         // Action triggered on selection

         dropDown.selectionAction = { [unowned self] (index: Int, item: String) in

           print("Selected item: \(item) at index: \(index)")

            if !self.hobbies.contains(item)
            {
                 self.hobbies.append(item)
            }
            

             self.hobbiesCollectionView.reloadData()

             print(self.hobbies)

         }

     }

     

     @IBAction func handleWiseBtn(_ sender: UIButton) {
         if sender.currentImage == UIImage(named: "circle-1"){
             sender.setImage(UIImage(named: "radio-on-button"), for: .normal)

             btnBold.setImage(UIImage.init(named: "circle-1"), for: .normal)

             btnConsiderate.setImage(UIImage.init(named: "circle-1"), for: .normal)

             btnFunny.setImage(UIImage.init(named: "circle-1"), for: .normal)

             kindofMember = btnWise.titleLabel?.text ?? ""
         }else{
             sender.setImage(UIImage(named: "circle-1"), for: .normal)
         }
     }

    @IBAction func handleFunnyBtn(_ sender: UIButton) {

         if sender.currentImage == UIImage(named: "circle-1"){

             sender.setImage(UIImage(named: "radio-on-button"), for: .normal)

             btnBold.setImage(UIImage.init(named: "circle-1"), for: .normal)

             btnConsiderate.setImage(UIImage.init(named: "circle-1"), for: .normal)

             btnWise.setImage(UIImage.init(named: "circle-1"), for: .normal)

             kindofMember = btnFunny.titleLabel?.text ?? ""

         }

         else{

                 sender.setImage(UIImage(named: "circle-1"), for: .normal)

             }

     }

     

     @IBAction func handleBoldBtn(_ sender: UIButton) {
        
        if sender.currentImage == UIImage(named: "circle-1"){

                sender.setImage(UIImage(named: "radio-on-button"), for: .normal)

                btnConsiderate.setImage(UIImage.init(named: "circle-1"), for: .normal)

                btnFunny.setImage(UIImage.init(named: "circle-1"), for: .normal)

                btnWise.setImage(UIImage.init(named: "circle-1"), for: .normal)

                kindofMember = btnBold.titleLabel?.text ?? ""

            }

            else{

                  sender.setImage(UIImage(named: "circle-1"), for: .normal)

               }
       
     }

     

     @IBAction func handleDistanceSlider(_ sender: UISlider) {

         self.distance = Int(sender.value)

         lblDistance.text = "\(distance)"

     }

     

    
    @IBAction func rangeSlider(_ sender: Any) {
       
      
    }
    
     @IBAction func handleAgeSlider(_ sender: UISlider) {

         currentValue = Int(sender.value)

         lblAge.text = "\(currentValue)"

     }

    


    
}
extension MenteeFilterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}
