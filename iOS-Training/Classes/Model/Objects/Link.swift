//
//  Link.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/18/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation

class Link:Mappable{
    
    var lnkId:String?
    var lnkContent:String?
    var lnkWebDesc:String?
    
    var lnkWebImg:String?
    var lnkWebTitle:String?
    var lnkWebUrl:String?
    
    var lnkLike:Int?
    var lnkComment:Int?
    var lnkShare:Int?
    var lnkView:Int?
    
    var lnkLikers:[Users]?
    var lnkTotalCommenters:Int?
    var lnkCommenter:[Users]?
    
    var lnkLong:Double?
    var lnkLat:Double?
    var lnkLocation:String?
    
    var lnkLinguisticId:Int?
    var lnkOwner:Users?
    
    var lnkReceiver:FeedReceiver?
    var lnkCreated:String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        lnkId <- map["id"]
        lnkContent <- map["content"]
        lnkWebDesc <- map["web_description"]
        lnkWebImg <- map["web_image"]
        lnkWebTitle <- map["web_title"]
        lnkWebUrl <- map["web_url"]
        
        lnkLike <- map["likes"]
        lnkComment <- map["comments"]
        lnkShare <- map["shares"]
        lnkView <- map["views"]
        
        lnkLikers <- map["likers"]
        lnkTotalCommenters <- map["commenters.total"]
        lnkCommenter <- map["commenters.items"]
        
        lnkLong <- map["longitude"]
        lnkLat <- map["latitude"]
        lnkLocation <- map["location"]
        
        lnkLinguisticId <- map["linguistic_id"]
        lnkOwner <- map["owner"]
        lnkReceiver <- map["receiver"]
        lnkCreated <- map["created"]
        
    }
    
}

// MARK: [Tuan]

class ItemLink: Mappable {
    
    // MARK: - Variables
    
    var items: [Link]?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        items <- map["data.items"]
    }
}