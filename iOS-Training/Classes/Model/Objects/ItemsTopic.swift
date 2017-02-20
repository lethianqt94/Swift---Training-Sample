//
//  ItemsTopic.swift
//  iOS-Training
//
//  Created by Le Kim Tuan on 1/20/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import UIKit

class ItemsTopic: Mappable {
    
    // MARK: - Variables
    
    var isShowOnTableView: Bool?
    
    var zoneId: String?
    var isUser: Bool?
    var title: String?
    var avatar: String?
    var cover: String?
    var descriptions: String?
    var latitude: Double?
    var longitude: Double?
    var location: String?
    var linguisticId: Int?
    var isPublish: Bool?
    var shares: Int?
    var likes: Int?
    var comments: Int?
    var views: Int?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        zoneId <- map["zone_id"]
        isUser <- map["is_user"]
        title <- map["title"]
        avatar <- map["avatar"]
        cover <- map["cover.image"]
        descriptions <- map["description"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        location <- map["location"]
        linguisticId <- map["linguistic_id"]
        isPublish <- map["is_publish"]
        shares <- map["shares"]
        likes <- map["likes"]
        comments <- map["comments"]
        views <- map["views"]
    }
}
