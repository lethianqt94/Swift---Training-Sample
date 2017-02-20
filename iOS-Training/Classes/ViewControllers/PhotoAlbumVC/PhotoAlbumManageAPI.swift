//
//  PhotoAlbumManageAPI.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/28/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import Alamofire

protocol PhotoAlbumDelegate: NSObjectProtocol {
    func photoAlbum(listPhoto listPhoto: ListPhoto)
}

class PhotoAlbumManageAPI: NSObject {
    
    // MARK: - Variable
    
    weak var delegate: PhotoAlbumDelegate?
    
    // MARK: - Custom Method
    
    func requestAlbumWithAlbumId(albumId albumId: String, page: Int) {
        let urlString = API_HOST + "/albums/\(albumId)/photos?page=\(page)"
        Alamofire.request(.GET, urlString)
            .responseJSON { response in
                if let json = response.result.value {
                    if let listAlbum = Mapper<ListPhoto>().map(json) {
                        self.delegate?.photoAlbum(listPhoto: listAlbum)
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
