//
//  AlbumObject.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/15/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation

class Video:Mappable{
    
    var vidId:String?
    var vidTitle:String?
    var vidDesc:String?
    var vidThumb:String?
    var vidLength:String?
    var vidIsUpload:String?
    var vidYoutubeId:String?
    var vidYoutubeUrl:String?
    
    var vidFileName:String?
    var vidUrl:String?
    var vidLike:Int?
    var vidComment:Int?
    var vidShare:Int?
    var vidView:Int?
    
    var vidLikers:[Users]?
    var vidCommenter:[Users]?
    var vidTotalCmt:Int?
    
    var vidLong:Double?
    var vidLat:Double?
    var vidLocation:String?
    
    var vidLinguisticId:Int?
    var vidOwner:Users?
    
    var vidReceiver:FeedReceiver?
    var vidCreated:String?
    var isLiked:Bool?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        vidId <- map["id"]
        vidTitle <- map["title"]
        vidDesc <- map["description"]
        vidThumb <- map["thumbnail"]
        vidLength <- map["length"]
        
        vidIsUpload <- map["is_upload"]
        vidYoutubeId <- map["youtube_id"]
        vidYoutubeUrl <- map["youtube_url"]
        
        vidFileName <- map["filename"]
        vidUrl <- map["url"]
        
        vidLike <- map["likes"]
        vidComment <- map["comments"]
        vidView <- map["views"]
        vidShare <- map["shares"]
        
        vidLikers <- map["likers"]
        vidTotalCmt <- map["commenters.total"]
        vidCommenter <- map["commenters.items"]
        
        vidLong <- map["longitude"]
        vidLat <- map["latitude"]
        vidLocation <- map["location"]
        
        vidLinguisticId <- map["linguistic_id"]
        
        vidOwner <- map["owner"]
        vidReceiver <- map["receiver"]
        vidCreated <- map["created"]
        isLiked <- map["user_relation.is_like"]
        
    }
    
    internal func getVideoThumnail()->String {
        return "http://img.youtube.com/vi/" + vidYoutubeId! + "/0.jpg"
    }
}

// [Tuan]

class ItemVideo: Mappable {
    
    // MARK: - Variables
    
    var items: [Video]?
    
    //[An added]
    var video: Video?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        items <- map["data.items"]
        video <- map["data.video"]
    }
}