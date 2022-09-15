//
//  LoginTypeView.swift
//  Mentea
//
//  Created by Rv on 13/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class LoginTypeView: UIViewController {

    typealias CompletionBlock = (_ isMentor: Bool) -> Void
       var onCompletion:CompletionBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func handleMantor(_ sender: Any) {
        if let isCompletion = self.onCompletion {
            isCompletion(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func handleMentee(_ sender: Any) {
        if let isCompletion = self.onCompletion {
            isCompletion(false)
            self.dismiss(animated: true, completion: nil)
        }
    }
 
}
