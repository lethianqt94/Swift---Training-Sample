//
//  AlbumObject.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/15/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation

class Album: Mappable{
    
    var albId:String?
    var albTitle:String?
    var albDesc:String?
    var albTotalPhotos:Int?
    var albPhotos:[Photo]?
    
    var albLike:Int?
    var albIsLike: Bool? = false
    var albComment:Int?
    var albShare:Int?
    var albView:Int?
    
    var albLikers:[Users]?
    var albTotalCmt:Int?
    var albCommenter:[Users]?
    
    var albLong:Double?
    var albLat:Double?
    var albLocation:String?
    var albIsProfile:Bool? = false
    var albLinguisticId:Int?
    
    var albOwner:Users!
    var albReceiver:FeedReceiver?
    var albCreated:String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        albId <- map["id"]
        albTitle <- map["title"]
        albDesc <- map["description"]
        albTotalPhotos <- map["photos.total"]
        albPhotos <- map["photos.items"]
        
        albLike <- map["likes"]
        albComment <- map["comments"]
        albShare <- map["shares"]
        albView <- map["views"]
        
        albLikers <- map["likers"]
        albTotalCmt <- map["commenters.total"]
        albCommenter <- map["commenters.items"]
        
        albLong <- map["longitude"]
        albLat <- map["latitude"]
        albLocation <- map["location"]
        
        albIsProfile <- map["is_profile"]
        albLinguisticId <- map["linguistic_id"]
        
        albOwner <- map["owner"]
        albReceiver <- map["receiver"]
        albCreated <- map["created"]
        
    }
    
}

class AlbumList: Mappable {
    
    var items:[Album] = []
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        items <- map["data.items"]
    }
}
