//
//  TutorialCollectionViewController.swift
//  Mentea
//
//  Created by apple on 17/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit



class TutorialCollectionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var btnNext: UIButton!
    
    @IBOutlet weak var btnSkip: UIButton!
    
    
    var image = [UIImage.init(named: "t1"),UIImage.init(named: "t2")]
    var headerText = ["FIND","CONNECT"]
    var belowText = ["Who is nearbay same as like you?","Interact with them & know how helpful ot good ther are?"]
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.view.addSubview(self.collectionView)
        //let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //layout.scrollDirection = .horizontal
        //collectionView.collectionViewLayout = layout
        
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func handleSkip(_ sender: Any) {
       
    let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
    let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
    let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
     if nextItem.row < self.image.count {
          let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                       if let login = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
                           //self.navigationController?.pushViewController(login, animated: true)
                           self.present(login, animated:true, completion:nil)
                       }
                 
             }else{
                 btnSkip.isHidden = true
                   
             }
             
        
    }
    
//    @IBAction func handlePrev(_ sender: Any) {
//
//           let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
//           let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
//           let nextItem: IndexPath = IndexPath(item: currentItem.item - 1, section: 0)
//           if nextItem.row < arrTutorials.count && nextItem.row >= 0{
//               self.collectionView.scrollToItem(at: nextItem, at: .right, animated: true)
//               btnNext.isHidden = false
//           }else{
//               btnPrev.isHidden = true
//           }
//
//       }
       
       
//       @IBAction func handleNext(_ sender: Any) {
//
//           let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
//           let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
//           let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
//           if nextItem.row < arrTutorials.count {
//               btnPrev.isHidden = false
//               self.collectionView.scrollToItem(at: nextItem, at: .left, animated: true)
//
//           }else{
//                btnNext.isHidden = true
//           }
//
//       }
//
    
    
    @IBAction func handleNext(_ sender: Any) {
        
        let visibleItems: NSArray = self.collectionView.indexPathsForVisibleItems as NSArray
        let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
        let nextItem: IndexPath = IndexPath(item: currentItem.item + 1, section: 0)
        print(nextItem.row)
        
        if nextItem.row < self.image.count {
           
            btnNext.setTitle("Next", for: .normal)
             self.pageControl.currentPage = nextItem.row
            self.collectionView.scrollToItem(at: nextItem, at: .left, animated: true)
            if(nextItem.row == self.image.count-1){
                 btnNext.setTitle("Let's Start", for: .normal)
                btnSkip.isHidden = true
            }
            else{
                btnNext.setTitle("Next", for: .normal)
                btnSkip.isHidden = false
            }
            
        }else{
            btnNext.setTitle("Let's Start", for: .normal)
              let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    if let login = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController{
                        //self.navigationController?.pushViewController(login, animated: true)
                        self.present(login, animated:true, completion:nil)
                    }
        }
        
       
    }
    
    
    
       func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return image.count
          }

          func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialCollectionViewCell", for: indexPath) as! TutorialCollectionViewCell
            
            cell.imgImage.image = image[indexPath.row]
            cell.lblTop.isHidden = true
            cell.lblText.isHidden = true
            cell.lblTop.text = headerText[indexPath.row]
            cell.lblText.text = belowText[indexPath.row]
      
           
            return cell
          }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let collectionWidth = self.collectionView.bounds.width
//        let collectionHeight:CGFloat = self.collectionView.bounds.height
//        return CGSize(width: collectionWidth, height: collectionHeight)
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let x = scrollView.contentOffset.x
        let w = scrollView.bounds.size.width
        let currentPage = Int(ceil(x/w))
        print(currentPage)
        self.pageControl.currentPage = currentPage
        
        if currentPage == 0{
            btnNext.setTitle("Next", for: .normal)
            btnSkip.isHidden = false
            
        }
        else
        {
            btnNext.setTitle("Let's Start", for: .normal)
            btnSkip.isHidden = true
        }
        
       
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

  

}
