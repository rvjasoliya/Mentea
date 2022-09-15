import UIKit

import DropDown
import TTRangeSlider
import ZMSwiftRangeSlider



class FilterViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    @IBOutlet weak var btnMale: UIButton!

    @IBOutlet weak var btnFemale: UIButton!

    @IBOutlet weak var btnOther: UIButton!

    @IBOutlet weak var btnConsiderate: UIButton!

    @IBOutlet weak var btnWise: UIButton!

    @IBOutlet weak var btnFunny: UIButton!

    @IBOutlet weak var btnBold: UIButton!

    @IBOutlet weak var imgMale: UIImageView!

    @IBOutlet weak var imgFemale: UIImageView!

    @IBOutlet weak var imgOther: UIImageView!

    @IBOutlet weak var btnHobbies: UIButton!

    @IBOutlet weak var distanceSlider: UISlider!

    @IBOutlet weak var lblDistance: UILabel!

    @IBOutlet weak var ageSlider: UISlider!

    @IBOutlet weak var lblAge: UILabel!

    @IBOutlet weak var hobbiesCollectionView: UICollectionView!
    
    @IBOutlet weak var HobbiesButton: UIButton!
    
    @IBOutlet weak var txtSearchKeyboard: UITextField!
    
    @IBOutlet weak var secongAgeSlider: UISlider!
    @IBOutlet weak var newrangeSlider: RangeSlider!
    
    @IBOutlet weak var secondAgeLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rangeslider: TTRangeSlider!
    
    
    var currentValue = 0
    var currentValue2 = 0
    
    var distance = 0

    var keyword = ""

    var gender = ""

    var kindofMember = ""

    var isMale = false

    var isFemale = false

    var isOther = false

    var genderList = [String]()

    let dropDown = DropDown()

    var hobbies = [String]()
    var userType = ""
    var fromWhere = ""

    
    var maximumValue = 0
    var minimumValue = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        newrangeSlider.setValueChangedCallback { (minValue, maxValue) in
            self.currentValue = maxValue
            self.currentValue2 = minValue
                   print("rangeSlider1 min value:\(minValue)")
                   print("rangeSlider1 max value:\(maxValue)")
               }
               newrangeSlider.setMinValueDisplayTextGetter { (minValue) -> String? in
                   return "\(minValue)"
               }
               newrangeSlider.setMaxValueDisplayTextGetter { (maxValue) -> String? in
                   return "\(maxValue)"
               }
               newrangeSlider.setMinAndMaxRange(0, maxRange: 100)
        
        
        
        dropDownHobbies()

        hobbiesCollectionView.delegate = self

        hobbiesCollectionView.dataSource = self
        
        self.txtSearchKeyboard.delegate = self
        
        
        
      secongAgeSlider.semanticContentAttribute = .forceRightToLeft

        
        print("fromWhere \(fromWhere)")
        
        
       
       
        
//        if currentValue2 < currentValue {
//             secondAgeLbl.text = "\(currentValue2)"
//             secondAgeLbl.text = "\(currentValue)"
//        }

    
    }
    
    override func viewWillAppear(_ animated: Bool) {
              NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidShow(notification:)),
                           name: UIResponder.keyboardDidShowNotification, object: nil)
          }
          
          override func viewWillDisappear(_ animated: Bool) {
              NotificationCenter.default.addObserver(self,selector: #selector(self.keyboardDidShow(notification:)),
                           name: UIResponder.keyboardDidHideNotification, object: nil)
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

    @IBAction func hobbiesButton(_ sender: Any) {
        self.dropDown.show()
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
    
    
//    func rangeSlider(_ sender: TTRangeSlider!, didChangeSelectedMinimumValue selectedMinimum: Float, andMaximumValue selectedMaximum: Float) {
//        print("hlo remo sir")
//        maximumValue = Int(selectedMaximum)
//        minimumValue =  Int(selectedMinimum)
//
//    }



    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return hobbies.count

    }

    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

               //return CGSize(width: 110, height: 110)

               return CGSize(width: collectionView.bounds.size.width / 3-10, height: collectionView.bounds.size.width / 3)

           }

    

    @IBAction func handleMaleBtn(_ sender: Any) {

           if isMale

           {

                self.imgMale.isHidden = true

                isMale = false

               

             }

           else{

                 isMale = true
                 self.imgMale.isHidden = false
                 gender = "Male"

             }

    }


    @IBAction func handleBackBtn(_ sender: Any) {
                     
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signup = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.dismiss(animated: true, completion: nil)
    }
    


    @IBAction func handleFemaleBtn(_ sender: Any) {

         if isFemale

         {

            self.imgFemale.isHidden = true
            isFemale = false


        }

         else{

             self.imgFemale.isHidden = false

             isFemale = true
             gender = "Female"

        }

    }



    @IBAction func handleOtherBtn(_ sender: Any) {

        if isOther

        {

            self.imgOther.isHidden = true

            isOther = false

           

        }

        else{

            self.imgOther.isHidden = false

            isOther = true
             gender = "Other"

        }

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
            
            if self.hobbies.count < 3 {
                if !self.hobbies.contains(item)
                {
                    self.hobbies.append(item)
                    
                }
                  self.hobbiesCollectionView.reloadData()

                
            }

//            if !self.hobbies.contains(item)
//            {
//                self.hobbies.append(item)
//
//            }
//            self.hobbiesCollectionView.reloadData()

            print(self.hobbies)

        }

    }


    @IBAction func handleHobbiesBtn(_ sender: Any) {

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

    

    @IBAction func secondAgeSlider(_ sender: UISlider) {
//        currentValue2 = 80 - Int(sender.value)
//
//        if currentValue == currentValue2{
//                    secongAgeSlider.isContinuous = false
//               }else{
//                    secongAgeSlider.isContinuous = true
//               }
//
//
//        if currentValue2 >= 17{
//           secondAgeLbl.text = "\(currentValue2)"
//        }

    }
    

    @IBAction func handleAgeSlider(_ sender: UISlider) {

//        currentValue = Int(sender.value)

//        lblAge.text = "\(currentValue)"

    }

    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

       // Here write down you logic to dismiss controller

        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func handleDoneBtn(_ sender: Any) {
        keyword = self.txtSearchKeyboard.text ?? ""
        
        if isMale{
            
            genderList.append("Male")
            
        }
        
        if isFemale{
            
            genderList.append("Female")
            
        }
        
        if isOther {
            
            genderList.append("Other")
            
        }
        
        var fun1 = ""
        var fun2 = ""
        var fun3 = ""
        
        if self.hobbies.count == 1 {
            fun1 = self.hobbies[0]
        }
        else if self.hobbies.count == 2 {
            fun1 = self.hobbies[0]
            fun2 = self.hobbies[1]
        }
        else if self.hobbies.count == 3 {
            fun1 = self.hobbies[0]
            fun2 = self.hobbies[1]
            fun3 = self.hobbies[2]
        }
        
        if fromWhere == "Mentor"{
            homeViewDelegate?.getDataForFilter(hobby:fun1,hobby2:fun2,hobby3:fun3, kindOfMember:self.kindofMember, gender:self.genderList, age:currentValue, age2: currentValue2,distance :self.distance, keyword : self.keyword )
            self.dismiss(animated: true, completion: nil)
        }else{
            
            homeViewDelegate?.getDataForFilter(hobby:fun1,hobby2:fun2,hobby3:fun3, kindOfMember:self.kindofMember, gender:self.genderList, age:currentValue,age2: currentValue2, distance :self.distance, keyword: self.keyword )
            self.dismiss(animated: true, completion: nil)
        }

    }

    @IBAction func handleClearBtn(_ sender: Any) {
        
       
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let signup = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        homeViewDelegate?.onClear()
        self.dismiss(animated: true, completion: nil)
    }

    

}
extension FilterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
}

