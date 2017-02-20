//
//  Following.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/22/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class Following: Mappable {
    
    // MARK: - Variables
    
    var items: [ItemsFollowing]?
    
    var total: Int?
    var limit: Int?
    var pages: Int?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        items <- map["data.items"]
        total <- map["data.pages.total"]
        limit <- map["data.pages.limit"]
        pages <- map["data.pages.pages"]
    }
}

class ItemsFollowing: Mappable {
    
    // MARK: - Variables
    
    var zoneId: String?
    var isUser: Bool? = false
    
    var title: String?
    var description: String?
    var avatar: String?
    
    var cover: String?
    var isPublish: Bool? = false
    var linguisticId:Int?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        zoneId <- map["zone_id"]
        isUser <- map["is_user"]
        title <- map["title"]
        description <- map["description"]
        avatar <- map["avatar"]
        cover <- map["cover.image"]
        isPublish <- map["is_publish"]
        linguisticId <- map["linguistic_id"]
    }
}
