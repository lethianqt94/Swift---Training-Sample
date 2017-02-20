//
//  Photo.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/15/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation
import UIKit

class Photo:Mappable {
    
    var ptId:String?
    var ptImage:String?
    var ptTile:String?
    var ptDesc:String?
    var ptMaxWidth: CGFloat?
    var ptMaxHeight: CGFloat?
    
    var ptLike:Int?
    var ptIsLike:Bool? = false
    var ptCmt:Int?
    var ptShare:Int?
    var ptView:Int?
    
    var ptLikers:[Users]?
    var ptTotalCmt:Int?
    var ptCommenters:[Users]?
    
    var ptLong:Double?
    var ptLat:Double?
    var ptLocation:String?
    
    var ptLinguisticId:Int?
    var ptOwner:Users?
    
    var ptReceiver:FeedReceiver?
    var ptCreated:String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        ptId <- map["id"]
        ptImage <- map["image"]
        ptTile <- map["title"]
        ptDesc <- map["description"]
        ptMaxWidth <- map["max_width"]
        ptMaxHeight <- map["max_height"]
        
        ptLike <- map["likes"]
        ptCmt <- map["comments"]
        ptShare <- map["shares"]
        ptView <- map["views"]
        
        ptLikers <- map["likers"]
        ptTotalCmt <- map["commenters.total"]
        ptCommenters <- map["commenters.items"]
        
        ptLong <- map["longitude"]
        ptLat <- map["latitude"]
        ptLocation <- map["location"]
        ptLinguisticId <- map["linguistic_id"]
        
        ptOwner <- map["owner"]
        
        ptReceiver <- map["receiver"]
        ptCreated <- map["created"]
    }
    
    internal func getPhotoUrl()->String {
        let imgUrl = CommonFunc.getImgFromAvatar(ptImage!)
        return imgUrl
//        return "http://d2yz3n5612lnr6.cloudfront.net/upload/gallery/thumbs/548-10000/\(ptImage)"
    }
    
}

class ListPhoto: Mappable {
    
    // MAR: - Variables
    
    var listPhoto:[Photo]?
    var total: Int?
    var limit: Int?
    var pages: Int?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        listPhoto <- map["data.items"]
        total <- map["data.pages.total"]
        limit <- map["data.pages.limit"]
        pages <- map["data.pages.pages"]
    }
    
}