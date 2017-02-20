//
//  AccountManager.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/18/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import Alamofire

var instance: AccountManager?
var myUser = Users()

protocol AccountManagerDelegate: NSObjectProtocol {
    func accountManager(user user: Users)
}

class AccountManager {
    
    // MARK: - Variable
    
    weak var delegate: AccountManagerDelegate?
    
    class var sharedInstance: AccountManager {
        struct Static {
            static var instance: AccountManager?
            static var myUser: Users?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = AccountManager()
        }
        return Static.instance!
    }
    
    // MARK: - Custom Methods
    
    func requestLogin(email email: String, password: String) {
        let parameters: [String: String] = [
            "username": email,
            "password": password
        ]
        let urlString = API_HOST + API_SIGNIN
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON { response in
                if let json = response.result.value {
                    if let users = Mapper<Users>().map(json) {
                        myUser = users
                        self.delegate?.accountManager(user: myUser)
                    }
                }
        }
    }
    
    func getInfoUser() -> Users {
        return myUser
    }
}
