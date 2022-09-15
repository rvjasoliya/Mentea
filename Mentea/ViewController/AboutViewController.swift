//
//  AboutViewController.swift
//  Mentea
//
//  Created by Apple on 16/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "About"
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        // Do any additional setup after loading the view.
    }

}
