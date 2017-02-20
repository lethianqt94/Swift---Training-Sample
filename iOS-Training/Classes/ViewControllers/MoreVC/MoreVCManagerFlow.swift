//
//  MoreVCManagerFlow.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/15/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class MoreVCManagerFlow: NSObject {
    
    var navi:UINavigationController?
    
    init(navi:UINavigationController?){
        
        self.navi = navi
        super.init()
    }
    
    // MARK: - Custom Folow Methods
    
    func pushToSignInVC() {
        let signInVC = SignInVC()
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.window?.rootViewController = signInVC
    }
    
    func pushToProfileVC() {
        let profileVC = ProfileVC()
        self.navi?.pushViewController(profileVC, animated: true)
    }
    
    func pushToProfileCreditVC() {
        let profileCreditVC = ProfileCreditVC()
        self.navi?.pushViewController(profileCreditVC, animated: true)
    }
    
    func pushToTopicDetailVC(topicId topicId: String) {
        let topicDetail = TopicDetalsVC()
        topicDetail.topicId = topicId
        self.navi?.pushViewController(topicDetail, animated: true)
    }
    
    func goToProfileCreditVC() {
        let profileVC = ProfileCreditVC()
        profileVC.addItemOnNaviBar(left: ParentVC.ItemType.Back, center: ParentVC.ItemType.Title, right: ParentVC.ItemType.None)
        profileVC.setTitleForVC("Credits", fontText: Semibold20)
        self.navi!.pushViewController(profileVC, animated: true)
    }
    
    func pushToCreditHistoryVC() {
        let creditHistoryVC = CreditHistoryVC()
        creditHistoryVC.addItemOnNaviBar(left: ParentVC.ItemType.Back, center: ParentVC.ItemType.Title, right: ParentVC.ItemType.None)
        creditHistoryVC.setTitleForVC("Credits history", fontText: Semibold20)
        self.navi!.pushViewController(creditHistoryVC, animated: true)
    }
}
