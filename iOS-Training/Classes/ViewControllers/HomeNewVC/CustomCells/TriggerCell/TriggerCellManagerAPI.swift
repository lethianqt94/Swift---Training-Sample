//
//  TriggerCellManagerAPI.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/20/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation
import Alamofire

class TriggerCellManagerAPI {
    
    class func doLikeObject(objectType:String, objId:String) {
        let url = CommonFunc.getAPILike(objectType, objId: objId)
        
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        
        Alamofire.request(.PUT, url, parameters: nil, encoding: .JSON, headers: headers).responseJSON { response -> Void in
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
            }
        }
    }
}