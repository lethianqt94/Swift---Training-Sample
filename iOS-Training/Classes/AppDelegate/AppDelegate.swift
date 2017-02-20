//
//  AppDelegate.swift
//  iOS-Training
//
//  Created by Pham Ngoc Thao on 1/14/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AccountManagerDelegate {

    var window: UIWindow?
    var signInVC: SignInVC?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        UIApplication.sharedApplication().statusBarHidden = true
        
        self.window = UIWindow()
        self.signInVC = SignInVC()
        
        if let signInVC = signInVC {
            if (signInVC.userDefault.objectForKey("accesstoken") != nil) {
                let email = signInVC.userDefault.objectForKey("email") as! String
                let password = signInVC.userDefault.objectForKey("password") as! String
                let accountManager = AccountManager()
                
                accountManager.delegate = self
                accountManager.requestLogin(email: email, password: password)
            } else {
                let navi = UINavigationController(rootViewController: signInVC)
                self.window?.rootViewController = navi
                self.window?.makeKeyAndVisible()
            }
        }
        
        return true
    }
    
    func accountManager(user user: Users) {
        if let code = user.code {
            if code == 200 {
                if let signInVC = signInVC {
                    if (signInVC.userDefault.objectForKey("accesstoken") != nil) {
                        let tabBarVC = TabBarVC()
                        self.window?.rootViewController = tabBarVC
                        self.window?.makeKeyAndVisible()
                    }
                }
            }
        }
    }

    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIApplication.topViewController()?.nibName == "VideoViewerVC" {
            return UIInterfaceOrientationMask.All
        } else {
            return UIInterfaceOrientationMask.Portrait
        }
    }
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

