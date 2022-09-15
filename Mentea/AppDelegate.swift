//
//  AppDelegate.swift
//  Mentea
//
//  Created by Apple on 21/05/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import IQKeyboardManagerSwift

let myApp = UIApplication.shared.delegate as! AppDelegate
 

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
          
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {

        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )

    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //IQKeyboardManager.shared.enable = false
        
        ApplicationDelegate.shared.application(
                  application,
                  didFinishLaunchingWithOptions: launchOptions
              )
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        styleTabBar()
        setNavigationBar()
        
       // Override point for customization after application launch.
       self.window = UIWindow(frame: UIScreen.main.bounds)

       let storyboard = UIStoryboard(name: "Main", bundle: nil)

       var initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        if Helper.getPREF("isTutoClick") ?? "" == "yes"{
            initialViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        } else{
            initialViewController = storyboard.instantiateViewController(withIdentifier: "TutorialViewController")
        }

       self.window?.rootViewController = initialViewController
       self.window?.makeKeyAndVisible()
        
        
        
        return true
    }
    
    func setNavigationBar() {
        //navigationController?.navigationBar.barTintColor = UIColor.green
        
        let navigationBar = UINavigationBar.appearance()
        //3b5998
        //Old
        //navigationBar.backgroundColor = UIColor.init(hexString: "#86E6EA")
        navigationBar.setBackgroundImage(UIImage(named: "sign-up")?.resizableImage(withCapInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0 ,right: 0), resizingMode: .stretch), for: .default)
         //navigationBar.backgroundColor = UIColor.init(hexString: "#3B5998")
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.isOpaque = true
        navigationBar.tintColor = .white
        //Old
        //navigationBar.barTintColor = UIColor.init(hexString: "#86E6EA")
        navigationBar.barTintColor = UIColor.init(hexString: "#3B5998")
        
        if let navFont = UIFont(name: "Futura", size: 18) {
            let navBarAttributesDictionary: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key(rawValue: NSAttributedString.Key.foregroundColor.rawValue): UIColor.white,
                NSAttributedString.Key(rawValue: NSAttributedString.Key.font.rawValue): navFont ]
            navigationBar.titleTextAttributes = navBarAttributesDictionary
        }
    }
    
    func styleTabBar(){
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        //Old
        //UITabBar.appearance().barTintColor = UIColor.init(hexString: "#86E6EA")
        //UITabBar.appearance()
        //self.tabBar.translucent = false
        //UITabBar.appearance().barTintColor = UIColor.init(hexString: "#3b5998")
        
        
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

