//
//  SignInVCManagerFlow.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/14/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class SignInVCManagerFlow: NSObject {
    func pushToHomeVC() {
        let tabBarVC = TabBarVC()
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        delegate.window?.rootViewController = tabBarVC
    }
}