//
//  TabBarVC.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/14/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController, UITabBarControllerDelegate {
        
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIApplication.sharedApplication().statusBarHidden = false
        self.initTabBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - TabBar
    
    func initTabBar() -> Void {
        
        
        self.tabBar.backgroundColor = UIColor.whiteColor()
        self.tabBar.barTintColor = UIColor.whiteColor()
        
        let homeBarItem = UITabBarItem(title: "Home", image: UIImage(named: "home.png"), tag: 0)
        let discoverBarItem = UITabBarItem(title: "Discover", image: UIImage(named: "discover.png"), tag: 1)
        let collectionBarItem = UITabBarItem(title: "Collection", image: UIImage(named: "collection.png"), tag: 2)
        let notificationBarItem = UITabBarItem(title: "Notification", image: UIImage(named: "notification.png"), tag: 3)
        let moreBarItem = UITabBarItem(title: "More", image: UIImage(named: "more.png"), tag: 4)
        
        let homeNewVC = HomeNewVC()
        let collectionVC = CollectionVC()
        let discoverVC = DiscoverVC()
        let moreVC = MoreVC()
        let notificationVC = NotificationVC()
        
        let homeNewNav = UINavigationController(rootViewController: homeNewVC)
        let collectionNav = UINavigationController(rootViewController: collectionVC)
        let discoverNav = UINavigationController(rootViewController: discoverVC)
        let moreNav = UINavigationController(rootViewController: moreVC)
        let notificationNav = UINavigationController(rootViewController: notificationVC)
        
        homeNewNav.tabBarItem = homeBarItem
        collectionNav.tabBarItem = collectionBarItem
        discoverNav.tabBarItem = discoverBarItem
        moreNav.tabBarItem = moreBarItem
        notificationNav.tabBarItem = notificationBarItem
        
        homeBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        discoverBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        moreBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        notificationBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        //array of the root view controllers displayed by the tab bar interface
        self.viewControllers = [homeNewNav, discoverNav, collectionNav, notificationNav, moreNav]
        
        self.tabBar.tintColor = UIColor(red: 76, green: 175, blue: 80)
        
        self.tabBar.layer.masksToBounds = true
        self.tabBar.layer.borderColor = UIColor(red: 225, green: 225, blue: 225).CGColor
        self.tabBar.layer.borderWidth = 0.5
        
        self.tabBarController?.tabBar.selectedItem = collectionBarItem
        self.tabBarController?.tabBar.translucent = false
    }
    
    // MARK: - UITabBarController Delegate
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        return true
    }
}
