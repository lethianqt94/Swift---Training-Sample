//
//  Comment.swift
//  iOS-Training
//
//  Created by Le Thi An on 1/18/16.
//  Copyright © 2016 ThaoPN. All rights reserved.
//

import Foundation

class Comment:Mappable {
    
    var cmtId:String?
    var cmtContent:String?
    var cmtLinguisticId:Int?
    
    var cmtOwner:Users?
    var cmtDate:String?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        cmtId <- map["id"]
        cmtContent <- map["content"]
        cmtLinguisticId <- map["linguistic_id"]
        
        cmtOwner <- map["owner"]
        cmtDate <- map["created"]
    }
    
}

class ItemComment: Mappable {
    
    var items: [Comment]?
    
    required convenience init?(_ map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        items <- map["data.items"]
    }
}