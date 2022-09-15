//
//  Helper.swift
//  Mentea
//
//  Created by Apple on 25/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import SKActivityIndicatorView

class Helper: NSObject {
    
    
    class func getPREF(_ key: String) -> String? {
        return Foundation.UserDefaults.standard.value(forKey: key) as? String
    }
    
    class func setPREF(_ sValue: String, key: String) {
        Foundation.UserDefaults.standard.setValue(sValue, forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }
  
    class func  delPREF(_ key: String) {
        Foundation.UserDefaults.standard.removeObject(forKey: key as String)
        Foundation.UserDefaults.standard.synchronize()
    }

    class func showOKAlert(onVC viewController:UIViewController,title:String,message:String) {
        DispatchQueue.main.async {
            let alert : UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style:.default, handler: nil))
            alert.view.tintColor = UIColor.black
            alert.view.setNeedsLayout()
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
    
    class func showOKCancelAlertWithCompletion(onVC viewController: UIViewController, title: String, message: String, btnOkTitle: String, btnCancelTitle: String, onOk: @escaping ()->()) {
          DispatchQueue.main.async {
              let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
              alert.addAction(UIAlertAction(title: btnOkTitle, style:.default, handler: { (action:UIAlertAction) in
                  onOk()
              }))
              alert.addAction(UIAlertAction(title: btnCancelTitle, style:.default, handler: { (action:UIAlertAction) in
                  
              }))
              alert.view.tintColor = UIColor.black
              alert.view.setNeedsLayout()
              viewController.present(alert, animated: true, completion: nil)
          }
      }
    
    class func showActionAlert(onVC viewController: UIViewController, onTakePhoto:@escaping ()->(), onChooseFromGallery:@escaping ()->()) {
        DispatchQueue.main.async {
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
            
            let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)
            
            let saveActionButton: UIAlertAction = UIAlertAction(title: "Take Photo", style: .default) { action -> Void in
                print("Take Photo")
                
                onTakePhoto()
            }
            actionSheetControllerIOS8.addAction(saveActionButton)
            
            let deleteActionButton: UIAlertAction = UIAlertAction(title: "Choose from library", style: .default) { action -> Void in
                print("Choose from library")
                
                onChooseFromGallery()
            }
            actionSheetControllerIOS8.addAction(deleteActionButton)
            
            if let popoverPresentationController = actionSheetControllerIOS8.popoverPresentationController {
                popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                
                var rect = viewController.view.frame;
                
                rect.origin.x = viewController.view.frame.size.width / 20;
                rect.origin.y = viewController.view.frame.size.height / 20;
                
                popoverPresentationController.sourceView = viewController.view
                popoverPresentationController.sourceRect = rect
            }
            
            actionSheetControllerIOS8.view.tintColor = UIColor.black
            viewController.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
    }
    
    class func showLoader(onVC viewController: UIViewController, message: String) {
        
        SKActivityIndicator.spinnerColor(UIColor.init(hexString: "3B5998") ?? UIColor.blue)
        SKActivityIndicator.statusTextColor(UIColor.init(hexString: "3B5998") ?? UIColor.blue)
        //SKActivityIndicator.statusLabelFont(TNotebookFonts.FONT_PROIMANOVA_SEMIBOLD_12 ?? UIFont.boldSystemFont(ofSize: 12))
        
        SKActivityIndicator.spinnerStyle(.defaultSpinner)
        SKActivityIndicator.show(message, userInteractionStatus: false)
    }
    
    class func hideLoader(onVC viewController: UIViewController) {
        SKActivityIndicator.dismiss()
    }
    
}
