//
//  MoreVCManagerAPI.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/15/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import Alamofire

protocol MoreVCDelegate: NSObjectProtocol {
    func moreVCDelegate(sendItemsTopicUser itemsTopic: [ItemsTopic])
    func moreVCDelegate(sendEventLogoutWithCode code: Int)
}

class MoreVCManagerAPI: NSObject {
    
    // MARK: - Variable
    
    weak var delegate: MoreVCDelegate?
    
    // MARK: - Custom Method
    
    func requestTopic(accessToken accessToken: String) {
        let header = [
            "Access-Token": accessToken
        ]
        let urlString = API_HOST + API_TOPIC_ME
        Alamofire.request(.GET, urlString, headers: header)
            .responseJSON { response in
                if let json = response.result.value {
                    if let usersTopic = Mapper<UsersTopic>().map(json) {
                        if let item = usersTopic.items {
                            self.delegate?.moreVCDelegate(sendItemsTopicUser: item)
                        }
                    }
                }
        }
    }
    
    func requestLogout(accessToken accessToken: String) {
        let parameters: [String: String] = [
            "Access-Token": accessToken
        ]
        let urlString = API_HOST + API_SIGNOUT
        Alamofire.request(.POST, urlString, parameters: parameters)
            .responseJSON { response in
                if let json = response.result.value {
                    if let users = Mapper<Users>().map(json) {
                        self.delegate?.moreVCDelegate(sendEventLogoutWithCode: users.code!)
                    }
                }
        }
    }
}
