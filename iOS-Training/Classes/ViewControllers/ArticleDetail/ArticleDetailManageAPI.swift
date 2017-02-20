//
//  ArticleDetailManageAPI.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 2/4/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit
import Alamofire

protocol ArticleDetailProtocol: NSObjectProtocol {
    func articleDetail(article article: Article)
    func articleDetailComment(comment comment: [Comment])
}

class ArticleDetailManageAPI: NSObject {
    
    // MARK: - Variables
    
    weak var delegate: ArticleDetailProtocol?
    
    // MARK: - Custom Method
    
    func requestArticle(articleId articleId: String) {
        let urlString = API_HOST + "/articles/\(articleId)"
        Alamofire.request(.GET, urlString)
            .responseJSON { response in
                if let json = response.result.value {
                    if let articleDetail = Mapper<ArticleDetail>().map(json) {
                        self.delegate?.articleDetail(article: articleDetail.article!)
                    }
                }
        }
    }
    
    func requestComment(type type: String, objectId: String) {
        let urlString = API_HOST + "/comment/\(type)/\(objectId)"
        let headers = [
            "Access-Token": AccountManager.sharedInstance.getInfoUser().accessToken!
        ]
        Alamofire.request(.GET, urlString, headers: headers)
            .responseJSON { response -> Void in
                if let JSON = response.result.value {
                    if let comment = Mapper<ItemComment>().map(JSON) {
                        self.delegate?.articleDetailComment(comment: comment.items!)
                    }
                }
        }
    }
    
    func requestLike(type type: String, articleId: String) {
        let urlString = API_HOST + "/like/\(type)/\(articleId)"
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
