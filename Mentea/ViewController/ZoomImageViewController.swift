//
//  ZoomImageViewController.swift
//  T-Notebook
//
//  Created by Apple on 15/10/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import UIKit
import SDWebImage

class ZoomImageViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
   
    var arrImages = [String]()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setLeftBarButton()
        setRightBarButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: IndexPath.init(item: self.selectedIndex, section: 0), at: .right, animated: false)
        }
    }
    
    func setLeftBarButton() {
        let leftBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_back"), style: .plain, target: self, action: #selector(backClicked(_:)))
        leftBarButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func setRightBarButton() {
        let rightBarButton = UIBarButtonItem.init(image: #imageLiteral(resourceName: "ic_download"), style: .plain, target: self, action: #selector(downloadImage(_:)))
        rightBarButton.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func downloadImage(_ sender: UIButton) {
        if let indexPaths = self.collectionView.indexPathsForVisibleItems as [IndexPath]? {
            if let cell = self.collectionView.cellForItem(at: indexPaths[0]) as? ZoomImageCollectionViewCell {
                UIImageWriteToSavedPhotosAlbum(cell.imgAssessment.image ?? UIImage(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            Helper.showOKAlert(onVC: self, title: "Alert", message: error.localizedDescription)
        } else {
            Helper.showOKAlert(onVC: self, title: "Alert", message: "Successfully downloaded")
        }
    }
}

// MARK: - UICOLLECTIONVIEW METHODS
extension ZoomImageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZoomImageCollectionViewCell", for: indexPath) as! ZoomImageCollectionViewCell
        
        cell.scrollView.minimumZoomScale = 1.0
        cell.scrollView.maximumZoomScale = 6.0
        cell.scrollView.delegate = self
        
        if let image = self.arrImages[indexPath.row] as String? {
            let block: SDExternalCompletionBlock? = {(image: UIImage?, error: Error?, cacheType: SDImageCacheType, imageURL: URL?) -> Void in
                //print(image)
                if (image == nil) {
                    cell.imgAssessment.image = #imageLiteral(resourceName: "img_add_photo")
                }
            }
            
            let url = URL(string: image)
            cell.imgAssessment.sd_setImage(with: url, completed: block)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: AppConstants.PORTRAIT_SCREEN_WIDTH, height: AppConstants.PORTRAIT_SCREEN_HEIGHT)
    }
}

// MARK: - UISCROLLVIEW DELEGATE
extension ZoomImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        if let indexPaths = self.collectionView.indexPathsForVisibleItems as [IndexPath]? {
            if let cell = self.collectionView.cellForItem(at: indexPaths[0]) as? ZoomImageCollectionViewCell {
                return cell.imgAssessment
            } else {
                return UIView()
            }
        } else {
            return UIView()
        }
    }
}
