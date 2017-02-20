//
//  ProfileVCManageFlow.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/22/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class ProfileVCManageFlow: NSObject {
    
    var navi:UINavigationController?
    
    init(navi:UINavigationController?){
        
        self.navi = navi
        super.init()
    }
    
    func pushToProfileCreditVC() {
        let profileCreditVC = ProfileCreditVC()
        self.navi?.pushViewController(profileCreditVC, animated: true)
    }
}
