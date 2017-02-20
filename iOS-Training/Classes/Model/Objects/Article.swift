//
//  Article.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/18/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation

class Article:Mappable {
    
    var artId:String?
    var artTitle:String?
    var artDesc:String?
    
    var artContent: String?
    
    var artTotalPhoto:Int?
    var artPhotos:[Photo]?
    
    var artPhoto:Photo?
    
    var artLike:Int?
    var artComment:Int?
    var artShare:Int?
    var artView:Int?
    
    var artLikers:[Users]?
    var artCommenter:[Users]?
    var artTotalCmt:Int?
    
    var artLong:Double?
    var artLat:Double?
    var artLocation:String?
    
    var artLinguisticId:Int?
    var artOwner:Users?
    
    var artReceiver:FeedReceiver?
    var artCreated:String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        artId <- map["id"]
        artTitle <- map["title"]
        artDesc <- map["description"]
        
        artContent <- map["content"]
        
        artTotalPhoto <- map["photos.total"]
        artPhotos <- map["photos.photo"]
        
        artPhoto <- map["photos.photo"]
        
        artLike <- map["likes"]
        artComment <- map["comments"]
        artView <- map["views"]
        artShare <- map["shares"]
        
        artLikers <- map["likers"]
        artTotalCmt <- map["commenters.total"]
        artCommenter <- map["commenters.items"]
        
        artLong <- map["longitude"]
        artLat <- map["latitude"]
        artLocation <- map["location"]
        
        artLinguisticId <- map["linguistic_id"]
        artOwner <- map["owner"]
        
        artReceiver <- map["receiver"]
        artCreated <- map["created"]
        
    }
    
}

class ArticleList: Mappable {
    
    var items:[Article] = []
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        items <- map["data.items"]
    }
}

// MARK: - [Tuan]

class ArticleDetail: Mappable {
    
    var article: Article?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        article <- map["data.article"]
    }
}
