//
//  Topic.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/18/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation

class Topic:Mappable {
    
    var tpZoneID:String?
    var tpIsUser:Bool? = false
    
    var tpTitle:String?
    var tpDesc:String?
    var tpAvatar:String?
    
    var tpCoverImage:String?
    var tpIsPublish:Bool? = false
    var tpLinguisticId:Int?
    
    var tpLong:Double?
    var tpLat:Double?
    var tpLocation:String?
    
    var tpLike:Int?
    var tpComment:Int?
    var tpShare:Int?
    var tpView:Int?
    
    var tpOwner:Users?
    var tpTypes:[Type]?
    
    var tpFollowers:[Users]?
    var tpCreated:String?
    
    var tpResourcePhotos:Int?
    var tpResourceAlbums:Int?
    var tpResourceArticles:Int?
    var tpResourceVideos:Int?
    var tpResourceLinks:Int?
    var tpFollowersNum:Int?
    var tpContributorsNum:Int?
    
    var tpIsFollow:Bool?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        tpZoneID <- map["zone_id"]
        tpIsUser <- map["is_user"]
        
        tpTitle <- map["title"]
        tpDesc <- map["description"]
        tpAvatar <- map["avatar"]
        
        tpCoverImage <- map["cover.image"]
        tpIsPublish <- map["is_publish"]
        tpLinguisticId <- map["linguistic_id"]
        
        tpLong <- map["longitude"]
        tpLat <- map["latitude"]
        tpLocation <- map["location"]
        
        tpLike <- map["likes"]
        tpComment <- map["comments"]
        tpShare <- map["shares"]
        tpView <- map["views"]
        
        tpOwner <- map["owner"]
        tpTypes <- map["types"]
        
        tpFollowers <- map["followers"]
        tpCreated <- map["created"]
        
        tpResourceAlbums <- map["stats.albums"]
        tpResourceArticles <- map["stats.articles"]
        tpResourceLinks <- map["stats.links"]
        tpResourcePhotos <- map["stats.photos"]
        tpResourceVideos <- map["stats.videos"]
        tpFollowersNum <- map["stats.followers"]
        tpContributorsNum <- map["stats.contributors"]
        
        tpIsFollow <- map["user_relation.is_follow"]
        
    }
    
    func getTopicAvatar()->String {
        let imgUrl = CommonFunc.getImgFromAvatar(tpAvatar!)
        return imgUrl
//        return "http://d2yz3n5612lnr6.cloudfront.net/upload/gallery/thumbs/548-10000/\(tpAvatar)"
    }
    
    func getTopicCoverPhoto()->String {
        let imgUrl = CommonFunc.getImgFromAvatar(tpCoverImage!)
        return imgUrl
    }
    
}

class TopicItem: Mappable {
    
    var item:Topic?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        item <- map["data.topic"]
    }
}
