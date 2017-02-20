//
//  PhotoDetailManageAPI.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/28/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import Alamofire

protocol PhotoDetailDelegate: NSObjectProtocol {
    func photoDetailComment(comment comment: [Comment])
}

class PhotoDetailManageAPI: NSObject {
    
    // MARK: - Variables
    
    weak var delegate: PhotoDetailDelegate?
    
    // MARK: - Custom Methods
    
    func requestComment(type type: String, objectId: String) {
        let urlString = API_HOST + "/comment/\(type)/\(objectId)"
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        Alamofire.request(.GET, urlString, headers: headers)
            .responseJSON { response -> Void in
                if let JSON = response.result.value {
                    if let comment = Mapper<ItemComment>().map(JSON) {
                        self.delegate?.photoDetailComment(comment: comment.items!)
                    }
                }
        }
    }
    
    func requestLike(type type: String, albumId: String) {
        let urlString = API_HOST + "/like/\(type)/\(albumId)"
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        Alamofire.request(.PUT, urlString, headers: headers)
            .responseJSON { response -> Void in
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
}
