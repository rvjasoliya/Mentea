//
//  File.swift
//  Mentea
//
//  Created by apple on 30/07/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import SKActivityIndicatorView

class LoaderController: NSObject {

static let sharedInstance = LoaderController()
private let activityIndicator = UIActivityIndicatorView()

//MARK: - Private Methods -
private func setupLoader() {
    removeLoader()

    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = .gray
}

//MARK: - Public Methods -
func showLoader() {
    setupLoader()

    let appDel = UIApplication.shared.delegate as! AppDelegate
    let holdingView = appDel.window!.rootViewController!.view!

    DispatchQueue.main.async {
        self.activityIndicator.center = holdingView.center
        self.activityIndicator.startAnimating()
        holdingView.addSubview(self.activityIndicator)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
}

func removeLoader(){
    DispatchQueue.main.async {
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
}
